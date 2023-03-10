# コマンド一覧

- `git init` Git リポジトリの作成
- `git add <ファイル名>` ファイルをステージング領域に追加 
- `git commit -m "<コミットメッセージ>"` ファイルをリポジトリにコミット 
- `git status` 状態確認
- `git log` commit log (変更の履歴) の確認
- `git ls-files` Git 管理下にあるファイル一覧確認
- `git diff` 変更の差分を表示する
- `git checkout <コミットハッシュ値>` 指定したコミットの時点に戻るが、最新のコミットにも戻れる。
- `git branch` ブランチの確認
- `git branch <branch名>` ブランチの作成
- `git branch -d <branch名>` ブランチの削除
- `git checkout <branch名>` ブランチの移動
- `git merge <branch名>` ブランチの結合
- `git rm <ファイル名>` ファイルの削除
- `git mv <ファイル名>` フィアルの移動、名前の変更
- `git reset --soft <コミットハッシュ値>` commit を取り消す
- `git reset --mixed <コミットハッシュ値>` add と commit を取り消す
- `git reset --hard <コミットハッシュ値>` working tree の変更と add, commit を取り消す
