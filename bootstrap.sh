mkdir tmp
wget https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz -O tmp/syslinux.tar.gz
tar xzvf tmp/syslinux.tar.gz -C tmp
mv tmp/syslinux-6.03 syslinux
grep -v '^$' dists.txt | awk '$0="pxelinux.cfg/"$1".cfg"' | sort | uniq | xargs touch
cat dists.txt | while read line; do ./append.sh $line; done
