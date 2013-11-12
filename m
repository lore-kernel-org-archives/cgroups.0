From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Tue, 12 Nov 2013 09:55:30 -0600
Message-ID: <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1EHXN4atUEr2y/Z0a4FLw8K2DIlcGd7sl4HHHbu81Xg=;
        b=jiLDURwFO3iHiVUkkkXqF3rLJnOnZG+K28EdRmOUaVjPhdcLpLeSUPoKOCW0nEgBPS
         D3cGLKMyHB+MEVEWY+GY/876fXJoMRLy7AZHcij/tztxOBcJPFjVRlT31+bKyYfPKmKf
         bn6gEvEHLzeYAXzbbKZLC150/R0fs6lgyvJxXEemIR93zMEEuHbH/kQnOtg63PF5+4nM
         dKC5AAeBfrcoIxXHGqd9aR/N/xBlSalF062NYC81G9k0r0rha4QI63Z5JhE+BPFTy9Bo
         5dlV58l0hK8qYMAIbaxvQR2bs/kPvefscH6Aa4ShYLkMLHDxAXhzoIoTb1auo1gqzTwh
         JlVw==
Content-Disposition: inline
In-Reply-To: <20131112143147.GB6049@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Markus Blank-Burian <burian@muenster.de>

On Tue, Nov 12, 2013 at 03:31:47PM +0100, Michal Hocko wrote:
> On Tue 12-11-13 18:17:20, Li Zefan wrote:
> > Cc more people
> > 
> > On 2013/11/12 6:06, Shawn Bohrer wrote:
> > > Hello,
> > > 
> > > This morning I had a machine running 3.10.16 go unresponsive but
> > > before we killed it we were able to get the information below.  I'm
> > > not an expert here but it looks like most of the tasks below are
> > > blocking waiting on the cgroup_mutex.  You can see that the
> > > resource_alloca:16502 task is holding the cgroup_mutex and that task
> > > appears to be waiting on a lru_add_drain_all() to complete.
> 
> Do you have sysrq+l output as well by any chance? That would tell
> us what the current CPUs are doing. Dumping all kworker stacks
> might be helpful as well. We know that lru_add_drain_all waits for
> schedule_on_each_cpu to return so it is waiting for workers to finish.
> I would be really curious why some of lru_add_drain_cpu cannot finish
> properly. The only reason would be that some work item(s) do not get CPU
> or somebody is holding lru_lock.

In fact the sys-admin did manage to fire off a sysrq+l, I've put all
of the info from the syslog below.  I've looked it over and I'm not
sure it reveals anything.  First looking at the timestamps it appears
we ran the sysrq+l 19.2 hours after the cgroup_mutex lockup I
previously sent.  I also have atop logs over that whole time period
that show hundreds of zombie processes which to me indicates that over
that 19.2 hours systemd remained wedged on the cgroup_mutex.  Looking
at the backtraces from the sysrq+l it appears most of the CPUs were
idle except there are a few where ptpd is trying to step the clock
with clock_settime.  The ptpd process also appears to get stuck for a
bit but it looks like it recovers because it moves CPUs and the
previous CPUs become idle.  The fact that ptpd is stepping the clock
at all at this time means that timekeeping is a mess at this point and
the system clock is way out of sync.  There are also a few of these
NMI messages in there that I don't understand but at this point the
machine was a sinking ship.

Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Uhhuh. NMI received for unknown reason 21 on CPU 26.
Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Do you have a strange power saving mode enabled?
Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Dazed and confused, but trying to continue
Nov 11 07:03:29 sydtest0 kernel: [764305.327143] Uhhuh. NMI received for unknown reason 31 on CPU 27.
Nov 11 07:03:29 sydtest0 kernel: [764305.327144] Do you have a strange power saving mode enabled?
Nov 11 07:03:29 sydtest0 kernel: [764305.327144] Dazed and confused, but trying to continue
Nov 11 07:03:29 sydtest0 kernel: [764305.327242] Uhhuh. NMI received for unknown reason 31 on CPU 28.
Nov 11 07:03:29 sydtest0 kernel: [764305.327242] Do you have a strange power saving mode enabled?
Nov 11 07:03:29 sydtest0 kernel: [764305.327243] Dazed and confused, but trying to continue

Perhaps there is another task blocking somewhere holding the lru_lock, but at
this point the machine has been rebooted so I'm not sure how we'd figure out
what task that might be. Anyway here is the full output of sysrq+l plus
whatever else ended up in the syslog.

