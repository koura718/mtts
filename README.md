# mtts
Mizuki Table Tennis School

## Cloudflare Pages

- Build command: `sh scripts/cf-pages-build.sh`
- Build output directory: `public`

### Environment variables

- `HUGO_VERSION`: `0.147.7`（推奨。Production/Preview 両方に設定）

### Notes

- Production ブランチ（既定: `main`）のときだけ `config.production.toml` を読み込み、GA を有効化します。
- Preview（本番以外のブランチ）は `config.toml` のみでビルドし、GA は無効のままです。
