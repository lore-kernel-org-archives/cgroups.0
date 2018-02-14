From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH V3 04/10] sched/core: Prevent race condition between
 cpuset and __sched_setscheduler()
Date: Wed, 14 Feb 2018 08:33:40 -0700
Message-ID: <CANLsYkwPo-uHOWwLZDdvhykx1EU2O--uphJ9KbZYAnD--nFoVg@mail.gmail.com>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
 <1518553967-20656-5-git-send-email-mathieu.poirier@linaro.org>
 <20180214103639.GR12979@localhost.localdomain> <20180214104935.GS12979@localhost.localdomain>
 <20180214112721.GT12979@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=DDX2NB5uLb2p/P/uYsayqVsOp0ZrFbZL24sQs4UxwLg=;
        b=eFyYS1pSrPQ8tZcDXZPfaPSHzSz8ar3b2ham02QV7gHr5EtNK45b39asm4P+BufF5h
         4rR3BNOkSFpplm5O44l3HJVMm68UHuqaw0mt+CiMjoHXp4Z8F0tHcrHOa7Rz5FJfrmN6
         wYpCTsF16iptziAuZsn+jDHvzGVBxsoo3xXyI=
In-Reply-To: <20180214112721.GT12979@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Claudio Scordino <claudio@evidence.eu.com>, Daniel Bristot de Oliveira <bristot@redhat.com>, Tommaso Cucinotta <tommaso.cucinotta@santannapisa.it>, "luca.abeni" <luca.abeni@santannapisa.it>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 14 February 2018 at 04:27, Juri Lelli <juri.lelli@redhat.com> wrote:
> On 14/02/18 11:49, Juri Lelli wrote:
>> On 14/02/18 11:36, Juri Lelli wrote:
>> > Hi Mathieu,
>> >
>> > On 13/02/18 13:32, Mathieu Poirier wrote:
>> > > No synchronisation mechanism exist between the cpuset subsystem and calls
>> > > to function __sched_setscheduler().  As such it is possible that new root
>> > > domains are created on the cpuset side while a deadline acceptance test
>> > > is carried out in __sched_setscheduler(), leading to a potential oversell
>> > > of CPU bandwidth.
>> > >
>> > > By making available the cpuset_mutex to the core scheduler it is possible
>> > > to prevent situations such as the one described above from happening.
>> > >
>> > > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> > > ---
>> >
>> > [...]
>> >
>> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> > > index f727c3d0064c..0d8badcf1f0f 100644
>> > > --- a/kernel/sched/core.c
>> > > +++ b/kernel/sched/core.c
>> > > @@ -4176,6 +4176,13 @@ static int __sched_setscheduler(struct task_struct *p,
>> > >   }
>> > >
>> > >   /*
>> > > +  * Make sure we don't race with the cpuset subsystem where root
>> > > +  * domains can be rebuilt or modified while operations like DL
>> > > +  * admission checks are carried out.
>> > > +  */
>> > > + cpuset_lock();
>> > > +
>> > > + /*
>> >
>> > Mmm, I'm afraid we can't do this. __sched_setscheduler might be called
>> > from interrupt contex by normalize_rt_tasks().
>>
>> Maybe conditionally grabbing it if pi is true could do? I guess we don't
>> care much about domains when sysrq.
>
> Ops.. just got this. :/


Arrghhh... Back to the drawing board.

>
> --->8---
> [    0.020203] ======================================================
> [    0.020946] WARNING: possible circular locking dependency detected
> [    0.021000] 4.16.0-rc1+ #64 Not tainted
> [    0.021000] ------------------------------------------------------
> [    0.021000] swapper/0/1 is trying to acquire lock:
> [    0.021000]  (cpu_hotplug_lock.rw_sem){.+.+}, at: [<000000007164d41d>] smpboot_register_percpu_thread_cpumask+0x2d/0x100
> [    0.021000]
> [    0.021000] but task is already holding lock:
> [    0.021000]  (cpuset_mutex){+.+.}, at: [<000000008529a52c>] __sched_setscheduler+0xb5/0x8b0
> [    0.021000]
> [    0.021000] which lock already depends on the new lock.
> [    0.021000]
> [    0.021000]
> [    0.021000] the existing dependency chain (in reverse order) is:
> [    0.021000]
> [    0.021000] -> #2 (cpuset_mutex){+.+.}:
> [    0.021000]        __sched_setscheduler+0xb5/0x8b0
> [    0.021000]        _sched_setscheduler+0x6c/0x80
> [    0.021000]        __kthread_create_on_node+0x10e/0x170
> [    0.021000]        kthread_create_on_node+0x37/0x40
> [    0.021000]        kthread_create_on_cpu+0x27/0x90
> [    0.021000]        __smpboot_create_thread.part.3+0x64/0xe0
> [    0.021000]        smpboot_register_percpu_thread_cpumask+0x91/0x100
> [    0.021000]        spawn_ksoftirqd+0x37/0x40
> [    0.021000]        do_one_initcall+0x3b/0x160
> [    0.021000]        kernel_init_freeable+0x118/0x258
> [    0.021000]        kernel_init+0xa/0x100
> [    0.021000]        ret_from_fork+0x3a/0x50
> [    0.021000]
> [    0.021000] -> #1 (smpboot_threads_lock){+.+.}:
> [    0.021000]        smpboot_register_percpu_thread_cpumask+0x3b/0x100
> [    0.021000]        spawn_ksoftirqd+0x37/0x40
> [    0.021000]        do_one_initcall+0x3b/0x160
> [    0.021000]        kernel_init_freeable+0x118/0x258
> [    0.021000]        kernel_init+0xa/0x100
> [    0.021000]        ret_from_fork+0x3a/0x50
> [    0.021000]
> [    0.021000] -> #0 (cpu_hotplug_lock.rw_sem){.+.+}:
> [    0.021000]        cpus_read_lock+0x3e/0x80
> [    0.021000]        smpboot_register_percpu_thread_cpumask+0x2d/0x100
> [    0.021000]        lockup_detector_init+0x3e/0x74
> [    0.021000]        kernel_init_freeable+0x146/0x258
> [    0.021000]        kernel_init+0xa/0x100
> [    0.021000]        ret_from_fork+0x3a/0x50
> [    0.021000]
> [    0.021000] other info that might help us debug this:
> [    0.021000]
> [    0.021000] Chain exists of:
> [    0.021000]   cpu_hotplug_lock.rw_sem --> smpboot_threads_lock --> cpuset_mutex
> [    0.021000]
> [    0.021000]  Possible unsafe locking scenario:
> [    0.021000]
> [    0.021000]        CPU0                    CPU1
> [    0.021000]        ----                    ----
> [    0.021000]   lock(cpuset_mutex);
> [    0.021000]                                lock(smpboot_threads_lock);
> [    0.021000]                                lock(cpuset_mutex);
> [    0.021000]   lock(cpu_hotplug_lock.rw_sem);
> [    0.021000]
> [    0.021000]  *** DEADLOCK ***
> [    0.021000]
> [    0.021000] 1 lock held by swapper/0/1:
> [    0.021000]  #0:  (cpuset_mutex){+.+.}, at: [<000000008529a52c>] __sched_setscheduler+0xb5/0x8b0
> [    0.021000]
> [    0.021000] stack backtrace:
> [    0.021000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.16.0-rc1+ #64
> [    0.021000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
> [    0.021000] Call Trace:
> [    0.021000]  dump_stack+0x85/0xc5
> [    0.021000]  print_circular_bug.isra.38+0x1ce/0x1db
> [    0.021000]  __lock_acquire+0x1278/0x1320
> [    0.021000]  ? sched_clock_local+0x12/0x80
> [    0.021000]  ? lock_acquire+0x9f/0x1f0
> [    0.021000]  lock_acquire+0x9f/0x1f0
> [    0.021000]  ? smpboot_register_percpu_thread_cpumask+0x2d/0x100
> [    0.021000]  cpus_read_lock+0x3e/0x80
> [    0.021000]  ? smpboot_register_percpu_thread_cpumask+0x2d/0x100
> [    0.021000]  smpboot_register_percpu_thread_cpumask+0x2d/0x100
> [    0.021000]  ? set_debug_rodata+0x11/0x11
> [    0.021000]  lockup_detector_init+0x3e/0x74
> [    0.021000]  kernel_init_freeable+0x146/0x258
> [    0.021000]  ? rest_init+0xd0/0xd0
> [    0.021000]  kernel_init+0xa/0x100
> [    0.021000]  ret_from_fork+0x3a/0x50
>
