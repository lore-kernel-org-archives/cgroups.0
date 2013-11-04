From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 4 Nov 2013 12:00:20 +0100
Message-ID: <CA+SBX_NjAYrqqOpSuCy8Wpj6q1hE_qdLrRV6auydmJjdcHKQHg@mail.gmail.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de>
	<5257F7CE.90702@huawei.com>
	<CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com>
	<5258E584.70500@huawei.com>
	<CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
	<525CB337.8050105@huawei.com>
	<CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
	<CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
	<5270BFE7.4000602@huawei.com>
	<alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
	<20131031130647.0ff6f2c7@gandalf.local.home>
	<alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
	<20131031192732.2dbb14b3@gandalf.local.home>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=+ToFh1l+spu7e6a+FTyaSqWtamOqgvC+YYcix+varT0=;
        b=JObUjCqTOoN0yGT63Ma7NIcdhXhtvLzHxE+D4PTupjW5nVRHCBic+XxyE/vTFL+Mg9
         F8M4pY+3DFdDR09pvDtUhPCzPfEZ76Jj+1aqEUkG35GwkRY4AYLGRqS7VbWTwoFlfvNf
         qHG8LeZY8aaziGWwjA3pMO2oAfu9x6vpNihs/EQilj7zx7LG1D/yN+UwCrtz5K9kbB0q
         pHQ6OwmqT5ZCp+Kz25YsOxgdDZa4Ul2Zw0mHoWpYLLVZDo12p4xhVX96Dnk8FB9hHMWK
         dfmvgYAuW/sn+/3j7YL44rnoeE4npER9hbtfqxQbGGJ1/RaqJ68dG/Jc/cwDal9avAP2
         h5Dg==
In-Reply-To: <20131031192732.2dbb14b3-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I am sorry, but kdump crash files are difficult to obtain on our
systems, since we are using nfsroot on diskless clients. Is there any
possibility to see, why "synchronize_rcu" is actually waiting? I tried
looking through the code but did not get very far. In any case, I am
appending current stack dumps from kernel 3.11.6. With lockdep
enabled, there were also no additional warnings in the kernel log.

The thread with "mem_cgroup_reparent_charges" is hanging at synchronize_rcu:

crash> bt -t 1200
PID: 1200   TASK: ffff883ff9db9770  CPU: 56  COMMAND: "kworker/56:0"
              START: __schedule at ffffffff813bb12c
  [ffff883ef84ffbd8] schedule at ffffffff813bb2cc
  [ffff883ef84ffbe8] schedule_timeout at ffffffff813b9234
  [ffff883ef84ffbf8] __wake_up_common at ffffffff8104a8bd
  [ffff883ef84ffc30] _raw_spin_unlock_irqrestore at ffffffff813bc55b
  [ffff883ef84ffc60] __wait_for_common at ffffffff813bab7f
  [ffff883ef84ffc68] schedule_timeout at ffffffff813b9200
  [ffff883ef84ffc80] default_wake_function at ffffffff8104eec3
  [ffff883ef84ffc98] call_rcu at ffffffff810937ff
  [ffff883ef84ffcc8] wait_for_completion at ffffffff813bac1b
  [ffff883ef84ffcd8] wait_rcu_gp at ffffffff81041ea6
  [ffff883ef84ffce8] wakeme_after_rcu at ffffffff81041e51
  [ffff883ef84ffd20] synchronize_rcu at ffffffff81092333
  [ffff883ef84ffd30] mem_cgroup_reparent_charges at ffffffff810e3962
  [ffff883ef84ffdc0] mem_cgroup_css_offline at ffffffff810e3d6e
  [ffff883ef84ffdf0] offline_css at ffffffff8107a872
  [ffff883ef84ffe10] cgroup_offline_fn at ffffffff8107c55f
  [ffff883ef84ffe50] process_one_work at ffffffff8103f26f
  [ffff883ef84ffe90] worker_thread at ffffffff8103f711
  [ffff883ef84ffeb0] worker_thread at ffffffff8103f5cd
  [ffff883ef84ffec8] kthread at ffffffff810441a4
  [ffff883ef84fff28] kthread at ffffffff8104411c
  [ffff883ef84fff50] ret_from_fork at ffffffff813bd02c
  [ffff883ef84fff80] kthread at ffffffff8104411c

The other stack traces from waiting threads are identical to these:

crash> bt -t 6721
PID: 6721   TASK: ffff8834940b5dc0  CPU: 11  COMMAND: "lssubsys"
              START: __schedule at ffffffff813bb12c
  [ffff8831e01d5dc8] schedule at ffffffff813bb2cc
  [ffff8831e01d5dd8] schedule_preempt_disabled at ffffffff813bb553
  [ffff8831e01d5de8] __mutex_lock_slowpath at ffffffff813ba46f
  [ffff8831e01d5e40] mutex_lock at ffffffff813b9640
  [ffff8831e01d5e58] proc_cgroupstats_show at ffffffff8107a0d7
  [ffff8831e01d5e78] seq_read at ffffffff8110492b
  [ffff8831e01d5ea8] acct_account_cputime at ffffffff81096a99
  [ffff8831e01d5ee0] proc_reg_read at ffffffff811325e0
  [ffff8831e01d5f18] vfs_read at ffffffff810eaaa3
  [ffff8831e01d5f48] sys_read at ffffffff810eb18f
  [ffff8831e01d5f80] tracesys at ffffffff813bd2cb
    RIP: 00007ffe7cdd1c50  RSP: 00007fffe43ec9b8  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: ffffffff813bd2cb  RCX: ffffffffffffffff
    RDX: 0000000000000400  RSI: 00007ffe7d730000  RDI: 0000000000000002
    RBP: 000000000114a250   R8: 00000000ffffffff   R9: 0000000000000000
    R10: 0000000000000022  R11: 0000000000000246  R12: 0000000000000000
    R13: 000000000000000a  R14: 000000000114a010  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b
crash> bt -t 6618
PID: 6618   TASK: ffff8807e645ddc0  CPU: 5   COMMAND: "kworker/5:1"
              START: __schedule at ffffffff813bb12c
  [ffff880396c4fd98] schedule at ffffffff813bb2cc
  [ffff880396c4fda8] schedule_preempt_disabled at ffffffff813bb553
  [ffff880396c4fdb8] __mutex_lock_slowpath at ffffffff813ba46f
  [ffff880396c4fdd8] mmdrop at ffffffff8104b2ce
  [ffff880396c4fe10] mutex_lock at ffffffff813b9640
  [ffff880396c4fe28] cgroup_free_fn at ffffffff81079e3e
  [ffff880396c4fe50] process_one_work at ffffffff8103f26f
  [ffff880396c4fe90] worker_thread at ffffffff8103f711
  [ffff880396c4feb0] worker_thread at ffffffff8103f5cd
  [ffff880396c4fec8] kthread at ffffffff810441a4
  [ffff880396c4ff28] kthread at ffffffff8104411c
  [ffff880396c4ff50] ret_from_fork at ffffffff813bd02c
  [ffff880396c4ff80] kthread at ffffffff8104411c
crash> bt -t 3053
PID: 3053   TASK: ffff881ffb724650  CPU: 50  COMMAND: "slurmstepd"
              START: __schedule at ffffffff813bb12c
  [ffff881e2e7b7dc8] schedule at ffffffff813bb2cc
  [ffff881e2e7b7dd8] schedule_preempt_disabled at ffffffff813bb553
  [ffff881e2e7b7de8] __mutex_lock_slowpath at ffffffff813ba46f
  [ffff881e2e7b7e08] shrink_dcache_parent at ffffffff810faf35
  [ffff881e2e7b7e40] mutex_lock at ffffffff813b9640
  [ffff881e2e7b7e58] cgroup_rmdir at ffffffff8107d42b
  [ffff881e2e7b7e78] vfs_rmdir at ffffffff810f5dea
  [ffff881e2e7b7ea0] do_rmdir at ffffffff810f5eff
  [ffff881e2e7b7f28] syscall_trace_enter at ffffffff8100c195
  [ffff881e2e7b7f70] sys_rmdir at ffffffff810f6c42
  [ffff881e2e7b7f80] tracesys at ffffffff813bd2cb
    RIP: 00007fa31ca8c047  RSP: 00007fffaa493f08  RFLAGS: 00000202
    RAX: ffffffffffffffda  RBX: ffffffff813bd2cb  RCX: ffffffffffffffff
    RDX: 0000000000000000  RSI: 0000000000000002  RDI: 000000000133b408
    RBP: 0000000000000000   R8: 0000000000000019   R9: 0101010101010101
    R10: 00007fffaa493ce0  R11: 0000000000000202  R12: ffffffff810f6c42
    R13: ffff881e2e7b7f78  R14: 00007fffaa494000  R15: 000000000132f758
    ORIG_RAX: 0000000000000054  CS: 0033  SS: 002b
