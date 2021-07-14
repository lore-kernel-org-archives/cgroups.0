From: Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 6/6] cpuset: Add cpuset.isolation_mask file
Date: Thu, 15 Jul 2021 00:44:08 +0100
Message-ID: <87o8b4mpfb.mognet@arm.com>
References: <20210714135420.69624-1-frederic@kernel.org> <20210714135420.69624-7-frederic@kernel.org> <YO8WWxWBmNuI0iUW@hirez.programming.kicks-ass.net> <20210714231338.GA65963@lothringen>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210714231338.GA65963@lothringen>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 15/07/21 01:13, Frederic Weisbecker wrote:
> On Wed, Jul 14, 2021 at 06:52:43PM +0200, Peter Zijlstra wrote:
>>
>> cpusets already has means to create paritions; why are you creating
>> something else?
>
> I was about to answer that the semantics of isolcpus, which reference
> a NULL domain, are different from SD_LOAD_BALANCE implied by
> cpuset.sched_load_balance. But then I realize that SD_LOAD_BALANCE has
> been removed.
>
> How cpuset.sched_load_balance is implemented then? Commit
> e669ac8ab952df2f07dee1e1efbf40647d6de332 ("sched: Remove checks against
> SD_LOAD_BALANCE") advertize that setting cpuset.sched_load_balance to 0
> ends up creating NULL domain but that's not what I get. For example if I
> mount a single cpuset root (no other cpuset mountpoints):
>
> $ mount -t cgroup none ./cpuset -o cpuset
> $ cd cpuset
> $ cat cpuset.cpus
> 0-7
> $ cat cpuset.sched_load_balance
> 1
> $ echo 0 > cpuset.sched_load_balance
> $ ls /sys/kernel/debug/domains/cpu1/
> domain0  domain1
>
> I still get the domains on all CPUs...

Huh. That's on v5.14-rc1 with an automounted cpuset:

$ cat /sys/fs/cgroup/cpuset/cpuset.cpus
0-5
$ cat /sys/fs/cgroup/cpuset/cpuset.sched_load_balance
1

$ ls /sys/kernel/debug/sched/domains/cpu*
/sys/kernel/debug/sched/domains/cpu0:
domain0  domain1

/sys/kernel/debug/sched/domains/cpu1:
domain0  domain1

/sys/kernel/debug/sched/domains/cpu2:
domain0  domain1

/sys/kernel/debug/sched/domains/cpu3:
domain0  domain1

/sys/kernel/debug/sched/domains/cpu4:
domain0  domain1

/sys/kernel/debug/sched/domains/cpu5:
domain0  domain1

$ echo 0 > /sys/fs/cgroup/cpuset/cpuset.sched_load_balance
$ ls /sys/kernel/debug/sched/domains/cpu*
/sys/kernel/debug/sched/domains/cpu0:

/sys/kernel/debug/sched/domains/cpu1:

/sys/kernel/debug/sched/domains/cpu2:

/sys/kernel/debug/sched/domains/cpu3:

/sys/kernel/debug/sched/domains/cpu4:

/sys/kernel/debug/sched/domains/cpu5:


I also checked that you can keep cpuset.sched_load_balance=0 at the root
and create exclusive child cpusets with different values of
sched_load_balance, giving you some CPUs attached to the NULL domain and
some others with a sched_domain hierarchy that stays within the cpuset span.
