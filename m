From: Stanislav Kholmanskikh <stanislav.kholmanskikh-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Issue with mount options on mount/umount
Date: Mon, 14 Mar 2016 17:22:19 +0300
Message-ID: <56E6C91B.6090109@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: Vasily Isaenko <vasily.isaenko-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Hello!

It seems that if 'umount' happens before some cgroup cleanup processes 
finish, we will not be able to mount this cgroup with changed options.

For example, consider this test case (where I'm playing with noprefix):

#!/bin/sh

mkdir /tmp/bla
mkdir /dev/cgroup

mount -t cgroup -o cpuset,noprefix bla /dev/cgroup
mkdir /dev/cgroup/ltp
rmdir /dev/cgroup/ltp

#sleep 1

umount /dev/cgroup
rmdir /dev/cgroup

for i in $(seq 2); do
     echo $i
     echo $i > /dev/kmsg
     mount -t cgroup -o cpuset bla /tmp/bla; ls /tmp/bla | grep 
effective_cpus; umount /tmp/bla
done

rmdir /tmp/bla

If it's executed as is, it reports:

[root@ol6-x64 cgroup]# ./test.sh
1
effective_cpus
2
cpuset.effective_cpus

and in dmesg:

[root@ol6-x64 cgroup]# dmesg|tail
1
cgroup: new mount options do not match the existing superblock, will be 
ignored
2

If we uncomment that 'sleep 1' the test will report 
cpuset.effective_cpus for both the iterations.

The kernel is v4.5-rc7-159-g7f02bf6. However, this issue is applicable 
to older versions as well.

Is this behavior a bug or feature? If it's a feature, then what is the 
motivation for this behavior?

Thank you.
