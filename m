From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v4 4/5] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Fri, 15 Jun 2018 09:01:32 +0200
Message-ID: <20180615070132.GA30871@localhost.localdomain>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
 <20180613121711.5018-5-juri.lelli@redhat.com>
 <20180614161142.69f186a6@gandalf.local.home>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614161142.69f186a6@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 14/06/18 16:11, Steven Rostedt wrote:
> On Wed, 13 Jun 2018 14:17:10 +0200
> Juri Lelli <juri.lelli@redhat.com> wrote:
> 
> > +/**
> > + * cpuset_lock - Grab the cpuset_mutex from another subsysytem
> > + */
> > +int cpuset_lock(void)
> > +{
> > +	return mutex_trylock(&cpuset_mutex);
> > +}
> > +
> > +/**
> > + * cpuset_unlock - Release the cpuset_mutex from another subsysytem
> > + */
> > +void cpuset_unlock(void)
> > +{
> > +	mutex_unlock(&cpuset_mutex);
> > +}
> > +
> >  /**
> >   * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
> >   * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index ca788f74259d..a5b0c6c25b44 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4218,6 +4218,14 @@ static int __sched_setscheduler(struct task_struct *p,
> >  		if (attr->sched_flags & SCHED_FLAG_SUGOV)
> >  			return -EINVAL;
> >  
> > +		/*
> > +		 * Make sure we don't race with the cpuset subsystem where root
> > +		 * domains can be rebuilt or modified while operations like DL
> > +		 * admission checks are carried out.
> > +		 */
> > +		if (!cpuset_lock())
> > +			return -EBUSY;
> > +
> 
> How important is this for being a trylock? Reason I am asking is that
> it is making my deadline test fail to get the resources. What my test
> does is to create a bunch of threads, and they try to get the deadline
> resources as they are created. This happens in parallel. Thus, when one
> gets the cpuset_lock, the others are hitting this and returning -EBUSY.
> At first I thought I was over committing somehow but after adding a
> trace_printk() in cpuset_lock(), and this fail case it became obvious
> to what was happening:
> 
>    deadline_test-1376  [004]   107.179693: sys_enter_sched_setattr: pid: 0x00000000, uattr: 0x7f017fceeed0, flags: 0x00000000
>    deadline_test-1376  [004]   107.179697: bputs:                cpuset_lock: cpuset_mutex trylock
>    deadline_test-1377  [003]   107.179763: sys_exit_futex:       0x0
>    deadline_test-1377  [003]   107.179767: sys_enter_sched_setattr: pid: 0x00000000, uattr: 0x7f017f4eded0, flags: 0x00000000
>    deadline_test-1377  [003]   107.179771: bputs:                cpuset_lock: cpuset_mutex trylock
>    deadline_test-1377  [003]   107.179771: bputs:                __sched_setscheduler: cpuset_lock
>    deadline_test-1377  [003]   107.179773: sys_exit_sched_setattr: 0xfffffffffffffff0

Right, not nice.

So, even if we can rework sched_setattr and do_sched_setscheduler to
endup calling __sched_setscheduler outside of RCU read_lock sections (as
Peter suggested) it seems that we might still get into troubles, e.g.

