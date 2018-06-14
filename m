From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v4 1/5] sched/topology: Add check to backup comment about
 hotplug lock
Date: Thu, 14 Jun 2018 15:42:34 +0200
Message-ID: <20180614134234.GC12032@localhost.localdomain>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
 <20180613121711.5018-2-juri.lelli@redhat.com>
 <20180614093324.7ea45448@gandalf.local.home>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180614093324.7ea45448@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 14/06/18 09:33, Steven Rostedt wrote:
> On Wed, 13 Jun 2018 14:17:07 +0200
> Juri Lelli <juri.lelli@redhat.com> wrote:
> 
> > From: Mathieu Poirier <mathieu.poirier@linaro.org>
> > 
> > The comment above function partition_sched_domains() clearly state that
> > the cpu_hotplug_lock should be held but doesn't mandate one to abide to
> > it.
> > 
> > Add an explicit check backing that comment, so to make it impossible
> > for anyone to miss the requirement.
> > 
> > Suggested-by: Juri Lelli <juri.lelli@redhat.com>
> > Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> > [modified changelog]
> > Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> -- Steve
> 
> > ---
> >  kernel/sched/topology.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> > index 61a1125c1ae4..96eee22fafe8 100644
> > --- a/kernel/sched/topology.c
> > +++ b/kernel/sched/topology.c
> > @@ -1858,6 +1858,7 @@ void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
> >  	int i, j, n;
> >  	int new_topology;
> >  
> > +	lockdep_assert_cpus_held();
> >  	mutex_lock(&sched_domains_mutex);
> >  
> >  	/* Always unregister in case we don't destroy any domains: */

Thanks for reviewing Steve. I thought this should be fine (also looking
at the comment before the function), but then got this from 0day

[    2.206129] .................................... done.
[    2.206662] Using IPI No-Shortcut mode
[    2.207084] sched_clock: Marking stable (2200014216, 0)->(2435550722, -235536506)
[    2.208792] registered taskstats version 1
[    2.209251] page_owner is disabled
[    2.290164] WARNING: CPU: 0 PID: 13 at kernel/cpu.c:311 lockdep_assert_cpus_held+0x22/0x26
[    2.291253] Modules linked in:
[    2.291589] CPU: 0 PID: 13 Comm: cpuhp/0 Not tainted 4.17.0-rc6-00217-gebf44b4 #2
[    2.292367] EIP: lockdep_assert_cpus_held+0x22/0x26
[    2.292882] EFLAGS: 00210246 CPU: 0
[    2.293255] EAX: 00000000 EBX: 00000000 ECX: c1b1fd98 EDX: 00200286
[    2.293915] ESI: 00000000 EDI: c1b1fcb4 EBP: dd8a3e60 ESP: dd8a3e60
[    2.294578]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    2.295128] CR0: 80050033 CR2: 00000000 CR3: 01c9d000 CR4: 000006d0
[    2.295770] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    2.296409] DR6: fffe0ff0 DR7: 00000400
[    2.296802] Call Trace:
[    2.297066]  partition_sched_domains+0x1b/0x29f
[    2.297557]  ? dl_cpu_busy+0x1b5/0x1c6
[    2.297955]  sched_cpu_deactivate+0x8b/0xb6
[    2.298403]  ? call_rcu_bh+0x17/0x17
[    2.298786]  ? call_rcu_bh+0x17/0x17
[    2.299170]  ? rcu_read_lock_bh_held+0x55/0x55
[    2.299648]  ? sched_cpu_activate+0xcc/0xcc
[    2.300076]  cpuhp_invoke_callback+0x19d/0x978
[    2.300537]  cpuhp_thread_fun+0x125/0x16b
[    2.300949]  smpboot_thread_fn+0x192/0x1a6
[    2.301377]  kthread+0xfc/0x101
[    2.301703]  ? sort_range+0x1d/0x1d
[    2.302062]  ? kthread_flush_work_fn+0x12/0x12
[    2.302524]  ret_from_fork+0x2e/0x40
[    2.302891] Code: ff 83 c4 10 5b 5e 5f 5d c3 55 89 e5 e8 ca dc fe ff 83 3d 20 bc b4 c1 00 74 13 83 ca ff b8 98 fd b1 c1 e8 e2 4b 04 00 85 c0 75 02 <0f> 0b 5d c3 55 89 e5 56 53 e8 a2 dc fe ff 89 c6 3b 05 8c 40 bd 
[    2.304975] irq event stamp: 308
[    2.305335] hardirqs last  enabled at (307): [<c179d83c>] _raw_spin_unlock_irqrestore+0x4a/0x68
[    2.306195] hardirqs last disabled at (308): [<c179ed38>] common_exception+0x46/0x6e
[    2.306969] softirqs last  enabled at (0): [<c10448e6>] copy_process+0x582/0x16c5
[    2.307720] softirqs last disabled at (0): [<00000000>]   (null)
[    2.308328] ---[ end trace 7197acb79221f1b9 ]---

Guess early boot is "special"? :-/

Best,

- Juri
