# Claude Code 動作監視方法

## 概要
Claude Codeプロセスの動作状況を判定するための様々な方法をまとめたドキュメントです。現在のccmonitorスクリプトはCPU使用率のみを基準としていますが、他の指標も組み合わせることでより正確な動作判定が可能になります。

## 現在の実装（CPU使用率ベース）
- **方法**: `ps aux`でCPU使用率をチェック
- **閾値**: デフォルト1.0%
- **利点**: シンプルで軽量
- **欠点**: 待機中のプロセスを非活性と判定してしまう

## CPU以外の動作判定方法

### 1. メモリ使用量変化の監視
```bash
# メモリ使用量の変化を監視
ps -eo pid,pmem,comm,args | grep claude | awk '{print $2}'
```
- **概要**: メモリ使用量の変化でアクティビティを検出
- **利点**: ファイル読み込みや大きなレスポンス処理時に反応
- **実装案**: 一定期間のメモリ使用量変化を追跡

### 2. ネットワーク接続の監視
```bash
# Claude Codeのネットワーク接続を確認
lsof -i -p $(pgrep claude) 2>/dev/null | grep ESTABLISHED
netstat -p | grep $(pgrep claude) | grep ESTABLISHED
```
- **概要**: API通信の有無でアクティビティを判定
- **利点**: 実際のAPIリクエスト処理中を検出可能
- **注意**: macOSでは権限が必要な場合有り

### 3. ファイルディスクリプタ（FD）の監視
```bash
# 開いているファイル数をチェック
lsof -p $(pgrep claude) | wc -l
```
- **概要**: 開いているファイル数の変化を監視
- **利点**: ファイル操作やソケット通信を検出
- **実装案**: ベースライン値からの変化を監視

### 4. プロセス状態（STAT）の確認
```bash
# プロセス状態を詳細に確認
ps -eo pid,stat,comm,args | grep claude
```
- **状態の意味**:
  - `S`: Sleep（割り込み可能）
  - `R`: Running
  - `D`: Sleep（割り込み不可能） - I/O待機中
  - `Z`: Zombie
  - `T`: Stopped
- **利点**: プロセスの詳細な状態を把握可能

### 5. 子プロセス・スレッドの監視
```bash
# 子プロセス数の確認
ps --ppid $(pgrep claude) | wc -l
# スレッド数の確認（Linuxの場合）
ps -eLf | grep claude | wc -l
```
- **概要**: 子プロセスやスレッド数の変化を監視
- **利点**: 並列処理中のアクティビティを検出

### 6. ログファイルの監視
```bash
# Claude Codeのログファイル監視（存在する場合）
tail -f ~/.claude/logs/* 2>/dev/null | grep -E "request|response|error"
```
- **概要**: ログファイルの更新を監視
- **利点**: 実際の処理内容を把握可能
- **注意**: ログファイルの場所は環境により異なる

### 7. プロセスの実行時間監視
```bash
# プロセスの実行時間を確認
ps -eo pid,etime,comm,args | grep claude
```
- **概要**: プロセスの連続実行時間を監視
- **利点**: 長時間動作しているプロセスを特定可能

### 8. システムコール監視（上級者向け）
```bash
# macOSの場合（要管理者権限）
dtruss -p $(pgrep claude) 2>&1 | head -10
# Linuxの場合
strace -p $(pgrep claude) -e trace=read,write,network 2>&1 | head -10
```
- **概要**: システムコールレベルでの活動を監視
- **利点**: 最も詳細な活動状況を把握可能
- **注意**: 権限が必要、パフォーマンス影響有り

## 組み合わせ監視の提案

### レベル1: 基本監視
- CPU使用率 + メモリ使用量変化

### レベル2: 中級監視
- 基本監視 + ネットワーク接続状態 + プロセス状態

### レベル3: 高度監視
- 中級監視 + ファイルディスクリプタ数 + 子プロセス数

## 実装時の考慮事項

### パフォーマンス
- 監視頻度と精度のトレードオフ
- システムリソースへの影響を最小限に

### 互換性
- macOS/Linux間での差異
- 必要な権限の確認

### 精度
- 偽陽性/偽陰性の最小化
- 適切な閾値の設定

## 推奨実装案

```bash
# 複合的な判定関数の例
is_claude_active() {
    local pid=$1
    local cpu_threshold=${2:-1.0}
    
    # CPU使用率チェック
    local cpu=$(ps -p $pid -o pcpu= | tr -d ' ')
    
    # ネットワーク接続チェック
    local connections=$(lsof -i -p $pid 2>/dev/null | grep ESTABLISHED | wc -l)
    
    # ファイルディスクリプタ数チェック
    local fd_count=$(lsof -p $pid 2>/dev/null | wc -l)
    
    # 判定ロジック
    if (( $(echo "$cpu > $cpu_threshold" | bc -l) )) || 
       [ $connections -gt 0 ] || 
       [ $fd_count -gt 10 ]; then
        return 0  # アクティブ
    else
        return 1  # 非アクティブ
    fi
}
```

このような多面的なアプローチにより、より正確なClaude Codeの動作状況監視が実現できます。