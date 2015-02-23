From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for
 memory
Date: Mon, 23 Feb 2015 15:28:11 +0100
Message-ID: <20150223142811.GF24272@dhcp22.suse.cz>
References: <1421767915-14232-1-git-send-email-hannes@cmpxchg.org>
 <1421767915-14232-3-git-send-email-hannes@cmpxchg.org>
 <54EB0B70.2040902@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54EB0B70.2040902-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 23-02-15 06:13:52, Sasha Levin wrote:
> Hi Johannes,
> 
> On 01/20/2015 10:31 AM, Johannes Weiner wrote:
> > Introduce the basic control files to account, partition, and limit
> > memory using cgroups in default hierarchy mode.
> 
> I'm seeing the following while fuzzing:

Already fixed by http://marc.info/?l=linux-mm&m=142416201408215&w=2.
Andrew has picked up the patch AFAIR but there is no mmotm tree yet.

> [ 5634.427361] GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> [ 5634.430492] Dumping ftrace buffer:
> [ 5634.430565]    (ftrace buffer empty)
> [ 5634.430565] Modules linked in:
> [ 5634.430565] CPU: 0 PID: 3983 Comm: kswapd0 Not tainted 3.19.0-next-20150222-sasha-00045-g8dc7569 #1943
> [ 5634.430565] task: ffff88056a7cb000 ti: ffff880568860000 task.ti: ffff880568860000
> [ 5634.430565] RIP: mem_cgroup_low (./arch/x86/include/asm/atomic64_64.h:21 include/asm-generic/atomic-long.h:31 include/linux/page_counter.h:34 mm/memcontrol.c:5438)
> [ 5634.430565] RSP: 0000:ffff880568867968  EFLAGS: 00010202
> [ 5634.430565] RAX: 000000000000001a RBX: 0000000000000000 RCX: 0000000000000000
> [ 5634.430565] RDX: 1ffff1000822a3a4 RSI: ffff880041151bd8 RDI: ffff880041151cb8
> [ 5634.430565] RBP: ffff880568867998 R08: 0000000000000000 R09: 0000000000000001
> [ 5634.430565] R10: ffff880041151bd8 R11: 0000000000000000 R12: 00000000000000d0
> [ 5634.430565] R13: dffffc0000000000 R14: ffff8800000237b0 R15: 0000000000000000
> [ 5634.430565] FS:  0000000000000000(0000) GS:ffff88091aa00000(0000) knlGS:0000000000000000
> [ 5634.430565] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 5634.430565] CR2: 000000000138efd8 CR3: 0000000500078000 CR4: 00000000000007b0
> [ 5634.430565] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 5634.430565] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 5634.430565] Stack:
> [ 5634.430565]  ffff880568867988 ffff880041151bd8 0000000000000000 ffff880000610000
> [ 5634.430565]  ffff880568867d68 dffffc0000000000 ffff880568867b38 ffffffff81a1ac0f
> [ 5634.430565]  ffffffff81b875b0 1ffff100ad10cf45 ffff880568867d80 ffff880568867d70
> [ 5634.430565] Call Trace:
> [ 5634.430565] shrink_zone (mm/vmscan.c:2389)
> [ 5634.430565] ? percpu_ref_get_many (include/linux/percpu-refcount.h:270)
> [ 5634.430565] ? shrink_lruvec (mm/vmscan.c:2365)
> [ 5634.430565] kswapd (mm/vmscan.c:3104 mm/vmscan.c:3276 mm/vmscan.c:3484)
> [ 5634.430565] ? debug_check_no_locks_freed (kernel/locking/lockdep.c:3051)
> [ 5634.430565] ? mem_cgroup_shrink_node_zone (mm/vmscan.c:3401)
> [ 5634.430565] ? __tick_nohz_task_switch (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/time/tick-sched.c:292 (discriminator 2))
> [ 5634.430565] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2554 kernel/locking/lockdep.c:2601)
> [ 5634.430565] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
> [ 5634.430565] ? finish_task_switch (kernel/sched/core.c:2229)
> [ 5634.430565] ? finish_task_switch (kernel/sched/sched.h:1058 kernel/sched/core.c:2210)
> [ 5634.430565] ? __init_waitqueue_head (kernel/sched/wait.c:292)
> [ 5634.430565] ? __schedule (kernel/sched/core.c:2320 kernel/sched/core.c:2778)
> [ 5634.430565] ? mem_cgroup_shrink_node_zone (mm/vmscan.c:3401)
> [ 5634.430565] ? mem_cgroup_shrink_node_zone (mm/vmscan.c:3401)
> [ 5634.430565] kthread (kernel/kthread.c:207)
> [ 5634.430565] ? __tick_nohz_task_switch (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/time/tick-sched.c:292 (discriminator 2))
> [ 5634.430565] ? flush_kthread_work (kernel/kthread.c:176)
> [ 5634.430565] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2554 kernel/locking/lockdep.c:2601)
> [ 5634.430565] ? schedule_tail (kernel/sched/core.c:2268)
> [ 5634.430565] ? flush_kthread_work (kernel/kthread.c:176)
> [ 5634.430565] ret_from_fork (arch/x86/kernel/entry_64.S:283)
> [ 5634.430565] ? flush_kthread_work (kernel/kthread.c:176)
> [ 5634.430565] Code: ff 49 39 de 0f 84 bd 00 00 00 49 89 dc 49 81 c4 d0 00 00 00 0f 84 f7 00 00 00 41 f6 c4 07 0f 85 ed 00 00 00 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 0f 85 ef 00 00 00 4c 8b a3 d0 00 00 00 48 85 db
> All code
> ========
>    0:	ff 49 39             	decl   0x39(%rcx)
>    3:	de 0f                	fimul  (%rdi)
>    5:	84 bd 00 00 00 49    	test   %bh,0x49000000(%rbp)
>    b:	89 dc                	mov    %ebx,%esp
>    d:	49 81 c4 d0 00 00 00 	add    $0xd0,%r12
>   14:	0f 84 f7 00 00 00    	je     0x111
>   1a:	41 f6 c4 07          	test   $0x7,%r12b
>   1e:	0f 85 ed 00 00 00    	jne    0x111
>   24:	4c 89 e0             	mov    %r12,%rax
>   27:	48 c1 e8 03          	shr    $0x3,%rax
>   2b:*	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)		<-- trapping instruction
>   30:	0f 85 ef 00 00 00    	jne    0x125
>   36:	4c 8b a3 d0 00 00 00 	mov    0xd0(%rbx),%r12
>   3d:	48 85 db             	test   %rbx,%rbx
> 	...
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
>    5:	0f 85 ef 00 00 00    	jne    0xfa
>    b:	4c 8b a3 d0 00 00 00 	mov    0xd0(%rbx),%r12
>   12:	48 85 db             	test   %rbx,%rbx
> 	...
> [ 5634.430565] RIP mem_cgroup_low (./arch/x86/include/asm/atomic64_64.h:21 include/asm-generic/atomic-long.h:31 include/linux/page_counter.h:34 mm/memcontrol.c:5438)
> [ 5634.430565]  RSP <ffff880568867968>
> 
> 
> Thanks,
> Sasha

-- 
Michal Hocko
SUSE Labs