Nov 11 07:00:12 sydtest0 kernel: [764111.523222] SysRq : Show backtrace of all active CPUs
Nov 11 07:00:12 sydtest0 kernel: [764111.610222] sending NMI to all CPUs:
Nov 11 07:00:12 sydtest0 kernel: [764111.696668] NMI backtrace for cpu 0
Nov 11 07:00:12 sydtest0 kernel: [764111.782738] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:12 sydtest0 kernel: [764111.870164] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:12 sydtest0 kernel: [764111.957565] task: ffffffff81a10440 ti: ffffffff81a00000 task.ti: ffffffff81a00000
Nov 11 07:00:12 sydtest0 kernel: [764112.044754] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:12 sydtest0 kernel: [764112.132714] RSP: 0018:ffffffff81a01ea8  EFLAGS: 00000286
Nov 11 07:00:12 sydtest0 kernel: [764112.219581] RAX: 00000000ffffffed RBX: ffffffff81a01fd8 RCX: 0140000000000000
Nov 11 07:00:12 sydtest0 kernel: [764112.306956] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc0d620
Nov 11 07:00:12 sydtest0 kernel: [764112.394305] RBP: ffffffff81a01ec8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:12 sydtest0 kernel: [764112.480854] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81a01fd8
Nov 11 07:00:12 sydtest0 kernel: [764112.567378] R13: 0000000000000000 R14: ffffffff81a01fd8 R15: 0000000000000000
Nov 11 07:00:12 sydtest0 kernel: [764112.653981] FS:  0000000000000000(0000) GS:ffff88041fc00000(0000) knlGS:0000000000000000
Nov 11 07:00:12 sydtest0 kernel: [764112.741036] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:12 sydtest0 kernel: [764112.827878] CR2: 00007fd1dc6cc000 CR3: 0000000787468000 CR4: 00000000000407f0
Nov 11 07:00:12 sydtest0 kernel: [764112.915812] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:12 sydtest0 kernel: [764113.003532] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:12 sydtest0 kernel: [764113.090719] Stack:
Nov 11 07:00:12 sydtest0 kernel: [764113.177162]  ffffffff81a01fd8 ffffffff81a01fd8 ffffffff81a01fd8 ffffffff81a01fd8
Nov 11 07:00:12 sydtest0 kernel: [764113.266400]  ffffffff81a01ed8 ffffffff8100aace ffffffff81a01f48 ffffffff810754be
Nov 11 07:00:12 sydtest0 kernel: [764113.355053]  ffffffff81a01fd8 ffffffff81a10440 0000000000000286 ffffffffffffffff
Nov 11 07:00:12 sydtest0 kernel: [764113.443493] Call Trace:
Nov 11 07:00:12 sydtest0 kernel: [764113.530925]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:12 sydtest0 kernel: [764113.618830]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:12 sydtest0 kernel: [764113.705858]  [<ffffffff814ac087>] rest_init+0x77/0x80
Nov 11 07:00:12 sydtest0 kernel: [764113.791636]  [<ffffffff81adae53>] start_kernel+0x3c9/0x3d6
Nov 11 07:00:12 sydtest0 kernel: [764113.876987]  [<ffffffff81ada88a>] ? repair_env_string+0x5a/0x5a
Nov 11 07:00:12 sydtest0 kernel: [764113.961593]  [<ffffffff81ada5a8>] x86_64_start_reservations+0x2a/0x2c
Nov 11 07:00:12 sydtest0 kernel: [764114.045959]  [<ffffffff81ada68f>] x86_64_start_kernel+0xe5/0xec
Nov 11 07:00:12 sydtest0 kernel: [764114.129765] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:12 sydtest0 kernel: [764114.307738] NMI backtrace for cpu 1
Nov 11 07:00:15 sydtest0 kernel: [764114.394558] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:15 sydtest0 kernel: [764114.483289] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:15 sydtest0 kernel: [764114.572875] task: ffff88041dc7cdb0 ti: ffff88041dd6e000 task.ti: ffff88041dd6e000
Nov 11 07:00:15 sydtest0 kernel: [764114.663336] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:15 sydtest0 kernel: [764114.755077] RSP: 0018:ffff88041dd6fe88  EFLAGS: 00000286
Nov 11 07:00:15 sydtest0 kernel: [764114.846817] RAX: 00000000ffffffed RBX: ffff88041dd6ffd8 RCX: 0140000000000000
Nov 11 07:00:15 sydtest0 kernel: [764114.939730] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc0d620
Nov 11 07:00:15 sydtest0 kernel: [764115.032934] RBP: ffff88041dd6fea8 R08: 0000000000000000 R09: 0000000000000001
Nov 11 07:00:15 sydtest0 kernel: [764115.126192] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd6ffd8
Nov 11 07:00:15 sydtest0 kernel: [764115.219423] R13: 0000000000000001 R14: ffff88041dd6ffd8 R15: 0000000000000000
Nov 11 07:00:15 sydtest0 kernel: [764115.312576] FS:  0000000000000000(0000) GS:ffff88082fc00000(0000) knlGS:0000000000000000
Nov 11 07:00:15 sydtest0 kernel: [764115.405754] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:15 sydtest0 kernel: [764115.497814] CR2: 0000000001bd8060 CR3: 00000007128cb000 CR4: 00000000000407e0
Nov 11 07:00:15 sydtest0 kernel: [764115.589848] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:15 sydtest0 kernel: [764115.681056] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:15 sydtest0 kernel: [764115.770772] Stack:
Nov 11 07:00:15 sydtest0 kernel: [764115.859238]  ffff88041dd6ffd8 ffff88041dd6ffd8 ffff88041dd6ffd8 ffff88041dd6ffd8
Nov 11 07:00:15 sydtest0 kernel: [764115.950260]  ffff88041dd6feb8 ffffffff8100aace ffff88041dd6ff28 ffffffff810754be
Nov 11 07:00:15 sydtest0 kernel: [764116.040218]  ffff88041dd6fee8 ffffffff8107c92b ffff88082fc0cc40 0000000000000000
Nov 11 07:00:15 sydtest0 kernel: [764116.129910] Call Trace:
Nov 11 07:00:15 sydtest0 kernel: [764116.218778]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:15 sydtest0 kernel: [764116.308735]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:15 sydtest0 kernel: [764116.398638]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:15 sydtest0 kernel: [764116.489130]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:15 sydtest0 kernel: [764116.579589] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:15 sydtest0 kernel: [764116.772975] NMI backtrace for cpu 2
Nov 11 07:00:17 sydtest0 kernel: [764116.867645] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:17 sydtest0 kernel: [764116.964309] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:17 sydtest0 kernel: [764117.061774] task: ffff88041dc7d4c0 ti: ffff88041dd70000 task.ti: ffff88041dd70000
Nov 11 07:00:17 sydtest0 kernel: [764117.159957] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:17 sydtest0 kernel: [764117.258726] RSP: 0018:ffff88041dd71e88  EFLAGS: 00000286
Nov 11 07:00:17 sydtest0 kernel: [764117.357363] RAX: 00000000ffffffed RBX: ffff88041dd71fd8 RCX: 0140000000000000
Nov 11 07:00:17 sydtest0 kernel: [764117.457384] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc2d620
Nov 11 07:00:17 sydtest0 kernel: [764117.556766] RBP: ffff88041dd71ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:17 sydtest0 kernel: [764117.655270] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd71fd8
Nov 11 07:00:17 sydtest0 kernel: [764117.753027] R13: 0000000000000002 R14: ffff88041dd71fd8 R15: 0000000000000000
Nov 11 07:00:17 sydtest0 kernel: [764117.849799] FS:  0000000000000000(0000) GS:ffff88041fc20000(0000) knlGS:0000000000000000
Nov 11 07:00:17 sydtest0 kernel: [764117.946705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:17 sydtest0 kernel: [764118.042972] CR2: 00007facee9af000 CR3: 000000039dd06000 CR4: 00000000000407e0
Nov 11 07:00:17 sydtest0 kernel: [764118.140037] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:17 sydtest0 kernel: [764118.236755] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:17 sydtest0 kernel: [764118.332781] Stack:
Nov 11 07:00:17 sydtest0 kernel: [764118.427930]  ffff88041dd71fd8 ffff88041dd71fd8 ffff88041dd71fd8 ffff88041dd71fd8
Nov 11 07:00:17 sydtest0 kernel: [764118.525501]  ffff88041dd71eb8 ffffffff8100aace ffff88041dd71f28 ffffffff810754be
Nov 11 07:00:17 sydtest0 kernel: [764118.622273]  ffff88041dd71ee8 ffffffff8107c92b ffff88041fc2cc40 0000000000000000
Nov 11 07:00:17 sydtest0 kernel: [764118.718274] Call Trace:
Nov 11 07:00:17 sydtest0 kernel: [764118.813612]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:17 sydtest0 kernel: [764118.910731]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:17 sydtest0 kernel: [764119.007184]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:17 sydtest0 kernel: [764119.103426]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:17 sydtest0 kernel: [764119.200115] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:17 sydtest0 kernel: [764119.405003] NMI backtrace for cpu 3
Nov 11 07:00:20 sydtest0 kernel: [764119.504572] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:20 sydtest0 kernel: [764119.606241] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:20 sydtest0 kernel: [764119.708871] task: ffff88041dc7dbd0 ti: ffff88041dd72000 task.ti: ffff88041dd72000
Nov 11 07:00:20 sydtest0 kernel: [764119.812351] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:20 sydtest0 kernel: [764119.917058] RSP: 0018:ffff88041dd73e88  EFLAGS: 00000286
Nov 11 07:00:20 sydtest0 kernel: [764120.021524] RAX: 00000000ffffffed RBX: ffff88041dd73fd8 RCX: 0140000000000000
Nov 11 07:00:20 sydtest0 kernel: [764120.127401] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc2d620
Nov 11 07:00:20 sydtest0 kernel: [764120.231335] RBP: ffff88041dd73ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:20 sydtest0 kernel: [764120.333060] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd73fd8
Nov 11 07:00:20 sydtest0 kernel: [764120.434596] R13: 0000000000000003 R14: ffff88041dd73fd8 R15: 0000000000000000
Nov 11 07:00:20 sydtest0 kernel: [764120.535363] FS:  0000000000000000(0000) GS:ffff88082fc20000(0000) knlGS:0000000000000000
Nov 11 07:00:20 sydtest0 kernel: [764120.635916] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:20 sydtest0 kernel: [764120.735483] CR2: 0000003b0debd790 CR3: 000000041a425000 CR4: 00000000000407e0
Nov 11 07:00:20 sydtest0 kernel: [764120.835024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:20 sydtest0 kernel: [764120.933447] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:20 sydtest0 kernel: [764121.030671] Stack:
Nov 11 07:00:20 sydtest0 kernel: [764121.126858]  ffff88041dd73fd8 ffff88041dd73fd8 ffff88041dd73fd8 ffff88041dd73fd8
Nov 11 07:00:20 sydtest0 kernel: [764121.225680]  ffff88041dd73eb8 ffffffff8100aace ffff88041dd73f28 ffffffff810754be
Nov 11 07:00:20 sydtest0 kernel: [764121.324211]  ffff88041dd73ee8 ffffffff8107c92b ffff88082fc2cc40 0000000000000000
Nov 11 07:00:20 sydtest0 kernel: [764121.422608] Call Trace:
Nov 11 07:00:20 sydtest0 kernel: [764121.519651]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:20 sydtest0 kernel: [764121.617274]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:20 sydtest0 kernel: [764121.714391]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:20 sydtest0 kernel: [764121.812468]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:20 sydtest0 kernel: [764121.911102] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:20 sydtest0 kernel: [764122.118147] NMI backtrace for cpu 4
Nov 11 07:00:20 sydtest0 ptpd[14045]: Discarding DelayResponse with inconsistent RecvTime
Nov 11 07:00:20 sydtest0 ptpd[14045]:   DelayResponse Claimed: 1384174854.317779465, Delta: 1.166536718
Nov 11 07:00:23 sydtest0 kernel: [764122.219231] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:23 sydtest0 kernel: [764122.322471] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:23 sydtest0 kernel: [764122.425793] task: ffff88041dc7e2e0 ti: ffff88041dd74000 task.ti: ffff88041dd74000
Nov 11 07:00:23 sydtest0 kernel: [764122.529621] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:23 sydtest0 kernel: [764122.634752] RSP: 0018:ffff88041dd75e88  EFLAGS: 00000286
Nov 11 07:00:23 sydtest0 kernel: [764122.739592] RAX: 00000000ffffffed RBX: ffff88041dd75fd8 RCX: 0140000000000000
Nov 11 07:00:23 sydtest0 kernel: [764122.845256] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc4d620
Nov 11 07:00:23 sydtest0 kernel: [764122.949083] RBP: ffff88041dd75ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:23 sydtest0 kernel: [764123.050675] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd75fd8
Nov 11 07:00:23 sydtest0 kernel: [764123.152132] R13: 0000000000000004 R14: ffff88041dd75fd8 R15: 0000000000000000
Nov 11 07:00:23 sydtest0 kernel: [764123.252792] FS:  0000000000000000(0000) GS:ffff88041fc40000(0000) knlGS:0000000000000000
Nov 11 07:00:23 sydtest0 kernel: [764123.353210] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:23 sydtest0 kernel: [764123.452671] CR2: 00000000015bc448 CR3: 000000078ec0f000 CR4: 00000000000407e0
Nov 11 07:00:23 sydtest0 kernel: [764123.552106] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:23 sydtest0 kernel: [764123.650396] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:23 sydtest0 kernel: [764123.747461] Stack:
Nov 11 07:00:23 sydtest0 kernel: [764123.843540]  ffff88041dd75fd8 ffff88041dd75fd8 ffff88041dd75fd8 ffff88041dd75fd8
Nov 11 07:00:23 sydtest0 kernel: [764123.942230]  ffff88041dd75eb8 ffffffff8100aace ffff88041dd75f28 ffffffff810754be
Nov 11 07:00:23 sydtest0 kernel: [764124.040600]  ffff88041dd75ee8 ffffffff8107c92b ffff88041fc4cc40 0000000000000000
Nov 11 07:00:23 sydtest0 kernel: [764124.138810] Call Trace:
Nov 11 07:00:23 sydtest0 kernel: [764124.235665]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:23 sydtest0 kernel: [764124.333129]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:23 sydtest0 kernel: [764124.430060]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:23 sydtest0 kernel: [764124.527873]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:23 sydtest0 kernel: [764124.626239] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:23 sydtest0 kernel: [764124.832857] NMI backtrace for cpu 5
Nov 11 07:00:26 sydtest0 kernel: [764124.933758] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:26 sydtest0 kernel: [764125.036838] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:26 sydtest0 kernel: [764125.140027] task: ffff88041dc7e9f0 ti: ffff88041dd76000 task.ti: ffff88041dd76000
Nov 11 07:00:26 sydtest0 kernel: [764125.243774] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:26 sydtest0 kernel: [764125.348799] RSP: 0018:ffff88041dd77e88  EFLAGS: 00000286
Nov 11 07:00:26 sydtest0 kernel: [764125.453372] RAX: 00000000ffffffed RBX: ffff88041dd77fd8 RCX: 0140000000000000
Nov 11 07:00:26 sydtest0 kernel: [764125.558824] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc4d620
Nov 11 07:00:26 sydtest0 kernel: [764125.662412] RBP: ffff88041dd77ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:26 sydtest0 kernel: [764125.763789] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd77fd8
Nov 11 07:00:26 sydtest0 kernel: [764125.865008] R13: 0000000000000005 R14: ffff88041dd77fd8 R15: 0000000000000000
Nov 11 07:00:26 sydtest0 kernel: [764125.965428] FS:  0000000000000000(0000) GS:ffff88082fc40000(0000) knlGS:0000000000000000
Nov 11 07:00:26 sydtest0 kernel: [764126.065608] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:26 sydtest0 kernel: [764126.164883] CR2: 000000000251b8e0 CR3: 000000040ec11000 CR4: 00000000000407e0
Nov 11 07:00:26 sydtest0 kernel: [764126.264159] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:26 sydtest0 kernel: [764126.362289] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:26 sydtest0 kernel: [764126.459114] Stack:
Nov 11 07:00:26 sydtest0 kernel: [764126.554901]  ffff88041dd77fd8 ffff88041dd77fd8 ffff88041dd77fd8 ffff88041dd77fd8
Nov 11 07:00:26 sydtest0 kernel: [764126.653270]  ffff88041dd77eb8 ffffffff8100aace ffff88041dd77f28 ffffffff810754be
Nov 11 07:00:26 sydtest0 kernel: [764126.751375]  ffff88041dd77ee8 ffffffff8107c92b ffff88082fc4cc40 0000000000000000
Nov 11 07:00:26 sydtest0 kernel: [764126.849345] Call Trace:
Nov 11 07:00:26 sydtest0 kernel: [764126.945933]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:26 sydtest0 kernel: [764127.043132]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:26 sydtest0 kernel: [764127.139824]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:26 sydtest0 kernel: [764127.237449]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:26 sydtest0 kernel: [764127.335629] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:26 sydtest0 kernel: [764127.541741] NMI backtrace for cpu 6
Nov 11 07:00:55 sydtest0 kernel: [764127.642374] CPU: 6 PID: 9400 Comm: bash Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764127.745109] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764127.847952] task: ffff880399d30000 ti: ffff8804104e0000 task.ti: ffff8804104e0000
Nov 11 07:00:55 sydtest0 kernel: [764127.951299] RIP: 0010:[<ffffffff81269f77>]  [<ffffffff81269f77>] delay_tsc+0x37/0x60
Nov 11 07:00:55 sydtest0 kernel: [764128.055846] RSP: 0018:ffff8804104e1d98  EFLAGS: 00000046
Nov 11 07:00:55 sydtest0 kernel: [764128.160045] RAX: 00000000f56f89f5 RBX: 00000000000003e9 RCX: 0000000000000006
Nov 11 07:00:55 sydtest0 kernel: [764128.265045] RDX: 000000000007e060 RSI: 00000000f56f89b3 RDI: 0000000000046cc7
Nov 11 07:00:55 sydtest0 kernel: [764128.367673] RBP: ffff8804104e1d98 R08: 0000000000000006 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764128.468013] R10: 00000000000005bd R11: 0000000000000001 R12: 0000000000001000
Nov 11 07:00:55 sydtest0 kernel: [764128.567821] R13: ffffffff81abcf00 R14: 0000000000000400 R15: 0000000000000096
Nov 11 07:00:55 sydtest0 kernel: [764128.666564] FS:  00007f67dc3cd700(0000) GS:ffff88041fc60000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764128.765492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764128.863596] CR2: 00007f67dc3ef000 CR3: 00000003ad331000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764128.961700] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764129.058739] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764129.154633] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764129.249409]  ffff8804104e1da8 ffffffff81269ed8 ffff8804104e1dc8 ffffffff8102471a
Nov 11 07:00:55 sydtest0 kernel: [764129.346821]  0000000000000002 000000000000b06a ffff8804104e1e18 ffffffff81025310
Nov 11 07:00:55 sydtest0 kernel: [764129.444152]  ffffffff00000026 0000000000000007 ffff8804104e1e38 0000000000002710
Nov 11 07:00:55 sydtest0 kernel: [764129.541297] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764129.637140]  [<ffffffff81269ed8>] __const_udelay+0x28/0x30
Nov 11 07:00:55 sydtest0 kernel: [764129.733646]  [<ffffffff8102471a>] native_safe_apic_wait_icr_idle+0x2a/0x60
Nov 11 07:00:55 sydtest0 kernel: [764129.830257]  [<ffffffff81025310>] default_send_IPI_mask_sequence_phys+0xc0/0xd0
Nov 11 07:00:55 sydtest0 kernel: [764129.927563]  [<ffffffff81028817>] physflat_send_IPI_all+0x17/0x20
Nov 11 07:00:55 sydtest0 kernel: [764130.025506]  [<ffffffff81025481>] arch_trigger_all_cpu_backtrace+0x61/0xa0
Nov 11 07:00:55 sydtest0 kernel: [764130.123211]  [<ffffffff8130033e>] sysrq_handle_showallcpus+0xe/0x10
Nov 11 07:00:55 sydtest0 kernel: [764130.220195]  [<ffffffff81300741>] __handle_sysrq+0x121/0x190
Nov 11 07:00:55 sydtest0 kernel: [764130.317287]  [<ffffffff813007fa>] write_sysrq_trigger+0x4a/0x50
Nov 11 07:00:55 sydtest0 kernel: [764130.414540]  [<ffffffff811936c3>] proc_reg_write+0x43/0x70
Nov 11 07:00:55 sydtest0 kernel: [764130.510754]  [<ffffffff8113820e>] vfs_write+0xce/0x1e0
Nov 11 07:00:55 sydtest0 kernel: [764130.606353]  [<ffffffff811386f2>] SyS_write+0x52/0xa0
Nov 11 07:00:55 sydtest0 kernel: [764130.701395]  [<ffffffff814bda2e>] ? do_page_fault+0xe/0x10
Nov 11 07:00:55 sydtest0 kernel: [764130.796144]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 11 07:00:55 sydtest0 kernel: [764130.890785] Code: 04 25 64 b0 00 00 0f 1f 00 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 65 8b 0c 25 64 b0 00 00 41 39 c8 75 12 0f 1f 00 0f ae e8 0f 31 <89> c2 29 f2 39 fa 72 e1 5d c3 29 c6 01 f7 0f 1f 00 0f ae e8 0f 
Nov 11 07:00:55 sydtest0 kernel: [764131.085555] NMI backtrace for cpu 15
Nov 11 07:00:55 sydtest0 kernel: [764131.179376] CPU: 15 PID: 16351 Comm: bus_tail Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764131.274709] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764131.369992] task: ffff8803ad0569f0 ti: ffff8804108ae000 task.ti: ffff8804108ae000
Nov 11 07:00:55 sydtest0 kernel: [764131.465246] RIP: 0033:[<0000003b0dee41bd>]  [<0000003b0dee41bd>] 0x3b0dee41bc
Nov 11 07:00:55 sydtest0 kernel: [764131.560269] RSP: 002b:00007f080d9e0ae0  EFLAGS: 00000293
Nov 11 07:00:55 sydtest0 kernel: [764131.654326] RAX: 0000000000000000 RBX: 00007f07fc0008c0 RCX: 0000003b0dee41bd
Nov 11 07:00:55 sydtest0 kernel: [764131.748782] RDX: 0000000000001000 RSI: 00007f080f6ab000 RDI: 000000000000000e
Nov 11 07:00:55 sydtest0 kernel: [764131.842759] RBP: 00007fff92800e40 R08: 00007f080d9e1700 R09: 0000000000e5ec58
Nov 11 07:00:55 sydtest0 kernel: [764131.936417] R10: 0000000000e5ec58 R11: 0000000000000293 R12: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764132.030048] R13: 00007fff92800e18 R14: 00007f080d9e0b60 R15: 0000000000e5eb10
Nov 11 07:00:55 sydtest0 kernel: [764132.123546] FS:  00007f080d9e1700(0000) GS:ffff88082fce0000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764132.217736] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764132.311341] CR2: 00000000015bc448 CR3: 00000007f62dc000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764132.405398] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764132.499535] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764132.593697] 
Nov 11 07:00:55 sydtest0 kernel: [764132.686079] NMI backtrace for cpu 18
Nov 11 07:00:55 sydtest0 kernel: [764132.777927] CPU: 18 PID: 14045 Comm: ptpd Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764132.872062] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764132.967238] task: ffff8808105d62e0 ti: ffff8807d0afa000 task.ti: ffff8807d0afa000
Nov 11 07:00:55 sydtest0 kernel: [764133.062413] RIP: 0010:[<ffffffff81083502>]  [<ffffffff81083502>] smp_call_function_many+0x272/0x2d0
Nov 11 07:00:55 sydtest0 kernel: [764133.159240] RSP: 0018:ffff8807d0afbdf8  EFLAGS: 00000202
Nov 11 07:00:55 sydtest0 kernel: [764133.256093] RAX: 0000000000000004 RBX: ffff88041fd33648 RCX: ffff88041fc56b78
Nov 11 07:00:55 sydtest0 kernel: [764133.353796] RDX: 0000000000000004 RSI: 0000000000000100 RDI: 0000000000000100
Nov 11 07:00:55 sydtest0 kernel: [764133.451234] RBP: ffff8807d0afbe58 R08: ffff88041fd33648 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764133.546676] R10: 0000000000000004 R11: 0000000000000246 R12: ffff88041fd33640
Nov 11 07:00:55 sydtest0 kernel: [764133.640228] R13: ffffffff81062480 R14: 0000000000000000 R15: 0000000000013600
Nov 11 07:00:55 sydtest0 kernel: [764133.733566] FS:  00007fc28c07a700(0000) GS:ffff88041fd20000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764133.827249] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764133.920002] CR2: 0000003b0de16c4c CR3: 00000007f0ae3000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764134.012967] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764134.104709] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764134.195118] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764134.284171]  ffff88082fdf3610 ffff88082fdf3600 ffff88082fdf6b78 ffffffff0000001f
Nov 11 07:00:55 sydtest0 kernel: [764134.376205]  01ff8807d0afbe38 ffff88041fd33668 ffff88080beaf400 ffffffff81062480
Nov 11 07:00:55 sydtest0 kernel: [764134.468184]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764134.561071] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764134.653322]  [<ffffffff81062480>] ? hrtimer_cancel+0x30/0x30
Nov 11 07:00:55 sydtest0 kernel: [764134.746073]  [<ffffffff810835e2>] smp_call_function+0x22/0x30
Nov 11 07:00:55 sydtest0 kernel: [764134.838133]  [<ffffffff81083648>] on_each_cpu+0x28/0x50
Nov 11 07:00:55 sydtest0 kernel: [764134.929341]  [<ffffffff8106272c>] clock_was_set+0x1c/0x30
Nov 11 07:00:55 sydtest0 kernel: [764135.020737]  [<ffffffff8107701e>] do_settimeofday+0xfe/0x110
Nov 11 07:00:55 sydtest0 kernel: [764135.112770]  [<ffffffff8104244d>] do_sys_settimeofday+0xdd/0xf0
Nov 11 07:00:55 sydtest0 kernel: [764135.204059]  [<ffffffff813f6fe9>] ? __sys_recvmsg+0x49/0x90
Nov 11 07:00:55 sydtest0 kernel: [764135.294388]  [<ffffffff8105d513>] posix_clock_realtime_set+0x13/0x20
Nov 11 07:00:55 sydtest0 kernel: [764135.385064]  [<ffffffff8105e55f>] SyS_clock_settime+0x5f/0x90
Nov 11 07:00:55 sydtest0 kernel: [764135.475848]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 11 07:00:55 sydtest0 kernel: [764135.565856] Code: 15 c1 1e 00 3b 05 f7 9a a3 00 0f 8d 15 fe ff ff 48 63 d0 49 8b 0c 24 48 03 0c d5 e0 b3 ab 81 f6 41 20 01 74 cc f3 90 f6 41 20 01 <74> c4 eb f6 0f b6 4d c7 4c 89 f2 4c 89 ee 89 df e8 29 fb ff ff 
Nov 11 07:00:55 sydtest0 kernel: [764135.756900] NMI backtrace for cpu 7
Nov 11 07:00:55 sydtest0 kernel: [764135.757180] [sched_delayed] sched: RT throttling activated
Nov 11 07:00:55 sydtest0 kernel: [764135.943364] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764136.038139] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764136.133580] task: ffff88041dc7f810 ti: ffff88041dd7a000 task.ti: ffff88041dd7a000
Nov 11 07:00:55 sydtest0 kernel: [764136.229793] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:55 sydtest0 kernel: [764136.327284] RSP: 0018:ffff88041dd7be88  EFLAGS: 00000286
Nov 11 07:00:55 sydtest0 kernel: [764136.424750] RAX: 00000000ffffffed RBX: ffff88041dd7bfd8 RCX: 0140000000000000
Nov 11 07:00:55 sydtest0 kernel: [764136.523572] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc6d620
Nov 11 07:00:55 sydtest0 kernel: [764136.623220] RBP: ffff88041dd7bea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764136.723082] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7bfd8
Nov 11 07:00:55 sydtest0 kernel: [764136.822942] R13: 0000000000000007 R14: ffff88041dd7bfd8 R15: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764136.920700] FS:  0000000000000000(0000) GS:ffff88082fc60000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764137.016994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764137.113020] CR2: 0000003b0debd790 CR3: 000000078e930000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764137.209074] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764137.303796] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764137.397080] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764137.488715]  ffff88041dd7bfd8 ffff88041dd7bfd8 ffff88041dd7bfd8 ffff88041dd7bfd8
Nov 11 07:00:55 sydtest0 kernel: [764137.582665]  ffff88041dd7beb8 ffffffff8100aace ffff88041dd7bf28 ffffffff810754be
Nov 11 07:00:55 sydtest0 kernel: [764137.675950]  ffff88041dd7bee8 ffffffff8107c92b ffff88082fc6cc40 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764137.769421] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764137.862229]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:55 sydtest0 kernel: [764137.956154]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:55 sydtest0 kernel: [764138.050289]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:55 sydtest0 kernel: [764138.144241]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:55 sydtest0 kernel: [764138.237417] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:55 sydtest0 kernel: [764138.435144] NMI backtrace for cpu 8
Nov 11 07:00:55 sydtest0 kernel: [764138.532662] CPU: 8 PID: 0 Comm: swapper/8 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764138.631535] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764138.731664] task: ffff88041dd88000 ti: ffff88041dd7c000 task.ti: ffff88041dd7c000
Nov 11 07:00:55 sydtest0 kernel: [764138.831710] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:55 sydtest0 kernel: [764138.931996] RSP: 0018:ffff88041dd7de88  EFLAGS: 00000286
Nov 11 07:00:55 sydtest0 kernel: [764139.031350] RAX: 00000000ffffffed RBX: ffff88041dd7dfd8 RCX: 0140000000000000
Nov 11 07:00:55 sydtest0 kernel: [764139.130439] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc8d620
Nov 11 07:00:55 sydtest0 kernel: [764139.228596] RBP: ffff88041dd7dea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764139.326273] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7dfd8
Nov 11 07:00:55 sydtest0 kernel: [764139.424005] R13: 0000000000000008 R14: ffff88041dd7dfd8 R15: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764139.521683] FS:  0000000000000000(0000) GS:ffff88041fc80000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764139.619680] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764139.717543] CR2: 00000000012e0428 CR3: 000000078ec0f000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764139.815513] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764139.912365] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764140.008018] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764140.103140]  ffff88041dd7dfd8 ffff88041dd7dfd8 ffff88041dd7dfd8 ffff88041dd7dfd8
Nov 11 07:00:55 sydtest0 kernel: [764140.201563]  ffff88041dd7deb8 ffffffff8100aace ffff88041dd7df28 ffffffff810754be
Nov 11 07:00:55 sydtest0 kernel: [764140.299054]  ffff88041dd7dee8 ffffffff8107c92b ffff88041fc8cc40 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764140.395560] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764140.491244]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:55 sydtest0 kernel: [764140.587537]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:55 sydtest0 kernel: [764140.683085]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:55 sydtest0 kernel: [764140.778873]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:55 sydtest0 kernel: [764140.874631] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:55 sydtest0 kernel: [764141.078719] NMI backtrace for cpu 9
Nov 11 07:00:55 sydtest0 kernel: [764141.178740] CPU: 9 PID: 0 Comm: swapper/9 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764141.280889] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764141.383971] task: ffff88041dd88710 ti: ffff88041dd7e000 task.ti: ffff88041dd7e000
Nov 11 07:00:55 sydtest0 kernel: [764141.487718] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:55 sydtest0 kernel: [764141.592557] RSP: 0018:ffff88041dd7fe88  EFLAGS: 00000286
Nov 11 07:00:55 sydtest0 kernel: [764141.697343] RAX: 00000000ffffffed RBX: ffff88041dd7ffd8 RCX: 0140000000000000
Nov 11 07:00:55 sydtest0 kernel: [764141.801197] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc8d620
Nov 11 07:00:55 sydtest0 kernel: [764141.903028] RBP: ffff88041dd7fea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764142.004725] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7ffd8
Nov 11 07:00:55 sydtest0 kernel: [764142.106315] R13: 0000000000000009 R14: ffff88041dd7ffd8 R15: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764142.206922] FS:  0000000000000000(0000) GS:ffff88082fc80000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764142.307236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764142.406617] CR2: 00007f5064a3e000 CR3: 000000078ec19000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764142.506026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764142.604343] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764142.701461] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764142.797516]  ffff88041dd7ffd8 ffff88041dd7ffd8 ffff88041dd7ffd8 ffff88041dd7ffd8
Nov 11 07:00:55 sydtest0 kernel: [764142.896205]  ffff88041dd7feb8 ffffffff8100aace ffff88041dd7ff28 ffffffff810754be
Nov 11 07:00:55 sydtest0 kernel: [764142.994654]  ffff88041dd7fee8 ffffffff8107c92b ffff88082fc8cc40 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764143.093024] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764143.190038]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:55 sydtest0 kernel: [764143.287557]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:55 sydtest0 kernel: [764143.384596]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:55 sydtest0 kernel: [764143.482514]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:55 sydtest0 kernel: [764143.580961] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:55 sydtest0 kernel: [764143.787739] NMI backtrace for cpu 10
Nov 11 07:00:55 sydtest0 kernel: [764143.888824] CPU: 10 PID: 0 Comm: swapper/10 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764143.992170] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764144.095573] task: ffff88041dd88e20 ti: ffff88041dd90000 task.ti: ffff88041dd90000
Nov 11 07:00:55 sydtest0 kernel: [764144.199532] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:55 sydtest0 kernel: [764144.304717] RSP: 0018:ffff88041dd91e88  EFLAGS: 00000286
Nov 11 07:00:55 sydtest0 kernel: [764144.409531] RAX: 00000000ffffffed RBX: ffff88041dd91fd8 RCX: 0140000000000000
Nov 11 07:00:55 sydtest0 kernel: [764144.515196] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fcad620
Nov 11 07:00:55 sydtest0 kernel: [764144.618997] RBP: ffff88041dd91ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764144.720534] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd91fd8
Nov 11 07:00:55 sydtest0 kernel: [764144.821913] R13: 000000000000000a R14: ffff88041dd91fd8 R15: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764144.922492] FS:  0000000000000000(0000) GS:ffff88041fca0000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764145.022858] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764145.122318] CR2: 00000000015bc448 CR3: 000000040d8b0000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764145.221727] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764145.320017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764145.417081] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764145.513081]  ffff88041dd91fd8 ffff88041dd91fd8 ffff88041dd91fd8 ffff88041dd91fd8
Nov 11 07:00:55 sydtest0 kernel: [764145.611584]  ffff88041dd91eb8 ffffffff8100aace ffff88041dd91f28 ffffffff810754be
Nov 11 07:00:55 sydtest0 kernel: [764145.709822]  ffff88041dd91ee8 ffffffff8107c92b ffff88041fcacc40 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764145.807925] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764145.904673]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:55 sydtest0 kernel: [764146.002032]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:55 sydtest0 kernel: [764146.098936]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:55 sydtest0 kernel: [764146.196828]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:55 sydtest0 kernel: [764146.295275] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:55 sydtest0 kernel: [764146.501921] NMI backtrace for cpu 11
Nov 11 07:00:55 sydtest0 kernel: [764146.602900] CPU: 11 PID: 0 Comm: swapper/11 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764146.706194] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764146.809543] task: ffff88041dd89530 ti: ffff88041dd92000 task.ti: ffff88041dd92000
Nov 11 07:00:55 sydtest0 kernel: [764146.913396] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:55 sydtest0 kernel: [764147.018529] RSP: 0018:ffff88041dd93e88  EFLAGS: 00000286
Nov 11 07:00:55 sydtest0 kernel: [764147.123316] RAX: 00000000ffffffed RBX: ffff88041dd93fd8 RCX: 0140000000000000
Nov 11 07:00:55 sydtest0 kernel: [764147.228953] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fcad620
Nov 11 07:00:55 sydtest0 kernel: [764147.332727] RBP: ffff88041dd93ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764147.434291] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd93fd8
Nov 11 07:00:55 sydtest0 kernel: [764147.535669] R13: 000000000000000b R14: ffff88041dd93fd8 R15: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764147.636302] FS:  0000000000000000(0000) GS:ffff88082fca0000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764147.736720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764147.836181] CR2: 0000003b0debd790 CR3: 000000039de73000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764147.935642] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764148.034012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764148.131182] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764148.227236]  ffff88041dd93fd8 ffff88041dd93fd8 ffff88041dd93fd8 ffff88041dd93fd8
Nov 11 07:00:55 sydtest0 kernel: [764148.325925]  ffff88041dd93eb8 ffffffff8100aace ffff88041dd93f28 ffffffff810754be
Nov 11 07:00:55 sydtest0 kernel: [764148.424375]  ffff88041dd93ee8 ffffffff8107c92b ffff88082fcacc40 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764148.522718] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764148.619759]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:55 sydtest0 kernel: [764148.717383]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:55 sydtest0 kernel: [764148.814474]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:55 sydtest0 kernel: [764148.912471]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:55 sydtest0 kernel: [764149.010972] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:55 sydtest0 kernel: [764149.217884] NMI backtrace for cpu 12
Nov 11 07:00:55 sydtest0 kernel: [764149.319022] CPU: 12 PID: 0 Comm: swapper/12 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764149.422449] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764149.525958] task: ffff88041dd89c40 ti: ffff88041dd94000 task.ti: ffff88041dd94000
Nov 11 07:00:55 sydtest0 kernel: [764149.630024] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:55 sydtest0 kernel: [764149.735369] RSP: 0018:ffff88041dd95e88  EFLAGS: 00000286
Nov 11 07:00:55 sydtest0 kernel: [764149.840368] RAX: 00000000ffffffed RBX: ffff88041dd95fd8 RCX: 0140000000000000
Nov 11 07:00:55 sydtest0 kernel: [764149.946219] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fccd620
Nov 11 07:00:55 sydtest0 kernel: [764150.050205] RBP: ffff88041dd95ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764150.152009] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd95fd8
Nov 11 07:00:55 sydtest0 kernel: [764150.253601] R13: 000000000000000c R14: ffff88041dd95fd8 R15: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764150.354260] FS:  0000000000000000(0000) GS:ffff88041fcc0000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764150.454680] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764150.554116] CR2: 00000000009ff448 CR3: 0000000399f1f000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764150.653551] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764150.751841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764150.848907] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764150.944907]  ffff88041dd95fd8 ffff88041dd95fd8 ffff88041dd95fd8 ffff88041dd95fd8
Nov 11 07:00:55 sydtest0 kernel: [764151.043464]  ffff88041dd95eb8 ffffffff8100aace ffff88041dd95f28 ffffffff810754be
Nov 11 07:00:55 sydtest0 kernel: [764151.141753]  ffff88041dd95ee8 ffffffff8107c92b ffff88041fcccc40 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764151.239884] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764151.336713]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:55 sydtest0 kernel: [764151.434123]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:55 sydtest0 kernel: [764151.531083]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:55 sydtest0 kernel: [764151.628973]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:55 sydtest0 kernel: [764151.727448] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:55 sydtest0 kernel: [764151.934386] NMI backtrace for cpu 13
Nov 11 07:00:55 sydtest0 kernel: [764152.035579] CPU: 13 PID: 0 Comm: swapper/13 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764152.139111] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764152.242727] task: ffff88041dd8a350 ti: ffff88041dd96000 task.ti: ffff88041dd96000
Nov 11 07:00:55 sydtest0 kernel: [764152.346899] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:55 sydtest0 kernel: [764152.452323] RSP: 0018:ffff88041dd97e88  EFLAGS: 00000286
Nov 11 07:00:55 sydtest0 kernel: [764152.557428] RAX: 00000000ffffffed RBX: ffff88041dd97fd8 RCX: 0140000000000000
Nov 11 07:00:55 sydtest0 kernel: [764152.663359] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fccd620
Nov 11 07:00:55 sydtest0 kernel: [764152.767452] RBP: ffff88041dd97ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764152.869283] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd97fd8
Nov 11 07:00:55 sydtest0 kernel: [764152.970954] R13: 000000000000000d R14: ffff88041dd97fd8 R15: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764153.071773] FS:  0000000000000000(0000) GS:ffff88082fcc0000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764153.172405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764153.272134] CR2: 00000000015bc448 CR3: 000000080c04b000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764153.371781] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764153.470257] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764153.567508] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764153.663721]  ffff88041dd97fd8 ffff88041dd97fd8 ffff88041dd97fd8 ffff88041dd97fd8
Nov 11 07:00:55 sydtest0 kernel: [764153.762516]  ffff88041dd97eb8 ffffffff8100aace ffff88041dd97f28 ffffffff810754be
Nov 11 07:00:55 sydtest0 kernel: [764153.861073]  ffff88041dd97ee8 ffffffff8107c92b ffff88082fcccc40 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764153.959523] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764154.056617]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:55 sydtest0 kernel: [764154.154348]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:55 sydtest0 kernel: [764154.251573]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:55 sydtest0 kernel: [764154.349676]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:55 sydtest0 kernel: [764154.448337] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:55 sydtest0 kernel: [764154.655569] NMI backtrace for cpu 14
Nov 11 07:00:55 sydtest0 kernel: [764154.756787] CPU: 14 PID: 0 Comm: swapper/14 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:55 sydtest0 kernel: [764154.860320] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:55 sydtest0 kernel: [764154.963934] task: ffff88041dd8aa60 ti: ffff88041dda0000 task.ti: ffff88041dda0000
Nov 11 07:00:55 sydtest0 kernel: [764155.068081] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:55 sydtest0 kernel: [764155.173532] RSP: 0018:ffff88041dda1e88  EFLAGS: 00000286
Nov 11 07:00:55 sydtest0 kernel: [764155.278637] RAX: 00000000ffffffed RBX: ffff88041dda1fd8 RCX: 0140000000000000
Nov 11 07:00:55 sydtest0 kernel: [764155.384620] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fced620
Nov 11 07:00:55 sydtest0 kernel: [764155.488741] RBP: ffff88041dda1ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764155.590625] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda1fd8
Nov 11 07:00:55 sydtest0 kernel: [764155.692348] R13: 000000000000000e R14: ffff88041dda1fd8 R15: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764155.793168] FS:  0000000000000000(0000) GS:ffff88041fce0000(0000) knlGS:0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764155.893694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:55 sydtest0 kernel: [764155.993260] CR2: 00000000012e0428 CR3: 00000004147ef000 CR4: 00000000000407e0
Nov 11 07:00:55 sydtest0 kernel: [764156.092774] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764156.191198] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:55 sydtest0 kernel: [764156.288449] Stack:
Nov 11 07:00:55 sydtest0 kernel: [764156.384662]  ffff88041dda1fd8 ffff88041dda1fd8 ffff88041dda1fd8 ffff88041dda1fd8
Nov 11 07:00:55 sydtest0 kernel: [764156.483431]  ffff88041dda1eb8 ffffffff8100aace ffff88041dda1f28 ffffffff810754be
Nov 11 07:00:55 sydtest0 kernel: [764156.581987]  ffff88041dda1ee8 ffffffff8107c92b ffff88041fcecc40 0000000000000000
Nov 11 07:00:55 sydtest0 kernel: [764156.680412] Call Trace:
Nov 11 07:00:55 sydtest0 kernel: [764156.777480]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:55 sydtest0 kernel: [764156.875183]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:55 sydtest0 kernel: [764156.972383]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:55 sydtest0 kernel: [764157.070460]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:55 sydtest0 kernel: [764157.169147] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:55 sydtest0 kernel: [764157.376509] NMI backtrace for cpu 16
Nov 11 07:00:58 sydtest0 kernel: [764157.477862] CPU: 16 PID: 0 Comm: swapper/16 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:00:58 sydtest0 kernel: [764157.581554] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:00:58 sydtest0 kernel: [764157.685301] task: ffff88041dd8b880 ti: ffff88041dda4000 task.ti: ffff88041dda4000
Nov 11 07:00:58 sydtest0 kernel: [764157.789581] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:00:58 sydtest0 kernel: [764157.895112] RSP: 0018:ffff88041dda5e88  EFLAGS: 00000286
Nov 11 07:00:58 sydtest0 kernel: [764158.000324] RAX: 00000000ffffffed RBX: ffff88041dda5fd8 RCX: 0140000000000000
Nov 11 07:00:58 sydtest0 kernel: [764158.106442] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd0d620
Nov 11 07:00:58 sydtest0 kernel: [764158.210668] RBP: ffff88041dda5ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:00:58 sydtest0 kernel: [764158.312659] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda5fd8
Nov 11 07:00:58 sydtest0 kernel: [764158.414437] R13: 0000000000000010 R14: ffff88041dda5fd8 R15: 0000000000000000
Nov 11 07:00:58 sydtest0 kernel: [764158.515283] FS:  0000000000000000(0000) GS:ffff88041fd00000(0000) knlGS:0000000000000000
Nov 11 07:00:58 sydtest0 kernel: [764158.615890] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:00:58 sydtest0 kernel: [764158.715484] CR2: 0000003b0de7b160 CR3: 0000000787468000 CR4: 00000000000407e0
Nov 11 07:00:58 sydtest0 kernel: [764158.815079] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:00:58 sydtest0 kernel: [764158.913556] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:00:58 sydtest0 kernel: [764159.010860] Stack:
Nov 11 07:00:58 sydtest0 kernel: [764159.107101]  ffff88041dda5fd8 ffff88041dda5fd8 ffff88041dda5fd8 ffff88041dda5fd8
Nov 11 07:00:58 sydtest0 kernel: [764159.206003]  ffff88041dda5eb8 ffffffff8100aace ffff88041dda5f28 ffffffff810754be
Nov 11 07:00:58 sydtest0 kernel: [764159.304615]  ffff88041dda5ee8 ffffffff8107c92b ffff88041fd0cc40 0000000000000000
Nov 11 07:00:58 sydtest0 kernel: [764159.403011] Call Trace:
Nov 11 07:00:58 sydtest0 kernel: [764159.499999]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:00:58 sydtest0 kernel: [764159.597569]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:00:58 sydtest0 kernel: [764159.694661]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:00:58 sydtest0 kernel: [764159.792684]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:00:58 sydtest0 kernel: [764159.891239] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:00:58 sydtest0 kernel: [764160.098203] NMI backtrace for cpu 17
Nov 11 07:00:58 sydtest0 ptpd[14045]: resetting system clock to 1384174820s 594837773ns
Nov 11 07:00:58 sydtest0 ptpd[14045]: clock stepped, off by 0.110332 seconds
Nov 11 07:01:01 sydtest0 kernel: [764160.199316] CPU: 17 PID: 0 Comm: swapper/17 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:01 sydtest0 kernel: [764160.302716] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:01 sydtest0 kernel: [764160.406145] task: ffff88041dd8bf90 ti: ffff88041dda6000 task.ti: ffff88041dda6000
Nov 11 07:01:01 sydtest0 kernel: [764160.510077] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:01 sydtest0 kernel: [764160.615289] RSP: 0018:ffff88041dda7e88  EFLAGS: 00000286
Nov 11 07:01:01 sydtest0 kernel: [764160.720129] RAX: 00000000ffffffed RBX: ffff88041dda7fd8 RCX: 0140000000000000
Nov 11 07:01:01 sydtest0 kernel: [764160.825819] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd0d620
Nov 11 07:01:01 sydtest0 kernel: [764160.929593] RBP: ffff88041dda7ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:01 sydtest0 kernel: [764161.031131] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda7fd8
Nov 11 07:01:01 sydtest0 kernel: [764161.132561] R13: 0000000000000011 R14: ffff88041dda7fd8 R15: 0000000000000000
Nov 11 07:01:01 sydtest0 kernel: [764161.233087] FS:  0000000000000000(0000) GS:ffff88082fd00000(0000) knlGS:0000000000000000
Nov 11 07:01:01 sydtest0 kernel: [764161.333375] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:01 sydtest0 kernel: [764161.432677] CR2: 0000003b0de16c4c CR3: 00000007f0954000 CR4: 00000000000407e0
Nov 11 07:01:01 sydtest0 kernel: [764161.531927] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:01 sydtest0 kernel: [764161.630058] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:01 sydtest0 kernel: [764161.727017] Stack:
Nov 11 07:01:01 sydtest0 kernel: [764161.822911]  ffff88041dda7fd8 ffff88041dda7fd8 ffff88041dda7fd8 ffff88041dda7fd8
Nov 11 07:01:01 sydtest0 kernel: [764161.921386]  ffff88041dda7eb8 ffffffff8100aace ffff88041dda7f28 ffffffff810754be
Nov 11 07:01:01 sydtest0 kernel: [764162.019596]  ffff88041dda7ee8 ffffffff8107c92b ffff88082fd0cc40 0000000000000000
Nov 11 07:01:01 sydtest0 kernel: [764162.117700] Call Trace:
Nov 11 07:01:01 sydtest0 kernel: [764162.214503]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:01 sydtest0 kernel: [764162.311886]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:01 sydtest0 kernel: [764162.408791]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:01 sydtest0 kernel: [764162.506629]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:01 sydtest0 kernel: [764162.605024] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:01 sydtest0 kernel: [764162.811587] NMI backtrace for cpu 19
Nov 11 07:01:04 sydtest0 kernel: [764162.912517] CPU: 19 PID: 0 Comm: swapper/19 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:04 sydtest0 kernel: [764163.015731] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:04 sydtest0 kernel: [764163.119025] task: ffff88041dd8cdb0 ti: ffff88041ddaa000 task.ti: ffff88041ddaa000
Nov 11 07:01:04 sydtest0 kernel: [764163.222853] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:04 sydtest0 kernel: [764163.328013] RSP: 0018:ffff88041ddabe88  EFLAGS: 00000286
Nov 11 07:01:04 sydtest0 kernel: [764163.432824] RAX: 00000000ffffffed RBX: ffff88041ddabfd8 RCX: 0140000000000000
Nov 11 07:01:04 sydtest0 kernel: [764163.538488] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd2d620
Nov 11 07:01:04 sydtest0 kernel: [764163.642262] RBP: ffff88041ddabea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:04 sydtest0 kernel: [764163.743826] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddabfd8
Nov 11 07:01:04 sydtest0 kernel: [764163.845230] R13: 0000000000000013 R14: ffff88041ddabfd8 R15: 0000000000000000
Nov 11 07:01:04 sydtest0 kernel: [764163.945757] FS:  0000000000000000(0000) GS:ffff88082fd20000(0000) knlGS:0000000000000000
Nov 11 07:01:04 sydtest0 kernel: [764164.046016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:04 sydtest0 kernel: [764164.145371] CR2: 0000003b0de16c4c CR3: 00000007eae6f000 CR4: 00000000000407e0
Nov 11 07:01:04 sydtest0 kernel: [764164.244807] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:04 sydtest0 kernel: [764164.343176] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:04 sydtest0 kernel: [764164.440295] Stack:
Nov 11 07:01:04 sydtest0 kernel: [764164.536375]  ffff88041ddabfd8 ffff88041ddabfd8 ffff88041ddabfd8 ffff88041ddabfd8
Nov 11 07:01:04 sydtest0 kernel: [764164.635064]  ffff88041ddabeb8 ffffffff8100aace ffff88041ddabf28 ffffffff810754be
Nov 11 07:01:04 sydtest0 kernel: [764164.733540]  ffff88041ddabee8 ffffffff8107c92b ffff88082fd2cc40 0000000000000000
Nov 11 07:01:04 sydtest0 kernel: [764164.831883] Call Trace:
Nov 11 07:01:04 sydtest0 kernel: [764164.928899]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:04 sydtest0 kernel: [764165.026550]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:04 sydtest0 kernel: [764165.123721]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:04 sydtest0 kernel: [764165.221800]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:04 sydtest0 kernel: [764165.320432] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:04 sydtest0 kernel: [764165.527503] NMI backtrace for cpu 20
Nov 11 07:01:04 sydtest0 sshd[13394]: Accepted publickey for hbi from 10.16.8.104 port 48376 ssh2
Nov 11 07:01:06 sydtest0 kernel: [764165.628668] CPU: 20 PID: 0 Comm: swapper/20 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:06 sydtest0 kernel: [764165.732201] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:06 sydtest0 kernel: [764165.835841] task: ffff88041dd8d4c0 ti: ffff88041ddac000 task.ti: ffff88041ddac000
Nov 11 07:01:06 sydtest0 kernel: [764165.939988] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:06 sydtest0 kernel: [764166.045440] RSP: 0018:ffff88041ddade88  EFLAGS: 00000286
Nov 11 07:01:06 sydtest0 kernel: [764166.150599] RAX: 00000000ffffffed RBX: ffff88041ddadfd8 RCX: 0140000000000000
Nov 11 07:01:06 sydtest0 kernel: [764166.256662] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd4d620
Nov 11 07:01:06 sydtest0 kernel: [764166.360862] RBP: ffff88041ddadea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:06 sydtest0 kernel: [764166.462800] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddadfd8
Nov 11 07:01:06 sydtest0 kernel: [764166.564550] R13: 0000000000000014 R14: ffff88041ddadfd8 R15: 0000000000000000
Nov 11 07:01:06 sydtest0 kernel: [764166.665397] FS:  0000000000000000(0000) GS:ffff88041fd40000(0000) knlGS:0000000000000000
Nov 11 07:01:06 sydtest0 kernel: [764166.766056] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:06 sydtest0 kernel: [764166.865784] CR2: 0000003b0de7b160 CR3: 000000040eeb1000 CR4: 00000000000407e0
Nov 11 07:01:06 sydtest0 kernel: [764166.965512] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:06 sydtest0 kernel: [764167.064121] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:06 sydtest0 kernel: [764167.161559] Stack:
Nov 11 07:01:06 sydtest0 kernel: [764167.257986]  ffff88041ddadfd8 ffff88041ddadfd8 ffff88041ddadfd8 ffff88041ddadfd8
Nov 11 07:01:06 sydtest0 kernel: [764167.357075]  ffff88041ddadeb8 ffffffff8100aace ffff88041ddadf28 ffffffff810754be
Nov 11 07:01:06 sydtest0 kernel: [764167.455846]  ffff88041ddadee8 ffffffff8107c92b ffff88041fd4cc40 0000000000000000
Nov 11 07:01:06 sydtest0 kernel: [764167.554429] Call Trace:
Nov 11 07:01:06 sydtest0 kernel: [764167.651657]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:06 sydtest0 kernel: [764167.749521]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:06 sydtest0 kernel: [764167.846931]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:06 sydtest0 kernel: [764167.945222]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:06 sydtest0 kernel: [764168.044068] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:06 sydtest0 kernel: [764168.251724] NMI backtrace for cpu 21
Nov 11 07:01:09 sydtest0 kernel: [764168.353187] CPU: 21 PID: 0 Comm: swapper/21 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:09 sydtest0 kernel: [764168.456931] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:09 sydtest0 kernel: [764168.560733] task: ffff88041dd8dbd0 ti: ffff88041ddae000 task.ti: ffff88041ddae000
Nov 11 07:01:09 sydtest0 kernel: [764168.665092] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:09 sydtest0 kernel: [764168.770730] RSP: 0018:ffff88041ddafe88  EFLAGS: 00000286
Nov 11 07:01:09 sydtest0 kernel: [764168.875994] RAX: 00000000ffffffed RBX: ffff88041ddaffd8 RCX: 0140000000000000
Nov 11 07:01:09 sydtest0 kernel: [764168.982111] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd4d620
Nov 11 07:01:09 sydtest0 kernel: [764169.086418] RBP: ffff88041ddafea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:09 sydtest0 kernel: [764169.188515] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddaffd8
Nov 11 07:01:09 sydtest0 kernel: [764169.290399] R13: 0000000000000015 R14: ffff88041ddaffd8 R15: 0000000000000000
Nov 11 07:01:09 sydtest0 kernel: [764169.391484] FS:  0000000000000000(0000) GS:ffff88082fd40000(0000) knlGS:0000000000000000
Nov 11 07:01:09 sydtest0 kernel: [764169.492328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:09 sydtest0 kernel: [764169.592242] CR2: 0000003b0debd790 CR3: 00000007e5c31000 CR4: 00000000000407e0
Nov 11 07:01:09 sydtest0 kernel: [764169.692129] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:09 sydtest0 kernel: [764169.790952] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:09 sydtest0 kernel: [764169.888549] Stack:
Nov 11 07:01:09 sydtest0 kernel: [764169.985108]  ffff88041ddaffd8 ffff88041ddaffd8 ffff88041ddaffd8 ffff88041ddaffd8
Nov 11 07:01:09 sydtest0 kernel: [764170.084249]  ffff88041ddafeb8 ffffffff8100aace ffff88041ddaff28 ffffffff810754be
Nov 11 07:01:09 sydtest0 kernel: [764170.183204]  ffff88041ddafee8 ffffffff8107c92b ffff88082fd4cc40 0000000000000000
Nov 11 07:01:09 sydtest0 kernel: [764170.281973] Call Trace:
Nov 11 07:01:09 sydtest0 kernel: [764170.379414]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:09 sydtest0 kernel: [764170.477438]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:09 sydtest0 kernel: [764170.574903]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:09 sydtest0 kernel: [764170.673221]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:09 sydtest0 kernel: [764170.772094] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:09 sydtest0 kernel: [764170.979750] NMI backtrace for cpu 22
Nov 11 07:01:12 sydtest0 kernel: [764171.081234] CPU: 22 PID: 0 Comm: swapper/22 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:12 sydtest0 kernel: [764171.185087] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:12 sydtest0 kernel: [764171.288993] task: ffff88041dd8e2e0 ti: ffff88041ddb8000 task.ti: ffff88041ddb8000
Nov 11 07:01:12 sydtest0 kernel: [764171.393433] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:12 sydtest0 kernel: [764171.499125] RSP: 0018:ffff88041ddb9e88  EFLAGS: 00000286
Nov 11 07:01:12 sydtest0 kernel: [764171.604443] RAX: 00000000ffffffed RBX: ffff88041ddb9fd8 RCX: 0140000000000000
Nov 11 07:01:12 sydtest0 kernel: [764171.710641] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd6d620
Nov 11 07:01:12 sydtest0 kernel: [764171.814973] RBP: ffff88041ddb9ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:12 sydtest0 kernel: [764171.917097] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddb9fd8
Nov 11 07:01:12 sydtest0 kernel: [764172.019088] R13: 0000000000000016 R14: ffff88041ddb9fd8 R15: 0000000000000000
Nov 11 07:01:12 sydtest0 kernel: [764172.120200] FS:  0000000000000000(0000) GS:ffff88041fd60000(0000) knlGS:0000000000000000
Nov 11 07:01:12 sydtest0 kernel: [764172.221098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:12 sydtest0 kernel: [764172.321091] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:12 sydtest0 kernel: [764172.420952] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:12 sydtest0 kernel: [764172.519640] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:12 sydtest0 kernel: [764172.617132] Stack:
Nov 11 07:01:12 sydtest0 kernel: [764172.713558]  ffff88041ddb9fd8 ffff88041ddb9fd8 ffff88041ddb9fd8 ffff88041ddb9fd8
Nov 11 07:01:12 sydtest0 kernel: [764172.812619]  ffff88041ddb9eb8 ffffffff8100aace ffff88041ddb9f28 ffffffff810754be
Nov 11 07:01:12 sydtest0 kernel: [764172.911469]  ffff88041ddb9ee8 ffffffff8107c92b ffff88041fd6cc40 0000000000000000
Nov 11 07:01:12 sydtest0 kernel: [764173.010105] Call Trace:
Nov 11 07:01:12 sydtest0 kernel: [764173.107413]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:12 sydtest0 kernel: [764173.205328]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:12 sydtest0 kernel: [764173.302739]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:12 sydtest0 kernel: [764173.401082]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:12 sydtest0 kernel: [764173.499956] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:12 sydtest0 kernel: [764173.707586] NMI backtrace for cpu 23
Nov 11 07:01:19 sydtest0 kernel: [764173.809073] CPU: 23 PID: 0 Comm: swapper/23 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:19 sydtest0 kernel: [764173.912924] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:19 sydtest0 kernel: [764174.016859] task: ffff88041dd8e9f0 ti: ffff88041ddbc000 task.ti: ffff88041ddbc000
Nov 11 07:01:19 sydtest0 kernel: [764174.121351] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:19 sydtest0 kernel: [764174.227095] RSP: 0018:ffff88041ddbde88  EFLAGS: 00000286
Nov 11 07:01:19 sydtest0 kernel: [764174.332494] RAX: 00000000ffffffed RBX: ffff88041ddbdfd8 RCX: 0140000000000000
Nov 11 07:01:19 sydtest0 kernel: [764174.438744] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd6d620
Nov 11 07:01:19 sydtest0 kernel: [764174.543078] RBP: ffff88041ddbdea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764174.645228] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddbdfd8
Nov 11 07:01:19 sydtest0 kernel: [764174.747191] R13: 0000000000000017 R14: ffff88041ddbdfd8 R15: 0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764174.848278] FS:  0000000000000000(0000) GS:ffff88082fd60000(0000) knlGS:0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764174.949150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:19 sydtest0 kernel: [764175.049090] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:19 sydtest0 kernel: [764175.148952] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764175.247668] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:19 sydtest0 kernel: [764175.345186] Stack:
Nov 11 07:01:19 sydtest0 kernel: [764175.441613]  ffff88041ddbdfd8 ffff88041ddbdfd8 ffff88041ddbdfd8 ffff88041ddbdfd8
Nov 11 07:01:19 sydtest0 kernel: [764175.505219] BUG: soft lockup - CPU#2 stuck for 22s! [ptpd:14045]
Nov 11 07:01:19 sydtest0 kernel: [764175.505248] Modules linked in: mpt2sas scsi_transport_sas raid_class dell_rbu ipmi_devintf ipmi_si ipmi_msghandler lockd 8021q mrp garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ext4 jbd2 mbcache fuse mlx4_ib ib_sa ib_mad ib_core mlx4_en igb dca i2c_algo_bit i2c_core mlx4_core ptp iTCO_wdt iTCO_vendor_support pps_core ehci_pci coretemp hwmon freq_table lpc_ich mfd_core ehci_hcd mperf sb_edac wmi dcdbas edac_core microcode sunrpc ipv6 autofs4 crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci libata megaraid_sas dm_mirror dm_region_hash dm_log dm_mod
Nov 11 07:01:19 sydtest0 kernel: [764175.505249] CPU: 2 PID: 14045 Comm: ptpd Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:19 sydtest0 kernel: [764175.505249] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:19 sydtest0 kernel: [764175.505250] task: ffff8808105d62e0 ti: ffff8807d0afa000 task.ti: ffff8807d0afa000
Nov 11 07:01:19 sydtest0 kernel: [764175.505253] RIP: 0010:[<ffffffff81083502>]  [<ffffffff81083502>] smp_call_function_many+0x272/0x2d0
Nov 11 07:01:19 sydtest0 kernel: [764175.505254] RSP: 0018:ffff8807d0afbdf8  EFLAGS: 00000202
Nov 11 07:01:19 sydtest0 kernel: [764175.505254] RAX: 0000000000000017 RBX: ffffffff81abcf00 RCX: ffff88082fd763b8
Nov 11 07:01:19 sydtest0 kernel: [764175.505255] RDX: 0000000000000017 RSI: 0000000000000100 RDI: 0000000000000100
Nov 11 07:01:19 sydtest0 kernel: [764175.505255] RBP: ffff8807d0afbe58 R08: ffff88041fc33648 R09: 0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764175.505256] R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000296
Nov 11 07:01:19 sydtest0 kernel: [764175.505256] R13: 000000000000002c R14: 00007fffee4934a0 R15: 0000000000000040
Nov 11 07:01:19 sydtest0 kernel: [764175.505257] FS:  00007fc28c07a700(0000) GS:ffff88041fc20000(0000) knlGS:0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764175.505258] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:19 sydtest0 kernel: [764175.505258] CR2: 00007facee9af000 CR3: 00000007f0ae3000 CR4: 00000000000407e0
Nov 11 07:01:19 sydtest0 kernel: [764175.505259] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764175.505260] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:19 sydtest0 kernel: [764175.505260] Stack:
Nov 11 07:01:19 sydtest0 kernel: [764175.505263]  ffff88082fdf3610 ffff88082fdf3600 ffff88082fdf63b8 ffff88070000001f
Nov 11 07:01:19 sydtest0 kernel: [764175.505264]  01ff8807d0afbe28 ffff88041fc33668 ffff8807d0afbee8 ffffffff81062480
Nov 11 07:01:19 sydtest0 kernel: [764175.505266]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764175.505266] Call Trace:
Nov 11 07:01:19 sydtest0 kernel: [764175.505270]  [<ffffffff81062480>] ? hrtimer_cancel+0x30/0x30
Nov 11 07:01:19 sydtest0 kernel: [764175.505272]  [<ffffffff810835e2>] smp_call_function+0x22/0x30
Nov 11 07:01:19 sydtest0 kernel: [764175.505273]  [<ffffffff81083648>] on_each_cpu+0x28/0x50
Nov 11 07:01:19 sydtest0 kernel: [764175.505275]  [<ffffffff8106272c>] clock_was_set+0x1c/0x30
Nov 11 07:01:19 sydtest0 kernel: [764175.505277]  [<ffffffff8107701e>] do_settimeofday+0xfe/0x110
Nov 11 07:01:19 sydtest0 kernel: [764175.505280]  [<ffffffff8104244d>] do_sys_settimeofday+0xdd/0xf0
Nov 11 07:01:19 sydtest0 kernel: [764175.505282]  [<ffffffff813f6fe9>] ? __sys_recvmsg+0x49/0x90
Nov 11 07:01:19 sydtest0 kernel: [764175.505284]  [<ffffffff8105d513>] posix_clock_realtime_set+0x13/0x20
Nov 11 07:01:19 sydtest0 kernel: [764175.505286]  [<ffffffff8105e55f>] SyS_clock_settime+0x5f/0x90
Nov 11 07:01:19 sydtest0 kernel: [764175.505288]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 11 07:01:19 sydtest0 kernel: [764175.505298] Code: 15 c1 1e 00 3b 05 f7 9a a3 00 0f 8d 15 fe ff ff 48 63 d0 49 8b 0c 24 48 03 0c d5 e0 b3 ab 81 f6 41 20 01 74 cc f3 90 f6 41 20 01 <74> c4 eb f6 0f b6 4d c7 4c 89 f2 4c 89 ee 89 df e8 29 fb ff ff 
Nov 11 07:01:19 sydtest0 kernel: [764179.567130]  ffff88041ddbdeb8 ffffffff8100aace ffff88041ddbdf28 ffffffff810754be
Nov 11 07:01:19 sydtest0 kernel: [764179.676336]  ffff88041ddbdee8 ffffffff8107c92b ffff88082fd6cc40 0000000000000000
Nov 11 07:01:19 sydtest0 kernel: [764179.784556] Call Trace:
Nov 11 07:01:19 sydtest0 kernel: [764179.891583]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:19 sydtest0 kernel: [764179.999857]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:19 sydtest0 kernel: [764180.107916]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:19 sydtest0 kernel: [764180.216376]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:19 sydtest0 kernel: [764180.322677] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:19 sydtest0 kernel: [764180.542578] NMI backtrace for cpu 24
Nov 11 07:01:21 sydtest0 kernel: [764180.649361] CPU: 24 PID: 0 Comm: swapper/24 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:21 sydtest0 kernel: [764180.757339] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:21 sydtest0 kernel: [764180.865374] task: ffff88041dd8f100 ti: ffff88041ddbe000 task.ti: ffff88041ddbe000
Nov 11 07:01:21 sydtest0 kernel: [764180.973221] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:21 sydtest0 kernel: [764181.081494] RSP: 0018:ffff88041ddbfe88  EFLAGS: 00000286
Nov 11 07:01:21 sydtest0 kernel: [764181.189155] RAX: 00000000ffffffed RBX: ffff88041ddbffd8 RCX: 0140000000000000
Nov 11 07:01:21 sydtest0 kernel: [764181.297748] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd8d620
Nov 11 07:01:21 sydtest0 kernel: [764181.406473] RBP: ffff88041ddbfea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:21 sydtest0 kernel: [764181.515280] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddbffd8
Nov 11 07:01:21 sydtest0 kernel: [764181.624140] R13: 0000000000000018 R14: ffff88041ddbffd8 R15: 0000000000000000
Nov 11 07:01:21 sydtest0 kernel: [764181.732574] FS:  0000000000000000(0000) GS:ffff88041fd80000(0000) knlGS:0000000000000000
Nov 11 07:01:21 sydtest0 kernel: [764181.841166] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:21 sydtest0 kernel: [764181.949172] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:21 sydtest0 kernel: [764182.058430] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:21 sydtest0 kernel: [764182.168008] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:21 sydtest0 kernel: [764182.276227] Stack:
Nov 11 07:01:21 sydtest0 kernel: [764182.382797]  ffff88041ddbffd8 ffff88041ddbffd8 ffff88041ddbffd8 ffff88041ddbffd8
Nov 11 07:01:21 sydtest0 kernel: [764182.491229]  ffff88041ddbfeb8 ffffffff8100aace ffff88041ddbff28 ffffffff810754be
Nov 11 07:01:21 sydtest0 kernel: [764182.597080]  ffff88041ddbfee8 ffffffff8107c92b ffff88041fd8cc40 0000000000000000
Nov 11 07:01:21 sydtest0 kernel: [764182.699842] Call Trace:
Nov 11 07:01:21 sydtest0 kernel: [764182.798721]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:21 sydtest0 kernel: [764182.895787]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:21 sydtest0 kernel: [764182.990003]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:21 sydtest0 kernel: [764183.084033]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:21 sydtest0 kernel: [764183.177290] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:21 sydtest0 kernel: [764183.372513] NMI backtrace for cpu 25
Nov 11 07:01:24 sydtest0 kernel: [764183.467051] CPU: 25 PID: 0 Comm: swapper/25 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:24 sydtest0 kernel: [764183.563901] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:24 sydtest0 kernel: [764183.661686] task: ffff88041dd8f810 ti: ffff88041ddc0000 task.ti: ffff88041ddc0000
Nov 11 07:01:24 sydtest0 kernel: [764183.760295] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:24 sydtest0 kernel: [764183.860582] RSP: 0018:ffff88041ddc1e88  EFLAGS: 00000286
Nov 11 07:01:24 sydtest0 kernel: [764183.960151] RAX: 00000000ffffffed RBX: ffff88041ddc1fd8 RCX: 0140000000000000
Nov 11 07:01:24 sydtest0 kernel: [764184.060252] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd8d620
Nov 11 07:01:24 sydtest0 kernel: [764184.160111] RBP: ffff88041ddc1ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:24 sydtest0 kernel: [764184.260423] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc1fd8
Nov 11 07:01:24 sydtest0 kernel: [764184.361482] R13: 0000000000000019 R14: ffff88041ddc1fd8 R15: 0000000000000000
Nov 11 07:01:24 sydtest0 kernel: [764184.461957] FS:  0000000000000000(0000) GS:ffff88082fd80000(0000) knlGS:0000000000000000
Nov 11 07:01:24 sydtest0 kernel: [764184.562403] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:24 sydtest0 kernel: [764184.662822] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:24 sydtest0 kernel: [764184.763668] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:24 sydtest0 kernel: [764184.863475] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:24 sydtest0 kernel: [764184.962378] Stack:
Nov 11 07:01:24 sydtest0 kernel: [764185.060561]  ffff88041ddc1fd8 ffff88041ddc1fd8 ffff88041ddc1fd8 ffff88041ddc1fd8
Nov 11 07:01:24 sydtest0 kernel: [764185.161700]  ffff88041ddc1eb8 ffffffff8100aace ffff88041ddc1f28 ffffffff810754be
Nov 11 07:01:24 sydtest0 kernel: [764185.262918]  ffff88041ddc1ee8 ffffffff8107c92b ffff88082fd8cc40 0000000000000000
Nov 11 07:01:24 sydtest0 kernel: [764185.364190] Call Trace:
Nov 11 07:01:24 sydtest0 kernel: [764185.464780]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:24 sydtest0 kernel: [764185.566616]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:24 sydtest0 kernel: [764185.668448]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:24 sydtest0 kernel: [764185.770894]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:24 sydtest0 kernel: [764185.873416] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:24 sydtest0 kernel: [764186.084374] NMI backtrace for cpu 26
Nov 11 07:01:27 sydtest0 kernel: [764186.185597] CPU: 26 PID: 0 Comm: swapper/26 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:27 sydtest0 kernel: [764186.289130] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:27 sydtest0 kernel: [764186.392719] task: ffff88041ddc8000 ti: ffff88041ddc2000 task.ti: ffff88041ddc2000
Nov 11 07:01:27 sydtest0 kernel: [764186.496839] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:27 sydtest0 kernel: [764186.602210] RSP: 0018:ffff88041ddc3e88  EFLAGS: 00000286
Nov 11 07:01:27 sydtest0 kernel: [764186.707155] RAX: 00000000ffffffed RBX: ffff88041ddc3fd8 RCX: 0140000000000000
Nov 11 07:01:27 sydtest0 kernel: [764186.812953] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fdad620
Nov 11 07:01:27 sydtest0 kernel: [764186.916887] RBP: ffff88041ddc3ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:27 sydtest0 kernel: [764187.018584] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc3fd8
Nov 11 07:01:27 sydtest0 kernel: [764187.120121] R13: 000000000000001a R14: ffff88041ddc3fd8 R15: 0000000000000000
Nov 11 07:01:27 sydtest0 kernel: [764187.220807] FS:  0000000000000000(0000) GS:ffff88041fda0000(0000) knlGS:0000000000000000
Nov 11 07:01:27 sydtest0 kernel: [764187.321254] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:27 sydtest0 kernel: [764187.420770] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:27 sydtest0 kernel: [764187.520233] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:27 sydtest0 kernel: [764187.618496] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:27 sydtest0 kernel: [764187.715587] Stack:
Nov 11 07:01:27 sydtest0 kernel: [764187.811587]  ffff88041ddc3fd8 ffff88041ddc3fd8 ffff88041ddc3fd8 ffff88041ddc3fd8
Nov 11 07:01:27 sydtest0 kernel: [764187.910092]  ffff88041ddc3eb8 ffffffff8100aace ffff88041ddc3f28 ffffffff810754be
Nov 11 07:01:27 sydtest0 kernel: [764188.008326]  ffff88041ddc3ee8 ffffffff8107c92b ffff88041fdacc40 0000000000000000
Nov 11 07:01:27 sydtest0 kernel: [764188.106403] Call Trace:
Nov 11 07:01:27 sydtest0 kernel: [764188.203128]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:27 sydtest0 kernel: [764188.300405]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:27 sydtest0 kernel: [764188.397257]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:27 sydtest0 kernel: [764188.495015]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:27 sydtest0 kernel: [764188.593328] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:27 sydtest0 kernel: [764188.799812] NMI backtrace for cpu 27
Nov 11 07:01:29 sydtest0 sshd[14085]: Received disconnect from 10.16.8.104: 11: disconnected by user
Nov 11 07:01:30 sydtest0 kernel: [764188.900687] CPU: 27 PID: 0 Comm: swapper/27 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:30 sydtest0 kernel: [764189.003954] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:30 sydtest0 kernel: [764189.107302] task: ffff88041ddc8710 ti: ffff88041ddc4000 task.ti: ffff88041ddc4000
Nov 11 07:01:30 sydtest0 kernel: [764189.211183] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:30 sydtest0 kernel: [764189.316395] RSP: 0018:ffff88041ddc5e88  EFLAGS: 00000286
Nov 11 07:01:30 sydtest0 kernel: [764189.421233] RAX: 00000000ffffffed RBX: ffff88041ddc5fd8 RCX: 0140000000000000
Nov 11 07:01:30 sydtest0 kernel: [764189.526950] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fdad620
Nov 11 07:01:30 sydtest0 kernel: [764189.630778] RBP: ffff88041ddc5ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:30 sydtest0 kernel: [764189.732395] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc5fd8
Nov 11 07:01:30 sydtest0 kernel: [764189.833826] R13: 000000000000001b R14: ffff88041ddc5fd8 R15: 0000000000000000
Nov 11 07:01:30 sydtest0 kernel: [764189.934353] FS:  0000000000000000(0000) GS:ffff88082fda0000(0000) knlGS:0000000000000000
Nov 11 07:01:30 sydtest0 kernel: [764190.034692] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:30 sydtest0 kernel: [764190.134127] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:30 sydtest0 kernel: [764190.233510] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:30 sydtest0 kernel: [764190.331773] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:30 sydtest0 kernel: [764190.428864] Stack:
Nov 11 07:01:30 sydtest0 kernel: [764190.524946]  ffff88041ddc5fd8 ffff88041ddc5fd8 ffff88041ddc5fd8 ffff88041ddc5fd8
Nov 11 07:01:30 sydtest0 kernel: [764190.623661]  ffff88041ddc5eb8 ffffffff8100aace ffff88041ddc5f28 ffffffff810754be
Nov 11 07:01:30 sydtest0 kernel: [764190.722137]  ffff88041ddc5ee8 ffffffff8107c92b ffff88082fdacc40 0000000000000000
Nov 11 07:01:30 sydtest0 kernel: [764190.820481] Call Trace:
Nov 11 07:01:30 sydtest0 kernel: [764190.917528]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:30 sydtest0 kernel: [764191.015180]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:30 sydtest0 kernel: [764191.112430]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:30 sydtest0 kernel: [764191.210589]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:30 sydtest0 kernel: [764191.309328] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:30 sydtest0 kernel: [764191.516796] NMI backtrace for cpu 28
Nov 11 07:01:32 sydtest0 kernel: [764191.618177] CPU: 28 PID: 0 Comm: swapper/28 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:32 sydtest0 kernel: [764191.721869] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:32 sydtest0 kernel: [764191.825645] task: ffff88041ddc8e20 ti: ffff88041ddc6000 task.ti: ffff88041ddc6000
Nov 11 07:01:32 sydtest0 kernel: [764191.930004] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:32 sydtest0 kernel: [764192.035668] RSP: 0018:ffff88041ddc7e88  EFLAGS: 00000286
Nov 11 07:01:32 sydtest0 kernel: [764192.140987] RAX: 00000000ffffffed RBX: ffff88041ddc7fd8 RCX: 0140000000000000
Nov 11 07:01:32 sydtest0 kernel: [764192.247156] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fdcd620
Nov 11 07:01:32 sydtest0 kernel: [764192.351464] RBP: ffff88041ddc7ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:32 sydtest0 kernel: [764192.453589] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc7fd8
Nov 11 07:01:32 sydtest0 kernel: [764192.555525] R13: 000000000000001c R14: ffff88041ddc7fd8 R15: 0000000000000000
Nov 11 07:01:32 sydtest0 kernel: [764192.656557] FS:  0000000000000000(0000) GS:ffff88041fdc0000(0000) knlGS:0000000000000000
Nov 11 07:01:32 sydtest0 kernel: [764192.757349] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:32 sydtest0 kernel: [764192.857209] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:32 sydtest0 kernel: [764192.956992] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:32 sydtest0 kernel: [764193.055601] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:32 sydtest0 kernel: [764193.153039] Stack:
Nov 11 07:01:32 sydtest0 kernel: [764193.249413]  ffff88041ddc7fd8 ffff88041ddc7fd8 ffff88041ddc7fd8 ffff88041ddc7fd8
Nov 11 07:01:32 sydtest0 kernel: [764193.348421]  ffff88041ddc7eb8 ffffffff8100aace ffff88041ddc7f28 ffffffff810754be
Nov 11 07:01:32 sydtest0 kernel: [764193.447165]  ffff88041ddc7ee8 ffffffff8107c92b ffff88041fdccc40 0000000000000000
Nov 11 07:01:32 sydtest0 kernel: [764193.545642] Call Trace:
Nov 11 07:01:32 sydtest0 kernel: [764193.642794]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:32 sydtest0 kernel: [764193.740523]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:32 sydtest0 kernel: [764193.837800]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:32 sydtest0 kernel: [764193.936064]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:32 sydtest0 kernel: [764194.034857] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:32 sydtest0 kernel: [764194.242487] NMI backtrace for cpu 29
Nov 11 07:01:35 sydtest0 kernel: [764194.343974] CPU: 29 PID: 0 Comm: swapper/29 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:35 sydtest0 kernel: [764194.447773] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:35 sydtest0 kernel: [764194.551601] task: ffff88041ddc9530 ti: ffff88041ddd0000 task.ti: ffff88041ddd0000
Nov 11 07:01:35 sydtest0 kernel: [764194.655988] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:35 sydtest0 kernel: [764194.761651] RSP: 0018:ffff88041ddd1e88  EFLAGS: 00000286
Nov 11 07:01:35 sydtest0 kernel: [764194.866969] RAX: 00000000ffffffed RBX: ffff88041ddd1fd8 RCX: 0140000000000000
Nov 11 07:01:35 sydtest0 kernel: [764194.973139] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fdcd620
Nov 11 07:01:35 sydtest0 kernel: [764195.077447] RBP: ffff88041ddd1ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:35 sydtest0 kernel: [764195.179543] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddd1fd8
Nov 11 07:01:35 sydtest0 kernel: [764195.281427] R13: 000000000000001d R14: ffff88041ddd1fd8 R15: 0000000000000000
Nov 11 07:01:35 sydtest0 kernel: [764195.382432] FS:  0000000000000000(0000) GS:ffff88082fdc0000(0000) knlGS:0000000000000000
Nov 11 07:01:35 sydtest0 kernel: [764195.483171] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:35 sydtest0 kernel: [764195.582978] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:35 sydtest0 kernel: [764195.682679] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:35 sydtest0 kernel: [764195.781209] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:35 sydtest0 kernel: [764195.878486] Stack:
Nov 11 07:01:35 sydtest0 kernel: [764195.974727]  ffff88041ddd1fd8 ffff88041ddd1fd8 ffff88041ddd1fd8 ffff88041ddd1fd8
Nov 11 07:01:35 sydtest0 kernel: [764195.995387] SysRq : Show backtrace of all active CPUs
Nov 11 07:01:35 sydtest0 kernel: [764195.995387] sending NMI to all CPUs:
Nov 11 07:01:35 sydtest0 kernel: [764196.270397]  ffff88041ddd1eb8 ffffffff8100aace ffff88041ddd1f28 ffffffff810754be
Nov 11 07:01:35 sydtest0 kernel: [764196.370337]  ffff88041ddd1ee8 ffffffff8107c92b ffff88082fdccc40 0000000000000000
Nov 11 07:01:35 sydtest0 kernel: [764196.469453] Call Trace:
Nov 11 07:01:35 sydtest0 kernel: [764196.567214]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:35 sydtest0 kernel: [764196.666514]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:35 sydtest0 kernel: [764196.766454]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:35 sydtest0 kernel: [764196.866183]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:35 sydtest0 kernel: [764196.964976] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:35 sydtest0 kernel: [764197.175294] NMI backtrace for cpu 30
Nov 11 07:01:38 sydtest0 kernel: [764197.277576] CPU: 30 PID: 0 Comm: swapper/30 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:38 sydtest0 kernel: [764197.381749] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:38 sydtest0 kernel: [764197.486882] task: ffff88041ddc9c40 ti: ffff88041ddd2000 task.ti: ffff88041ddd2000
Nov 11 07:01:38 sydtest0 kernel: [764197.592546] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:38 sydtest0 kernel: [764197.699170] RSP: 0018:ffff88041ddd3e88  EFLAGS: 00000286
Nov 11 07:01:38 sydtest0 kernel: [764197.803582] RAX: 00000000ffffffed RBX: ffff88041ddd3fd8 RCX: 0140000000000000
Nov 11 07:01:38 sydtest0 kernel: [764197.906824] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fded620
Nov 11 07:01:38 sydtest0 kernel: [764198.010039] RBP: ffff88041ddd3ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:38 sydtest0 kernel: [764198.112481] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddd3fd8
Nov 11 07:01:38 sydtest0 kernel: [764198.213992] R13: 000000000000001e R14: ffff88041ddd3fd8 R15: 0000000000000000
Nov 11 07:01:38 sydtest0 kernel: [764198.314731] FS:  0000000000000000(0000) GS:ffff88041fde0000(0000) knlGS:0000000000000000
Nov 11 07:01:38 sydtest0 kernel: [764198.415204] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:38 sydtest0 kernel: [764198.514744] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:01:38 sydtest0 kernel: [764198.614605] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:38 sydtest0 kernel: [764198.713852] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:38 sydtest0 kernel: [764198.812354] Stack:
Nov 11 07:01:38 sydtest0 kernel: [764198.909926]  ffff88041ddd3fd8 ffff88041ddd3fd8 ffff88041ddd3fd8 ffff88041ddd3fd8
Nov 11 07:01:38 sydtest0 kernel: [764199.010212]  ffff88041ddd3eb8 ffffffff8100aace ffff88041ddd3f28 ffffffff810754be
Nov 11 07:01:38 sydtest0 kernel: [764199.109939]  ffff88041ddd3ee8 ffffffff8107c92b ffff88041fdecc40 0000000000000000
Nov 11 07:01:38 sydtest0 kernel: [764199.208921] Call Trace:
Nov 11 07:01:38 sydtest0 kernel: [764199.306521]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:38 sydtest0 kernel: [764199.405608]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:38 sydtest0 kernel: [764199.505362]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:38 sydtest0 kernel: [764199.604956]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:38 sydtest0 kernel: [764199.703617] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:38 sydtest0 kernel: [764199.913749] NMI backtrace for cpu 31
Nov 11 07:01:41 sydtest0 kernel: [764200.015955] CPU: 31 PID: 0 Comm: swapper/31 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:41 sydtest0 kernel: [764200.120153] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:41 sydtest0 kernel: [764200.225312] task: ffff88041ddca350 ti: ffff88041ddd4000 task.ti: ffff88041ddd4000
Nov 11 07:01:41 sydtest0 kernel: [764200.330976] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:41 sydtest0 kernel: [764200.437598] RSP: 0018:ffff88041ddd5e88  EFLAGS: 00000286
Nov 11 07:01:41 sydtest0 kernel: [764200.542010] RAX: 00000000ffffffed RBX: ffff88041ddd5fd8 RCX: 0140000000000000
Nov 11 07:01:41 sydtest0 kernel: [764200.645252] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fded620
Nov 11 07:01:41 sydtest0 kernel: [764200.748493] RBP: ffff88041ddd5ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:41 sydtest0 kernel: [764200.850909] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddd5fd8
Nov 11 07:01:41 sydtest0 kernel: [764200.952473] R13: 000000000000001f R14: ffff88041ddd5fd8 R15: 0000000000000000
Nov 11 07:01:41 sydtest0 kernel: [764201.053239] FS:  0000000000000000(0000) GS:ffff88082fde0000(0000) knlGS:0000000000000000
Nov 11 07:01:41 sydtest0 kernel: [764201.153792] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:41 sydtest0 kernel: [764201.253387] CR2: 0000003b0de16c4c CR3: 0000000813569000 CR4: 00000000000407e0
Nov 11 07:01:41 sydtest0 kernel: [764201.353406] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:41 sydtest0 kernel: [764201.452920] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:41 sydtest0 kernel: [764201.551689] Stack:
Nov 11 07:01:41 sydtest0 kernel: [764201.649580]  ffff88041ddd5fd8 ffff88041ddd5fd8 ffff88041ddd5fd8 ffff88041ddd5fd8
Nov 11 07:01:41 sydtest0 kernel: [764201.750106]  ffff88041ddd5eb8 ffffffff8100aace ffff88041ddd5f28 ffffffff810754be
Nov 11 07:01:41 sydtest0 kernel: [764201.850019]  ffff88041ddd5ee8 ffffffff8107c92b ffff88082fdecc40 0000000000000000
Nov 11 07:01:41 sydtest0 kernel: [764201.949187] Call Trace:
Nov 11 07:01:41 sydtest0 kernel: [764202.047002]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:41 sydtest0 kernel: [764202.146410]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:41 sydtest0 kernel: [764202.246537]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:41 sydtest0 kernel: [764202.346477]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:41 sydtest0 kernel: [764202.445456] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:41 sydtest0 kernel: [764202.653855] NMI backtrace for cpu 0
Nov 11 07:01:44 sydtest0 kernel: [764202.755049] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:44 sydtest0 kernel: [764202.858503] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:44 sydtest0 kernel: [764202.962011] task: ffffffff81a10440 ti: ffffffff81a00000 task.ti: ffffffff81a00000
Nov 11 07:01:44 sydtest0 kernel: [764203.066078] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:44 sydtest0 kernel: [764203.171423] RSP: 0018:ffffffff81a01ea8  EFLAGS: 00000286
Nov 11 07:01:44 sydtest0 kernel: [764203.276342] RAX: 00000000ffffffed RBX: ffffffff81a01fd8 RCX: 0140000000000000
Nov 11 07:01:44 sydtest0 kernel: [764203.382033] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc0d620
Nov 11 07:01:44 sydtest0 kernel: [764203.485860] RBP: ffffffff81a01ec8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:44 sydtest0 kernel: [764203.587424] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81a01fd8
Nov 11 07:01:44 sydtest0 kernel: [764203.688801] R13: 0000000000000000 R14: ffffffff81a01fd8 R15: 0000000000000000
Nov 11 07:01:44 sydtest0 kernel: [764203.789249] FS:  0000000000000000(0000) GS:ffff88041fc00000(0000) knlGS:0000000000000000
Nov 11 07:01:44 sydtest0 kernel: [764203.889268] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:44 sydtest0 kernel: [764203.988303] CR2: 0000000001db8428 CR3: 00000004147ef000 CR4: 00000000000407f0
Nov 11 07:01:44 sydtest0 kernel: [764204.087338] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:44 sydtest0 kernel: [764204.185282] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:44 sydtest0 kernel: [764204.282000] Stack:
Nov 11 07:01:44 sydtest0 kernel: [764204.377654]  ffffffff81a01fd8 ffffffff81a01fd8 ffffffff81a01fd8 ffffffff81a01fd8
Nov 11 07:01:44 sydtest0 kernel: [764204.475891]  ffffffff81a01ed8 ffffffff8100aace ffffffff81a01f48 ffffffff810754be
Nov 11 07:01:44 sydtest0 kernel: [764204.573514]  ffffffff81a01fd8 ffffffff81a10440 0000000000000286 ffffffffffffffff
Nov 11 07:01:44 sydtest0 kernel: [764204.671006] Call Trace:
Nov 11 07:01:44 sydtest0 kernel: [764204.767143]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:44 sydtest0 kernel: [764204.863889]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:44 sydtest0 kernel: [764204.960210]  [<ffffffff814ac087>] rest_init+0x77/0x80
Nov 11 07:01:44 sydtest0 kernel: [764205.056636]  [<ffffffff81adae53>] start_kernel+0x3c9/0x3d6
Nov 11 07:01:44 sydtest0 kernel: [764205.153780]  [<ffffffff81ada88a>] ? repair_env_string+0x5a/0x5a
Nov 11 07:01:44 sydtest0 kernel: [764205.250313]  [<ffffffff81ada5a8>] x86_64_start_reservations+0x2a/0x2c
Nov 11 07:01:44 sydtest0 kernel: [764205.346233]  [<ffffffff81ada68f>] x86_64_start_kernel+0xe5/0xec
Nov 11 07:01:44 sydtest0 kernel: [764205.441859] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:44 sydtest0 kernel: [764205.644749] NMI backtrace for cpu 1
Nov 11 07:01:46 sydtest0 kernel: [764205.743333] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:46 sydtest0 kernel: [764205.844045] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:46 sydtest0 kernel: [764205.945424] task: ffff88041dc7cdb0 ti: ffff88041dd6e000 task.ti: ffff88041dd6e000
Nov 11 07:01:46 sydtest0 kernel: [764206.047333] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:46 sydtest0 kernel: [764206.148392] RSP: 0018:ffff88041dd6fe88  EFLAGS: 00000286
Nov 11 07:01:46 sydtest0 kernel: [764206.247002] RAX: 00000000ffffffed RBX: ffff88041dd6ffd8 RCX: 0140000000000000
Nov 11 07:01:46 sydtest0 kernel: [764206.346490] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc0d620
Nov 11 07:01:46 sydtest0 kernel: [764206.445179] RBP: ffff88041dd6fea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:46 sydtest0 kernel: [764206.542963] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd6ffd8
Nov 11 07:01:46 sydtest0 kernel: [764206.640001] R13: 0000000000000001 R14: ffff88041dd6ffd8 R15: 0000000000000000
Nov 11 07:01:46 sydtest0 kernel: [764206.736029] FS:  0000000000000000(0000) GS:ffff88082fc00000(0000) knlGS:0000000000000000
Nov 11 07:01:46 sydtest0 kernel: [764206.832029] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:46 sydtest0 kernel: [764206.927204] CR2: 00000000012e0428 CR3: 00000007945d1000 CR4: 00000000000407e0
Nov 11 07:01:46 sydtest0 kernel: [764207.023178] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:46 sydtest0 kernel: [764207.118753] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:46 sydtest0 kernel: [764207.213635] Stack:
Nov 11 07:01:46 sydtest0 kernel: [764207.307639]  ffff88041dd6ffd8 ffff88041dd6ffd8 ffff88041dd6ffd8 ffff88041dd6ffd8
Nov 11 07:01:46 sydtest0 kernel: [764207.403826]  ffff88041dd6feb8 ffffffff8100aace ffff88041dd6ff28 ffffffff810754be
Nov 11 07:01:46 sydtest0 kernel: [764207.499268]  ffff88041dd6fee8 ffffffff8107c92b ffff88082fc0cc40 0000000000000000
Nov 11 07:01:46 sydtest0 kernel: [764207.594044] Call Trace:
Nov 11 07:01:46 sydtest0 kernel: [764207.688211]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:46 sydtest0 kernel: [764207.784211]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:46 sydtest0 kernel: [764207.879465]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:46 sydtest0 kernel: [764207.974509]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:46 sydtest0 kernel: [764208.069655] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:46 sydtest0 kernel: [764208.271693] NMI backtrace for cpu 2
Nov 11 07:01:50 sydtest0 kernel: [764208.369849] CPU: 2 PID: 14045 Comm: ptpd Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:50 sydtest0 kernel: [764208.470107] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:50 sydtest0 kernel: [764208.571059] task: ffff8808105d62e0 ti: ffff8807d0afa000 task.ti: ffff8807d0afa000
Nov 11 07:01:50 sydtest0 kernel: [764208.672571] RIP: 0010:[<ffffffff81083502>]  [<ffffffff81083502>] smp_call_function_many+0x272/0x2d0
Nov 11 07:01:50 sydtest0 kernel: [764208.773922] RSP: 0018:ffff8807d0afbdf8  EFLAGS: 00000202
Nov 11 07:01:50 sydtest0 kernel: [764208.872903] RAX: 000000000000001d RBX: ffff88041fc33648 RCX: ffff88082fdd63b8
Nov 11 07:01:50 sydtest0 kernel: [764208.972816] RDX: 000000000000001d RSI: 0000000000000100 RDI: 0000000000000100
Nov 11 07:01:50 sydtest0 kernel: [764209.071930] RBP: ffff8807d0afbe58 R08: ffff88041fc33648 R09: 0000000000000000
Nov 11 07:01:50 sydtest0 kernel: [764209.170194] R10: 0000000000000004 R11: 0000000000000246 R12: ffff88041fc33640
Nov 11 07:01:50 sydtest0 kernel: [764209.268004] R13: ffffffff81062480 R14: 0000000000000000 R15: 0000000000013600
Nov 11 07:01:50 sydtest0 kernel: [764209.364858] FS:  00007fc28c07a700(0000) GS:ffff88041fc20000(0000) knlGS:0000000000000000
Nov 11 07:01:50 sydtest0 kernel: [764209.462163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:50 sydtest0 kernel: [764209.558961] CR2: 00007facee9af000 CR3: 00000007f0ae3000 CR4: 00000000000407e0
Nov 11 07:01:50 sydtest0 kernel: [764209.656532] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:50 sydtest0 kernel: [764209.753757] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:50 sydtest0 kernel: [764209.850289] Stack:
Nov 11 07:01:50 sydtest0 kernel: [764209.945997]  ffff88082fdf3610 ffff88082fdf3600 ffff88082fdf63b8 ffff88070000001f
Nov 11 07:01:50 sydtest0 kernel: [764210.044155]  01ff8807d0afbe28 ffff88041fc33668 ffff8807d0afbee8 ffffffff81062480
Nov 11 07:01:50 sydtest0 kernel: [764210.141858]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Nov 11 07:01:50 sydtest0 kernel: [764210.239536] Call Trace:
Nov 11 07:01:50 sydtest0 kernel: [764210.336659]  [<ffffffff81062480>] ? hrtimer_cancel+0x30/0x30
Nov 11 07:01:50 sydtest0 kernel: [764210.435719]  [<ffffffff810835e2>] smp_call_function+0x22/0x30
Nov 11 07:01:50 sydtest0 kernel: [764210.534008]  [<ffffffff81083648>] on_each_cpu+0x28/0x50
Nov 11 07:01:50 sydtest0 kernel: [764210.631154]  [<ffffffff8106272c>] clock_was_set+0x1c/0x30
Nov 11 07:01:50 sydtest0 kernel: [764210.728752]  [<ffffffff8107701e>] do_settimeofday+0xfe/0x110
Nov 11 07:01:50 sydtest0 kernel: [764210.826457]  [<ffffffff8104244d>] do_sys_settimeofday+0xdd/0xf0
Nov 11 07:01:50 sydtest0 kernel: [764210.923255]  [<ffffffff813f6fe9>] ? __sys_recvmsg+0x49/0x90
Nov 11 07:01:50 sydtest0 kernel: [764211.019601]  [<ffffffff8105d513>] posix_clock_realtime_set+0x13/0x20
Nov 11 07:01:50 sydtest0 kernel: [764211.116480]  [<ffffffff8105e55f>] SyS_clock_settime+0x5f/0x90
Nov 11 07:01:50 sydtest0 kernel: [764211.213307]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 11 07:01:50 sydtest0 kernel: [764211.310236] Code: 15 c1 1e 00 3b 05 f7 9a a3 00 0f 8d 15 fe ff ff 48 63 d0 49 8b 0c 24 48 03 0c d5 e0 b3 ab 81 f6 41 20 01 74 cc f3 90 f6 41 20 01 <74> c4 eb f6 0f b6 4d c7 4c 89 f2 4c 89 ee 89 df e8 29 fb ff ff 
Nov 11 07:01:50 sydtest0 kernel: [764211.516108] NMI backtrace for cpu 3
Nov 11 07:01:50 sydtest0 ptpd[14045]: resetting system clock to 1384174853s 486781779ns
Nov 11 07:01:50 sydtest0 ptpd[14045]: clock stepped, off by -0.110395 seconds
Nov 11 07:01:52 sydtest0 kernel: [764211.617089] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:52 sydtest0 kernel: [764211.717985] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:52 sydtest0 kernel: [764211.817473] task: ffff88041dc7dbd0 ti: ffff88041dd72000 task.ti: ffff88041dd72000
Nov 11 07:01:52 sydtest0 kernel: [764211.917545] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:52 sydtest0 kernel: [764212.017992] RSP: 0018:ffff88041dd73e88  EFLAGS: 00000286
Nov 11 07:01:52 sydtest0 kernel: [764212.117400] RAX: 00000000ffffffed RBX: ffff88041dd73fd8 RCX: 0140000000000000
Nov 11 07:01:52 sydtest0 kernel: [764212.217101] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc2d620
Nov 11 07:01:52 sydtest0 kernel: [764212.315951] RBP: ffff88041dd73ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:52 sydtest0 kernel: [764212.414108] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd73fd8
Nov 11 07:01:52 sydtest0 kernel: [764212.511785] R13: 0000000000000003 R14: ffff88041dd73fd8 R15: 0000000000000000
Nov 11 07:01:52 sydtest0 kernel: [764212.609276] FS:  0000000000000000(0000) GS:ffff88082fc20000(0000) knlGS:0000000000000000
Nov 11 07:01:52 sydtest0 kernel: [764212.707486] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:52 sydtest0 kernel: [764212.805483] CR2: 000000000229e448 CR3: 000000078e6a6000 CR4: 00000000000407e0
Nov 11 07:01:52 sydtest0 kernel: [764212.904439] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:52 sydtest0 kernel: [764213.002595] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:52 sydtest0 kernel: [764213.099660] Stack:
Nov 11 07:01:52 sydtest0 kernel: [764213.195287]  ffff88041dd73fd8 ffff88041dd73fd8 ffff88041dd73fd8 ffff88041dd73fd8
Nov 11 07:01:52 sydtest0 kernel: [764213.293923]  ffff88041dd73eb8 ffffffff8100aace ffff88041dd73f28 ffffffff810754be
Nov 11 07:01:52 sydtest0 kernel: [764213.392958]  ffff88041dd73ee8 ffffffff8107c92b ffff88082fc2cc40 0000000000000000
Nov 11 07:01:52 sydtest0 kernel: [764213.491141] Call Trace:
Nov 11 07:01:52 sydtest0 kernel: [764213.587624]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:52 sydtest0 kernel: [764213.685487]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:52 sydtest0 kernel: [764213.783510]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:52 sydtest0 kernel: [764213.881294]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:52 sydtest0 kernel: [764213.978703] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:52 sydtest0 kernel: [764214.185745] NMI backtrace for cpu 4
Nov 11 07:01:52 sydtest0 ptpd[14045]: Discarding DelayResponse with inconsistent RecvTime
Nov 11 07:01:52 sydtest0 ptpd[14045]:   DelayResponse Claimed: 1384174946.346757225, Delta: 1.142137021
Nov 11 07:01:55 sydtest0 kernel: [764214.286672] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:55 sydtest0 kernel: [764214.387516] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:55 sydtest0 kernel: [764214.486951] task: ffff88041dc7e2e0 ti: ffff88041dd74000 task.ti: ffff88041dd74000
Nov 11 07:01:55 sydtest0 kernel: [764214.586944] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:55 sydtest0 kernel: [764214.687284] RSP: 0018:ffff88041dd75e88  EFLAGS: 00000286
Nov 11 07:01:55 sydtest0 kernel: [764214.786559] RAX: 00000000ffffffed RBX: ffff88041dd75fd8 RCX: 0140000000000000
Nov 11 07:01:55 sydtest0 kernel: [764214.886180] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc4d620
Nov 11 07:01:55 sydtest0 kernel: [764214.984629] RBP: ffff88041dd75ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:55 sydtest0 kernel: [764215.082041] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd75fd8
Nov 11 07:01:55 sydtest0 kernel: [764215.178946] R13: 0000000000000004 R14: ffff88041dd75fd8 R15: 0000000000000000
Nov 11 07:01:55 sydtest0 kernel: [764215.275851] FS:  0000000000000000(0000) GS:ffff88041fc40000(0000) knlGS:0000000000000000
Nov 11 07:01:55 sydtest0 kernel: [764215.373422] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:55 sydtest0 kernel: [764215.470487] CR2: 00007fc9b4e34928 CR3: 00000004143cd000 CR4: 00000000000407e0
Nov 11 07:01:55 sydtest0 kernel: [764215.568565] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:55 sydtest0 kernel: [764215.665657] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:55 sydtest0 kernel: [764215.761444] Stack:
Nov 11 07:01:55 sydtest0 kernel: [764215.855822]  ffff88041dd75fd8 ffff88041dd75fd8 ffff88041dd75fd8 ffff88041dd75fd8
Nov 11 07:01:55 sydtest0 kernel: [764215.953207]  ffff88041dd75eb8 ffffffff8100aace ffff88041dd75f28 ffffffff810754be
Nov 11 07:01:55 sydtest0 kernel: [764216.050991]  ffff88041dd75ee8 ffffffff8107c92b ffff88041fc4cc40 0000000000000000
Nov 11 07:01:55 sydtest0 kernel: [764216.147924] Call Trace:
Nov 11 07:01:55 sydtest0 kernel: [764216.243102]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:55 sydtest0 kernel: [764216.339394]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:55 sydtest0 kernel: [764216.435207]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:55 sydtest0 kernel: [764216.530755]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:55 sydtest0 kernel: [764216.625903] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:55 sydtest0 kernel: [764216.828660] NMI backtrace for cpu 5
Nov 11 07:01:57 sydtest0 kernel: [764216.928095] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:01:57 sydtest0 kernel: [764217.029631] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:01:57 sydtest0 kernel: [764217.132261] task: ffff88041dc7e9f0 ti: ffff88041dd76000 task.ti: ffff88041dd76000
Nov 11 07:01:57 sydtest0 kernel: [764217.235741] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:01:57 sydtest0 kernel: [764217.340182] RSP: 0018:ffff88041dd77e88  EFLAGS: 00000286
Nov 11 07:01:57 sydtest0 kernel: [764217.444461] RAX: 00000000ffffffed RBX: ffff88041dd77fd8 RCX: 0140000000000000
Nov 11 07:01:57 sydtest0 kernel: [764217.549885] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc4d620
Nov 11 07:01:57 sydtest0 kernel: [764217.653446] RBP: ffff88041dd77ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:01:57 sydtest0 kernel: [764217.754823] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd77fd8
Nov 11 07:01:57 sydtest0 kernel: [764217.856042] R13: 0000000000000005 R14: ffff88041dd77fd8 R15: 0000000000000000
Nov 11 07:01:57 sydtest0 kernel: [764217.956462] FS:  0000000000000000(0000) GS:ffff88082fc40000(0000) knlGS:0000000000000000
Nov 11 07:01:57 sydtest0 kernel: [764218.056694] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:01:57 sydtest0 kernel: [764218.156050] CR2: 00000000006e2c14 CR3: 00000003ad331000 CR4: 00000000000407e0
Nov 11 07:01:57 sydtest0 kernel: [764218.255404] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:01:57 sydtest0 kernel: [764218.353641] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:01:57 sydtest0 kernel: [764218.450706] Stack:
Nov 11 07:01:57 sydtest0 kernel: [764218.546760]  ffff88041dd77fd8 ffff88041dd77fd8 ffff88041dd77fd8 ffff88041dd77fd8
Nov 11 07:01:57 sydtest0 kernel: [764218.645449]  ffff88041dd77eb8 ffffffff8100aace ffff88041dd77f28 ffffffff810754be
Nov 11 07:01:57 sydtest0 kernel: [764218.743873]  ffff88041dd77ee8 ffffffff8107c92b ffff88082fc4cc40 0000000000000000
Nov 11 07:01:57 sydtest0 kernel: [764218.842189] Call Trace:
Nov 11 07:01:57 sydtest0 kernel: [764218.939124]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:01:57 sydtest0 kernel: [764219.036669]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:01:57 sydtest0 kernel: [764219.133760]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:01:57 sydtest0 kernel: [764219.231757]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:01:57 sydtest0 kernel: [764219.330258] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:01:57 sydtest0 kernel: [764219.537115] NMI backtrace for cpu 6
Nov 11 07:02:24 sydtest0 kernel: [764219.638200] CPU: 6 PID: 9400 Comm: bash Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764219.741414] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764219.844762] task: ffff880399d30000 ti: ffff8804104e0000 task.ti: ffff8804104e0000
Nov 11 07:02:24 sydtest0 kernel: [764219.948589] RIP: 0010:[<ffffffff81269f77>]  [<ffffffff81269f77>] delay_tsc+0x37/0x60
Nov 11 07:02:24 sydtest0 kernel: [764220.053589] RSP: 0018:ffff8804104e1d98  EFLAGS: 00000046
Nov 11 07:02:24 sydtest0 kernel: [764220.158214] RAX: 00000000e50ccf7e RBX: 00000000000003e9 RCX: 0000000000000006
Nov 11 07:02:24 sydtest0 kernel: [764220.263665] RDX: 000000000007e099 RSI: 00000000e50ccf3c RDI: 0000000000046cc7
Nov 11 07:02:24 sydtest0 kernel: [764220.366774] RBP: ffff8804104e1d98 R08: 0000000000000006 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764220.467513] R10: 0000000000000038 R11: 0000000000010dac R12: 0000000000001000
Nov 11 07:02:24 sydtest0 kernel: [764220.567773] R13: ffffffff81abcf00 R14: 0000000000000400 R15: 0000000000000096
Nov 11 07:02:24 sydtest0 kernel: [764220.666968] FS:  00007f67dc3cd700(0000) GS:ffff88041fc60000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764220.766348] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764220.864852] CR2: 00007f67dc3ef000 CR3: 00000003ad331000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764220.963435] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764221.061005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764221.157378] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764221.252739]  ffff8804104e1da8 ffffffff81269ed8 ffff8804104e1dc8 ffffffff8102471a
Nov 11 07:02:24 sydtest0 kernel: [764221.350710]  0000000000000002 000000000000b06a ffff8804104e1e18 ffffffff81025310
Nov 11 07:02:24 sydtest0 kernel: [764221.448600]  ffffffff00000026 0000000000000007 ffff8804104e1e38 0000000000002710
Nov 11 07:02:24 sydtest0 kernel: [764221.546304] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764221.642627]  [<ffffffff81269ed8>] __const_udelay+0x28/0x30
Nov 11 07:02:24 sydtest0 kernel: [764221.739586]  [<ffffffff8102471a>] native_safe_apic_wait_icr_idle+0x2a/0x60
Nov 11 07:02:24 sydtest0 kernel: [764221.836704]  [<ffffffff81025310>] default_send_IPI_mask_sequence_phys+0xc0/0xd0
Nov 11 07:02:24 sydtest0 kernel: [764221.934303]  [<ffffffff81028817>] physflat_send_IPI_all+0x17/0x20
Nov 11 07:02:24 sydtest0 kernel: [764222.032459]  [<ffffffff81025481>] arch_trigger_all_cpu_backtrace+0x61/0xa0
Nov 11 07:02:24 sydtest0 kernel: [764222.130404]  [<ffffffff8130033e>] sysrq_handle_showallcpus+0xe/0x10
Nov 11 07:02:24 sydtest0 kernel: [764222.227574]  [<ffffffff81300741>] __handle_sysrq+0x121/0x190
Nov 11 07:02:24 sydtest0 kernel: [764222.324826]  [<ffffffff813007fa>] write_sysrq_trigger+0x4a/0x50
Nov 11 07:02:24 sydtest0 kernel: [764222.422185]  [<ffffffff811936c3>] proc_reg_write+0x43/0x70
Nov 11 07:02:24 sydtest0 kernel: [764222.518506]  [<ffffffff8113820e>] vfs_write+0xce/0x1e0
Nov 11 07:02:24 sydtest0 kernel: [764222.614239]  [<ffffffff811386f2>] SyS_write+0x52/0xa0
Nov 11 07:02:24 sydtest0 kernel: [764222.709388]  [<ffffffff814bda2e>] ? do_page_fault+0xe/0x10
Nov 11 07:02:24 sydtest0 kernel: [764222.804296]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 11 07:02:24 sydtest0 kernel: [764222.899125] Code: 04 25 64 b0 00 00 0f 1f 00 0f ae e8 0f 31 89 c6 eb 11 66 90 f3 90 65 8b 0c 25 64 b0 00 00 41 39 c8 75 12 0f 1f 00 0f ae e8 0f 31 <89> c2 29 f2 39 fa 72 e1 5d c3 29 c6 01 f7 0f 1f 00 0f ae e8 0f 
Nov 11 07:02:24 sydtest0 kernel: [764223.094244] NMI backtrace for cpu 7
Nov 11 07:02:24 sydtest0 kernel: [764223.096255] Uhhuh. NMI received for unknown reason 21 on CPU 29.
Nov 11 07:02:24 sydtest0 kernel: [764223.096256] Do you have a strange power saving mode enabled?
Nov 11 07:02:24 sydtest0 kernel: [764223.096256] Dazed and confused, but trying to continue
Nov 11 07:02:24 sydtest0 kernel: [764223.096355] Uhhuh. NMI received for unknown reason 31 on CPU 30.
Nov 11 07:02:24 sydtest0 kernel: [764223.096355] Do you have a strange power saving mode enabled?
Nov 11 07:02:24 sydtest0 kernel: [764223.096356] Dazed and confused, but trying to continue
Nov 11 07:02:24 sydtest0 kernel: [764223.096455] Uhhuh. NMI received for unknown reason 31 on CPU 31.
Nov 11 07:02:24 sydtest0 kernel: [764223.096456] Do you have a strange power saving mode enabled?
Nov 11 07:02:24 sydtest0 kernel: [764223.096456] Dazed and confused, but trying to continue
Nov 11 07:02:24 sydtest0 kernel: [764224.018741] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764224.112023] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764224.205814] task: ffff88041dc7f810 ti: ffff88041dd7a000 task.ti: ffff88041dd7a000
Nov 11 07:02:24 sydtest0 kernel: [764224.299844] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:24 sydtest0 kernel: [764224.394461] RSP: 0018:ffff88041dd7be88  EFLAGS: 00000286
Nov 11 07:02:24 sydtest0 kernel: [764224.489316] RAX: 00000000ffffffed RBX: ffff88041dd7bfd8 RCX: 0140000000000000
Nov 11 07:02:24 sydtest0 kernel: [764224.585955] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc6d620
Nov 11 07:02:24 sydtest0 kernel: [764224.682087] RBP: ffff88041dd7bea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764224.777475] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7bfd8
Nov 11 07:02:24 sydtest0 kernel: [764224.873156] R13: 0000000000000007 R14: ffff88041dd7bfd8 R15: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764224.968944] FS:  0000000000000000(0000) GS:ffff88082fc60000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764225.064679] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764225.160040] CR2: 0000000001db8428 CR3: 00000007e5c31000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764225.256467] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764225.352360] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764225.447348] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764225.539436]  ffff88041dd7bfd8 ffff88041dd7bfd8 ffff88041dd7bfd8 ffff88041dd7bfd8
Nov 11 07:02:24 sydtest0 kernel: [764225.631922]  ffff88041dd7beb8 ffffffff8100aace ffff88041dd7bf28 ffffffff810754be
Nov 11 07:02:24 sydtest0 kernel: [764225.723957]  ffff88041dd7bee8 ffffffff8107c92b ffff88082fc6cc40 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764225.815086] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764225.904409]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:24 sydtest0 kernel: [764225.994153]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:24 sydtest0 kernel: [764226.082964]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:24 sydtest0 kernel: [764226.171725]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:24 sydtest0 kernel: [764226.259895] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:24 sydtest0 kernel: [764226.448942] NMI backtrace for cpu 22
Nov 11 07:02:24 sydtest0 kernel: [764226.541589] CPU: 22 PID: 0 Comm: swapper/22 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764226.636683] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764226.731832] task: ffff88041dd8e2e0 ti: ffff88041ddb8000 task.ti: ffff88041ddb8000
Nov 11 07:02:24 sydtest0 kernel: [764226.827140] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:24 sydtest0 kernel: [764226.923087] RSP: 0018:ffff88041ddb9e88  EFLAGS: 00000286
Nov 11 07:02:24 sydtest0 kernel: [764227.019194] RAX: 00000000ffffffed RBX: ffff88041ddb9fd8 RCX: 0140000000000000
Nov 11 07:02:24 sydtest0 kernel: [764227.117111] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd6d620
Nov 11 07:02:24 sydtest0 kernel: [764227.214468] RBP: ffff88041ddb9ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764227.311081] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddb9fd8
Nov 11 07:02:24 sydtest0 kernel: [764227.407748] R13: 0000000000000016 R14: ffff88041ddb9fd8 R15: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764227.504653] FS:  0000000000000000(0000) GS:ffff88041fd60000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764227.601505] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764227.697932] CR2: 0000003b0de7b160 CR3: 000000040eeb1000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764227.795051] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764227.891664] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764227.987346] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764228.081935]  ffff88041ddb9fd8 ffff88041ddb9fd8 ffff88041ddb9fd8 ffff88041ddb9fd8
Nov 11 07:02:24 sydtest0 kernel: [764228.178974]  ffff88041ddb9eb8 ffffffff8100aace ffff88041ddb9f28 ffffffff810754be
Nov 11 07:02:24 sydtest0 kernel: [764228.275800]  ffff88041ddb9ee8 ffffffff8107c92b ffff88041fd6cc40 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764228.372545] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764228.468468]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:24 sydtest0 kernel: [764228.565800]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:24 sydtest0 kernel: [764228.663796]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:24 sydtest0 kernel: [764228.762485]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:24 sydtest0 kernel: [764228.861066] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:24 sydtest0 kernel: [764229.063984] NMI backtrace for cpu 8
Nov 11 07:02:24 sydtest0 kernel: [764229.161902] CPU: 8 PID: 0 Comm: swapper/8 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764229.261602] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764229.361836] task: ffff88041dd88000 ti: ffff88041dd7c000 task.ti: ffff88041dd7c000
Nov 11 07:02:24 sydtest0 kernel: [764229.462628] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:24 sydtest0 kernel: [764229.564325] RSP: 0018:ffff88041dd7de88  EFLAGS: 00000286
Nov 11 07:02:24 sydtest0 kernel: [764229.665623] RAX: 00000000ffffffed RBX: ffff88041dd7dfd8 RCX: 0140000000000000
Nov 11 07:02:24 sydtest0 kernel: [764229.767774] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc8d620
Nov 11 07:02:24 sydtest0 kernel: [764229.869844] RBP: ffff88041dd7dea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764229.971674] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7dfd8
Nov 11 07:02:24 sydtest0 kernel: [764230.073345] R13: 0000000000000008 R14: ffff88041dd7dfd8 R15: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764230.174165] FS:  0000000000000000(0000) GS:ffff88041fc80000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764230.274744] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764230.374339] CR2: 000000000163c448 CR3: 000000078d140000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764230.473987] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764230.572518] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764230.669822] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764230.766089]  ffff88041dd7dfd8 ffff88041dd7dfd8 ffff88041dd7dfd8 ffff88041dd7dfd8
Nov 11 07:02:24 sydtest0 kernel: [764230.864965]  ffff88041dd7deb8 ffffffff8100aace ffff88041dd7df28 ffffffff810754be
Nov 11 07:02:24 sydtest0 kernel: [764230.963549]  ffff88041dd7dee8 ffffffff8107c92b ffff88041fc8cc40 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764231.061972] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764231.159041]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:24 sydtest0 kernel: [764231.256691]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:24 sydtest0 kernel: [764231.353783]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:24 sydtest0 kernel: [764231.451754]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:24 sydtest0 kernel: [764231.550282] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:24 sydtest0 kernel: [764231.757218] NMI backtrace for cpu 9
Nov 11 07:02:24 sydtest0 kernel: [764231.858332] CPU: 9 PID: 0 Comm: swapper/9 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764231.961598] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764232.064946] task: ffff88041dd88710 ti: ffff88041dd7e000 task.ti: ffff88041dd7e000
Nov 11 07:02:24 sydtest0 kernel: [764232.168826] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:24 sydtest0 kernel: [764232.273986] RSP: 0018:ffff88041dd7fe88  EFLAGS: 00000286
Nov 11 07:02:24 sydtest0 kernel: [764232.378719] RAX: 00000000ffffffed RBX: ffff88041dd7ffd8 RCX: 0140000000000000
Nov 11 07:02:24 sydtest0 kernel: [764232.484276] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc8d620
Nov 11 07:02:24 sydtest0 kernel: [764232.587997] RBP: ffff88041dd7fea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764232.689508] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7ffd8
Nov 11 07:02:24 sydtest0 kernel: [764232.790887] R13: 0000000000000009 R14: ffff88041dd7ffd8 R15: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764232.891387] FS:  0000000000000000(0000) GS:ffff88082fc80000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764232.991593] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764233.090842] CR2: 00000000012e0428 CR3: 000000078e930000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764233.190064] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764233.288114] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764233.384912] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764233.480646]  ffff88041dd7ffd8 ffff88041dd7ffd8 ffff88041dd7ffd8 ffff88041dd7ffd8
Nov 11 07:02:24 sydtest0 kernel: [764233.578988]  ffff88041dd7feb8 ffffffff8100aace ffff88041dd7ff28 ffffffff810754be
Nov 11 07:02:24 sydtest0 kernel: [764233.677093]  ffff88041dd7fee8 ffffffff8107c92b ffff88082fc8cc40 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764233.775036] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764233.871598]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:24 sydtest0 kernel: [764233.968743]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:24 sydtest0 kernel: [764234.065409]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:24 sydtest0 kernel: [764234.163007]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:24 sydtest0 kernel: [764234.261134] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:24 sydtest0 kernel: [764234.467220] NMI backtrace for cpu 10
Nov 11 07:02:24 sydtest0 kernel: [764234.567908] CPU: 10 PID: 0 Comm: swapper/10 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764234.670934] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764234.774016] task: ffff88041dd88e20 ti: ffff88041dd90000 task.ti: ffff88041dd90000
Nov 11 07:02:24 sydtest0 kernel: [764234.877603] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:24 sydtest0 kernel: [764234.982469] RSP: 0018:ffff88041dd91e88  EFLAGS: 00000286
Nov 11 07:02:24 sydtest0 kernel: [764235.086989] RAX: 00000000ffffffed RBX: ffff88041dd91fd8 RCX: 0140000000000000
Nov 11 07:02:24 sydtest0 kernel: [764235.192361] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fcad620
Nov 11 07:02:24 sydtest0 kernel: [764235.295895] RBP: ffff88041dd91ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764235.397220] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd91fd8
Nov 11 07:02:24 sydtest0 kernel: [764235.493533] BUG: soft lockup - CPU#2 stuck for 22s! [swapper/2:0]
Nov 11 07:02:24 sydtest0 kernel: [764235.493567] Modules linked in: mpt2sas scsi_transport_sas raid_class dell_rbu ipmi_devintf ipmi_si ipmi_msghandler lockd 8021q mrp garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ext4 jbd2 mbcache fuse mlx4_ib ib_sa ib_mad ib_core mlx4_en igb dca i2c_algo_bit i2c_core mlx4_core ptp iTCO_wdt iTCO_vendor_support pps_core ehci_pci coretemp hwmon freq_table lpc_ich mfd_core ehci_hcd mperf sb_edac wmi dcdbas edac_core microcode sunrpc ipv6 autofs4 crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci libata megaraid_sas dm_mirror dm_region_hash dm_log dm_mod
Nov 11 07:02:24 sydtest0 kernel: [764235.493569] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764235.493569] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764235.493570] task: ffff88041dc7d4c0 ti: ffff88041dd70000 task.ti: ffff88041dd70000
Nov 11 07:02:24 sydtest0 kernel: [764235.493573] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:24 sydtest0 kernel: [764235.493574] RSP: 0018:ffff88041dd71e88  EFLAGS: 00000286
Nov 11 07:02:24 sydtest0 kernel: [764235.493575] RAX: 00000000ffffffed RBX: ffff880810f6d080 RCX: 0140000000000000
Nov 11 07:02:24 sydtest0 kernel: [764235.493576] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc2d620
Nov 11 07:02:24 sydtest0 kernel: [764235.493577] RBP: ffff88041dd71ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764235.493578] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880810f6d080
Nov 11 07:02:24 sydtest0 kernel: [764235.493578] R13: ffff88041fc32c80 R14: ffffffff81070710 R15: ffff88041dd71e18
Nov 11 07:02:24 sydtest0 kernel: [764235.493580] FS:  0000000000000000(0000) GS:ffff88041fc20000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764235.493581] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764235.493582] CR2: 00007facee9af000 CR3: 00000007f0ae3000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764235.493582] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764235.493583] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764235.493584] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764235.493588]  ffff88041dd71fd8 ffff88041dd71fd8 ffff88041dd71fd8 ffff88041dd71fd8
Nov 11 07:02:24 sydtest0 kernel: [764235.493591]  ffff88041dd71eb8 ffffffff8100aace ffff88041dd71f28 ffffffff810754be
Nov 11 07:02:24 sydtest0 kernel: [764235.493594]  ffff88041dd71ee8 ffffffff8107c92b ffff88041fc2cc40 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764235.493595] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764235.493597]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:24 sydtest0 kernel: [764235.493601]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:24 sydtest0 kernel: [764235.493603]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:24 sydtest0 kernel: [764235.493607]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:24 sydtest0 kernel: [764235.493623] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:24 sydtest0 kernel: [764238.939436] R13: 000000000000000a R14: ffff88041dd91fd8 R15: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764239.049173] FS:  0000000000000000(0000) GS:ffff88041fca0000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764239.159096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764239.268647] CR2: 000000000229e448 CR3: 000000040e8e4000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764239.379129] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764239.489240] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764239.598683] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764239.706930]  ffff88041dd91fd8 ffff88041dd91fd8 ffff88041dd91fd8 ffff88041dd91fd8
Nov 11 07:02:24 sydtest0 kernel: [764239.817334]  ffff88041dd91eb8 ffffffff8100aace ffff88041dd91f28 ffffffff810754be
Nov 11 07:02:24 sydtest0 kernel: [764239.926991]  ffff88041dd91ee8 ffffffff8107c92b ffff88041fcacc40 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764240.036915] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764240.146602]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:24 sydtest0 kernel: [764240.256765]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:24 sydtest0 kernel: [764240.366156]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:24 sydtest0 kernel: [764240.476320]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:24 sydtest0 kernel: [764240.586508] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:24 sydtest0 kernel: [764240.817165] NMI backtrace for cpu 11
Nov 11 07:02:24 sydtest0 kernel: [764240.930258] CPU: 11 PID: 0 Comm: swapper/11 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764241.045264] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764241.160939] task: ffff88041dd89530 ti: ffff88041dd92000 task.ti: ffff88041dd92000
Nov 11 07:02:24 sydtest0 kernel: [764241.275335] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:24 sydtest0 kernel: [764241.388613] RSP: 0018:ffff88041dd93e88  EFLAGS: 00000286
Nov 11 07:02:24 sydtest0 kernel: [764241.501573] RAX: 00000000ffffffed RBX: ffff88041dd93fd8 RCX: 0140000000000000
Nov 11 07:02:24 sydtest0 kernel: [764241.614772] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fcad620
Nov 11 07:02:24 sydtest0 kernel: [764241.727224] RBP: ffff88041dd93ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764241.838985] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd93fd8
Nov 11 07:02:24 sydtest0 kernel: [764241.949840] R13: 000000000000000b R14: ffff88041dd93fd8 R15: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764242.059924] FS:  0000000000000000(0000) GS:ffff88082fca0000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764242.170219] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764242.280170] CR2: 00000000017f7448 CR3: 000000039de73000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764242.391052] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764242.501589] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764242.610714] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764242.716618]  ffff88041dd93fd8 ffff88041dd93fd8 ffff88041dd93fd8 ffff88041dd93fd8
Nov 11 07:02:24 sydtest0 kernel: [764242.822283]  ffff88041dd93eb8 ffffffff8100aace ffff88041dd93f28 ffffffff810754be
Nov 11 07:02:24 sydtest0 kernel: [764242.924806]  ffff88041dd93ee8 ffffffff8107c92b ffff88082fcacc40 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764243.024241] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764243.119953]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:24 sydtest0 kernel: [764243.216060]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:24 sydtest0 kernel: [764243.311500]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:24 sydtest0 kernel: [764243.406622]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:24 sydtest0 kernel: [764243.501024] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:24 sydtest0 kernel: [764243.701065] NMI backtrace for cpu 12
Nov 11 07:02:24 sydtest0 kernel: [764243.798983] CPU: 12 PID: 0 Comm: swapper/12 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:24 sydtest0 kernel: [764243.899214] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:24 sydtest0 kernel: [764244.000353] task: ffff88041dd89c40 ti: ffff88041dd94000 task.ti: ffff88041dd94000
Nov 11 07:02:24 sydtest0 kernel: [764244.101545] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:24 sydtest0 kernel: [764244.203455] RSP: 0018:ffff88041dd95e88  EFLAGS: 00000286
Nov 11 07:02:24 sydtest0 kernel: [764244.304780] RAX: 00000000ffffffed RBX: ffff88041dd95fd8 RCX: 0140000000000000
Nov 11 07:02:24 sydtest0 kernel: [764244.407649] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fccd620
Nov 11 07:02:24 sydtest0 kernel: [764244.511476] RBP: ffff88041dd95ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764244.614797] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd95fd8
Nov 11 07:02:24 sydtest0 kernel: [764244.717453] R13: 000000000000000c R14: ffff88041dd95fd8 R15: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764244.820401] FS:  0000000000000000(0000) GS:ffff88041fcc0000(0000) knlGS:0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764244.924362] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:24 sydtest0 kernel: [764245.027470] CR2: 00007facee9af000 CR3: 000000040eaff000 CR4: 00000000000407e0
Nov 11 07:02:24 sydtest0 kernel: [764245.131431] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764245.235231] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:24 sydtest0 kernel: [764245.338179] Stack:
Nov 11 07:02:24 sydtest0 kernel: [764245.440116]  ffff88041dd95fd8 ffff88041dd95fd8 ffff88041dd95fd8 ffff88041dd95fd8
Nov 11 07:02:24 sydtest0 kernel: [764245.542746]  ffff88041dd95eb8 ffffffff8100aace ffff88041dd95f28 ffffffff810754be
Nov 11 07:02:24 sydtest0 kernel: [764245.642845]  ffff88041dd95ee8 ffffffff8107c92b ffff88041fcccc40 0000000000000000
Nov 11 07:02:24 sydtest0 kernel: [764245.741800] Call Trace:
Nov 11 07:02:24 sydtest0 kernel: [764245.839374]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:24 sydtest0 kernel: [764245.937557]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:24 sydtest0 kernel: [764246.035208]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:24 sydtest0 kernel: [764246.133791]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:24 sydtest0 kernel: [764246.232930] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:24 sydtest0 kernel: [764246.441038] NMI backtrace for cpu 13
Nov 11 07:02:27 sydtest0 kernel: [764246.542710] CPU: 13 PID: 0 Comm: swapper/13 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:27 sydtest0 kernel: [764246.646696] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:27 sydtest0 kernel: [764246.750709] task: ffff88041dd8a350 ti: ffff88041dd96000 task.ti: ffff88041dd96000
Nov 11 07:02:27 sydtest0 kernel: [764246.855281] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:27 sydtest0 kernel: [764246.961132] RSP: 0018:ffff88041dd97e88  EFLAGS: 00000286
Nov 11 07:02:27 sydtest0 kernel: [764247.066636] RAX: 00000000ffffffed RBX: ffff88041dd97fd8 RCX: 0140000000000000
Nov 11 07:02:27 sydtest0 kernel: [764247.172993] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fccd620
Nov 11 07:02:27 sydtest0 kernel: [764247.277512] RBP: ffff88041dd97ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:27 sydtest0 kernel: [764247.379822] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd97fd8
Nov 11 07:02:27 sydtest0 kernel: [764247.481945] R13: 000000000000000d R14: ffff88041dd97fd8 R15: 0000000000000000
Nov 11 07:02:27 sydtest0 kernel: [764247.583165] FS:  0000000000000000(0000) GS:ffff88082fcc0000(0000) knlGS:0000000000000000
Nov 11 07:02:27 sydtest0 kernel: [764247.684117] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:27 sydtest0 kernel: [764247.784111] CR2: 00007f2924302248 CR3: 000000078ec19000 CR4: 00000000000407e0
Nov 11 07:02:27 sydtest0 kernel: [764247.884024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:27 sydtest0 kernel: [764247.982901] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:27 sydtest0 kernel: [764248.080577] Stack:
Nov 11 07:02:27 sydtest0 kernel: [764248.177217]  ffff88041dd97fd8 ffff88041dd97fd8 ffff88041dd97fd8 ffff88041dd97fd8
Nov 11 07:02:27 sydtest0 kernel: [764248.276438]  ffff88041dd97eb8 ffffffff8100aace ffff88041dd97f28 ffffffff810754be
Nov 11 07:02:27 sydtest0 kernel: [764248.375395]  ffff88041dd97ee8 ffffffff8107c92b ffff88082fcccc40 0000000000000000
Nov 11 07:02:27 sydtest0 kernel: [764248.474217] Call Trace:
Nov 11 07:02:27 sydtest0 kernel: [764248.571657]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:27 sydtest0 kernel: [764248.669628]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:27 sydtest0 kernel: [764248.767064]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:27 sydtest0 kernel: [764248.865381]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:27 sydtest0 kernel: [764248.964256] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:27 sydtest0 kernel: [764249.171886] NMI backtrace for cpu 14
Nov 11 07:02:30 sydtest0 kernel: [764249.273344] CPU: 14 PID: 0 Comm: swapper/14 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:30 sydtest0 kernel: [764249.377091] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:30 sydtest0 kernel: [764249.480892] task: ffff88041dd8aa60 ti: ffff88041dda0000 task.ti: ffff88041dda0000
Nov 11 07:02:30 sydtest0 kernel: [764249.585197] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:30 sydtest0 kernel: [764249.690755] RSP: 0018:ffff88041dda1e88  EFLAGS: 00000286
Nov 11 07:02:30 sydtest0 kernel: [764249.795993] RAX: 00000000ffffffed RBX: ffff88041dda1fd8 RCX: 0140000000000000
Nov 11 07:02:30 sydtest0 kernel: [764249.902056] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fced620
Nov 11 07:02:30 sydtest0 kernel: [764250.006310] RBP: ffff88041dda1ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:30 sydtest0 kernel: [764250.108380] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda1fd8
Nov 11 07:02:30 sydtest0 kernel: [764250.210211] R13: 000000000000000e R14: ffff88041dda1fd8 R15: 0000000000000000
Nov 11 07:02:30 sydtest0 kernel: [764250.311163] FS:  0000000000000000(0000) GS:ffff88041fce0000(0000) knlGS:0000000000000000
Nov 11 07:02:30 sydtest0 kernel: [764250.411875] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:30 sydtest0 kernel: [764250.511576] CR2: 00000000017f7448 CR3: 00000004147ef000 CR4: 00000000000407e0
Nov 11 07:02:30 sydtest0 kernel: [764250.611249] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:30 sydtest0 kernel: [764250.709833] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:30 sydtest0 kernel: [764250.807244] Stack:
Nov 11 07:02:30 sydtest0 kernel: [764250.903591]  ffff88041dda1fd8 ffff88041dda1fd8 ffff88041dda1fd8 ffff88041dda1fd8
Nov 11 07:02:30 sydtest0 kernel: [764251.002519]  ffff88041dda1eb8 ffffffff8100aace ffff88041dda1f28 ffffffff810754be
Nov 11 07:02:30 sydtest0 kernel: [764251.101209]  ffff88041dda1ee8 ffffffff8107c92b ffff88041fcecc40 0000000000000000
Nov 11 07:02:30 sydtest0 kernel: [764251.199712] Call Trace:
Nov 11 07:02:30 sydtest0 kernel: [764251.296860]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:30 sydtest0 kernel: [764251.394590]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:30 sydtest0 kernel: [764251.491763]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:30 sydtest0 kernel: [764251.589813]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:30 sydtest0 kernel: [764251.688474] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:30 sydtest0 kernel: [764251.895678] NMI backtrace for cpu 15
Nov 11 07:02:33 sydtest0 kernel: [764251.996976] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:33 sydtest0 kernel: [764252.100642] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:33 sydtest0 kernel: [764252.204443] task: ffff88041dd8b170 ti: ffff88041dda2000 task.ti: ffff88041dda2000
Nov 11 07:02:33 sydtest0 kernel: [764252.308696] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:33 sydtest0 kernel: [764252.414227] RSP: 0018:ffff88041dda3e88  EFLAGS: 00000286
Nov 11 07:02:33 sydtest0 kernel: [764252.519386] RAX: 00000000ffffffed RBX: ffff88041dda3fd8 RCX: 0140000000000000
Nov 11 07:02:33 sydtest0 kernel: [764252.625396] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fced620
Nov 11 07:02:33 sydtest0 kernel: [764252.729516] RBP: ffff88041dda3ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:33 sydtest0 kernel: [764252.831373] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda3fd8
Nov 11 07:02:33 sydtest0 kernel: [764252.933097] R13: 000000000000000f R14: ffff88041dda3fd8 R15: 0000000000000000
Nov 11 07:02:33 sydtest0 kernel: [764253.033916] FS:  0000000000000000(0000) GS:ffff88082fce0000(0000) knlGS:0000000000000000
Nov 11 07:02:33 sydtest0 kernel: [764253.134521] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:33 sydtest0 kernel: [764253.234169] CR2: 00000000009ff448 CR3: 000000040d792000 CR4: 00000000000407e0
Nov 11 07:02:33 sydtest0 kernel: [764253.333763] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:33 sydtest0 kernel: [764253.432159] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:33 sydtest0 kernel: [764253.529357] Stack:
Nov 11 07:02:33 sydtest0 kernel: [764253.625464]  ffff88041dda3fd8 ffff88041dda3fd8 ffff88041dda3fd8 ffff88041dda3fd8
Nov 11 07:02:33 sydtest0 kernel: [764253.724180]  ffff88041dda3eb8 ffffffff8100aace ffff88041dda3f28 ffffffff810754be
Nov 11 07:02:33 sydtest0 kernel: [764253.822683]  ffff88041dda3ee8 ffffffff8107c92b ffff88082fcecc40 0000000000000000
Nov 11 07:02:33 sydtest0 kernel: [764253.921026] Call Trace:
Nov 11 07:02:33 sydtest0 kernel: [764254.018040]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:33 sydtest0 kernel: [764254.115690]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:33 sydtest0 kernel: [764254.212889]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:33 sydtest0 kernel: [764254.310912]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:33 sydtest0 kernel: [764254.409493] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:33 sydtest0 kernel: [764254.616562] NMI backtrace for cpu 16
Nov 11 07:02:40 sydtest0 kernel: [764254.717726] CPU: 16 PID: 0 Comm: swapper/16 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:40 sydtest0 kernel: [764254.821180] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:40 sydtest0 kernel: [764254.924715] task: ffff88041dd8b880 ti: ffff88041dda4000 task.ti: ffff88041dda4000
Nov 11 07:02:40 sydtest0 kernel: [764255.028809] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:40 sydtest0 kernel: [764255.134180] RSP: 0018:ffff88041dda5e88  EFLAGS: 00000286
Nov 11 07:02:40 sydtest0 kernel: [764255.239205] RAX: 00000000ffffffed RBX: ffff88041dda5fd8 RCX: 0140000000000000
Nov 11 07:02:40 sydtest0 kernel: [764255.345083] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd0d620
Nov 11 07:02:40 sydtest0 kernel: [764255.449097] RBP: ffff88041dda5ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:40 sydtest0 kernel: [764255.550821] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda5fd8
Nov 11 07:02:40 sydtest0 kernel: [764255.652385] R13: 0000000000000010 R14: ffff88041dda5fd8 R15: 0000000000000000
Nov 11 07:02:40 sydtest0 kernel: [764255.753045] FS:  0000000000000000(0000) GS:ffff88041fd00000(0000) knlGS:0000000000000000
Nov 11 07:02:40 sydtest0 kernel: [764255.853438] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:40 sydtest0 kernel: [764255.952845] CR2: 0000003b0de16c4c CR3: 0000000787468000 CR4: 00000000000407e0
Nov 11 07:02:40 sydtest0 kernel: [764256.052306] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:40 sydtest0 kernel: [764256.082170] ------------[ cut here ]------------
Nov 11 07:02:40 sydtest0 kernel: [764256.082174] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x257/0x260()
Nov 11 07:02:40 sydtest0 kernel: [764256.082175] NETDEV WATCHDOG: eth0 (igb): transmit queue 0 timed out
Nov 11 07:02:40 sydtest0 kernel: [764256.082195] Modules linked in: mpt2sas scsi_transport_sas raid_class dell_rbu ipmi_devintf ipmi_si ipmi_msghandler lockd 8021q mrp garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ext4 jbd2 mbcache fuse mlx4_ib ib_sa ib_mad ib_core mlx4_en igb dca i2c_algo_bit i2c_core mlx4_core ptp iTCO_wdt iTCO_vendor_support pps_core ehci_pci coretemp hwmon freq_table lpc_ich mfd_core ehci_hcd mperf sb_edac wmi dcdbas edac_core microcode sunrpc ipv6 autofs4 crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci libata megaraid_sas dm_mirror dm_region_hash dm_log dm_mod
Nov 11 07:02:40 sydtest0 kernel: [764256.082196] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:40 sydtest0 kernel: [764256.082197] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:40 sydtest0 kernel: [764256.082201]  ffffffff817ef330 ffff88041fc03d00 ffffffff814b500e ffff88041fc03d40
Nov 11 07:02:40 sydtest0 kernel: [764256.082204]  ffffffff8103b390 0000000000000001 ffff880413b26000 ffff8804139e08c0
Nov 11 07:02:40 sydtest0 kernel: [764256.082206]  0000000000000008 0000000000000000 ffffffff81a01fd8 ffff88041fc03da0
Nov 11 07:02:40 sydtest0 kernel: [764256.082206] Call Trace:
Nov 11 07:02:40 sydtest0 kernel: [764256.082211]  <IRQ>  [<ffffffff814b500e>] dump_stack+0x19/0x1b
Nov 11 07:02:40 sydtest0 kernel: [764256.082214]  [<ffffffff8103b390>] warn_slowpath_common+0x70/0xa0
Nov 11 07:02:40 sydtest0 kernel: [764256.082215]  [<ffffffff8103b476>] warn_slowpath_fmt+0x46/0x50
Nov 11 07:02:40 sydtest0 kernel: [764256.082217]  [<ffffffff81071a1c>] ? load_balance+0xfc/0x6e0
Nov 11 07:02:40 sydtest0 kernel: [764256.082220]  [<ffffffff8142b217>] dev_watchdog+0x257/0x260
Nov 11 07:02:40 sydtest0 kernel: [764256.082222]  [<ffffffff8142afc0>] ? pfifo_fast_dequeue+0xe0/0xe0
Nov 11 07:02:40 sydtest0 kernel: [764256.082225]  [<ffffffff810493cb>] call_timer_fn+0x3b/0x150
Nov 11 07:02:40 sydtest0 kernel: [764256.082227]  [<ffffffff8104ab9d>] run_timer_softirq+0x22d/0x260
Nov 11 07:02:40 sydtest0 kernel: [764256.082229]  [<ffffffff812667a4>] ? timerqueue_add+0x64/0xb0
Nov 11 07:02:40 sydtest0 kernel: [764256.082231]  [<ffffffff8142afc0>] ? pfifo_fast_dequeue+0xe0/0xe0
Nov 11 07:02:40 sydtest0 kernel: [764256.082234]  [<ffffffff81043158>] __do_softirq+0xd8/0x280
Nov 11 07:02:40 sydtest0 kernel: [764256.082236]  [<ffffffff8107e524>] ? tick_program_event+0x24/0x30
Nov 11 07:02:40 sydtest0 kernel: [764256.082240]  [<ffffffff81062c31>] ? hrtimer_interrupt+0x141/0x240
Nov 11 07:02:40 sydtest0 kernel: [764256.082243]  [<ffffffff814c333c>] call_softirq+0x1c/0x30
Nov 11 07:02:40 sydtest0 kernel: [764256.082245]  [<ffffffff81004105>] do_softirq+0x55/0x90
Nov 11 07:02:40 sydtest0 kernel: [764256.082247]  [<ffffffff81043435>] irq_exit+0x65/0x70
Nov 11 07:02:40 sydtest0 kernel: [764256.082249]  [<ffffffff814c394e>] smp_apic_timer_interrupt+0x6e/0x99
Nov 11 07:02:40 sydtest0 kernel: [764256.082251]  [<ffffffff814c2cca>] apic_timer_interrupt+0x6a/0x70
Nov 11 07:02:40 sydtest0 kernel: [764256.082254]  <EOI>  [<ffffffff8100a300>] ? default_idle+0x20/0xe0
Nov 11 07:02:40 sydtest0 kernel: [764256.082256]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:40 sydtest0 kernel: [764256.082258]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:40 sydtest0 kernel: [764256.082260]  [<ffffffff814ac087>] rest_init+0x77/0x80
Nov 11 07:02:40 sydtest0 kernel: [764256.082262]  [<ffffffff81adae53>] start_kernel+0x3c9/0x3d6
Nov 11 07:02:40 sydtest0 kernel: [764256.082264]  [<ffffffff81ada88a>] ? repair_env_string+0x5a/0x5a
Nov 11 07:02:40 sydtest0 kernel: [764256.082266]  [<ffffffff81ada5a8>] x86_64_start_reservations+0x2a/0x2c
Nov 11 07:02:40 sydtest0 kernel: [764256.082267]  [<ffffffff81ada68f>] x86_64_start_kernel+0xe5/0xec
Nov 11 07:02:40 sydtest0 kernel: [764256.082268] ---[ end trace 9253e32ca117b8c5 ]---
Nov 11 07:02:40 sydtest0 kernel: [764256.082296] igb 0000:01:00.0 eth0: Reset adapter
Nov 11 07:02:40 sydtest0 kernel: [764260.067129] igb 0000:01:00.0 eth0: Reset adapter
Nov 11 07:02:40 sydtest0 kernel: [764260.569180] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:40 sydtest0 kernel: [764260.666590] Stack:
Nov 11 07:02:40 sydtest0 kernel: [764260.763228]  ffff88041dda5fd8 ffff88041dda5fd8 ffff88041dda5fd8 ffff88041dda5fd8
Nov 11 07:02:40 sydtest0 kernel: [764260.862290]  ffff88041dda5eb8 ffffffff8100aace ffff88041dda5f28 ffffffff810754be
Nov 11 07:02:40 sydtest0 kernel: [764260.960845]  ffff88041dda5ee8 ffffffff8107c92b ffff88041fd0cc40 0000000000000000
Nov 11 07:02:40 sydtest0 kernel: [764261.057112] Call Trace:
Nov 11 07:02:40 sydtest0 kernel: [764261.150214]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:40 sydtest0 kernel: [764261.244244]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:40 sydtest0 kernel: [764261.337395]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:40 sydtest0 kernel: [764261.430174]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:40 sydtest0 kernel: [764261.522072] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:40 sydtest0 kernel: [764261.715273] NMI backtrace for cpu 17
Nov 11 07:02:40 sydtest0 ptpd[14045]: resetting system clock to 1384174912s 642038338ns
Nov 11 07:02:40 sydtest0 ptpd[14045]: clock stepped, off by 0.131600 seconds
Nov 11 07:02:46 sydtest0 kernel: [764261.808792] CPU: 17 PID: 0 Comm: swapper/17 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:46 sydtest0 kernel: [764261.904605] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:46 sydtest0 kernel: [764262.001193] task: ffff88041dd8bf90 ti: ffff88041dda6000 task.ti: ffff88041dda6000
Nov 11 07:02:46 sydtest0 kernel: [764262.098524] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:46 sydtest0 kernel: [764262.197026] RSP: 0018:ffff88041dda7e88  EFLAGS: 00000286
Nov 11 07:02:46 sydtest0 kernel: [764262.294996] RAX: 00000000ffffffed RBX: ffff88041dda7fd8 RCX: 0140000000000000
Nov 11 07:02:46 sydtest0 kernel: [764262.393525] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd0d620
Nov 11 07:02:46 sydtest0 kernel: [764262.491657] RBP: ffff88041dda7ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764262.590106] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda7fd8
Nov 11 07:02:46 sydtest0 kernel: [764262.687863] R13: 0000000000000011 R14: ffff88041dda7fd8 R15: 0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764262.785008] FS:  0000000000000000(0000) GS:ffff88082fd00000(0000) knlGS:0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764262.882207] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:46 sydtest0 kernel: [764262.976743] CR2: 00007f3d7be33000 CR3: 00000007945d1000 CR4: 00000000000407e0
Nov 11 07:02:46 sydtest0 kernel: [764263.069416] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764263.158893] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:46 sydtest0 kernel: [764263.244777] Stack:
Nov 11 07:02:46 sydtest0 kernel: [764263.326987]  ffff88041dda7fd8 ffff88041dda7fd8 ffff88041dda7fd8 ffff88041dda7fd8
Nov 11 07:02:46 sydtest0 kernel: [764263.411061]  ffff88041dda7eb8 ffffffff8100aace ffff88041dda7f28 ffffffff810754be
Nov 11 07:02:46 sydtest0 kernel: [764263.473039] BUG: soft lockup - CPU#2 stuck for 22s! [swapper/2:0]
Nov 11 07:02:46 sydtest0 kernel: [764263.473061] Modules linked in: mpt2sas scsi_transport_sas raid_class dell_rbu ipmi_devintf ipmi_si ipmi_msghandler lockd 8021q mrp garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ext4 jbd2 mbcache fuse mlx4_ib ib_sa ib_mad ib_core mlx4_en igb dca i2c_algo_bit i2c_core mlx4_core ptp iTCO_wdt iTCO_vendor_support pps_core ehci_pci coretemp hwmon freq_table lpc_ich mfd_core ehci_hcd mperf sb_edac wmi dcdbas edac_core microcode sunrpc ipv6 autofs4 crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci libata megaraid_sas dm_mirror dm_region_hash dm_log dm_mod
Nov 11 07:02:46 sydtest0 kernel: [764263.473062] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:46 sydtest0 kernel: [764263.473063] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:46 sydtest0 kernel: [764263.473064] task: ffff88041dc7d4c0 ti: ffff88041dd70000 task.ti: ffff88041dd70000
Nov 11 07:02:46 sydtest0 kernel: [764263.473066] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:46 sydtest0 kernel: [764263.473067] RSP: 0018:ffff88041dd71e88  EFLAGS: 00000286
Nov 11 07:02:46 sydtest0 kernel: [764263.473068] RAX: 00000000ffffffed RBX: ffff88081b610000 RCX: 0140000000000000
Nov 11 07:02:46 sydtest0 kernel: [764263.473068] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc2d620
Nov 11 07:02:46 sydtest0 kernel: [764263.473069] RBP: ffff88041dd71ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764263.473070] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88081b610000
Nov 11 07:02:46 sydtest0 kernel: [764263.473071] R13: ffff88041fc32c80 R14: ffffffff81070710 R15: ffff88041dd71e18
Nov 11 07:02:46 sydtest0 kernel: [764263.473072] FS:  0000000000000000(0000) GS:ffff88041fc20000(0000) knlGS:0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764263.473073] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:46 sydtest0 kernel: [764263.473074] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:02:46 sydtest0 kernel: [764263.473075] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764263.473075] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:46 sydtest0 kernel: [764263.473076] Stack:
Nov 11 07:02:46 sydtest0 kernel: [764263.473079]  ffff88041dd71fd8 ffff88041dd71fd8 ffff88041dd71fd8 ffff88041dd71fd8
Nov 11 07:02:46 sydtest0 kernel: [764263.473082]  ffff88041dd71eb8 ffffffff8100aace ffff88041dd71f28 ffffffff810754be
Nov 11 07:02:46 sydtest0 kernel: [764263.473085]  ffff88041dd71ee8 ffffffff8107c92b ffff88041fc2cc40 0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764263.473086] Call Trace:
Nov 11 07:02:46 sydtest0 kernel: [764263.473088]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:46 sydtest0 kernel: [764263.473090]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:46 sydtest0 kernel: [764263.473092]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:46 sydtest0 kernel: [764263.473095]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:46 sydtest0 kernel: [764263.473110] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:46 sydtest0 kernel: [764266.620046]  ffff88041dda7ee8 ffffffff8107c92b ffff88082fd0cc40 0000000000000000
Nov 11 07:02:46 sydtest0 kernel: [764266.731726] Call Trace:
Nov 11 07:02:46 sydtest0 kernel: [764266.841998]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:46 sydtest0 kernel: [764266.952747]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:46 sydtest0 kernel: [764267.062749]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:46 sydtest0 kernel: [764267.173552]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:46 sydtest0 kernel: [764267.284486] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:46 sydtest0 kernel: [764267.516580] NMI backtrace for cpu 18
Nov 11 07:02:49 sydtest0 kernel: [764267.630498] CPU: 18 PID: 0 Comm: swapper/18 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:49 sydtest0 kernel: [764267.674440] mlx4_en: eth4:   frag:0 - size:512 prefix:0 align:0 stride:512
Nov 11 07:02:49 sydtest0 kernel: [764267.674441] mlx4_en: eth4:   frag:1 - size:1014 prefix:512 align:0 stride:1024
Nov 11 07:02:49 sydtest0 kernel: [764267.977442] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:49 sydtest0 kernel: [764268.090401] task: ffff88041dd8c6a0 ti: ffff88041dda8000 task.ti: ffff88041dda8000
Nov 11 07:02:49 sydtest0 kernel: [764268.191464] mlx4_en: eth4: Link Down
Nov 11 07:02:49 sydtest0 kernel: [764268.316186] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:49 sydtest0 kernel: [764268.429704] RSP: 0018:ffff88041dda9e88  EFLAGS: 00000286
Nov 11 07:02:49 sydtest0 kernel: [764268.542317] RAX: 00000000ffffffed RBX: ffff88041dda9fd8 RCX: 0140000000000000
Nov 11 07:02:49 sydtest0 kernel: [764268.655115] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd2d620
Nov 11 07:02:49 sydtest0 kernel: [764268.767382] RBP: ffff88041dda9ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:49 sydtest0 kernel: [764268.879223] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda9fd8
Nov 11 07:02:49 sydtest0 kernel: [764268.990957] R13: 0000000000000012 R14: ffff88041dda9fd8 R15: 0000000000000000
Nov 11 07:02:49 sydtest0 kernel: [764269.102691] FS:  0000000000000000(0000) GS:ffff88041fd20000(0000) knlGS:0000000000000000
Nov 11 07:02:49 sydtest0 kernel: [764269.215169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:49 sydtest0 kernel: [764269.327488] CR2: 00007fb1a3d9c050 CR3: 0000000399f1f000 CR4: 00000000000407e0
Nov 11 07:02:49 sydtest0 kernel: [764269.440393] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:49 sydtest0 kernel: [764269.552554] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:49 sydtest0 kernel: [764269.663489] Stack:
Nov 11 07:02:49 sydtest0 kernel: [764269.773812]  ffff88041dda9fd8 ffff88041dda9fd8 ffff88041dda9fd8 ffff88041dda9fd8
Nov 11 07:02:49 sydtest0 kernel: [764269.887436]  ffff88041dda9eb8 ffffffff8100aace ffff88041dda9f28 ffffffff810754be
Nov 11 07:02:49 sydtest0 kernel: [764270.000154]  ffff88041dda9ee8 ffffffff8107c92b ffff88041fd2cc40 0000000000000000
Nov 11 07:02:49 sydtest0 kernel: [764270.111941] Call Trace:
Nov 11 07:02:49 sydtest0 kernel: [764270.176936] mlx4_en: eth4: Link Up
Nov 11 07:02:49 sydtest0 kernel: [764270.333122]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:49 sydtest0 kernel: [764270.441767]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:49 sydtest0 kernel: [764270.546206] mlx4_en: eth4: Link Down
Nov 11 07:02:49 sydtest0 kernel: [764270.650167]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:49 sydtest0 kernel: [764270.751546]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:49 sydtest0 kernel: [764270.849994] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:49 sydtest0 kernel: [764271.056372] NMI backtrace for cpu 19
Nov 11 07:02:52 sydtest0 kernel: [764271.156211] CPU: 19 PID: 0 Comm: swapper/19 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:52 sydtest0 kernel: [764271.257826] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:52 sydtest0 kernel: [764271.359817] task: ffff88041dd8cdb0 ti: ffff88041ddaa000 task.ti: ffff88041ddaa000
Nov 11 07:02:52 sydtest0 kernel: [764271.462607] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:52 sydtest0 kernel: [764271.566620] RSP: 0018:ffff88041ddabe88  EFLAGS: 00000286
Nov 11 07:02:52 sydtest0 kernel: [764271.670634] RAX: 00000000ffffffed RBX: ffff88041ddabfd8 RCX: 0140000000000000
Nov 11 07:02:52 sydtest0 kernel: [764271.724022] mlx4_en: eth4: Link Up
Nov 11 07:02:52 sydtest0 kernel: [764271.879752] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd2d620
Nov 11 07:02:52 sydtest0 kernel: [764271.985151] RBP: ffff88041ddabea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:52 sydtest0 kernel: [764272.090229] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddabfd8
Nov 11 07:02:52 sydtest0 kernel: [764272.195867] R13: 0000000000000013 R14: ffff88041ddabfd8 R15: 0000000000000000
Nov 11 07:02:52 sydtest0 kernel: [764272.302304] FS:  0000000000000000(0000) GS:ffff88082fd20000(0000) knlGS:0000000000000000
Nov 11 07:02:52 sydtest0 kernel: [764272.408900] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:52 sydtest0 kernel: [764272.514617] CR2: 0000003b0de16c4c CR3: 00000007eae6f000 CR4: 00000000000407e0
Nov 11 07:02:52 sydtest0 kernel: [764272.621665] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:52 sydtest0 kernel: [764272.728715] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:52 sydtest0 kernel: [764272.834379] Stack:
Nov 11 07:02:52 sydtest0 kernel: [764272.939059]  ffff88041ddabfd8 ffff88041ddabfd8 ffff88041ddabfd8 ffff88041ddabfd8
Nov 11 07:02:52 sydtest0 kernel: [764273.046559]  ffff88041ddabeb8 ffffffff8100aace ffff88041ddabf28 ffffffff810754be
Nov 11 07:02:52 sydtest0 kernel: [764273.153714]  ffff88041ddabee8 ffffffff8107c92b ffff88082fd2cc40 0000000000000000
Nov 11 07:02:52 sydtest0 kernel: [764273.260604] Call Trace:
Nov 11 07:02:52 sydtest0 kernel: [764273.364567]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:52 sydtest0 kernel: [764273.467382]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:52 sydtest0 kernel: [764273.569131]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:52 sydtest0 kernel: [764273.670644]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:52 sydtest0 kernel: [764273.771833] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:52 sydtest0 kernel: [764273.986251] NMI backtrace for cpu 20
Nov 11 07:02:55 sydtest0 kernel: [764274.090930] CPU: 20 PID: 0 Comm: swapper/20 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:55 sydtest0 kernel: [764274.196035] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:55 sydtest0 kernel: [764274.299596] task: ffff88041dd8d4c0 ti: ffff88041ddac000 task.ti: ffff88041ddac000
Nov 11 07:02:55 sydtest0 kernel: [764274.403716] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:55 sydtest0 kernel: [764274.508102] RSP: 0018:ffff88041ddade88  EFLAGS: 00000286
Nov 11 07:02:55 sydtest0 kernel: [764274.611264] RAX: 00000000ffffffed RBX: ffff88041ddadfd8 RCX: 0140000000000000
Nov 11 07:02:55 sydtest0 kernel: [764274.715624] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd4d620
Nov 11 07:02:55 sydtest0 kernel: [764274.819371] RBP: ffff88041ddadea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:55 sydtest0 kernel: [764274.922372] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddadfd8
Nov 11 07:02:55 sydtest0 kernel: [764275.024576] R13: 0000000000000014 R14: ffff88041ddadfd8 R15: 0000000000000000
Nov 11 07:02:55 sydtest0 kernel: [764275.125769] FS:  0000000000000000(0000) GS:ffff88041fd40000(0000) knlGS:0000000000000000
Nov 11 07:02:55 sydtest0 kernel: [764275.226907] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:55 sydtest0 kernel: [764275.327326] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:02:55 sydtest0 kernel: [764275.428464] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:55 sydtest0 kernel: [764275.529124] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:55 sydtest0 kernel: [764275.629037] Stack:
Nov 11 07:02:55 sydtest0 kernel: [764275.728020]  ffff88041ddadfd8 ffff88041ddadfd8 ffff88041ddadfd8 ffff88041ddadfd8
Nov 11 07:02:55 sydtest0 kernel: [764275.829158]  ffff88041ddadeb8 ffffffff8100aace ffff88041ddadf28 ffffffff810754be
Nov 11 07:02:55 sydtest0 kernel: [764275.929499]  ffff88041ddadee8 ffffffff8107c92b ffff88041fd4cc40 0000000000000000
Nov 11 07:02:55 sydtest0 kernel: [764276.029013] Call Trace:
Nov 11 07:02:55 sydtest0 kernel: [764276.127838]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:55 sydtest0 kernel: [764276.228444]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:55 sydtest0 kernel: [764276.328357]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:55 sydtest0 kernel: [764276.428005]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:55 sydtest0 kernel: [764276.527704] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:55 sydtest0 kernel: [764276.738554] NMI backtrace for cpu 21
Nov 11 07:02:58 sydtest0 kernel: [764276.841824] CPU: 21 PID: 0 Comm: swapper/21 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:02:58 sydtest0 kernel: [764276.947246] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:02:58 sydtest0 kernel: [764277.053523] task: ffff88041dd8dbd0 ti: ffff88041ddae000 task.ti: ffff88041ddae000
Nov 11 07:02:58 sydtest0 kernel: [764277.160226] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:02:58 sydtest0 kernel: [764277.267354] RSP: 0018:ffff88041ddafe88  EFLAGS: 00000286
Nov 11 07:02:58 sydtest0 kernel: [764277.374111] RAX: 00000000ffffffed RBX: ffff88041ddaffd8 RCX: 0140000000000000
Nov 11 07:02:58 sydtest0 kernel: [764277.479909] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd4d620
Nov 11 07:02:58 sydtest0 kernel: [764277.583628] RBP: ffff88041ddafea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:02:58 sydtest0 kernel: [764277.687216] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddaffd8
Nov 11 07:02:58 sydtest0 kernel: [764277.789978] R13: 0000000000000015 R14: ffff88041ddaffd8 R15: 0000000000000000
Nov 11 07:02:58 sydtest0 kernel: [764277.891595] FS:  0000000000000000(0000) GS:ffff88082fd40000(0000) knlGS:0000000000000000
Nov 11 07:02:58 sydtest0 kernel: [764277.993212] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:02:58 sydtest0 kernel: [764278.093711] CR2: 0000003b0de7b160 CR3: 000000080c727000 CR4: 00000000000407e0
Nov 11 07:02:58 sydtest0 kernel: [764278.194424] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:02:58 sydtest0 kernel: [764278.294259] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:02:58 sydtest0 kernel: [764278.392654] Stack:
Nov 11 07:02:58 sydtest0 kernel: [764278.489427]  ffff88041ddaffd8 ffff88041ddaffd8 ffff88041ddaffd8 ffff88041ddaffd8
Nov 11 07:02:58 sydtest0 kernel: [764278.588836]  ffff88041ddafeb8 ffffffff8100aace ffff88041ddaff28 ffffffff810754be
Nov 11 07:02:58 sydtest0 kernel: [764278.687952]  ffff88041ddafee8 ffffffff8107c92b ffff88082fd4cc40 0000000000000000
Nov 11 07:02:58 sydtest0 kernel: [764278.786908] Call Trace:
Nov 11 07:02:58 sydtest0 kernel: [764278.884456]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:02:58 sydtest0 kernel: [764278.982612]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:02:58 sydtest0 kernel: [764279.080209]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:02:58 sydtest0 kernel: [764279.178686]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:02:58 sydtest0 kernel: [764279.277774] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:02:58 sydtest0 kernel: [764279.485829] NMI backtrace for cpu 23
Nov 11 07:03:00 sydtest0 kernel: [764279.587530] CPU: 23 PID: 0 Comm: swapper/23 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:00 sydtest0 kernel: [764279.691807] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:00 sydtest0 kernel: [764279.796088] task: ffff88041dd8e9f0 ti: ffff88041ddbc000 task.ti: ffff88041ddbc000
Nov 11 07:03:00 sydtest0 kernel: [764279.900900] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:00 sydtest0 kernel: [764280.007018] RSP: 0018:ffff88041ddbde88  EFLAGS: 00000286
Nov 11 07:03:00 sydtest0 kernel: [764280.112815] RAX: 00000000ffffffed RBX: ffff88041ddbdfd8 RCX: 0140000000000000
Nov 11 07:03:00 sydtest0 kernel: [764280.219439] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd6d620
Nov 11 07:03:00 sydtest0 kernel: [764280.324198] RBP: ffff88041ddbdea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:00 sydtest0 kernel: [764280.426748] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddbdfd8
Nov 11 07:03:00 sydtest0 kernel: [764280.529085] R13: 0000000000000017 R14: ffff88041ddbdfd8 R15: 0000000000000000
Nov 11 07:03:00 sydtest0 kernel: [764280.630489] FS:  0000000000000000(0000) GS:ffff88082fd60000(0000) knlGS:0000000000000000
Nov 11 07:03:00 sydtest0 kernel: [764280.731494] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:00 sydtest0 kernel: [764280.831541] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:03:00 sydtest0 kernel: [764280.931508] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:00 sydtest0 kernel: [764281.030303] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:00 sydtest0 kernel: [764281.127873] Stack:
Nov 11 07:03:00 sydtest0 kernel: [764281.224406]  ffff88041ddbdfd8 ffff88041ddbdfd8 ffff88041ddbdfd8 ffff88041ddbdfd8
Nov 11 07:03:00 sydtest0 kernel: [764281.323547]  ffff88041ddbdeb8 ffffffff8100aace ffff88041ddbdf28 ffffffff810754be
Nov 11 07:03:00 sydtest0 kernel: [764281.422475]  ffff88041ddbdee8 ffffffff8107c92b ffff88082fd6cc40 0000000000000000
Nov 11 07:03:00 sydtest0 kernel: [764281.521244] Call Trace:
Nov 11 07:03:00 sydtest0 kernel: [764281.618659]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:00 sydtest0 kernel: [764281.716682]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:00 sydtest0 kernel: [764281.814226]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:00 sydtest0 kernel: [764281.912730]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:00 sydtest0 kernel: [764282.011814] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:00 sydtest0 kernel: [764282.220027] NMI backtrace for cpu 24
Nov 11 07:03:07 sydtest0 kernel: [764282.321806] CPU: 24 PID: 0 Comm: swapper/24 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:07 sydtest0 kernel: [764282.426270] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:07 sydtest0 kernel: [764282.530711] task: ffff88041dd8f100 ti: ffff88041ddbe000 task.ti: ffff88041ddbe000
Nov 11 07:03:07 sydtest0 kernel: [764282.635709] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:07 sydtest0 kernel: [764282.741933] RSP: 0018:ffff88041ddbfe88  EFLAGS: 00000286
Nov 11 07:03:07 sydtest0 kernel: [764282.847837] RAX: 00000000ffffffed RBX: ffff88041ddbffd8 RCX: 0140000000000000
Nov 11 07:03:07 sydtest0 kernel: [764282.954592] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd8d620
Nov 11 07:03:07 sydtest0 kernel: [764283.059538] RBP: ffff88041ddbfea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764283.162273] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddbffd8
Nov 11 07:03:07 sydtest0 kernel: [764283.264876] R13: 0000000000000018 R14: ffff88041ddbffd8 R15: 0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764283.366574] FS:  0000000000000000(0000) GS:ffff88041fd80000(0000) knlGS:0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764283.392122] BUG: soft lockup - CPU#0 stuck for 22s! [ptpd:14045]
Nov 11 07:03:07 sydtest0 kernel: [764283.392148] Modules linked in: mpt2sas scsi_transport_sas raid_class dell_rbu ipmi_devintf ipmi_si ipmi_msghandler lockd 8021q mrp garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ext4 jbd2 mbcache fuse mlx4_ib ib_sa ib_mad ib_core mlx4_en igb dca i2c_algo_bit i2c_core mlx4_core ptp iTCO_wdt iTCO_vendor_support pps_core ehci_pci coretemp hwmon freq_table lpc_ich mfd_core ehci_hcd mperf sb_edac wmi dcdbas edac_core microcode sunrpc ipv6 autofs4 crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci libata megaraid_sas dm_mirror dm_region_hash dm_log dm_mod
Nov 11 07:03:07 sydtest0 kernel: [764283.392150] CPU: 0 PID: 14045 Comm: ptpd Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:07 sydtest0 kernel: [764283.392150] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:07 sydtest0 kernel: [764283.392151] task: ffff8808105d62e0 ti: ffff8807d0afa000 task.ti: ffff8807d0afa000
Nov 11 07:03:07 sydtest0 kernel: [764283.392155] RIP: 0010:[<ffffffff81083502>]  [<ffffffff81083502>] smp_call_function_many+0x272/0x2d0
Nov 11 07:03:07 sydtest0 kernel: [764283.392156] RSP: 0018:ffff8807d0afbdf8  EFLAGS: 00000202
Nov 11 07:03:07 sydtest0 kernel: [764283.392156] RAX: 0000000000000018 RBX: ffffffff81abcf00 RCX: ffff88041fd95d48
Nov 11 07:03:07 sydtest0 kernel: [764283.392157] RDX: 0000000000000018 RSI: 0000000000000100 RDI: 0000000000000100
Nov 11 07:03:07 sydtest0 kernel: [764283.392157] RBP: ffff8807d0afbe58 R08: ffff88041fc13648 R09: 0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764283.392158] R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000296
Nov 11 07:03:07 sydtest0 kernel: [764283.392158] R13: 000000000000002c R14: 00007fffee4934a0 R15: 0000000000000040
Nov 11 07:03:07 sydtest0 kernel: [764283.392159] FS:  00007fc28c07a700(0000) GS:ffff88041fc00000(0000) knlGS:0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764283.392160] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:07 sydtest0 kernel: [764283.392160] CR2: 0000003b0de7b160 CR3: 00000007f0ae3000 CR4: 00000000000407f0
Nov 11 07:03:07 sydtest0 kernel: [764283.392161] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764283.392162] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:07 sydtest0 kernel: [764283.392162] Stack:
Nov 11 07:03:07 sydtest0 kernel: [764283.392165]  ffff88082fdf3610 ffff88082fdf3600 ffff88082fdf5d48 ffffffff0000001f
Nov 11 07:03:07 sydtest0 kernel: [764283.392167]  01ff8807d0afbe48 ffff88041fc13668 ffff88080beaf400 ffffffff81062480
Nov 11 07:03:07 sydtest0 kernel: [764283.392169]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764283.392169] Call Trace:
Nov 11 07:03:07 sydtest0 kernel: [764283.392173]  [<ffffffff81062480>] ? hrtimer_cancel+0x30/0x30
Nov 11 07:03:07 sydtest0 kernel: [764283.392175]  [<ffffffff810835e2>] smp_call_function+0x22/0x30
Nov 11 07:03:07 sydtest0 kernel: [764283.392176]  [<ffffffff81083648>] on_each_cpu+0x28/0x50
Nov 11 07:03:07 sydtest0 kernel: [764283.392178]  [<ffffffff8106272c>] clock_was_set+0x1c/0x30
Nov 11 07:03:07 sydtest0 kernel: [764283.392180]  [<ffffffff8107701e>] do_settimeofday+0xfe/0x110
Nov 11 07:03:07 sydtest0 kernel: [764283.392183]  [<ffffffff8104244d>] do_sys_settimeofday+0xdd/0xf0
Nov 11 07:03:07 sydtest0 kernel: [764283.392186]  [<ffffffff813f6fe9>] ? __sys_recvmsg+0x49/0x90
Nov 11 07:03:07 sydtest0 kernel: [764283.392187]  [<ffffffff8105d513>] posix_clock_realtime_set+0x13/0x20
Nov 11 07:03:07 sydtest0 kernel: [764283.392189]  [<ffffffff8105e55f>] SyS_clock_settime+0x5f/0x90
Nov 11 07:03:07 sydtest0 kernel: [764283.392192]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 11 07:03:07 sydtest0 kernel: [764283.392202] Code: 15 c1 1e 00 3b 05 f7 9a a3 00 0f 8d 15 fe ff ff 48 63 d0 49 8b 0c 24 48 03 0c d5 e0 b3 ab 81 f6 41 20 01 74 cc f3 90 f6 41 20 01 <74> c4 eb f6 0f b6 4d c7 4c 89 f2 4c 89 ee 89 df e8 29 fb ff ff 
Nov 11 07:03:07 sydtest0 kernel: [764287.552862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:07 sydtest0 kernel: [764287.659937] CR2: 0000003b0debd790 CR3: 000000040d931000 CR4: 00000000000407e0
Nov 11 07:03:07 sydtest0 kernel: [764287.768398] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764287.877204] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:07 sydtest0 kernel: [764287.984677] Stack:
Nov 11 07:03:07 sydtest0 kernel: [764288.090501]  ffff88041ddbffd8 ffff88041ddbffd8 ffff88041ddbffd8 ffff88041ddbffd8
Nov 11 07:03:07 sydtest0 kernel: [764288.199253]  ffff88041ddbfeb8 ffffffff8100aace ffff88041ddbff28 ffffffff810754be
Nov 11 07:03:07 sydtest0 kernel: [764288.307951]  ffff88041ddbfee8 ffffffff8107c92b ffff88041fd8cc40 0000000000000000
Nov 11 07:03:07 sydtest0 kernel: [764288.415639] Call Trace:
Nov 11 07:03:07 sydtest0 kernel: [764288.522159]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:07 sydtest0 kernel: [764288.629953]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:07 sydtest0 kernel: [764288.737506]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:07 sydtest0 kernel: [764288.845407]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:07 sydtest0 kernel: [764288.951122] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:07 sydtest0 kernel: [764289.169905] NMI backtrace for cpu 25
Nov 11 07:03:10 sydtest0 kernel: [764289.276133] CPU: 25 PID: 0 Comm: swapper/25 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:10 sydtest0 kernel: [764289.383686] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:10 sydtest0 kernel: [764289.491241] task: ffff88041dd8f810 ti: ffff88041ddc0000 task.ti: ffff88041ddc0000
Nov 11 07:03:10 sydtest0 kernel: [764289.598687] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:10 sydtest0 kernel: [764289.706509] RSP: 0018:ffff88041ddc1e88  EFLAGS: 00000286
Nov 11 07:03:10 sydtest0 kernel: [764289.813716] RAX: 00000000ffffffed RBX: ffff88041ddc1fd8 RCX: 0140000000000000
Nov 11 07:03:10 sydtest0 kernel: [764289.921830] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd8d620
Nov 11 07:03:10 sydtest0 kernel: [764290.030104] RBP: ffff88041ddc1ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:10 sydtest0 kernel: [764290.138457] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc1fd8
Nov 11 07:03:10 sydtest0 kernel: [764290.246862] R13: 0000000000000019 R14: ffff88041ddc1fd8 R15: 0000000000000000
Nov 11 07:03:10 sydtest0 kernel: [764290.354923] FS:  0000000000000000(0000) GS:ffff88082fd80000(0000) knlGS:0000000000000000
Nov 11 07:03:10 sydtest0 kernel: [764290.462744] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:10 sydtest0 kernel: [764290.568035] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:03:10 sydtest0 kernel: [764290.671357] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:10 sydtest0 kernel: [764290.771351] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:10 sydtest0 kernel: [764290.867643] Stack:
Nov 11 07:03:10 sydtest0 kernel: [764290.960130]  ffff88041ddc1fd8 ffff88041ddc1fd8 ffff88041ddc1fd8 ffff88041ddc1fd8
Nov 11 07:03:10 sydtest0 kernel: [764291.054267]  ffff88041ddc1eb8 ffffffff8100aace ffff88041ddc1f28 ffffffff810754be
Nov 11 07:03:10 sydtest0 kernel: [764291.147604]  ffff88041ddc1ee8 ffffffff8107c92b ffff88082fd8cc40 0000000000000000
Nov 11 07:03:10 sydtest0 kernel: [764291.239586] Call Trace:
Nov 11 07:03:10 sydtest0 kernel: [764291.329680]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:10 sydtest0 kernel: [764291.420463]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:10 sydtest0 kernel: [764291.511405]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:10 sydtest0 kernel: [764291.603040]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:10 sydtest0 kernel: [764291.694645] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:10 sydtest0 kernel: [764291.890399] NMI backtrace for cpu 26
Nov 11 07:03:13 sydtest0 kernel: [764291.985309] CPU: 26 PID: 0 Comm: swapper/26 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:13 sydtest0 kernel: [764292.082238] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:13 sydtest0 kernel: [764292.180423] task: ffff88041ddc8000 ti: ffff88041ddc2000 task.ti: ffff88041ddc2000
Nov 11 07:03:13 sydtest0 kernel: [764292.280124] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:13 sydtest0 kernel: [764292.380383] RSP: 0018:ffff88041ddc3e88  EFLAGS: 00000286
Nov 11 07:03:13 sydtest0 kernel: [764292.479790] RAX: 00000000ffffffed RBX: ffff88041ddc3fd8 RCX: 0140000000000000
Nov 11 07:03:13 sydtest0 kernel: [764292.580530] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fdad620
Nov 11 07:03:13 sydtest0 kernel: [764292.681055] RBP: ffff88041ddc3ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:13 sydtest0 kernel: [764292.780968] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc3fd8
Nov 11 07:03:13 sydtest0 kernel: [764292.880696] R13: 000000000000001a R14: ffff88041ddc3fd8 R15: 0000000000000000
Nov 11 07:03:13 sydtest0 kernel: [764292.980583] FS:  0000000000000000(0000) GS:ffff88041fda0000(0000) knlGS:0000000000000000
Nov 11 07:03:13 sydtest0 kernel: [764293.080111] INFO: rcu_sched detected stalls on CPUs/tasks: { 26 27 28} (detected by 0, t=60002 jiffies, g=13323126, c=13323125, q=91464)
Nov 11 07:03:13 sydtest0 kernel: [764293.080112] sending NMI to all CPUs:
Nov 11 07:03:13 sydtest0 kernel: [764293.290122] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:13 sydtest0 kernel: [764293.395334] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:03:13 sydtest0 kernel: [764293.501611] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:13 sydtest0 kernel: [764293.607515] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:13 sydtest0 kernel: [764293.712779] Stack:
Nov 11 07:03:13 sydtest0 kernel: [764293.817326]  ffff88041ddc3fd8 ffff88041ddc3fd8 ffff88041ddc3fd8 ffff88041ddc3fd8
Nov 11 07:03:13 sydtest0 kernel: [764293.922564]  ffff88041ddc3eb8 ffffffff8100aace ffff88041ddc3f28 ffffffff810754be
Nov 11 07:03:13 sydtest0 kernel: [764294.025354]  ffff88041ddc3ee8 ffffffff8107c92b ffff88041fdacc40 0000000000000000
Nov 11 07:03:13 sydtest0 kernel: [764294.127370] Call Trace:
Nov 11 07:03:13 sydtest0 kernel: [764294.227900]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:13 sydtest0 kernel: [764294.329837]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:13 sydtest0 kernel: [764294.432439]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:13 sydtest0 kernel: [764294.534882]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:13 sydtest0 kernel: [764294.636363] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:13 sydtest0 kernel: [764294.852033] NMI backtrace for cpu 27
Nov 11 07:03:16 sydtest0 kernel: [764294.956979] CPU: 27 PID: 0 Comm: swapper/27 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:16 sydtest0 kernel: [764295.064133] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:16 sydtest0 kernel: [764295.172247] task: ffff88041ddc8710 ti: ffff88041ddc4000 task.ti: ffff88041ddc4000
Nov 11 07:03:16 sydtest0 kernel: [764295.280892] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:16 sydtest0 kernel: [764295.390496] RSP: 0018:ffff88041ddc5e88  EFLAGS: 00000286
Nov 11 07:03:16 sydtest0 kernel: [764295.497864] RAX: 00000000ffffffed RBX: ffff88041ddc5fd8 RCX: 0140000000000000
Nov 11 07:03:16 sydtest0 kernel: [764295.604034] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fdad620
Nov 11 07:03:16 sydtest0 kernel: [764295.710203] RBP: ffff88041ddc5ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:16 sydtest0 kernel: [764295.815548] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc5fd8
Nov 11 07:03:16 sydtest0 kernel: [764295.919748] R13: 000000000000001b R14: ffff88041ddc5fd8 R15: 0000000000000000
Nov 11 07:03:16 sydtest0 kernel: [764296.023096] FS:  0000000000000000(0000) GS:ffff88082fda0000(0000) knlGS:0000000000000000
Nov 11 07:03:16 sydtest0 kernel: [764296.126284] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:16 sydtest0 kernel: [764296.228540] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:03:16 sydtest0 kernel: [764296.331142] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:16 sydtest0 kernel: [764296.433159] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:16 sydtest0 kernel: [764296.534350] Stack:
Nov 11 07:03:16 sydtest0 kernel: [764296.634610]  ffff88041ddc5fd8 ffff88041ddc5fd8 ffff88041ddc5fd8 ffff88041ddc5fd8
Nov 11 07:03:16 sydtest0 kernel: [764296.737451]  ffff88041ddc5eb8 ffffffff8100aace ffff88041ddc5f28 ffffffff810754be
Nov 11 07:03:16 sydtest0 kernel: [764296.839629]  ffff88041ddc5ee8 ffffffff8107c92b ffff88082fdacc40 0000000000000000
Nov 11 07:03:16 sydtest0 kernel: [764296.941060] Call Trace:
Nov 11 07:03:16 sydtest0 kernel: [764297.041109]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:16 sydtest0 kernel: [764297.142673]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:16 sydtest0 kernel: [764297.245009]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:16 sydtest0 kernel: [764297.347186]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:16 sydtest0 kernel: [764297.448455] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:16 sydtest0 kernel: [764297.663513] NMI backtrace for cpu 28
Nov 11 07:03:19 sydtest0 kernel: [764297.768086] CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:19 sydtest0 kernel: [764297.874894] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:19 sydtest0 kernel: [764297.982610] task: ffff88041ddc8e20 ti: ffff88041ddc6000 task.ti: ffff88041ddc6000
Nov 11 07:03:19 sydtest0 kernel: [764298.090883] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:19 sydtest0 kernel: [764298.200114] RSP: 0018:ffff88041ddc7e88  EFLAGS: 00000286
Nov 11 07:03:19 sydtest0 kernel: [764298.307190] RAX: 00000000ffffffed RBX: ffff88041ddc7fd8 RCX: 0140000000000000
Nov 11 07:03:19 sydtest0 kernel: [764298.413067] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fdcd620
Nov 11 07:03:19 sydtest0 kernel: [764298.518944] RBP: ffff88041ddc7ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:19 sydtest0 kernel: [764298.624022] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc7fd8
Nov 11 07:03:19 sydtest0 kernel: [764298.727983] R13: 000000000000001c R14: ffff88041ddc7fd8 R15: 0000000000000000
Nov 11 07:03:19 sydtest0 kernel: [764298.831198] FS:  0000000000000000(0000) GS:ffff88041fdc0000(0000) knlGS:0000000000000000
Nov 11 07:03:19 sydtest0 kernel: [764298.934252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:19 sydtest0 kernel: [764299.036429] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:03:19 sydtest0 kernel: [764299.138979] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:19 sydtest0 kernel: [764299.240942] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:19 sydtest0 kernel: [764299.342187] Stack:
Nov 11 07:03:19 sydtest0 kernel: [764299.442526]  ffff88041ddc7fd8 ffff88041ddc7fd8 ffff88041ddc7fd8 ffff88041ddc7fd8
Nov 11 07:03:19 sydtest0 kernel: [764299.545528]  ffff88041ddc7eb8 ffffffff8100aace ffff88041ddc7f28 ffffffff810754be
Nov 11 07:03:19 sydtest0 kernel: [764299.647864]  ffff88041ddc7ee8 ffffffff8107c92b ffff88041fdccc40 0000000000000000
Nov 11 07:03:19 sydtest0 kernel: [764299.747725] Call Trace:
Nov 11 07:03:19 sydtest0 kernel: [764299.844767]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:19 sydtest0 kernel: [764299.942684]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:19 sydtest0 kernel: [764300.040149]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:19 sydtest0 kernel: [764300.138600]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:19 sydtest0 kernel: [764300.237660] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:19 sydtest0 kernel: [764300.445528] NMI backtrace for cpu 0
Nov 11 07:03:29 sydtest0 kernel: [764300.547040] CPU: 0 PID: 14045 Comm: ptpd Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:29 sydtest0 kernel: [764300.651026] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:29 sydtest0 kernel: [764300.755093] task: ffff8808105d62e0 ti: ffff8807d0afa000 task.ti: ffff8807d0afa000
Nov 11 07:03:29 sydtest0 kernel: [764300.859693] RIP: 0010:[<ffffffff81269ec5>]  [<ffffffff81269ec5>] __const_udelay+0x15/0x30
Nov 11 07:03:29 sydtest0 kernel: [764300.965624] RSP: 0018:ffff88041fc03d38  EFLAGS: 00000012
Nov 11 07:03:29 sydtest0 kernel: [764301.071181] RAX: 00000000001a36f0 RBX: 00000000000003e9 RCX: 0000000000000020
Nov 11 07:03:29 sydtest0 kernel: [764301.177591] RDX: 00000000002c3faf RSI: 0000000000000100 RDI: 0000000000068dbc
Nov 11 07:03:29 sydtest0 kernel: [764301.281471] RBP: ffff88041fc03d38 R08: ffffffff81abcf00 R09: 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764301.383195] R10: 0000000000000038 R11: 000000000001ea88 R12: 0000000000001000
Nov 11 07:03:29 sydtest0 kernel: [764301.484706] R13: ffffffff81abcf00 R14: 0000000000000400 R15: 0000000000000092
Nov 11 07:03:29 sydtest0 kernel: [764301.585126] FS:  00007fc28c07a700(0000) GS:ffff88041fc00000(0000) knlGS:0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764301.685359] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:29 sydtest0 kernel: [764301.784660] CR2: 0000003b0de7b160 CR3: 00000007f0ae3000 CR4: 00000000000407f0
Nov 11 07:03:29 sydtest0 kernel: [764301.883935] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764301.982145] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:29 sydtest0 kernel: [764302.079130] Stack:
Nov 11 07:03:29 sydtest0 kernel: [764302.175077]  ffff88041fc03d58 ffffffff8102471a 0000000000000002 000000000000b06a
Nov 11 07:03:29 sydtest0 kernel: [764302.273607]  ffff88041fc03da8 ffffffff81025310 0000000000000020 0000000000000001
Nov 11 07:03:29 sydtest0 kernel: [764302.371391]  ffff88041fc03dc8 0000000000002710 ffffffff81a445c0 ffffffff81a44680
Nov 11 07:03:29 sydtest0 kernel: [764302.469494] Call Trace:
Nov 11 07:03:29 sydtest0 kernel: [764302.566188]  <IRQ> 
Nov 11 07:03:29 sydtest0 kernel: [764302.566854]  [<ffffffff8102471a>] native_safe_apic_wait_icr_idle+0x2a/0x60
Nov 11 07:03:29 sydtest0 kernel: [764302.758670]  [<ffffffff81025310>] default_send_IPI_mask_sequence_phys+0xc0/0xd0
Nov 11 07:03:29 sydtest0 kernel: [764302.856348]  [<ffffffff81028817>] physflat_send_IPI_all+0x17/0x20
Nov 11 07:03:29 sydtest0 kernel: [764302.954637]  [<ffffffff81025481>] arch_trigger_all_cpu_backtrace+0x61/0xa0
Nov 11 07:03:29 sydtest0 kernel: [764303.052715]  [<ffffffff810a477c>] rcu_check_callbacks+0x63c/0x680
Nov 11 07:03:29 sydtest0 kernel: [764303.150099]  [<ffffffff8104b168>] update_process_times+0x48/0x80
Nov 11 07:03:29 sydtest0 kernel: [764303.247617]  [<ffffffff8107e736>] tick_sched_timer+0x56/0x130
Nov 11 07:03:29 sydtest0 kernel: [764303.345215]  [<ffffffff8106254f>] __run_hrtimer+0x5f/0x1f0
Nov 11 07:03:29 sydtest0 kernel: [764303.441801]  [<ffffffff8107e6e0>] ? tick_init_highres+0x20/0x20
Nov 11 07:03:29 sydtest0 kernel: [764303.538202]  [<ffffffff810431d4>] ? __do_softirq+0x154/0x280
Nov 11 07:03:29 sydtest0 kernel: [764303.634468]  [<ffffffff81062bef>] hrtimer_interrupt+0xff/0x240
Nov 11 07:03:29 sydtest0 kernel: [764303.730442]  [<ffffffff81062480>] ? hrtimer_cancel+0x30/0x30
Nov 11 07:03:29 sydtest0 kernel: [764303.825990]  [<ffffffff814c3949>] smp_apic_timer_interrupt+0x69/0x99
Nov 11 07:03:29 sydtest0 kernel: [764303.919834]  [<ffffffff814c2cca>] apic_timer_interrupt+0x6a/0x70
Nov 11 07:03:29 sydtest0 kernel: [764304.011386]  <EOI> 
Nov 11 07:03:29 sydtest0 kernel: [764304.012052]  [<ffffffff810834fe>] ? smp_call_function_many+0x26e/0x2d0
Nov 11 07:03:29 sydtest0 kernel: [764304.193671]  [<ffffffff810834db>] ? smp_call_function_many+0x24b/0x2d0
Nov 11 07:03:29 sydtest0 kernel: [764304.283281]  [<ffffffff81062480>] ? hrtimer_cancel+0x30/0x30
Nov 11 07:03:29 sydtest0 kernel: [764304.371855]  [<ffffffff810835e2>] smp_call_function+0x22/0x30
Nov 11 07:03:29 sydtest0 kernel: [764304.459390]  [<ffffffff81083648>] on_each_cpu+0x28/0x50
Nov 11 07:03:29 sydtest0 kernel: [764304.545886]  [<ffffffff8106272c>] clock_was_set+0x1c/0x30
Nov 11 07:03:29 sydtest0 kernel: [764304.631770]  [<ffffffff8107701e>] do_settimeofday+0xfe/0x110
Nov 11 07:03:29 sydtest0 kernel: [764304.717441]  [<ffffffff8104244d>] do_sys_settimeofday+0xdd/0xf0
Nov 11 07:03:29 sydtest0 kernel: [764304.803005]  [<ffffffff813f6fe9>] ? __sys_recvmsg+0x49/0x90
Nov 11 07:03:29 sydtest0 kernel: [764304.888382]  [<ffffffff8105d513>] posix_clock_realtime_set+0x13/0x20
Nov 11 07:03:29 sydtest0 kernel: [764304.974133]  [<ffffffff8105e55f>] SyS_clock_settime+0x5f/0x90
Nov 11 07:03:29 sydtest0 kernel: [764305.059325]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 11 07:03:29 sydtest0 kernel: [764305.144037] Code: 15 19 c3 80 00 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8d 04 bd 00 00 00 00 48 89 e5 65 48 8b 14 25 a0 24 01 00 <48> 69 d2 fa 00 00 00 f7 e2 48 8d 7a 01 ff 15 e0 c2 80 00 5d c3 
Nov 11 07:03:29 sydtest0 kernel: [764305.324937] NMI backtrace for cpu 1
Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Uhhuh. NMI received for unknown reason 21 on CPU 26.
Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Do you have a strange power saving mode enabled?
Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Dazed and confused, but trying to continue
Nov 11 07:03:29 sydtest0 kernel: [764305.327143] Uhhuh. NMI received for unknown reason 31 on CPU 27.
Nov 11 07:03:29 sydtest0 kernel: [764305.327144] Do you have a strange power saving mode enabled?
Nov 11 07:03:29 sydtest0 kernel: [764305.327144] Dazed and confused, but trying to continue
Nov 11 07:03:29 sydtest0 kernel: [764305.327242] Uhhuh. NMI received for unknown reason 31 on CPU 28.
Nov 11 07:03:29 sydtest0 kernel: [764305.327242] Do you have a strange power saving mode enabled?
Nov 11 07:03:29 sydtest0 kernel: [764305.327243] Dazed and confused, but trying to continue
Nov 11 07:03:29 sydtest0 kernel: [764306.217006] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:29 sydtest0 kernel: [764306.306162] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:29 sydtest0 kernel: [764306.393831] task: ffff88041dc7cdb0 ti: ffff88041dd6e000 task.ti: ffff88041dd6e000
Nov 11 07:03:29 sydtest0 kernel: [764306.482083] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:29 sydtest0 kernel: [764306.570790] RSP: 0018:ffff88041dd6fe88  EFLAGS: 00000286
Nov 11 07:03:29 sydtest0 kernel: [764306.658244] RAX: 00000000ffffffed RBX: ffff88041dd6ffd8 RCX: 0140000000000000
Nov 11 07:03:29 sydtest0 kernel: [764306.746098] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc0d620
Nov 11 07:03:29 sydtest0 kernel: [764306.833181] RBP: ffff88041dd6fea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764306.919517] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd6ffd8
Nov 11 07:03:29 sydtest0 kernel: [764307.005374] R13: 0000000000000001 R14: ffff88041dd6ffd8 R15: 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764307.091739] FS:  0000000000000000(0000) GS:ffff88082fc00000(0000) knlGS:0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764307.178714] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:29 sydtest0 kernel: [764307.265504] CR2: 00007f92144e48f4 CR3: 000000078d0a9000 CR4: 00000000000407e0
Nov 11 07:03:29 sydtest0 kernel: [764307.353464] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764307.440465] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:29 sydtest0 kernel: [764307.526189] Stack:
Nov 11 07:03:29 sydtest0 kernel: [764307.610530]  ffff88041dd6ffd8 ffff88041dd6ffd8 ffff88041dd6ffd8 ffff88041dd6ffd8
Nov 11 07:03:29 sydtest0 kernel: [764307.697905]  ffff88041dd6feb8 ffffffff8100aace ffff88041dd6ff28 ffffffff810754be
Nov 11 07:03:29 sydtest0 kernel: [764307.785758]  ffff88041dd6fee8 ffffffff8107c92b ffff88082fc0cc40 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764307.872786] Call Trace:
Nov 11 07:03:29 sydtest0 kernel: [764307.958089]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:29 sydtest0 kernel: [764308.045250]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:29 sydtest0 kernel: [764308.132225]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:29 sydtest0 kernel: [764308.218962]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:29 sydtest0 kernel: [764308.306254] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:29 sydtest0 kernel: [764308.491574] NMI backtrace for cpu 2
Nov 11 07:03:29 sydtest0 kernel: [764308.581665] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:29 sydtest0 kernel: [764308.673857] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:29 sydtest0 kernel: [764308.766558] task: ffff88041dc7d4c0 ti: ffff88041dd70000 task.ti: ffff88041dd70000
Nov 11 07:03:29 sydtest0 kernel: [764308.860108] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:29 sydtest0 kernel: [764308.954804] RSP: 0018:ffff88041dd71e88  EFLAGS: 00000286
Nov 11 07:03:29 sydtest0 kernel: [764309.049474] RAX: 00000000ffffffed RBX: ffff88041dd71fd8 RCX: 0140000000000000
Nov 11 07:03:29 sydtest0 kernel: [764309.145342] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc2d620
Nov 11 07:03:29 sydtest0 kernel: [764309.241555] RBP: ffff88041dd71ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764309.337928] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd71fd8
Nov 11 07:03:29 sydtest0 kernel: [764309.434488] R13: 0000000000000002 R14: ffff88041dd71fd8 R15: 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764309.530861] FS:  0000000000000000(0000) GS:ffff88041fc20000(0000) knlGS:0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764309.627846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:29 sydtest0 kernel: [764309.724245] CR2: 0000003b0de7b160 CR3: 0000000399f1f000 CR4: 00000000000407e0
Nov 11 07:03:29 sydtest0 kernel: [764309.821097] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764309.918429] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:29 sydtest0 kernel: [764310.015094] Stack:
Nov 11 07:03:29 sydtest0 kernel: [764310.110989]  ffff88041dd71fd8 ffff88041dd71fd8 ffff88041dd71fd8 ffff88041dd71fd8
Nov 11 07:03:29 sydtest0 kernel: [764310.209678]  ffff88041dd71eb8 ffffffff8100aace ffff88041dd71f28 ffffffff810754be
Nov 11 07:03:29 sydtest0 kernel: [764310.308314]  ffff88041dd71ee8 ffffffff8107c92b ffff88041fc2cc40 0000000000000000
Nov 11 07:03:29 sydtest0 kernel: [764310.406843] Call Trace:
Nov 11 07:03:29 sydtest0 kernel: [764310.504577]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:29 sydtest0 kernel: [764310.603479]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:29 sydtest0 kernel: [764310.702247]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:29 sydtest0 kernel: [764310.801497]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:29 sydtest0 kernel: [764310.900609] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:29 sydtest0 kernel: [764311.104457] NMI backtrace for cpu 3
Nov 11 07:03:32 sydtest0 kernel: [764311.202882] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:32 sydtest0 kernel: [764311.303379] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:32 sydtest0 kernel: [764311.404412] task: ffff88041dc7dbd0 ti: ffff88041dd72000 task.ti: ffff88041dd72000
Nov 11 07:03:32 sydtest0 kernel: [764311.506002] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:32 sydtest0 kernel: [764311.608498] RSP: 0018:ffff88041dd73e88  EFLAGS: 00000286
Nov 11 07:03:32 sydtest0 kernel: [764311.710595] RAX: 00000000ffffffed RBX: ffff88041dd73fd8 RCX: 0140000000000000
Nov 11 07:03:32 sydtest0 kernel: [764311.813597] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc2d620
Nov 11 07:03:32 sydtest0 kernel: [764311.916465] RBP: ffff88041dd73ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:32 sydtest0 kernel: [764312.019147] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd73fd8
Nov 11 07:03:32 sydtest0 kernel: [764312.121670] R13: 0000000000000003 R14: ffff88041dd73fd8 R15: 0000000000000000
Nov 11 07:03:32 sydtest0 kernel: [764312.223260] FS:  0000000000000000(0000) GS:ffff88082fc20000(0000) knlGS:0000000000000000
Nov 11 07:03:32 sydtest0 kernel: [764312.324426] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:32 sydtest0 kernel: [764312.424660] CR2: 00000000009ff448 CR3: 00000008144a9000 CR4: 00000000000407e0
Nov 11 07:03:32 sydtest0 kernel: [764312.524840] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:32 sydtest0 kernel: [764312.623822] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:32 sydtest0 kernel: [764312.721553] Stack:
Nov 11 07:03:32 sydtest0 kernel: [764312.818220]  ffff88041dd73fd8 ffff88041dd73fd8 ffff88041dd73fd8 ffff88041dd73fd8
Nov 11 07:03:32 sydtest0 kernel: [764312.917522]  ffff88041dd73eb8 ffffffff8100aace ffff88041dd73f28 ffffffff810754be
Nov 11 07:03:32 sydtest0 kernel: [764313.016504]  ffff88041dd73ee8 ffffffff8107c92b ffff88082fc2cc40 0000000000000000
Nov 11 07:03:32 sydtest0 kernel: [764313.115326] Call Trace:
Nov 11 07:03:32 sydtest0 kernel: [764313.212794]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:32 sydtest0 kernel: [764313.310871]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:32 sydtest0 kernel: [764313.408442]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:32 sydtest0 kernel: [764313.506840]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:32 sydtest0 kernel: [764313.605793] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:32 sydtest0 kernel: [764313.813501] NMI backtrace for cpu 4
Nov 11 07:03:33 sydtest0 kernel: [764313.914906] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:33 sydtest0 kernel: [764314.018705] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:33 sydtest0 kernel: [764314.122481] task: ffff88041dc7e2e0 ti: ffff88041dd74000 task.ti: ffff88041dd74000
Nov 11 07:03:33 sydtest0 kernel: [764314.226814] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:33 sydtest0 kernel: [764314.332372] RSP: 0018:ffff88041dd75e88  EFLAGS: 00000286
Nov 11 07:03:33 sydtest0 kernel: [764314.437583] RAX: 00000000ffffffed RBX: ffff88041dd75fd8 RCX: 0140000000000000
Nov 11 07:03:33 sydtest0 kernel: [764314.543620] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc4d620
Nov 11 07:03:33 sydtest0 kernel: [764314.647793] RBP: ffff88041dd75ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:33 sydtest0 kernel: [764314.749731] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd75fd8
Nov 11 07:03:33 sydtest0 kernel: [764314.851454] R13: 0000000000000004 R14: ffff88041dd75fd8 R15: 0000000000000000
Nov 11 07:03:33 sydtest0 kernel: [764314.952407] FS:  0000000000000000(0000) GS:ffff88041fc40000(0000) knlGS:0000000000000000
Nov 11 07:03:33 sydtest0 kernel: [764315.052932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:33 sydtest0 kernel: [764315.152526] CR2: 00007fd42148f000 CR3: 000000040ec11000 CR4: 00000000000407e0
Nov 11 07:03:33 sydtest0 kernel: [764315.252120] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:35 sydtest0 kernel: [764315.325436] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
Nov 11 07:03:35 sydtest0 kernel: [764315.449151] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:35 sydtest0 kernel: [764315.548214] Stack:
Nov 11 07:03:35 sydtest0 kernel: [764315.646344]  ffff88041dd75fd8 ffff88041dd75fd8 ffff88041dd75fd8 ffff88041dd75fd8
Nov 11 07:03:35 sydtest0 kernel: [764315.747057]  ffff88041dd75eb8 ffffffff8100aace ffff88041dd75f28 ffffffff810754be
Nov 11 07:03:35 sydtest0 kernel: [764315.847557]  ffff88041dd75ee8 ffffffff8107c92b ffff88041fc4cc40 0000000000000000
Nov 11 07:03:35 sydtest0 kernel: [764315.947391] Call Trace:
Nov 11 07:03:35 sydtest0 kernel: [764316.045710]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:35 sydtest0 kernel: [764316.144665]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:35 sydtest0 kernel: [764316.243966]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:35 sydtest0 kernel: [764316.344439]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:35 sydtest0 kernel: [764316.444058] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:35 sydtest0 kernel: [764316.653923] NMI backtrace for cpu 5
Nov 11 07:03:38 sydtest0 kernel: [764316.756925] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:38 sydtest0 kernel: [764316.861391] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:38 sydtest0 kernel: [764316.966417] task: ffff88041dc7e9f0 ti: ffff88041dd76000 task.ti: ffff88041dd76000
Nov 11 07:03:38 sydtest0 kernel: [764317.072347] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:38 sydtest0 kernel: [764317.179237] RSP: 0018:ffff88041dd77e88  EFLAGS: 00000286
Nov 11 07:03:38 sydtest0 kernel: [764317.285753] RAX: 00000000ffffffed RBX: ffff88041dd77fd8 RCX: 0140000000000000
Nov 11 07:03:38 sydtest0 kernel: [764317.391337] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc4d620
Nov 11 07:03:38 sydtest0 kernel: [764317.494872] RBP: ffff88041dd77ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:38 sydtest0 kernel: [764317.598248] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd77fd8
Nov 11 07:03:38 sydtest0 kernel: [764317.700878] R13: 0000000000000005 R14: ffff88041dd77fd8 R15: 0000000000000000
Nov 11 07:03:38 sydtest0 kernel: [764317.802390] FS:  0000000000000000(0000) GS:ffff88082fc40000(0000) knlGS:0000000000000000
Nov 11 07:03:38 sydtest0 kernel: [764317.903874] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:38 sydtest0 kernel: [764318.004266] CR2: 00000000017f7448 CR3: 000000080c727000 CR4: 00000000000407e0
Nov 11 07:03:38 sydtest0 kernel: [764318.104899] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:38 sydtest0 kernel: [764318.204599] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:38 sydtest0 kernel: [764318.303420] Stack:
Nov 11 07:03:38 sydtest0 kernel: [764318.401311]  ffff88041dd77fd8 ffff88041dd77fd8 ffff88041dd77fd8 ffff88041dd77fd8
Nov 11 07:03:38 sydtest0 kernel: [764318.501811]  ffff88041dd77eb8 ffffffff8100aace ffff88041dd77f28 ffffffff810754be
Nov 11 07:03:38 sydtest0 kernel: [764318.601991]  ffff88041dd77ee8 ffffffff8107c92b ffff88082fc4cc40 0000000000000000
Nov 11 07:03:38 sydtest0 kernel: [764318.701584] Call Trace:
Nov 11 07:03:38 sydtest0 kernel: [764318.799664]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:38 sydtest0 kernel: [764318.898352]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:38 sydtest0 kernel: [764318.997495]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:38 sydtest0 kernel: [764319.097888]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:38 sydtest0 kernel: [764319.197480] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:38 sydtest0 kernel: [764319.407266] NMI backtrace for cpu 6
Nov 11 07:03:40 sydtest0 kernel: [764319.510241] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:40 sydtest0 kernel: [764319.614732] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:40 sydtest0 kernel: [764319.719759] task: ffff88041dc7f100 ti: ffff88041dd78000 task.ti: ffff88041dd78000
Nov 11 07:03:40 sydtest0 kernel: [764319.825636] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:40 sydtest0 kernel: [764319.932418] RSP: 0018:ffff88041dd79e88  EFLAGS: 00000286
Nov 11 07:03:40 sydtest0 kernel: [764320.038881] RAX: 00000000ffffffed RBX: ffff88041dd79fd8 RCX: 0140000000000000
Nov 11 07:03:40 sydtest0 kernel: [764320.144438] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc6d620
Nov 11 07:03:40 sydtest0 kernel: [764320.247946] RBP: ffff88041dd79ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:40 sydtest0 kernel: [764320.351348] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd79fd8
Nov 11 07:03:40 sydtest0 kernel: [764320.454029] R13: 0000000000000006 R14: ffff88041dd79fd8 R15: 0000000000000000
Nov 11 07:03:40 sydtest0 kernel: [764320.555595] FS:  0000000000000000(0000) GS:ffff88041fc60000(0000) knlGS:0000000000000000
Nov 11 07:03:40 sydtest0 kernel: [764320.657078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:40 sydtest0 kernel: [764320.757445] CR2: 00000000012e0428 CR3: 000000041ac81000 CR4: 00000000000407e0
Nov 11 07:03:40 sydtest0 kernel: [764320.857971] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:40 sydtest0 kernel: [764320.957565] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:40 sydtest0 kernel: [764321.056252] Stack:
Nov 11 07:03:40 sydtest0 kernel: [764321.154037]  ffff88041dd79fd8 ffff88041dd79fd8 ffff88041dd79fd8 ffff88041dd79fd8
Nov 11 07:03:40 sydtest0 kernel: [764321.254484]  ffff88041dd79eb8 ffffffff8100aace ffff88041dd79f28 ffffffff810754be
Nov 11 07:03:40 sydtest0 kernel: [764321.354663]  ffff88041dd79ee8 ffffffff8107c92b ffff88041fc6cc40 0000000000000000
Nov 11 07:03:40 sydtest0 kernel: [764321.454231] Call Trace:
Nov 11 07:03:40 sydtest0 kernel: [764321.552283]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:40 sydtest0 kernel: [764321.650945]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:40 sydtest0 kernel: [764321.750008]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:40 sydtest0 kernel: [764321.848936]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:40 sydtest0 kernel: [764321.947117] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:40 sydtest0 kernel: [764322.153362] NMI backtrace for cpu 7
Nov 11 07:03:43 sydtest0 kernel: [764322.254130] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:43 sydtest0 kernel: [764322.357476] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:43 sydtest0 kernel: [764322.460823] task: ffff88041dc7f810 ti: ffff88041dd7a000 task.ti: ffff88041dd7a000
Nov 11 07:03:43 sydtest0 kernel: [764322.564704] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:43 sydtest0 kernel: [764322.669836] RSP: 0018:ffff88041dd7be88  EFLAGS: 00000286
Nov 11 07:03:43 sydtest0 kernel: [764322.774621] RAX: 00000000ffffffed RBX: ffff88041dd7bfd8 RCX: 0140000000000000
Nov 11 07:03:43 sydtest0 kernel: [764322.880285] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc6d620
Nov 11 07:03:43 sydtest0 kernel: [764322.984140] RBP: ffff88041dd7bea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:43 sydtest0 kernel: [764323.085784] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7bfd8
Nov 11 07:03:43 sydtest0 kernel: [764323.187295] R13: 0000000000000007 R14: ffff88041dd7bfd8 R15: 0000000000000000
Nov 11 07:03:43 sydtest0 kernel: [764323.288061] FS:  0000000000000000(0000) GS:ffff88082fc60000(0000) knlGS:0000000000000000
Nov 11 07:03:43 sydtest0 kernel: [764323.388427] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:43 sydtest0 kernel: [764323.487834] CR2: 000000000229e448 CR3: 000000040e8e4000 CR4: 00000000000407e0
Nov 11 07:03:43 sydtest0 kernel: [764323.587215] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:43 sydtest0 kernel: [764323.685479] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:43 sydtest0 kernel: [764323.782517] Stack:
Nov 11 07:03:43 sydtest0 kernel: [764323.878465]  ffff88041dd7bfd8 ffff88041dd7bfd8 ffff88041dd7bfd8 ffff88041dd7bfd8
Nov 11 07:03:43 sydtest0 kernel: [764323.977049]  ffff88041dd7beb8 ffffffff8100aace ffff88041dd7bf28 ffffffff810754be
Nov 11 07:03:43 sydtest0 kernel: [764324.075364]  ffff88041dd7bee8 ffffffff8107c92b ffff88082fc6cc40 0000000000000000
Nov 11 07:03:43 sydtest0 kernel: [764324.173601] Call Trace:
Nov 11 07:03:43 sydtest0 kernel: [764324.270482]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:43 sydtest0 kernel: [764324.367946]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:43 sydtest0 kernel: [764324.464905]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:43 sydtest0 kernel: [764324.562796]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:43 sydtest0 kernel: [764324.661323] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:43 sydtest0 kernel: [764324.868234] NMI backtrace for cpu 8
Nov 11 07:03:46 sydtest0 kernel: [764324.969372] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:46 sydtest0 kernel: [764325.073012] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:46 sydtest0 kernel: [764325.176679] task: ffff88041dd88000 ti: ffff88041dd7c000 task.ti: ffff88041dd7c000
Nov 11 07:03:46 sydtest0 kernel: [764325.280906] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:46 sydtest0 kernel: [764325.386437] RSP: 0018:ffff88041dd7de88  EFLAGS: 00000286
Nov 11 07:03:46 sydtest0 kernel: [764325.491595] RAX: 00000000ffffffed RBX: ffff88041dd7dfd8 RCX: 0140000000000000
Nov 11 07:03:46 sydtest0 kernel: [764325.597632] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fc8d620
Nov 11 07:03:46 sydtest0 kernel: [764325.701858] RBP: ffff88041dd7dea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:46 sydtest0 kernel: [764325.803875] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7dfd8
Nov 11 07:03:46 sydtest0 kernel: [764325.905680] R13: 0000000000000008 R14: ffff88041dd7dfd8 R15: 0000000000000000
Nov 11 07:03:46 sydtest0 kernel: [764326.006686] FS:  0000000000000000(0000) GS:ffff88041fc80000(0000) knlGS:0000000000000000
Nov 11 07:03:46 sydtest0 kernel: [764326.107265] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:46 sydtest0 kernel: [764326.206939] CR2: 00000000015bc448 CR3: 000000040c52f000 CR4: 00000000000407e0
Nov 11 07:03:46 sydtest0 kernel: [764326.306613] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:46 sydtest0 kernel: [764326.405115] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:46 sydtest0 kernel: [764326.502341] Stack:
Nov 11 07:03:46 sydtest0 kernel: [764326.598476]  ffff88041dd7dfd8 ffff88041dd7dfd8 ffff88041dd7dfd8 ffff88041dd7dfd8
Nov 11 07:03:46 sydtest0 kernel: [764326.697219]  ffff88041dd7deb8 ffffffff8100aace ffff88041dd7df28 ffffffff810754be
Nov 11 07:03:46 sydtest0 kernel: [764326.795695]  ffff88041dd7dee8 ffffffff8107c92b ffff88041fc8cc40 0000000000000000
Nov 11 07:03:46 sydtest0 kernel: [764326.894012] Call Trace:
Nov 11 07:03:46 sydtest0 kernel: [764326.990973]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:46 sydtest0 kernel: [764327.088517]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:46 sydtest0 kernel: [764327.185635]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:46 sydtest0 kernel: [764327.283713]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:46 sydtest0 kernel: [764327.382374] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:46 sydtest0 kernel: [764327.589522] NMI backtrace for cpu 9
Nov 11 07:03:48 sydtest0 kernel: [764327.690743] CPU: 9 PID: 0 Comm: swapper/9 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:48 sydtest0 kernel: [764327.794515] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:48 sydtest0 kernel: [764327.898289] task: ffff88041dd88710 ti: ffff88041dd7e000 task.ti: ffff88041dd7e000
Nov 11 07:03:48 sydtest0 kernel: [764328.002623] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:48 sydtest0 kernel: [764328.108287] RSP: 0018:ffff88041dd7fe88  EFLAGS: 00000286
Nov 11 07:03:48 sydtest0 kernel: [764328.213605] RAX: 00000000ffffffed RBX: ffff88041dd7ffd8 RCX: 0140000000000000
Nov 11 07:03:48 sydtest0 kernel: [764328.319775] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fc8d620
Nov 11 07:03:48 sydtest0 kernel: [764328.424056] RBP: ffff88041dd7fea8 R08: 0000000000000000 R09: 0000000000000001
Nov 11 07:03:48 sydtest0 kernel: [764328.526205] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd7ffd8
Nov 11 07:03:48 sydtest0 kernel: [764328.628196] R13: 0000000000000009 R14: ffff88041dd7ffd8 R15: 0000000000000000
Nov 11 07:03:48 sydtest0 kernel: [764328.729388] FS:  0000000000000000(0000) GS:ffff88082fc80000(0000) knlGS:0000000000000000
Nov 11 07:03:48 sydtest0 kernel: [764328.830180] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:48 sydtest0 kernel: [764328.930014] CR2: 00000000015bc448 CR3: 000000080c04b000 CR4: 00000000000407e0
Nov 11 07:03:48 sydtest0 kernel: [764329.029823] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:48 sydtest0 kernel: [764329.128539] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:48 sydtest0 kernel: [764329.226030] Stack:
Nov 11 07:03:48 sydtest0 kernel: [764329.322403]  ffff88041dd7ffd8 ffff88041dd7ffd8 ffff88041dd7ffd8 ffff88041dd7ffd8
Nov 11 07:03:48 sydtest0 kernel: [764329.421386]  ffff88041dd7feb8 ffffffff8100aace ffff88041dd7ff28 ffffffff810754be
Nov 11 07:03:48 sydtest0 kernel: [764329.520075]  ffff88041dd7fee8 ffffffff8107c92b ffff88082fc8cc40 0000000000000000
Nov 11 07:03:48 sydtest0 kernel: [764329.618658] Call Trace:
Nov 11 07:03:48 sydtest0 kernel: [764329.715912]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:48 sydtest0 kernel: [764329.813775]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:48 sydtest0 kernel: [764329.911134]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:48 sydtest0 kernel: [764330.009451]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:48 sydtest0 kernel: [764330.108405] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:48 sydtest0 kernel: [764330.316113] NMI backtrace for cpu 10
Nov 11 07:03:51 sydtest0 kernel: [764330.417625] CPU: 10 PID: 0 Comm: swapper/10 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:51 sydtest0 kernel: [764330.521690] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:51 sydtest0 kernel: [764330.625731] task: ffff88041dd88e20 ti: ffff88041dd90000 task.ti: ffff88041dd90000
Nov 11 07:03:51 sydtest0 kernel: [764330.730303] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:51 sydtest0 kernel: [764330.836153] RSP: 0018:ffff88041dd91e88  EFLAGS: 00000286
Nov 11 07:03:51 sydtest0 kernel: [764330.941631] RAX: 00000000ffffffed RBX: ffff88041dd91fd8 RCX: 0140000000000000
Nov 11 07:03:51 sydtest0 kernel: [764331.047986] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fcad620
Nov 11 07:03:51 sydtest0 kernel: [764331.152505] RBP: ffff88041dd91ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:51 sydtest0 kernel: [764331.254868] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd91fd8
Nov 11 07:03:51 sydtest0 kernel: [764331.357071] R13: 000000000000000a R14: ffff88041dd91fd8 R15: 0000000000000000
Nov 11 07:03:51 sydtest0 kernel: [764331.458477] FS:  0000000000000000(0000) GS:ffff88041fca0000(0000) knlGS:0000000000000000
Nov 11 07:03:51 sydtest0 kernel: [764331.559428] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:51 sydtest0 kernel: [764331.659422] CR2: 00000000015bc448 CR3: 00000004143cd000 CR4: 00000000000407e0
Nov 11 07:03:51 sydtest0 kernel: [764331.759335] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:51 sydtest0 kernel: [764331.858130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:51 sydtest0 kernel: [764331.955675] Stack:
Nov 11 07:03:51 sydtest0 kernel: [764332.052156]  ffff88041dd91fd8 ffff88041dd91fd8 ffff88041dd91fd8 ffff88041dd91fd8
Nov 11 07:03:51 sydtest0 kernel: [764332.151245]  ffff88041dd91eb8 ffffffff8100aace ffff88041dd91f28 ffffffff810754be
Nov 11 07:03:51 sydtest0 kernel: [764332.250121]  ffff88041dd91ee8 ffffffff8107c92b ffff88041fcacc40 0000000000000000
Nov 11 07:03:51 sydtest0 kernel: [764332.348836] Call Trace:
Nov 11 07:03:51 sydtest0 kernel: [764332.446277]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:51 sydtest0 kernel: [764332.544301]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:51 sydtest0 kernel: [764332.641819]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:51 sydtest0 kernel: [764332.740295]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:51 sydtest0 kernel: [764332.839356] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:51 sydtest0 kernel: [764333.047438] NMI backtrace for cpu 11
Nov 11 07:03:54 sydtest0 kernel: [764333.149109] CPU: 11 PID: 0 Comm: swapper/11 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:54 sydtest0 kernel: [764333.253414] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:54 sydtest0 kernel: [764333.357722] task: ffff88041dd89530 ti: ffff88041dd92000 task.ti: ffff88041dd92000
Nov 11 07:03:54 sydtest0 kernel: [764333.462533] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:54 sydtest0 kernel: [764333.568596] RSP: 0018:ffff88041dd93e88  EFLAGS: 00000286
Nov 11 07:03:54 sydtest0 kernel: [764333.674260] RAX: 00000000ffffffed RBX: ffff88041dd93fd8 RCX: 0140000000000000
Nov 11 07:03:54 sydtest0 kernel: [764333.780802] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fcad620
Nov 11 07:03:54 sydtest0 kernel: [764333.885508] RBP: ffff88041dd93ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:54 sydtest0 kernel: [764333.987977] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd93fd8
Nov 11 07:03:54 sydtest0 kernel: [764334.090287] R13: 000000000000000b R14: ffff88041dd93fd8 R15: 0000000000000000
Nov 11 07:03:54 sydtest0 kernel: [764334.191799] FS:  0000000000000000(0000) GS:ffff88082fca0000(0000) knlGS:0000000000000000
Nov 11 07:03:54 sydtest0 kernel: [764334.292936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:54 sydtest0 kernel: [764334.393143] CR2: 00000000017f7448 CR3: 000000080bf00000 CR4: 00000000000407e0
Nov 11 07:03:54 sydtest0 kernel: [764334.493243] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:54 sydtest0 kernel: [764334.592093] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:54 sydtest0 kernel: [764334.689691] Stack:
Nov 11 07:03:54 sydtest0 kernel: [764334.786251]  ffff88041dd93fd8 ffff88041dd93fd8 ffff88041dd93fd8 ffff88041dd93fd8
Nov 11 07:03:54 sydtest0 kernel: [764334.885338]  ffff88041dd93eb8 ffffffff8100aace ffff88041dd93f28 ffffffff810754be
Nov 11 07:03:54 sydtest0 kernel: [764334.984188]  ffff88041dd93ee8 ffffffff8107c92b ffff88082fcacc40 0000000000000000
Nov 11 07:03:54 sydtest0 kernel: [764335.082905] Call Trace:
Nov 11 07:03:54 sydtest0 kernel: [764335.180318]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:54 sydtest0 kernel: [764335.278315]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:54 sydtest0 kernel: [764335.375833]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:54 sydtest0 kernel: [764335.474257]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:54 sydtest0 kernel: [764335.573237] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:54 sydtest0 kernel: [764335.781027] NMI backtrace for cpu 12
Nov 11 07:03:57 sydtest0 kernel: [764335.882564] CPU: 12 PID: 0 Comm: swapper/12 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:57 sydtest0 kernel: [764335.986684] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:57 sydtest0 kernel: [764336.090724] task: ffff88041dd89c40 ti: ffff88041dd94000 task.ti: ffff88041dd94000
Nov 11 07:03:57 sydtest0 kernel: [764336.195323] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:57 sydtest0 kernel: [764336.301174] RSP: 0018:ffff88041dd95e88  EFLAGS: 00000286
Nov 11 07:03:57 sydtest0 kernel: [764336.406678] RAX: 00000000ffffffed RBX: ffff88041dd95fd8 RCX: 0140000000000000
Nov 11 07:03:57 sydtest0 kernel: [764336.512928] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fccd620
Nov 11 07:03:57 sydtest0 kernel: [764336.617341] RBP: ffff88041dd95ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:57 sydtest0 kernel: [764336.719544] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd95fd8
Nov 11 07:03:57 sydtest0 kernel: [764336.821534] R13: 000000000000000c R14: ffff88041dd95fd8 R15: 0000000000000000
Nov 11 07:03:57 sydtest0 kernel: [764336.922594] FS:  0000000000000000(0000) GS:ffff88041fcc0000(0000) knlGS:0000000000000000
Nov 11 07:03:57 sydtest0 kernel: [764337.023173] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:57 sydtest0 kernel: [764337.122847] CR2: 0000003b0de7b160 CR3: 000000040eaff000 CR4: 00000000000407e0
Nov 11 07:03:57 sydtest0 kernel: [764337.222495] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:57 sydtest0 kernel: [764337.321051] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:57 sydtest0 kernel: [764337.418384] Stack:
Nov 11 07:03:57 sydtest0 kernel: [764337.514653]  ffff88041dd95fd8 ffff88041dd95fd8 ffff88041dd95fd8 ffff88041dd95fd8
Nov 11 07:03:57 sydtest0 kernel: [764337.613502]  ffff88041dd95eb8 ffffffff8100aace ffff88041dd95f28 ffffffff810754be
Nov 11 07:03:57 sydtest0 kernel: [764337.712084]  ffff88041dd95ee8 ffffffff8107c92b ffff88041fcccc40 0000000000000000
Nov 11 07:03:57 sydtest0 kernel: [764337.810508] Call Trace:
Nov 11 07:03:57 sydtest0 kernel: [764337.907628]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:57 sydtest0 kernel: [764338.005358]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:57 sydtest0 kernel: [764338.102635]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:57 sydtest0 kernel: [764338.200846]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:57 sydtest0 kernel: [764338.299640] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:57 sydtest0 kernel: [764338.507057] NMI backtrace for cpu 13
Nov 11 07:03:59 sydtest0 kernel: [764338.608410] CPU: 13 PID: 0 Comm: swapper/13 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:03:59 sydtest0 kernel: [764338.712395] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:03:59 sydtest0 kernel: [764338.816356] task: ffff88041dd8a350 ti: ffff88041dd96000 task.ti: ffff88041dd96000
Nov 11 07:03:59 sydtest0 kernel: [764338.920823] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:03:59 sydtest0 kernel: [764339.026594] RSP: 0018:ffff88041dd97e88  EFLAGS: 00000286
Nov 11 07:03:59 sydtest0 kernel: [764339.132019] RAX: 00000000ffffffed RBX: ffff88041dd97fd8 RCX: 0140000000000000
Nov 11 07:03:59 sydtest0 kernel: [764339.238322] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fccd620
Nov 11 07:03:59 sydtest0 kernel: [764339.342735] RBP: ffff88041dd97ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:03:59 sydtest0 kernel: [764339.444937] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dd97fd8
Nov 11 07:03:59 sydtest0 kernel: [764339.546981] R13: 000000000000000d R14: ffff88041dd97fd8 R15: 0000000000000000
Nov 11 07:03:59 sydtest0 kernel: [764339.648094] FS:  0000000000000000(0000) GS:ffff88082fcc0000(0000) knlGS:0000000000000000
Nov 11 07:03:59 sydtest0 kernel: [764339.748752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:03:59 sydtest0 kernel: [764339.848479] CR2: 00000000023f9448 CR3: 000000040e5fd000 CR4: 00000000000407e0
Nov 11 07:03:59 sydtest0 kernel: [764339.948153] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:03:59 sydtest0 kernel: [764340.046710] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:03:59 sydtest0 kernel: [764340.144094] Stack:
Nov 11 07:03:59 sydtest0 kernel: [764340.240387]  ffff88041dd97fd8 ffff88041dd97fd8 ffff88041dd97fd8 ffff88041dd97fd8
Nov 11 07:03:59 sydtest0 kernel: [764340.339315]  ffff88041dd97eb8 ffffffff8100aace ffff88041dd97f28 ffffffff810754be
Nov 11 07:03:59 sydtest0 kernel: [764340.438004]  ffff88041dd97ee8 ffffffff8107c92b ffff88082fcccc40 0000000000000000
Nov 11 07:03:59 sydtest0 kernel: [764340.536561] Call Trace:
Nov 11 07:03:59 sydtest0 kernel: [764340.633762]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:03:59 sydtest0 kernel: [764340.731520]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:03:59 sydtest0 kernel: [764340.828824]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:03:59 sydtest0 kernel: [764340.927194]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:03:59 sydtest0 kernel: [764341.026122] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:03:59 sydtest0 kernel: [764341.233911] NMI backtrace for cpu 14
Nov 11 07:04:02 sydtest0 kernel: [764341.335475] CPU: 14 PID: 0 Comm: swapper/14 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:02 sydtest0 kernel: [764341.439647] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:02 sydtest0 kernel: [764341.543767] task: ffff88041dd8aa60 ti: ffff88041dda0000 task.ti: ffff88041dda0000
Nov 11 07:04:02 sydtest0 kernel: [764341.648421] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:02 sydtest0 kernel: [764341.754378] RSP: 0018:ffff88041dda1e88  EFLAGS: 00000286
Nov 11 07:04:02 sydtest0 kernel: [764341.859991] RAX: 00000000ffffffed RBX: ffff88041dda1fd8 RCX: 0140000000000000
Nov 11 07:04:02 sydtest0 kernel: [764341.966453] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fced620
Nov 11 07:04:02 sydtest0 kernel: [764342.071132] RBP: ffff88041dda1ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:02 sydtest0 kernel: [764342.173655] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda1fd8
Nov 11 07:04:02 sydtest0 kernel: [764342.276019] R13: 000000000000000e R14: ffff88041dda1fd8 R15: 0000000000000000
Nov 11 07:04:02 sydtest0 kernel: [764342.377478] FS:  0000000000000000(0000) GS:ffff88041fce0000(0000) knlGS:0000000000000000
Nov 11 07:04:02 sydtest0 kernel: [764342.478509] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:02 sydtest0 kernel: [764342.578582] CR2: 00000000023f9448 CR3: 000000037114b000 CR4: 00000000000407e0
Nov 11 07:04:02 sydtest0 kernel: [764342.678655] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:02 sydtest0 kernel: [764342.777584] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:02 sydtest0 kernel: [764342.875341] Stack:
Nov 11 07:04:02 sydtest0 kernel: [764342.972033]  ffff88041dda1fd8 ffff88041dda1fd8 ffff88041dda1fd8 ffff88041dda1fd8
Nov 11 07:04:02 sydtest0 kernel: [764343.071334]  ffff88041dda1eb8 ffffffff8100aace ffff88041dda1f28 ffffffff810754be
Nov 11 07:04:02 sydtest0 kernel: [764343.170422]  ffff88041dda1ee8 ffffffff8107c92b ffff88041fcecc40 0000000000000000
Nov 11 07:04:02 sydtest0 kernel: [764343.269378] Call Trace:
Nov 11 07:04:02 sydtest0 kernel: [764343.367058]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:02 sydtest0 kernel: [764343.465268]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:02 sydtest0 kernel: [764343.562946]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:02 sydtest0 kernel: [764343.661555]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:02 sydtest0 kernel: [764343.760721] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:02 sydtest0 kernel: [764343.968908] NMI backtrace for cpu 15
Nov 11 07:04:05 sydtest0 kernel: [764344.070665] CPU: 15 PID: 0 Comm: swapper/15 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:05 sydtest0 kernel: [764344.175103] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:05 sydtest0 kernel: [764344.279516] task: ffff88041dd8b170 ti: ffff88041dda2000 task.ti: ffff88041dda2000
Nov 11 07:04:05 sydtest0 kernel: [764344.384435] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:05 sydtest0 kernel: [764344.490658] RSP: 0018:ffff88041dda3e88  EFLAGS: 00000286
Nov 11 07:04:05 sydtest0 kernel: [764344.596535] RAX: 00000000ffffffed RBX: ffff88041dda3fd8 RCX: 0140000000000000
Nov 11 07:04:05 sydtest0 kernel: [764344.703264] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fced620
Nov 11 07:04:05 sydtest0 kernel: [764344.808183] RBP: ffff88041dda3ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:05 sydtest0 kernel: [764344.910864] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda3fd8
Nov 11 07:04:05 sydtest0 kernel: [764345.013388] R13: 000000000000000f R14: ffff88041dda3fd8 R15: 0000000000000000
Nov 11 07:04:05 sydtest0 kernel: [764345.115032] FS:  0000000000000000(0000) GS:ffff88082fce0000(0000) knlGS:0000000000000000
Nov 11 07:04:05 sydtest0 kernel: [764345.216224] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:05 sydtest0 kernel: [764345.316510] CR2: 00007f5064a3e000 CR3: 00000008004dc000 CR4: 00000000000407e0
Nov 11 07:04:05 sydtest0 kernel: [764345.416716] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:05 sydtest0 kernel: [764345.515725] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:05 sydtest0 kernel: [764345.613481] Stack:
Nov 11 07:04:05 sydtest0 kernel: [764345.710175]  ffff88041dda3fd8 ffff88041dda3fd8 ffff88041dda3fd8 ffff88041dda3fd8
Nov 11 07:04:05 sydtest0 kernel: [764345.809450]  ffff88041dda3eb8 ffffffff8100aace ffff88041dda3f28 ffffffff810754be
Nov 11 07:04:05 sydtest0 kernel: [764345.908538]  ffff88041dda3ee8 ffffffff8107c92b ffff88082fcecc40 0000000000000000
Nov 11 07:04:05 sydtest0 kernel: [764346.007547] Call Trace:
Nov 11 07:04:05 sydtest0 kernel: [764346.105204]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:05 sydtest0 kernel: [764346.203467]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:05 sydtest0 kernel: [764346.301251]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:05 sydtest0 kernel: [764346.399994]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:05 sydtest0 kernel: [764346.499240] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:05 sydtest0 kernel: [764346.707589] NMI backtrace for cpu 16
Nov 11 07:04:08 sydtest0 kernel: [764346.809420] CPU: 16 PID: 0 Comm: swapper/16 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:08 sydtest0 kernel: [764346.913831] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:08 sydtest0 kernel: [764347.018245] task: ffff88041dd8b880 ti: ffff88041dda4000 task.ti: ffff88041dda4000
Nov 11 07:04:08 sydtest0 kernel: [764347.123244] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:08 sydtest0 kernel: [764347.229468] RSP: 0018:ffff88041dda5e88  EFLAGS: 00000286
Nov 11 07:04:08 sydtest0 kernel: [764347.335319] RAX: 00000000ffffffed RBX: ffff88041dda5fd8 RCX: 0140000000000000
Nov 11 07:04:08 sydtest0 kernel: [764347.442075] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd0d620
Nov 11 07:04:08 sydtest0 kernel: [764347.546967] RBP: ffff88041dda5ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:08 sydtest0 kernel: [764347.649596] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda5fd8
Nov 11 07:04:08 sydtest0 kernel: [764347.752040] R13: 0000000000000010 R14: ffff88041dda5fd8 R15: 0000000000000000
Nov 11 07:04:08 sydtest0 kernel: [764347.853605] FS:  0000000000000000(0000) GS:ffff88041fd00000(0000) knlGS:0000000000000000
Nov 11 07:04:08 sydtest0 kernel: [764347.954716] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:08 sydtest0 kernel: [764348.054870] CR2: 0000003b0de7b160 CR3: 00000003a423e000 CR4: 00000000000407e0
Nov 11 07:04:08 sydtest0 kernel: [764348.155050] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:08 sydtest0 kernel: [764348.254112] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:08 sydtest0 kernel: [764348.351975] Stack:
Nov 11 07:04:08 sydtest0 kernel: [764348.448747]  ffff88041dda5fd8 ffff88041dda5fd8 ffff88041dda5fd8 ffff88041dda5fd8
Nov 11 07:04:08 sydtest0 kernel: [764348.548101]  ffff88041dda5eb8 ffffffff8100aace ffff88041dda5f28 ffffffff810754be
Nov 11 07:04:08 sydtest0 kernel: [764348.647163]  ffff88041dda5ee8 ffffffff8107c92b ffff88041fd0cc40 0000000000000000
Nov 11 07:04:08 sydtest0 kernel: [764348.746011] Call Trace:
Nov 11 07:04:08 sydtest0 kernel: [764348.843531]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:08 sydtest0 kernel: [764348.941608]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:08 sydtest0 kernel: [764349.039205]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:08 sydtest0 kernel: [764349.137761]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:08 sydtest0 kernel: [764349.236874] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:08 sydtest0 kernel: [764349.445008] NMI backtrace for cpu 17
Nov 11 07:04:08 sydtest0 ptpd[14045]: resetting system clock to 1384174960s 491761887ns
Nov 11 07:04:08 sydtest0 ptpd[14045]: clock stepped, off by -0.137181 seconds
Nov 11 07:04:10 sydtest0 kernel: [764349.546679] CPU: 17 PID: 0 Comm: swapper/17 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:10 sydtest0 kernel: [764349.650985] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:10 sydtest0 kernel: [764349.755265] task: ffff88041dd8bf90 ti: ffff88041dda6000 task.ti: ffff88041dda6000
Nov 11 07:04:10 sydtest0 kernel: [764349.860077] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:10 sydtest0 kernel: [764349.966194] RSP: 0018:ffff88041dda7e88  EFLAGS: 00000286
Nov 11 07:04:10 sydtest0 kernel: [764350.071939] RAX: 00000000ffffffed RBX: ffff88041dda7fd8 RCX: 0140000000000000
Nov 11 07:04:10 sydtest0 kernel: [764350.178614] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd0d620
Nov 11 07:04:10 sydtest0 kernel: [764350.283400] RBP: ffff88041dda7ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:10 sydtest0 kernel: [764350.385950] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda7fd8
Nov 11 07:04:10 sydtest0 kernel: [764350.488313] R13: 0000000000000011 R14: ffff88041dda7fd8 R15: 0000000000000000
Nov 11 07:04:10 sydtest0 kernel: [764350.589745] FS:  0000000000000000(0000) GS:ffff88082fd00000(0000) knlGS:0000000000000000
Nov 11 07:04:10 sydtest0 kernel: [764350.690750] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:10 sydtest0 kernel: [764350.790824] CR2: 0000003b0de16c4c CR3: 000000040c641000 CR4: 00000000000407e0
Nov 11 07:04:10 sydtest0 kernel: [764350.890845] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:10 sydtest0 kernel: [764350.989721] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:10 sydtest0 kernel: [764351.087425] Stack:
Nov 11 07:04:10 sydtest0 kernel: [764351.184037]  ffff88041dda7fd8 ffff88041dda7fd8 ffff88041dda7fd8 ffff88041dda7fd8
Nov 11 07:04:10 sydtest0 kernel: [764351.283258]  ffff88041dda7eb8 ffffffff8100aace ffff88041dda7f28 ffffffff810754be
Nov 11 07:04:10 sydtest0 kernel: [764351.382215]  ffff88041dda7ee8 ffffffff8107c92b ffff88082fd0cc40 0000000000000000
Nov 11 07:04:10 sydtest0 kernel: [764351.480984] Call Trace:
Nov 11 07:04:10 sydtest0 kernel: [764351.578399]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:10 sydtest0 kernel: [764351.676422]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:10 sydtest0 kernel: [764351.773993]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:10 sydtest0 kernel: [764351.872549]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:10 sydtest0 kernel: [764351.971692] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:10 sydtest0 kernel: [764352.179880] NMI backtrace for cpu 18
Nov 11 07:04:13 sydtest0 kernel: [764352.281605] CPU: 18 PID: 0 Comm: swapper/18 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:13 sydtest0 kernel: [764352.385937] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:13 sydtest0 kernel: [764352.490245] task: ffff88041dd8c6a0 ti: ffff88041dda8000 task.ti: ffff88041dda8000
Nov 11 07:04:13 sydtest0 kernel: [764352.595110] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:13 sydtest0 kernel: [764352.701254] RSP: 0018:ffff88041dda9e88  EFLAGS: 00000286
Nov 11 07:04:13 sydtest0 kernel: [764352.807052] RAX: 00000000ffffffed RBX: ffff88041dda9fd8 RCX: 0140000000000000
Nov 11 07:04:13 sydtest0 kernel: [764352.913675] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd2d620
Nov 11 07:04:13 sydtest0 kernel: [764353.018488] RBP: ffff88041dda9ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:13 sydtest0 kernel: [764353.121091] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041dda9fd8
Nov 11 07:04:13 sydtest0 kernel: [764353.223534] R13: 0000000000000012 R14: ffff88041dda9fd8 R15: 0000000000000000
Nov 11 07:04:13 sydtest0 kernel: [764353.325099] FS:  0000000000000000(0000) GS:ffff88041fd20000(0000) knlGS:0000000000000000
Nov 11 07:04:13 sydtest0 kernel: [764353.426211] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:13 sydtest0 kernel: [764353.526364] CR2: 0000003b0de7b160 CR3: 000000040cf75000 CR4: 00000000000407e0
Nov 11 07:04:13 sydtest0 kernel: [764353.626545] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:13 sydtest0 kernel: [764353.725606] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:13 sydtest0 kernel: [764353.823443] Stack:
Nov 11 07:04:13 sydtest0 kernel: [764353.920216]  ffff88041dda9fd8 ffff88041dda9fd8 ffff88041dda9fd8 ffff88041dda9fd8
Nov 11 07:04:13 sydtest0 kernel: [764354.019623]  ffff88041dda9eb8 ffffffff8100aace ffff88041dda9f28 ffffffff810754be
Nov 11 07:04:13 sydtest0 kernel: [764354.118845]  ffff88041dda9ee8 ffffffff8107c92b ffff88041fd2cc40 0000000000000000
Nov 11 07:04:13 sydtest0 kernel: [764354.217854] Call Trace:
Nov 11 07:04:13 sydtest0 kernel: [764354.315507]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:13 sydtest0 kernel: [764354.413770]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:13 sydtest0 kernel: [764354.511500]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:13 sydtest0 kernel: [764354.610110]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:13 sydtest0 kernel: [764354.709250] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:13 sydtest0 kernel: [764354.917410] NMI backtrace for cpu 19
Nov 11 07:04:16 sydtest0 kernel: [764355.019189] CPU: 19 PID: 0 Comm: swapper/19 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:16 sydtest0 kernel: [764355.123681] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:16 sydtest0 kernel: [764355.228148] task: ffff88041dd8cdb0 ti: ffff88041ddaa000 task.ti: ffff88041ddaa000
Nov 11 07:04:16 sydtest0 kernel: [764355.333172] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:16 sydtest0 kernel: [764355.439475] RSP: 0018:ffff88041ddabe88  EFLAGS: 00000286
Nov 11 07:04:16 sydtest0 kernel: [764355.545352] RAX: 00000000ffffffed RBX: ffff88041ddabfd8 RCX: 0140000000000000
Nov 11 07:04:16 sydtest0 kernel: [764355.652108] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd2d620
Nov 11 07:04:16 sydtest0 kernel: [764355.757026] RBP: ffff88041ddabea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:16 sydtest0 kernel: [764355.859707] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddabfd8
Nov 11 07:04:16 sydtest0 kernel: [764355.962257] R13: 0000000000000013 R14: ffff88041ddabfd8 R15: 0000000000000000
Nov 11 07:04:16 sydtest0 kernel: [764356.063928] FS:  0000000000000000(0000) GS:ffff88082fd20000(0000) knlGS:0000000000000000
Nov 11 07:04:16 sydtest0 kernel: [764356.165173] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:16 sydtest0 kernel: [764356.265514] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:04:16 sydtest0 kernel: [764356.365774] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:16 sydtest0 kernel: [764356.464863] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:16 sydtest0 kernel: [764356.562672] Stack:
Nov 11 07:04:16 sydtest0 kernel: [764356.659445]  ffff88041ddabfd8 ffff88041ddabfd8 ffff88041ddabfd8 ffff88041ddabfd8
Nov 11 07:04:16 sydtest0 kernel: [764356.758852]  ffff88041ddabeb8 ffffffff8100aace ffff88041ddabf28 ffffffff810754be
Nov 11 07:04:16 sydtest0 kernel: [764356.858048]  ffff88041ddabee8 ffffffff8107c92b ffff88082fd2cc40 0000000000000000
Nov 11 07:04:16 sydtest0 kernel: [764356.957057] Call Trace:
Nov 11 07:04:16 sydtest0 kernel: [764357.054685]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:16 sydtest0 kernel: [764357.152947]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:16 sydtest0 kernel: [764357.250731]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:16 sydtest0 kernel: [764357.349449]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:16 sydtest0 kernel: [764357.448720] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:16 sydtest0 kernel: [764357.657146] NMI backtrace for cpu 20
Nov 11 07:04:19 sydtest0 kernel: [764357.758977] CPU: 20 PID: 0 Comm: swapper/20 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:19 sydtest0 kernel: [764357.863443] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:19 sydtest0 kernel: [764357.967908] task: ffff88041dd8d4c0 ti: ffff88041ddac000 task.ti: ffff88041ddac000
Nov 11 07:04:19 sydtest0 kernel: [764358.072880] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:19 sydtest0 kernel: [764358.179183] RSP: 0018:ffff88041ddade88  EFLAGS: 00000286
Nov 11 07:04:19 sydtest0 kernel: [764358.285086] RAX: 00000000ffffffed RBX: ffff88041ddadfd8 RCX: 0140000000000000
Nov 11 07:04:19 sydtest0 kernel: [764358.391841] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd4d620
Nov 11 07:04:19 sydtest0 kernel: [764358.496760] RBP: ffff88041ddadea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:19 sydtest0 kernel: [764358.599442] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddadfd8
Nov 11 07:04:19 sydtest0 kernel: [764358.701939] R13: 0000000000000014 R14: ffff88041ddadfd8 R15: 0000000000000000
Nov 11 07:04:19 sydtest0 kernel: [764358.803556] FS:  0000000000000000(0000) GS:ffff88041fd40000(0000) knlGS:0000000000000000
Nov 11 07:04:19 sydtest0 kernel: [764358.904748] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:19 sydtest0 kernel: [764359.004980] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:04:19 sydtest0 kernel: [764359.105160] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:19 sydtest0 kernel: [764359.204142] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:19 sydtest0 kernel: [764359.301925] Stack:
Nov 11 07:04:19 sydtest0 kernel: [764359.398619]  ffff88041ddadfd8 ffff88041ddadfd8 ffff88041ddadfd8 ffff88041ddadfd8
Nov 11 07:04:19 sydtest0 kernel: [764359.497893]  ffff88041ddadeb8 ffffffff8100aace ffff88041ddadf28 ffffffff810754be
Nov 11 07:04:19 sydtest0 kernel: [764359.596903]  ffff88041ddadee8 ffffffff8107c92b ffff88041fd4cc40 0000000000000000
Nov 11 07:04:19 sydtest0 kernel: [764359.695672] Call Trace:
Nov 11 07:04:19 sydtest0 kernel: [764359.793087]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:19 sydtest0 kernel: [764359.891083]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:19 sydtest0 kernel: [764359.988547]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:19 sydtest0 kernel: [764360.086970]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:19 sydtest0 kernel: [764360.186004] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:19 sydtest0 kernel: [764360.393899] NMI backtrace for cpu 21
Nov 11 07:04:21 sydtest0 sshd[15143]: Accepted publickey for hbi from 10.16.8.104 port 48390 ssh2
Nov 11 07:04:21 sydtest0 kernel: [764360.495417] CPU: 21 PID: 0 Comm: swapper/21 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:21 sydtest0 kernel: [764360.599589] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:21 sydtest0 kernel: [764360.703762] task: ffff88041dd8dbd0 ti: ffff88041ddae000 task.ti: ffff88041ddae000
Nov 11 07:04:21 sydtest0 kernel: [764360.808494] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:21 sydtest0 kernel: [764360.914505] RSP: 0018:ffff88041ddafe88  EFLAGS: 00000286
Nov 11 07:04:21 sydtest0 kernel: [764361.020197] RAX: 00000000ffffffed RBX: ffff88041ddaffd8 RCX: 0140000000000000
Nov 11 07:04:21 sydtest0 kernel: [764361.126819] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd4d620
Nov 11 07:04:21 sydtest0 kernel: [764361.231578] RBP: ffff88041ddafea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:21 sydtest0 kernel: [764361.334128] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddaffd8
Nov 11 07:04:21 sydtest0 kernel: [764361.436466] R13: 0000000000000015 R14: ffff88041ddaffd8 R15: 0000000000000000
Nov 11 07:04:21 sydtest0 kernel: [764361.537897] FS:  0000000000000000(0000) GS:ffff88082fd40000(0000) knlGS:0000000000000000
Nov 11 07:04:21 sydtest0 kernel: [764361.638902] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:21 sydtest0 kernel: [764361.738977] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:04:21 sydtest0 kernel: [764361.838943] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:21 sydtest0 kernel: [764361.937739] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:21 sydtest0 kernel: [764362.035309] Stack:
Nov 11 07:04:21 sydtest0 kernel: [764362.131789]  ffff88041ddaffd8 ffff88041ddaffd8 ffff88041ddaffd8 ffff88041ddaffd8
Nov 11 07:04:21 sydtest0 kernel: [764362.230851]  ffff88041ddafeb8 ffffffff8100aace ffff88041ddaff28 ffffffff810754be
Nov 11 07:04:21 sydtest0 kernel: [764362.329672]  ffff88041ddafee8 ffffffff8107c92b ffff88082fd4cc40 0000000000000000
Nov 11 07:04:21 sydtest0 kernel: [764362.428362] Call Trace:
Nov 11 07:04:21 sydtest0 kernel: [764362.525649]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:21 sydtest0 kernel: [764362.623513]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:21 sydtest0 kernel: [764362.720951]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:21 sydtest0 kernel: [764362.819381]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:21 sydtest0 kernel: [764362.918360] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:21 sydtest0 kernel: [764363.126148] NMI backtrace for cpu 22
Nov 11 07:04:24 sydtest0 kernel: [764363.227687] CPU: 22 PID: 0 Comm: swapper/22 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:24 sydtest0 kernel: [764363.331859] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:24 sydtest0 kernel: [764363.436059] task: ffff88041dd8e2e0 ti: ffff88041ddb8000 task.ti: ffff88041ddb8000
Nov 11 07:04:24 sydtest0 kernel: [764363.540711] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:24 sydtest0 kernel: [764363.646669] RSP: 0018:ffff88041ddb9e88  EFLAGS: 00000286
Nov 11 07:04:24 sydtest0 kernel: [764363.752254] RAX: 00000000ffffffed RBX: ffff88041ddb9fd8 RCX: 0140000000000000
Nov 11 07:04:24 sydtest0 kernel: [764363.858690] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd6d620
Nov 11 07:04:24 sydtest0 kernel: [764363.963262] RBP: ffff88041ddb9ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:24 sydtest0 kernel: [764364.065652] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddb9fd8
Nov 11 07:04:24 sydtest0 kernel: [764364.167882] R13: 0000000000000016 R14: ffff88041ddb9fd8 R15: 0000000000000000
Nov 11 07:04:24 sydtest0 kernel: [764364.269208] FS:  0000000000000000(0000) GS:ffff88041fd60000(0000) knlGS:0000000000000000
Nov 11 07:04:24 sydtest0 kernel: [764364.370080] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:24 sydtest0 kernel: [764364.470047] CR2: 0000003b0de7b160 CR3: 000000040eeb1000 CR4: 00000000000407e0
Nov 11 07:04:24 sydtest0 kernel: [764364.569908] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:24 sydtest0 kernel: [764364.668730] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:24 sydtest0 kernel: [764364.766353] Stack:
Nov 11 07:04:24 sydtest0 kernel: [764364.862887]  ffff88041ddb9fd8 ffff88041ddb9fd8 ffff88041ddb9fd8 ffff88041ddb9fd8
Nov 11 07:04:24 sydtest0 kernel: [764364.962028]  ffff88041ddb9eb8 ffffffff8100aace ffff88041ddb9f28 ffffffff810754be
Nov 11 07:04:24 sydtest0 kernel: [764365.060904]  ffff88041ddb9ee8 ffffffff8107c92b ffff88041fd6cc40 0000000000000000
Nov 11 07:04:24 sydtest0 kernel: [764365.159567] Call Trace:
Nov 11 07:04:24 sydtest0 kernel: [764365.256901]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:24 sydtest0 kernel: [764365.354819]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:24 sydtest0 kernel: [764365.452282]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:24 sydtest0 kernel: [764365.550732]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:24 sydtest0 kernel: [764365.649737] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:24 sydtest0 kernel: [764365.857526] NMI backtrace for cpu 23
Nov 11 07:04:27 sydtest0 kernel: [764365.959013] CPU: 23 PID: 0 Comm: swapper/23 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:27 sydtest0 kernel: [764366.063184] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:27 sydtest0 kernel: [764366.167385] task: ffff88041dd8e9f0 ti: ffff88041ddbc000 task.ti: ffff88041ddbc000
Nov 11 07:04:27 sydtest0 kernel: [764366.272091] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:27 sydtest0 kernel: [764366.378155] RSP: 0018:ffff88041ddbde88  EFLAGS: 00000286
Nov 11 07:04:27 sydtest0 kernel: [764366.483819] RAX: 00000000ffffffed RBX: ffff88041ddbdfd8 RCX: 0140000000000000
Nov 11 07:04:27 sydtest0 kernel: [764366.590308] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd6d620
Nov 11 07:04:27 sydtest0 kernel: [764366.694987] RBP: ffff88041ddbdea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:27 sydtest0 kernel: [764366.797457] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddbdfd8
Nov 11 07:04:27 sydtest0 kernel: [764366.899741] R13: 0000000000000017 R14: ffff88041ddbdfd8 R15: 0000000000000000
Nov 11 07:04:27 sydtest0 kernel: [764367.001146] FS:  0000000000000000(0000) GS:ffff88082fd60000(0000) knlGS:0000000000000000
Nov 11 07:04:27 sydtest0 kernel: [764367.102151] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:27 sydtest0 kernel: [764367.202170] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:04:27 sydtest0 kernel: [764367.302084] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:27 sydtest0 kernel: [764367.400800] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:27 sydtest0 kernel: [764367.498264] Stack:
Nov 11 07:04:27 sydtest0 kernel: [764367.594664]  ffff88041ddbdfd8 ffff88041ddbdfd8 ffff88041ddbdfd8 ffff88041ddbdfd8
Nov 11 07:04:27 sydtest0 kernel: [764367.693592]  ffff88041ddbdeb8 ffffffff8100aace ffff88041ddbdf28 ffffffff810754be
Nov 11 07:04:27 sydtest0 kernel: [764367.792308]  ffff88041ddbdee8 ffffffff8107c92b ffff88082fd6cc40 0000000000000000
Nov 11 07:04:27 sydtest0 kernel: [764367.890864] Call Trace:
Nov 11 07:04:27 sydtest0 kernel: [764367.988065]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:27 sydtest0 kernel: [764368.085849]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:27 sydtest0 kernel: [764368.183261]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:27 sydtest0 kernel: [764368.281685]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:27 sydtest0 kernel: [764368.380663] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:27 sydtest0 kernel: [764368.588505] NMI backtrace for cpu 24
Nov 11 07:04:30 sydtest0 kernel: [764368.690069] CPU: 24 PID: 0 Comm: swapper/24 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:30 sydtest0 kernel: [764368.794240] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:30 sydtest0 kernel: [764368.898415] task: ffff88041dd8f100 ti: ffff88041ddbe000 task.ti: ffff88041ddbe000
Nov 11 07:04:30 sydtest0 kernel: [764369.003120] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:30 sydtest0 kernel: [764369.109131] RSP: 0018:ffff88041ddbfe88  EFLAGS: 00000286
Nov 11 07:04:30 sydtest0 kernel: [764369.214741] RAX: 00000000ffffffed RBX: ffff88041ddbffd8 RCX: 0140000000000000
Nov 11 07:04:30 sydtest0 kernel: [764369.321204] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fd8d620
Nov 11 07:04:30 sydtest0 kernel: [764369.425856] RBP: ffff88041ddbfea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:30 sydtest0 kernel: [764369.528273] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddbffd8
Nov 11 07:04:30 sydtest0 kernel: [764369.630503] R13: 0000000000000018 R14: ffff88041ddbffd8 R15: 0000000000000000
Nov 11 07:04:30 sydtest0 kernel: [764369.731855] FS:  0000000000000000(0000) GS:ffff88041fd80000(0000) knlGS:0000000000000000
Nov 11 07:04:30 sydtest0 kernel: [764369.832726] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:30 sydtest0 kernel: [764369.932719] CR2: 0000003b0de7b160 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:04:30 sydtest0 kernel: [764370.032580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:30 sydtest0 kernel: [764370.131323] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:30 sydtest0 kernel: [764370.228840] Stack:
Nov 11 07:04:30 sydtest0 kernel: [764370.325319]  ffff88041ddbffd8 ffff88041ddbffd8 ffff88041ddbffd8 ffff88041ddbffd8
Nov 11 07:04:30 sydtest0 kernel: [764370.424382]  ffff88041ddbfeb8 ffffffff8100aace ffff88041ddbff28 ffffffff810754be
Nov 11 07:04:30 sydtest0 kernel: [764370.523178]  ffff88041ddbfee8 ffffffff8107c92b ffff88041fd8cc40 0000000000000000
Nov 11 07:04:30 sydtest0 kernel: [764370.621789] Call Trace:
Nov 11 07:04:30 sydtest0 kernel: [764370.719044]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:30 sydtest0 kernel: [764370.816880]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:30 sydtest0 kernel: [764370.914266]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:30 sydtest0 kernel: [764371.012529]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:30 sydtest0 kernel: [764371.111376] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:30 sydtest0 kernel: [764371.318978] NMI backtrace for cpu 25
Nov 11 07:04:32 sydtest0 kernel: [764371.420463] CPU: 25 PID: 0 Comm: swapper/25 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:32 sydtest0 kernel: [764371.524608] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:32 sydtest0 kernel: [764371.628702] task: ffff88041dd8f810 ti: ffff88041ddc0000 task.ti: ffff88041ddc0000
Nov 11 07:04:32 sydtest0 kernel: [764371.733302] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:32 sydtest0 kernel: [764371.839126] RSP: 0018:ffff88041ddc1e88  EFLAGS: 00000286
Nov 11 07:04:32 sydtest0 kernel: [764371.944577] RAX: 00000000ffffffed RBX: ffff88041ddc1fd8 RCX: 0140000000000000
Nov 11 07:04:32 sydtest0 kernel: [764372.050934] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fd8d620
Nov 11 07:04:32 sydtest0 kernel: [764372.155506] RBP: ffff88041ddc1ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:32 sydtest0 kernel: [764372.257921] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddc1fd8
Nov 11 07:04:32 sydtest0 kernel: [764372.360178] R13: 0000000000000019 R14: ffff88041ddc1fd8 R15: 0000000000000000
Nov 11 07:04:32 sydtest0 kernel: [764372.461583] FS:  0000000000000000(0000) GS:ffff88082fd80000(0000) knlGS:0000000000000000
Nov 11 07:04:32 sydtest0 kernel: [764372.562482] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:32 sydtest0 kernel: [764372.662448] CR2: 0000003b0de16c4c CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:04:32 sydtest0 kernel: [764372.762282] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:32 sydtest0 kernel: [764372.860971] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:32 sydtest0 kernel: [764372.958436] Stack:
Nov 11 07:04:32 sydtest0 kernel: [764373.054836]  ffff88041ddc1fd8 ffff88041ddc1fd8 ffff88041ddc1fd8 ffff88041ddc1fd8
Nov 11 07:04:32 sydtest0 kernel: [764373.153818]  ffff88041ddc1eb8 ffffffff8100aace ffff88041ddc1f28 ffffffff810754be
Nov 11 07:04:32 sydtest0 kernel: [764373.252560]  ffff88041ddc1ee8 ffffffff8107c92b ffff88082fd8cc40 0000000000000000
Nov 11 07:04:32 sydtest0 kernel: [764373.351143] Call Trace:
Nov 11 07:04:32 sydtest0 kernel: [764373.448345]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:32 sydtest0 kernel: [764373.546155]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:32 sydtest0 kernel: [764373.643539]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:32 sydtest0 kernel: [764373.741910]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:32 sydtest0 kernel: [764373.840836] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:32 sydtest0 kernel: [764374.048624] NMI backtrace for cpu 29
Nov 11 07:04:35 sydtest0 kernel: [764374.150162] CPU: 29 PID: 0 Comm: swapper/29 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:35 sydtest0 kernel: [764374.254334] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:35 sydtest0 kernel: [764374.358482] task: ffff88041ddc9530 ti: ffff88041ddd0000 task.ti: ffff88041ddd0000
Nov 11 07:04:35 sydtest0 kernel: [764374.463160] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:35 sydtest0 kernel: [764374.569117] RSP: 0018:ffff88041ddd1e88  EFLAGS: 00000286
Nov 11 07:04:35 sydtest0 kernel: [764374.674675] RAX: 00000000ffffffed RBX: ffff88041ddd1fd8 RCX: 0140000000000000
Nov 11 07:04:35 sydtest0 kernel: [764374.781112] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fdcd620
Nov 11 07:04:35 sydtest0 kernel: [764374.885738] RBP: ffff88041ddd1ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:35 sydtest0 kernel: [764374.988128] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddd1fd8
Nov 11 07:04:35 sydtest0 kernel: [764375.090331] R13: 000000000000001d R14: ffff88041ddd1fd8 R15: 0000000000000000
Nov 11 07:04:35 sydtest0 kernel: [764375.191684] FS:  0000000000000000(0000) GS:ffff88082fdc0000(0000) knlGS:0000000000000000
Nov 11 07:04:35 sydtest0 kernel: [764375.292609] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:35 sydtest0 kernel: [764375.392576] CR2: 0000003b0debd790 CR3: 000000078ec19000 CR4: 00000000000407e0
Nov 11 07:04:35 sydtest0 kernel: [764375.492516] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:35 sydtest0 kernel: [764375.591339] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:35 sydtest0 kernel: [764375.688964] Stack:
Nov 11 07:04:35 sydtest0 kernel: [764375.785524]  ffff88041ddd1fd8 ffff88041ddd1fd8 ffff88041ddd1fd8 ffff88041ddd1fd8
Nov 11 07:04:35 sydtest0 kernel: [764375.884665]  ffff88041ddd1eb8 ffffffff8100aace ffff88041ddd1f28 ffffffff810754be
Nov 11 07:04:35 sydtest0 kernel: [764375.983566]  ffff88041ddd1ee8 ffffffff8107c92b ffff88082fdccc40 0000000000000000
Nov 11 07:04:35 sydtest0 kernel: [764376.082282] Call Trace:
Nov 11 07:04:35 sydtest0 kernel: [764376.179697]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:35 sydtest0 kernel: [764376.277720]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:35 sydtest0 kernel: [764376.375343]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:35 sydtest0 kernel: [764376.473901]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:35 sydtest0 kernel: [764376.573013] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:35 sydtest0 kernel: [764376.781042] NMI backtrace for cpu 30
Nov 11 07:04:36 sydtest0 sshd[15275]: Accepted publickey for timecheck from 10.0.4.17 port 36799 ssh2
Nov 11 07:04:42 sydtest0 kernel: [764376.882740] CPU: 30 PID: 0 Comm: swapper/30 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:42 sydtest0 kernel: [764376.987072] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:42 sydtest0 kernel: [764377.091379] task: ffff88041ddc9c40 ti: ffff88041ddd2000 task.ti: ffff88041ddd2000
Nov 11 07:04:42 sydtest0 kernel: [764377.196192] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:42 sydtest0 kernel: [764377.302283] RSP: 0018:ffff88041ddd3e88  EFLAGS: 00000286
Nov 11 07:04:42 sydtest0 kernel: [764377.408027] RAX: 00000000ffffffed RBX: ffff88041ddd3fd8 RCX: 0140000000000000
Nov 11 07:04:42 sydtest0 kernel: [764377.514596] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88041fded620
Nov 11 07:04:42 sydtest0 kernel: [764377.619329] RBP: ffff88041ddd3ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764377.721825] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddd3fd8
Nov 11 07:04:42 sydtest0 kernel: [764377.824135] R13: 000000000000001e R14: ffff88041ddd3fd8 R15: 0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764377.925512] FS:  0000000000000000(0000) GS:ffff88041fde0000(0000) knlGS:0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764378.026465] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:42 sydtest0 kernel: [764378.126539] CR2: 0000000001f07448 CR3: 0000000001a0b000 CR4: 00000000000407e0
Nov 11 07:04:42 sydtest0 kernel: [764378.226559] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764378.325301] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:42 sydtest0 kernel: [764378.422819] Stack:
Nov 11 07:04:42 sydtest0 kernel: [764378.519219]  ffff88041ddd3fd8 ffff88041ddd3fd8 ffff88041ddd3fd8 ffff88041ddd3fd8
Nov 11 07:04:42 sydtest0 kernel: [764378.618200]  ffff88041ddd3eb8 ffffffff8100aace ffff88041ddd3f28 ffffffff810754be
Nov 11 07:04:42 sydtest0 kernel: [764378.716916]  ffff88041ddd3ee8 ffffffff8107c92b ffff88041fdecc40 0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764378.815393] Call Trace:
Nov 11 07:04:42 sydtest0 kernel: [764378.912540]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:42 sydtest0 kernel: [764379.010299]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:42 sydtest0 kernel: [764379.107682]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:42 sydtest0 kernel: [764379.206053]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
Nov 11 07:04:42 sydtest0 kernel: [764379.381853] BUG: soft lockup - CPU#0 stuck for 22s! [ptpd:14045]
Nov 11 07:04:42 sydtest0 kernel: [764379.304981] Code: a1 05 00 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 65 44 8b 2c 25 64 b0 00 00 66 66 66 66 90 fb f4 <65> 44 8b 
Nov 11 07:04:42 sydtest0 kernel: [764379.381854] Modules linked in: mpt2sas scsi_transport_sas raid_class dell_rbu ipmi_devintf ipmi_si ipmi_msghandler lockd 8021q mrp garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ext4 jbd2 mbcache fuse mlx4_ib ib_sa ib_mad ib_core mlx4_en igb dca i2c_algo_bit i2c_core mlx4_core ptp iTCO_wdt iTCO_vendor_support pps_core ehci_pci coretemp hwmon freq_table lpc_ich mfd_core ehci_hcd mperf sb_edac wmi dcdbas edac_core microcode sunrpc ipv6 autofs4 crc32c_intel aesni_intel ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci libata megaraid_sas dm_mirror dm_region_hash dm_log dm_mod
Nov 11 07:04:42 sydtest0 kernel: [764379.381886] CPU: 0 PID: 14045 Comm: ptpd Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:42 sydtest0 kernel: [764379.381887] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:42 sydtest0 kernel: [764379.381888] task: ffff8808105d62e0 ti: ffff8807d0afa000 task.ti: ffff8807d0afa000
Nov 11 07:04:42 sydtest0 kernel: [764379.381888] RIP: 0010:[<ffffffff810834fe>]  [<ffffffff810834fe>] smp_call_function_many+0x26e/0x2d0
Nov 11 07:04:42 sydtest0 kernel: [764379.381891] RSP: 0018:ffff8807d0afbdf8  EFLAGS: 00000202
Nov 11 07:04:42 sydtest0 kernel: [764379.381892] RAX: 000000000000001e RBX: ffffffff81abcf00 RCX: ffff88041fdf5d48
Nov 11 07:04:42 sydtest0 kernel: [764379.381892] RDX: 000000000000001e RSI: 0000000000000100 RDI: 0000000000000100
Nov 11 07:04:42 sydtest0 kernel: [764379.381893] RBP: ffff8807d0afbe58 R08: ffff88041fc13648 R09: 0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764379.381894] R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000296
Nov 11 07:04:42 sydtest0 kernel: [764379.381894] R13: 000000000000002c R14: 00007fffee4934a0 R15: 0000000000000040
Nov 11 07:04:42 sydtest0 kernel: [764379.381895] FS:  00007fc28c07a700(0000) GS:ffff88041fc00000(0000) knlGS:0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764379.381896] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:42 sydtest0 kernel: [764379.381896] CR2: 000000000163c448 CR3: 00000007f0ae3000 CR4: 00000000000407f0
Nov 11 07:04:42 sydtest0 kernel: [764379.381897] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764379.381897] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:42 sydtest0 kernel: [764379.381897] Stack:
Nov 11 07:04:42 sydtest0 kernel: [764379.381898]  ffff88082fdf3610 ffff88082fdf3600 ffff88082fdf5d48 ffffffff0000001f
Nov 11 07:04:42 sydtest0 kernel: [764379.381900]  01ff880700000010 ffff88041fc13668 000000000000002c ffffffff81062480
Nov 11 07:04:42 sydtest0 kernel: [764379.381902]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Nov 11 07:04:42 sydtest0 kernel: [764379.381904] Call Trace:
Nov 11 07:04:42 sydtest0 kernel: [764379.381905]  [<ffffffff81062480>] ? hrtimer_cancel+0x30/0x30
Nov 11 07:04:42 sydtest0 kernel: [764379.381908]  [<ffffffff810835e2>] smp_call_function+0x22/0x30
Nov 11 07:04:42 sydtest0 kernel: [764379.381910]  [<ffffffff81083648>] on_each_cpu+0x28/0x50
Nov 11 07:04:42 sydtest0 kernel: [764379.381912]  [<ffffffff8106272c>] clock_was_set+0x1c/0x30
Nov 11 07:04:42 sydtest0 kernel: [764379.381913]  [<ffffffff8107701e>] do_settimeofday+0xfe/0x110
Nov 11 07:04:42 sydtest0 kernel: [764379.381916]  [<ffffffff8104244d>] do_sys_settimeofday+0xdd/0xf0
Nov 11 07:04:42 sydtest0 kernel: [764379.381918]  [<ffffffff813f6fe9>] ? __sys_recvmsg+0x49/0x90
Nov 11 07:04:42 sydtest0 kernel: [764379.381921]  [<ffffffff8105d513>] posix_clock_realtime_set+0x13/0x20
Nov 11 07:04:42 sydtest0 kernel: [764379.381923]  [<ffffffff8105e55f>] SyS_clock_settime+0x5f/0x90
Nov 11 07:04:42 sydtest0 kernel: [764379.381924]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
Nov 11 07:04:42 sydtest0 kernel: [764379.381927] Code: 48 63 d0 e8 15 c1 1e 00 3b 05 f7 9a a3 00 0f 8d 15 fe ff ff 48 63 d0 49 8b 0c 24 48 03 0c d5 e0 b3 ab 81 f6 41 20 01 74 cc f3 90 <f6> 41 20 01 74 c4 eb f6 0f b6 4d c7 4c 89 f2 4c 89 ee 89 df e8 
Nov 11 07:04:42 sydtest0 kernel: [764383.513019] 2c 25 64 b0 00 00 66 66 66 66 90 5b 41 5c 41 5d 41 5e 
Nov 11 07:04:42 sydtest0 kernel: [764383.724376] NMI backtrace for cpu 31
Nov 11 07:04:45 sydtest0 kernel: [764383.828526] CPU: 31 PID: 0 Comm: swapper/31 Tainted: G        W    3.10.16-1.rgm.fc16.x86_64 #1
Nov 11 07:04:45 sydtest0 kernel: [764383.934321] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS 1.6.0 03/07/2013
Nov 11 07:04:45 sydtest0 kernel: [764384.039933] task: ffff88041ddca350 ti: ffff88041ddd4000 task.ti: ffff88041ddd4000
Nov 11 07:04:45 sydtest0 kernel: [764384.145570] RIP: 0010:[<ffffffff8100a300>]  [<ffffffff8100a300>] default_idle+0x20/0xe0
Nov 11 07:04:45 sydtest0 kernel: [764384.251874] RSP: 0018:ffff88041ddd5e88  EFLAGS: 00000286
Nov 11 07:04:45 sydtest0 kernel: [764384.357831] RAX: 00000000ffffffed RBX: ffff88041ddd5fd8 RCX: 0140000000000000
Nov 11 07:04:45 sydtest0 kernel: [764384.464799] RDX: 0000000000000000 RSI: 0140000000000000 RDI: ffff88082fded620
Nov 11 07:04:45 sydtest0 kernel: [764384.571955] RBP: ffff88041ddd5ea8 R08: 0000000000000000 R09: 0000000000000000
Nov 11 07:04:45 sydtest0 kernel: [764384.679217] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88041ddd5fd8
Nov 11 07:04:45 sydtest0 kernel: [764384.786079] R13: 000000000000001f R14: ffff88041ddd5fd8 R15: 0000000000000000
Nov 11 07:04:45 sydtest0 kernel: [764384.892383] FS:  0000000000000000(0000) GS:ffff88082fde0000(0000) knlGS:0000000000000000
Nov 11 07:04:45 sydtest0 kernel: [764384.999006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 11 07:04:45 sydtest0 kernel: [764385.106000] CR2: 00000000015bc448 CR3: 00000007f62dc000 CR4: 00000000000407e0
Nov 11 07:04:45 sydtest0 kernel: [764385.214646] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 11 07:04:45 sydtest0 kernel: [764385.322281] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 11 07:04:45 sydtest0 kernel: [764385.428504] Stack:
Nov 11 07:04:45 sydtest0 kernel: [764385.534089]  ffff88041ddd5fd8 ffff88041ddd5fd8 ffff88041ddd5fd8 ffff88041ddd5fd8
Nov 11 07:04:45 sydtest0 kernel: [764385.642576]  ffff88041ddd5eb8 ffffffff8100aace ffff88041ddd5f28 ffffffff810754be
Nov 11 07:04:45 sydtest0 kernel: [764385.750049]  ffff88041ddd5ee8 ffffffff8107c92b ffff88082fdecc40 0000000000000000
Nov 11 07:04:45 sydtest0 kernel: [764385.857151] Call Trace:
Nov 11 07:04:45 sydtest0 kernel: [764385.963406]  [<ffffffff8100aace>] arch_cpu_idle+0x1e/0x30
Nov 11 07:04:45 sydtest0 kernel: [764386.070561]  [<ffffffff810754be>] cpu_startup_entry+0xae/0x270
Nov 11 07:04:45 sydtest0 kernel: [764386.177557]  [<ffffffff8107c92b>] ? clockevents_register_device+0xdb/0x140
Nov 11 07:04:45 sydtest0 kernel: [764386.283036]  [<ffffffff81b21e1d>] start_secondary+0x266/0x268