[   39.890366] ======================================================
[   39.892741] WARNING: possible circular locking dependency detected
[   39.894723] 4.17.0-rc6-before+ #169 Not tainted
[   39.896380] ------------------------------------------------------
[   39.898369] bash/2206 is trying to acquire lock:
[   39.899862] 0000000083b596bc (cpu_hotplug_lock.rw_sem){++++}, at: rebuild_sched_domains_locked+0x29/0x660
[   39.902931]
[   39.902931] but task is already holding lock:
[   39.904790] 000000004fc7a567 (cpuset_mutex){+.+.}, at: cpuset_write_u64+0x23/0x140
[   39.907263]
[   39.907263] which lock already depends on the new lock.
[   39.907263]
[   39.909936]
[   39.909936] the existing dependency chain (in reverse order) is:
[   39.912479]
[   39.912479] -> #2 (cpuset_mutex){+.+.}:
[   39.914249]        __sched_setscheduler+0xc6/0x880
[   39.915779]        _sched_setscheduler+0x77/0xa0
[   39.917270]        __kthread_create_on_node+0x122/0x1a0
[   39.918948]        kthread_create_on_node+0x46/0x70
[   39.920512]        init_rescuer.part.8+0x49/0xa0
[   39.921688]        workqueue_init+0x1ec/0x2d5
[   39.922659]        kernel_init_freeable+0x23b/0x5b9
[   39.923756]        kernel_init+0xa/0x110
[   39.924656]        ret_from_fork+0x3a/0x50
[   39.925570]
[   39.925570] -> #1 (wq_pool_mutex){+.+.}:
[   39.926591]        apply_workqueue_attrs+0x20/0x50
[   39.927554]        __alloc_workqueue_key+0x1c7/0x490
[   39.928700]        workqueue_init_early+0x257/0x33f
[   39.929685]        start_kernel+0x2fe/0x531
[   39.930530]        secondary_startup_64+0xa5/0xb0
[   39.931336]
[   39.931336] -> #0 (cpu_hotplug_lock.rw_sem){++++}:
[   39.932195]        cpus_read_lock+0x39/0xa0
[   39.932772]        rebuild_sched_domains_locked+0x29/0x660
[   39.933513]        update_flag+0x1fd/0x210
[   39.934075]        cpuset_write_u64+0xe7/0x140
[   39.934708]        cgroup_file_write+0x174/0x230
[   39.935350]        kernfs_fop_write+0x113/0x1a0
[   39.935991]        __vfs_write+0x36/0x180
[   39.936473]        vfs_write+0xc5/0x1b0
[   39.936991]        ksys_write+0x55/0xc0
[   39.937504]        do_syscall_64+0x73/0x4d0
[   39.938061]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   39.938803]
[   39.938803] other info that might help us debug this:
[   39.938803]
[   39.939708] Chain exists of:
[   39.939708]   cpu_hotplug_lock.rw_sem --> wq_pool_mutex --> cpuset_mutex
[   39.939708]
[   39.940960]  Possible unsafe locking scenario:
[   39.940960]
[   39.941607]        CPU0                    CPU1
[   39.942056]        ----                    ----
[   39.942523]   lock(cpuset_mutex);
[   39.942858]                                lock(wq_pool_mutex);
[   39.943436]                                lock(cpuset_mutex);
[   39.944028]   lock(cpu_hotplug_lock.rw_sem);
[   39.944449]
[   39.944449]  *** DEADLOCK ***
[   39.944449]
[   39.945113] 4 locks held by bash/2206:
[   39.945485]  #0: 000000003cc231db (sb_writers#10){.+.+}, at: vfs_write+0x193/0x1b0
[   39.946246]  #1: 00000000fdc2c059 (&of->mutex){+.+.}, at: kernfs_fop_write+0xe2/0x1a0
[   39.946980]  #2: 00000000e12e3a5d (kn->count#11){.+.+}, at: kernfs_fop_write+0xeb/0x1a0
[   39.947736]  #3: 000000004fc7a567 (cpuset_mutex){+.+.}, at: cpuset_write_u64+0x23/0x140
[   39.948463]
[   39.948463] stack backtrace:
[   39.948871] CPU: 0 PID: 2206 Comm: bash Not tainted 4.17.0-rc6-before+ #169
[   39.949489] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
[   39.950271] Call Trace:
[   39.950502]  dump_stack+0x67/0x9b
[   39.950810]  print_circular_bug.isra.24+0x1c8/0x2b0
[   39.951252]  __lock_acquire+0x1813/0x18e0
[   39.951618]  ? __lock_acquire+0x1219/0x18e0
[   39.952016]  ? lock_acquire+0x8e/0x240
[   39.952357]  lock_acquire+0x8e/0x240
[   39.952683]  ? rebuild_sched_domains_locked+0x29/0x660
[   39.953179]  cpus_read_lock+0x39/0xa0
[   39.953516]  ? rebuild_sched_domains_locked+0x29/0x660
[   39.953981]  rebuild_sched_domains_locked+0x29/0x660
[   39.954431]  ? mark_held_locks+0x56/0x80
[   39.954790]  ? _raw_spin_unlock_irq+0x29/0x50
[   39.955186]  update_flag+0x1fd/0x210
[   39.955541]  cpuset_write_u64+0xe7/0x140
[   39.955900]  cgroup_file_write+0x174/0x230
[   39.956274]  kernfs_fop_write+0x113/0x1a0
[   39.956640]  __vfs_write+0x36/0x180
[   39.956963]  ? rcu_read_lock_sched_held+0x74/0x80
[   39.957482]  ? rcu_sync_lockdep_assert+0x2e/0x60
[   39.957969]  ? __sb_start_write+0x154/0x1f0
[   39.958415]  ? __sb_start_write+0x16a/0x1f0
[   39.958877]  vfs_write+0xc5/0x1b0
[   39.959310]  ksys_write+0x55/0xc0
[   39.959696]  do_syscall_64+0x73/0x4d0
[   39.960054]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[   39.960533]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   39.961071] RIP: 0033:0x7f534866d780
[   39.961477] RSP: 002b:00007fff54dfa398 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[   39.962380] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f534866d780
[   39.963166] RDX: 0000000000000002 RSI: 0000000000d97408 RDI: 0000000000000001
[   39.964008] RBP: 0000000000d97408 R08: 000000000000000a R09: 00007f5348f6d700
[   39.964780] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f53489237a0
[   39.965588] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000

Happening the moment one disables sched_load_balance at root level.

I'll try harder to find alternatives, but suggestions are welcome! :-)

Best,

- Juri
