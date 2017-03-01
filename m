From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.10-fixes] cgroup/pids: remove spurious
 suspicious RCU usage warning
Date: Wed, 1 Mar 2017 15:39:07 -0500
Message-ID: <20170301203907.GF3662@htj.duckdns.org>
References: <1487585723.8499.5.camel@gmx.de>
 <20170301174452.GE3662@htj.duckdns.org>
 <1488391071.4812.2.camel@gmx.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O8LPz4MTtdUPJFE59O9pVEdPciVwLLc2eYgfUthXaDY=;
        b=Qnq3U4LtOwA0oj/gTps6AkrD+HVofTPtz2dgKN9UUzgSkk8hFaALmDToDPZuuYabkV
         ZYaHhFfkkql5EAoxSqUdIiqlMFREfNCFM9xIW65FjtVqqqS3chKPkEopxFUOAEMSgcUv
         3844KHxoZ8sdWFUOSHdU4q9GZ+OU/TGKwpoPEfFJ3Ibs5d+xpnbF30DS0YEFSw0c9rvy
         1vxFtblKK/Gygsqk1XO2KEvMyILKJM/RQJEvh1WzoCU2VkCkzTz1uD5ceUgFfU7OqpV/
         tNKQsXGLvxji59Pm6EdoZepzZ6qU9D8dZhbw6yF9pMtphydmezACruN6jjBr9gr0yIzO
         WMIg==
Content-Disposition: inline
In-Reply-To: <1488391071.4812.2.camel@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>, kernel-team@fb.com

pids_can_fork() is special in that the css association is guaranteed
to be stable throughout the function and thus doesn't need RCU
protection around task_css access.  When determining the css to charge
the pid, task_css_check() is used to override the RCU sanity check.

While adding a warning message on fork rejection from pids limit,
135b8b37bd91 ("cgroup: Add pids controller event when fork fails
because of pid limit") incorrectly added a task_css access which is
neither RCU protected or explicitly annotated.  This triggers the
following suspicious RCU usage warning when RCU debugging is enabled.

  cgroup: fork rejected by pids controller in 

  ===============================
  [ ERR: suspicious RCU usage.  ]
  4.10.0-work+ #1 Not tainted
  -------------------------------
  ./include/linux/cgroup.h:435 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:


  rcu_scheduler_active = 2, debug_locks = 0
  1 lock held by bash/1748:
   #0:  (&cgroup_threadgroup_rwsem){+++++.}, at: [<ffffffff81052c96>] _do_fork+0xe6/0x6e0

  stack backtrace:
  CPU: 3 PID: 1748 Comm: bash Not tainted 4.10.0-work+ #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
  Call Trace:
   dump_stack+0x68/0x93
   lockdep_rcu_suspicious+0xd7/0x110
   pids_can_fork+0x1c7/0x1d0
   cgroup_can_fork+0x67/0xc0
   copy_process.part.58+0x1709/0x1e90
   _do_fork+0xe6/0x6e0
   SyS_clone+0x19/0x20
   do_syscall_64+0x5c/0x140
   entry_SYSCALL64_slow_path+0x25/0x25
  RIP: 0033:0x7f7853fab93a
  RSP: 002b:00007ffc12d05c90 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
  RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7853fab93a
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
  RBP: 00007ffc12d05cc0 R08: 0000000000000000 R09: 00007f78548db700
  R10: 00007f78548db9d0 R11: 0000000000000246 R12: 00000000000006d4
  R13: 0000000000000001 R14: 0000000000000000 R15: 000055e3ebe2c04d
  /asdf

There's no reason to dereference task_css again here when the
associated css is already available.  Fix it by replacing the
task_cgroup() call with css->cgroup.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mike Galbraith <efault@gmx.de>
Fixes: 135b8b37bd91 ("cgroup: Add pids controller event when fork fails because of pid limit")
Cc: Kenny Yu <kennyyu@fb.com>
Cc: stable@vger.kernel.org # v4.8+
---
 kernel/cgroup/pids.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index 2bd6737..a57242e 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -229,7 +229,7 @@ static int pids_can_fork(struct task_struct *task)
 		/* Only log the first time events_limit is incremented. */
 		if (atomic64_inc_return(&pids->events_limit) == 1) {
 			pr_info("cgroup: fork rejected by pids controller in ");
-			pr_cont_cgroup_path(task_cgroup(current, pids_cgrp_id));
+			pr_cont_cgroup_path(css->cgroup);
 			pr_cont("\n");
 		}
 		cgroup_file_notify(&pids->events_file);
