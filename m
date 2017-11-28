From: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroup/for-next: WARNING: possible circular locking dependency
 detected in cpuset_write_resmask
Date: Mon, 27 Nov 2017 17:22:21 -0800
Message-ID: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RUFB1Mx4eG9ItTK+x0f8611k/UN31KSNDVC66Xvdn4w=;
        b=jwsYlQto3UMX5SQI+NCX2T08IuaMWMrkzDbV2MA+7HwhIVZGiM8KaX/zbm59k03A0o
         Yl916jdLmDISTd9V2TuIgrw415H+OCKy1UL2aSoe73aDqTqrXCSmwRvAfTO7hcE7tSkv
         8OhMh8A6ag72nT5MPjk5lP7kFEokqBQXZQVGKc5iz9yhTmRYhJ7ksns97KRcmYuhsPuk
         66wW3TGHXJ68LCTEEa3GR/WHuHB12pVfwDCoPQUSWrMsfkPicUqYVzl7YlEuge4Rx20K
         JWS19q+wCD5oLTjUIk/dhgepKDJYdTc5y5rs4FG7RNZx7kIwLHsLOtuGqqa/Fs8zTpsq
         eeBA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Hi,

We run CRIU tests for cgroup/for-next regularly, and today they
detected this warning:


[  380.301034] ======================================================
[  380.301096] WARNING: possible circular locking dependency detected
[  380.301159] 4.15.0-rc1+ #1 Not tainted
[  380.301223] ------------------------------------------------------
[  380.301284] criu/14277 is trying to acquire lock:
[  380.301346]  (cpuset_mutex){+.+.}, at: [<ffffffffb3160191>]
cpuset_write_resmask+0x61/0x1100
[  380.301423]
[  380.301423] but task is already holding lock:
[  380.301489]  (cpu_hotplug_lock.rw_sem){++++}, at:
[<ffffffffb3160183>] cpuset_write_resmask+0x53/0x1100
[  380.301559]
[  380.301559] which lock already depends on the new lock.
[  380.301559]
[  380.301632]
[  380.301632] the existing dependency chain (in reverse order) is:
[  380.301699]
[  380.301699] -> #1 (cpu_hotplug_lock.rw_sem){++++}:
[  380.301770]        cpus_read_lock+0x3e/0x80
[  380.301835]        static_key_slow_inc+0xe/0xa0
[  380.301897]        cpuset_css_online+0x62/0x330
[  380.301961]        online_css+0x26/0x80
[  380.302022]        cgroup_apply_control_enable+0x266/0x3d0
[  380.302084]        cgroup_mkdir+0x37d/0x4f0
[  380.302148]        kernfs_iop_mkdir+0x53/0x80
[  380.302213]        vfs_mkdir+0x10e/0x1a0
[  380.302275]        SyS_mkdirat+0xb3/0xe0
[  380.302338]        entry_SYSCALL_64_fastpath+0x23/0x9a
[  380.302399]
[  380.302399] -> #0 (cpuset_mutex){+.+.}:
[  380.302468]        lock_acquire+0xec/0x1e0
[  380.302531]        __mutex_lock+0x89/0x920
[  380.302593]        cpuset_write_resmask+0x61/0x1100
[  380.302655]        cgroup_file_write+0x7b/0x200
[  380.302716]        kernfs_fop_write+0x112/0x1a0
[  380.302779]        __vfs_write+0x23/0x150
[  380.302840]        vfs_write+0xc8/0x1c0
[  380.302901]        SyS_write+0x45/0xa0
[  380.302963]        entry_SYSCALL_64_fastpath+0x23/0x9a
[  380.303023]
[  380.303023] other info that might help us debug this:
[  380.303023]
[  380.303095]  Possible unsafe locking scenario:
[  380.303095]
[  380.303162]        CPU0                    CPU1
[  380.303225]        ----                    ----
[  380.303285]   lock(cpu_hotplug_lock.rw_sem);
[  380.303347]                                lock(cpuset_mutex);
[  380.303408]                                lock(cpu_hotplug_lock.rw_sem);
[  380.303470]   lock(cpuset_mutex);
[  380.303531]
[  380.303531]  *** DEADLOCK ***
[  380.303531]
[  380.303609] 3 locks held by criu/14277:
[  380.303677]  #0:  (sb_writers#12){.+.+}, at: [<ffffffffb3284a70>]
vfs_write+0x1a0/0x1c0
[  380.303746]  #1:  (&of->mutex){+.+.}, at: [<ffffffffb3317dc2>]
kernfs_fop_write+0xe2/0x1a0
[  380.303816]  #2:  (cpu_hotplug_lock.rw_sem){++++}, at:
[<ffffffffb3160183>] cpuset_write_resmask+0x53/0x1100
[  380.303886]
[  380.303886] stack backtrace:
[  380.303953] CPU: 0 PID: 14277 Comm: criu Not tainted 4.15.0-rc1+ #1
[  380.304015] Hardware name: Google Google Compute Engine/Google
Compute Engine, BIOS Google 01/01/2011
[  380.304081] Call Trace:
[  380.304146]  dump_stack+0x7c/0xbe
[  380.304212]  print_circular_bug+0x20d/0x320
[  380.304276]  ? copy_trace+0xb0/0xb0
[  380.304337]  check_prev_add+0x41d/0x770
[  380.304400]  ? __lock_acquire+0x1091/0x1130
[  380.304461]  __lock_acquire+0x1091/0x1130
[  380.304523]  lock_acquire+0xec/0x1e0
[  380.304586]  ? cpuset_write_resmask+0x61/0x1100
[  380.304649]  __mutex_lock+0x89/0x920
[  380.304711]  ? cpuset_write_resmask+0x61/0x1100
[  380.304774]  ? cpuset_write_resmask+0x61/0x1100
[  380.304837]  ? cpuset_write_resmask+0x27f/0x1100
[  380.304900]  ? cpuset_write_resmask+0x27f/0x1100
[  380.304962]  ? cpuset_write_resmask+0x61/0x1100
[  380.305024]  cpuset_write_resmask+0x61/0x1100
[  380.305086]  ? kernfs_fop_write+0xea/0x1a0
[  380.305148]  cgroup_file_write+0x7b/0x200
[  380.305215]  kernfs_fop_write+0x112/0x1a0
[  380.305277]  __vfs_write+0x23/0x150
[  380.305341]  ? rcu_read_lock_sched_held+0x3f/0x70
[  380.305404]  ? rcu_sync_lockdep_assert+0x2a/0x50
[  380.305466]  ? __sb_start_write+0xd2/0x1b0
[  380.305527]  ? vfs_write+0x1a0/0x1c0
[  380.305588]  vfs_write+0xc8/0x1c0
[  380.305650]  SyS_write+0x45/0xa0
[  380.305712]  entry_SYSCALL_64_fastpath+0x23/0x9a
[  380.305774] RIP: 0033:0x145971dc4330
[  380.305835] RSP: 002b:00007ffeaffb30b8 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  380.305903] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000145971dc4330
[  380.305964] RDX: 0000000000000003 RSI: 000000000137aac0 RDI: 0000000000000003
[  380.306026] RBP: 0000000000000000 R08: 737570632e746573 R09: 6f72702070756f72
[  380.306087] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000137b440
[  380.306149] R13: 0000000001373448 R14: 0000000001373450 R15: 000000000137a970


[avagin@laptop linux]$ git describe cgroup/for-next
v4.15-rc1-3-gddf7005f3221

All logs are here: https://travis-ci.org/avagin/linux/jobs/308154268

Thanks,
Andrei