crash> bt -t 1224
PID: 1224   TASK: ffff8807e646aee0  CPU: 7   COMMAND: "kworker/7:0"
              START: __schedule at ffffffff813bb12c
  [ffff88010cd6fd78] schedule at ffffffff813bb2cc
  [ffff88010cd6fd88] schedule_preempt_disabled at ffffffff813bb553
  [ffff88010cd6fd98] __mutex_lock_slowpath at ffffffff813ba46f
  [ffff88010cd6fdb8] _raw_spin_unlock_irqrestore at ffffffff813bc55b
  [ffff88010cd6fdf8] mutex_lock at ffffffff813b9640
  [ffff88010cd6fe10] cgroup_offline_fn at ffffffff8107c523
  [ffff88010cd6fe50] process_one_work at ffffffff8103f26f
  [ffff88010cd6fe90] worker_thread at ffffffff8103f711
  [ffff88010cd6feb0] worker_thread at ffffffff8103f5cd
  [ffff88010cd6fec8] kthread at ffffffff810441a4
  [ffff88010cd6ff28] kthread at ffffffff8104411c
  [ffff88010cd6ff50] ret_from_fork at ffffffff813bd02c
  [ffff88010cd6ff80] kthread at ffffffff8104411c
crash> bt -t 1159
PID: 1159   TASK: ffff8807e5455dc0  CPU: 5   COMMAND: "kworker/5:0"
              START: __schedule at ffffffff813bb12c
  [ffff88031fdefd98] schedule at ffffffff813bb2cc
  [ffff88031fdefda8] schedule_preempt_disabled at ffffffff813bb553
  [ffff88031fdefdb8] __mutex_lock_slowpath at ffffffff813ba46f
  [ffff88031fdefdd8] mmdrop at ffffffff8104b2ce
  [ffff88031fdefe10] mutex_lock at ffffffff813b9640
  [ffff88031fdefe28] cgroup_free_fn at ffffffff81079e3e
  [ffff88031fdefe50] process_one_work at ffffffff8103f26f
  [ffff88031fdefe90] worker_thread at ffffffff8103f711
  [ffff88031fdefeb0] worker_thread at ffffffff8103f5cd
  [ffff88031fdefec8] kthread at ffffffff810441a4
  [ffff88031fdeff28] kthread at ffffffff8104411c
  [ffff88031fdeff50] ret_from_fork at ffffffff813bd02c
  [ffff88031fdeff80] kthread at ffffffff8104411c
crash> bt -t 2449
PID: 2449   TASK: ffff881ffb0aaee0  CPU: 31  COMMAND: "kworker/31:1"
              START: __schedule at ffffffff813bb12c
  [ffff881ffad2dd68] schedule at ffffffff813bb2cc
  [ffff881ffad2dd78] schedule_preempt_disabled at ffffffff813bb553
  [ffff881ffad2dd88] __mutex_lock_slowpath at ffffffff813ba46f
  [ffff881ffad2dde0] mutex_lock at ffffffff813b9640
  [ffff881ffad2ddf8] cgroup_release_agent at ffffffff8107b8a1
  [ffff881ffad2de50] process_one_work at ffffffff8103f26f
  [ffff881ffad2de90] worker_thread at ffffffff8103f711
  [ffff881ffad2deb0] worker_thread at ffffffff8103f5cd
  [ffff881ffad2dec8] kthread at ffffffff810441a4
  [ffff881ffad2df28] kthread at ffffffff8104411c
  [ffff881ffad2df50] ret_from_fork at ffffffff813bd02c
  [ffff881ffad2df80] kthread at ffffffff8104411c
crash> bt -t 1130
PID: 1130   TASK: ffff8827fb051770  CPU: 35  COMMAND: "kworker/35:1"
              START: __schedule at ffffffff813bb12c
  [ffff8827fb7d9d98] schedule at ffffffff813bb2cc
  [ffff8827fb7d9da8] schedule_preempt_disabled at ffffffff813bb553
  [ffff8827fb7d9db8] __mutex_lock_slowpath at ffffffff813ba46f
  [ffff8827fb7d9dd8] mmdrop at ffffffff8104b2ce
  [ffff8827fb7d9e10] mutex_lock at ffffffff813b9640
  [ffff8827fb7d9e28] cgroup_free_fn at ffffffff81079e3e
  [ffff8827fb7d9e50] process_one_work at ffffffff8103f26f
  [ffff8827fb7d9e90] worker_thread at ffffffff8103f711
  [ffff8827fb7d9eb0] worker_thread at ffffffff8103f5cd
  [ffff8827fb7d9ec8] kthread at ffffffff810441a4
  [ffff8827fb7d9f28] kthread at ffffffff8104411c
  [ffff8827fb7d9f50] ret_from_fork at ffffffff813bd02c
  [ffff8827fb7d9f80] kthread at ffffffff8104411c
