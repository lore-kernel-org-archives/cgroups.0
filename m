From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
 process in the same cgroup
Date: Mon, 11 Jul 2016 08:41:50 +0200
Message-ID: <20160711064150.GB5284@dhcp22.suse.cz>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shayan Pooya <shayan-UQzSddOuLosdnm+yROfE0A@public.gmane.org>
Cc: cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat 09-07-16 16:49:32, Shayan Pooya wrote:
> I came across the following issue in kernel 3.16 (Ubuntu 14.04) which
> was then reproduced in kernels 4.4 LTS:
> After a couple of of memcg oom-kills in a cgroup, a syscall in
> *another* process in the same cgroup hangs indefinitely.
> 
> Reproducing:
> 
> # mkdir -p strace_run
> #  mkdir /sys/fs/cgroup/memory/1
> # echo 1073741824 > /sys/fs/cgroup/memory/1/memory.limit_in_bytes
> # echo 0 > /sys/fs/cgroup/memory/1/memory.swappiness
> # for i in $(seq 1000); do ./call-mem-hog
> /sys/fs/cgroup/memory/1/cgroup.procs & done
> 
> Where call-mem-hog is:
> #!/bin/sh
> set -ex
> echo $$ > $1
> echo "Adding $$ to $1"
> strace -ff -tt ./mem-hog 2> strace_run/$$
> 
> 
> Initially I thought it was a userspace bug in dash as it only happened
> with /bin/sh (which points to dash) and not with bash. I see the
> following hanging processes:
> 
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root     20999  0.0  0.0   4508   100 pts/6    S    16:28   0:00
> /bin/sh ./call-mem-hog /sys/fs/cgroup/memory/1/cgroup.procs
> 
> However, when using strace, I noticed that sometimes there is actually
> a mem-hog process hanging on sbrk syscall (Of course the
> memory.oom_control is 0 and this is not expected).
> Sending an ABRT signal to the waiting strace process then resulted in
> the mem-hog process getting oom-killed by the kernel.

Could you post the stack trace of the hung oom victim? Also could you
post the full kernel log?
-- 
Michal Hocko
SUSE Labs
