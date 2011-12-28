From: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: how to make memory.memsw.failcnt is nonzero
Date: Wed, 28 Dec 2011 17:23:04 +0800
Message-ID: <4EFADFF8.5020703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org


memory.memsw.failcnt shows the number of memory+Swap hits limits.
So I think when memory+swap usage is equal to limit, memsw.failcnt should be nonzero.

I test as follows:

# uname -a
Linux K-test 3.2.0-rc7-17-g371de6e #2 SMP Wed Dec 28 12:02:52 CST 2011 x86_64 x86_64 x86_64 GNU/Linux
# mkdir /cgroup/memory/group
# cd /cgroup/memory/group/
# echo 10M > memory.limit_in_bytes
# echo 10M > memory.memsw.limit_in_bytes
# echo $$ > tasks
# dd if=/dev/zero of=/tmp/temp_file count=20 bs=1M
Killed
# cat memory.memsw.failcnt
0
# grep "failcnt" /var/log/messages | tail -2
Dec 28 17:05:52 K-test kernel: memory: usage 10240kB, limit 10240kB, failcnt 21
Dec 28 17:05:52 K-test kernel: memory+swap: usage 10240kB, limit 10240kB, failcnt 0

memory+swap usage is equal to limit, but memsw.failcnt is zero.

I change memory.memsw.limit_in_bytes to 15M.

# echo 15M > memory.memsw.limit_in_bytes
# dd if=/dev/zero of=/tmp/temp_file count=20 bs=1M
Killed
# grep "failcnt" /var/log/messages | tail -2
Dec 28 17:08:45 K-test kernel: memory: usage 10240kB, limit 10240kB, failcnt 86
Dec 28 17:08:45 K-test kernel: memory+swap: usage 10240kB, limit 15360kB, failcnt 0
# cat memory.memsw.failcnt
0

The limit is 15M, but memory+swap usage also is 10M.
I think memory+swap usage should be 15M and memsw.failcnt should be nonzero.

This is a kernel bug or I misunderstand memory+swap?

I am looking forward to your feedback soon!
Thanks

-- 
Best Regards,
Peng
