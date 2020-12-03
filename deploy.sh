#!/usr/bin/env sh
# 确保脚本抛出遇到的错误
set -e
# 生成静态文件
npm run docs:build

if [ ! -d .deploy  ];then
  mkdir .deploy
else
  echo .deploy is exist
fi
cd .deploy
if [ ! -d zhangjunp.github.io  ];then
  git clone https://github.com/zhangjunp/zhangjunp.github.io.git
else
  echo zhangjunp.github.io is exist
fi
cd zhangjunp.github.io/
git pull
if [ ! -d blog  ];then
  mkdir blog
else
  echo blog is exist copy dist/* to ./blog/
fi
cp -r ../../docs/.vuepress/dist/* ./blog/
cd blog
#创建.nojekyll 防止Github Pages build错误
touch .nojekyll
git add -A
git commit -m 'blog-deploy'
git push git@github.com:zhangjunp/zhangjunp.github.io.git master

#rm -rf ../../../.deploy/
# 如果发布到 https://<USERNAME>.github.io
#git push -f git@github.com:<USERNAME>/<USERNAME>.github.io.git master

# 如果发布到 https://<USERNAME>.github.io/<REPO>
# git push -f git@github.com:<USERNAME>/<REPO>.git master:gh-pages

cd -
