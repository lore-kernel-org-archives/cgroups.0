From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v7 0/5] cpuset: Enable cpuset controller in default
 hierarchy
Date: Mon, 23 Apr 2018 15:07:15 +0200
Message-ID: <20180423130715.GA32341@localhost.localdomain>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524145624-23655-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hi Waiman,

On 19/04/18 09:46, Waiman Long wrote:
> v7:
>  - Add a root-only cpuset.cpus.isolated control file for CPU isolation.
>  - Enforce that load_balancing can only be turned off on cpusets with
>    CPUs from the isolated list.
>  - Update sched domain generation to allow cpusets with CPUs only
>    from the isolated CPU list to be in separate root domains.

Just got this while

# echo 2-3 > /sys/fs/cgroup/cpuset.cpus.isolated

[ 6679.177826] =============================
[ 6679.178385] WARNING: suspicious RCU usage
[ 6679.178910] 4.16.0-rc6+ #151 Not tainted
[ 6679.179459] -----------------------------
[ 6679.180082] /home/juri/work/kernel/linux/kernel/cgroup/cgroup.c:3826 cgroup_mutex or RCU read lock required!
[ 6679.181402]
[ 6679.181402] other info that might help us debug this:
[ 6679.181402]
[ 6679.182407]
[ 6679.182407] rcu_scheduler_active = 2, debug_locks = 1
[ 6679.183278] 3 locks held by bash/2205:
[ 6679.183785]  #0:  (sb_writers#10){.+.+}, at: [<000000004e577fb9>] vfs_write+0x18a/0x1b0
[ 6679.184871]  #1:  (&of->mutex){+.+.}, at: [<000000005944c83f>] kernfs_fop_write+0xe2/0x1a0
[ 6679.185987]  #2:  (cpuset_mutex){+.+.}, at: [<00000000879bfba0>] cpuset_write_resmask+0x72/0x1560
[ 6679.187112]
[ 6679.187112] stack backtrace:
[ 6679.187612] CPU: 3 PID: 2205 Comm: bash Not tainted 4.16.0-rc6+ #151
[ 6679.188318] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
[ 6679.189291] Call Trace:
[ 6679.189581]  dump_stack+0x85/0xc5
[ 6679.189963]  css_next_child+0x90/0xd0
[ 6679.190385]  cpuset_write_resmask+0x46f/0x1560
[ 6679.190885]  ? lock_acquire+0x9f/0x210
[ 6679.191315]  cgroup_file_write+0x94/0x230
[ 6679.191768]  kernfs_fop_write+0x113/0x1a0
[ 6679.192223]  __vfs_write+0x36/0x180
[ 6679.192617]  ? rcu_read_lock_sched_held+0x6b/0x80
[ 6679.193139]  ? rcu_sync_lockdep_assert+0x2e/0x60
[ 6679.193654]  ? __sb_start_write+0x154/0x1f0
[ 6679.194118]  ? __sb_start_write+0x16a/0x1f0
[ 6679.194607]  vfs_write+0xc1/0x1b0
[ 6679.194984]  SyS_write+0x55/0xc0
[ 6679.195365]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[ 6679.195839]  do_syscall_64+0x79/0x220
[ 6679.196212]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[ 6679.196729] RIP: 0033:0x7f03183ff780
[ 6679.197138] RSP: 002b:00007ffeae336ca8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ 6679.197866] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f03183ff780
[ 6679.198550] RDX: 0000000000000004 RSI: 0000000000eaf408 RDI: 0000000000000001
[ 6679.199235] RBP: 0000000000eaf408 R08: 000000000000000a R09: 00007f0318cff700
[ 6679.199928] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f03186b57a0
[ 6679.200615] R13: 0000000000000004 R14: 0000000000000001 R15: 0000000000000000
[ 6679.201369] rebuild_sched_domains dom 0: 0-1
[ 6679.202196] span: 0-1 (max cpu_capacity = 1024)

Guess we should grab either lock from the writing path.

Best,

- Juri
