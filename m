From: Shayan Pooya <shayan@liveve.org>
Subject: bug in memcg oom-killer results in a hung syscall in another process
 in the same cgroup
Date: Sat, 9 Jul 2016 16:49:32 -0700
Message-ID: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=liveve-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=xTSIUcorV7Oeic+ZxfpFS3jBqoK+TEXvlucHwYImhVo=;
        b=AHIolmuWRnm15JoX0/3CQrFvDfdTBJjsCAoRsn08iQz1CsgHygFuf+AnC2Kq74B/RS
         ol/TY22u0Rls3ja12A8Ip0+IetfuaJB4u+OaFmNDkpNieEP7LwNtGoHiYV6egWWhvkuC
         0OgvNg5ZRwAxRXv92nHu/YgmgSm4pzXWeVSovvAQeaDbopmEf9+RZqcrW2fl/pX+46rr
         JnoPl0hl+IVosjLeBK+m8F7DLNyzEaz7sQBXU57Gz0jI9n68/DqoFfDiXnzT8fuPuDvR
         NzvPzv26/ApC0CsV5UoxegfRvyTfv6KqGMagmwHHg8heynTSYIDwdie1ct/huJ5W7tRs
         esKQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

I came across the following issue in kernel 3.16 (Ubuntu 14.04) which
was then reproduced in kernels 4.4 LTS:
After a couple of of memcg oom-kills in a cgroup, a syscall in
*another* process in the same cgroup hangs indefinitely.

Reproducing:

# mkdir -p strace_run
#  mkdir /sys/fs/cgroup/memory/1
# echo 1073741824 > /sys/fs/cgroup/memory/1/memory.limit_in_bytes
# echo 0 > /sys/fs/cgroup/memory/1/memory.swappiness
# for i in $(seq 1000); do ./call-mem-hog
/sys/fs/cgroup/memory/1/cgroup.procs & done

Where call-mem-hog is:
#!/bin/sh
set -ex
echo $$ > $1
echo "Adding $$ to $1"
strace -ff -tt ./mem-hog 2> strace_run/$$


Initially I thought it was a userspace bug in dash as it only happened
with /bin/sh (which points to dash) and not with bash. I see the
following hanging processes:

USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root     20999  0.0  0.0   4508   100 pts/6    S    16:28   0:00
/bin/sh ./call-mem-hog /sys/fs/cgroup/memory/1/cgroup.procs

However, when using strace, I noticed that sometimes there is actually
a mem-hog process hanging on sbrk syscall (Of course the
memory.oom_control is 0 and this is not expected).
Sending an ABRT signal to the waiting strace process then resulted in
the mem-hog process getting oom-killed by the kernel.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
