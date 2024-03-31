!# /bin/bash

hexo clean && hexo generate
echo "生成html文件成功!"

hexo clean && hexo g -d
echo "部署成功!"

git checkout main 
git add . 
git commit -am ${0}
git push origin main
echo "git同步成功!"