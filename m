From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.15] cgroup: statically initialize
 init_css_set->dfl_cgrp
Date: Mon, 25 Sep 2017 14:10:30 -0700
Message-ID: <20170925211030.GB560070@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=AyejRBhmaXx40UWSrglDwIjXUz664ObTQ61SwPhBBfY=;
        b=rqp+DuDx1Pvh8tQF/Rf0zWKLtXmx2kUvaHCulNLCI20Zu2+umcINsqm3U7ZMtgI7zB
         k6BuMoeMhDteXaZ0InI0ZpNZbl/7C6bk9Lhxnk9ZQQbmKWmOIF3YlmcAj3cyZa1W2+iB
         wx7Dm+CWJf2XVQdnL8ddpgRkzB3L1Dmp9wLKlxjEvjhGMxPgFIJOqMFmUIl+lSdd5bBk
         Qwm3+fR2FmFkgPlVSAdChwnvKisJ5flcxX+z89kCRCG7VGZtCTkLaKXiUEyJzXbTh8EI
         srAOdHVwAawwfB2XjD+C/aDrzqMNawSYdlR2MjRhOwBK1MBM7GaVFIOTEkyZOWqZPDkE
         bHDg==
Content-Disposition: inline
In-Reply-To: <20170811163754.3939102-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

A follow-up patch to fix sporadic oops during boot which is caused by
trying dereference the default cgroup from accounting code before
cgroup is initialized.

Applied to cgroup/for-4.15.

Thanks.
------ 8< ------
From 38683148828165ea0b66ace93a9fedc2d3281e27 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 25 Sep 2017 13:50:20 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Like other csets, init_css_set's dfl_cgrp is initialized when the cset
gets linked.  init_css_set gets linked in cgroup_init().  This has
been fine till now but the recently added basic CPU usage accounting
may end up accessing dfl_cgrp of init before cgroup_init() leading to
the following oops.

  SELinux:  Initializing.
  BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
  IP: account_system_index_time+0x60/0x90
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0-rc2-00003-g041cd64 #10
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
  +1.9.3-20161025_171302-gandalf 04/01/2014
  task: ffffffff81e10480 task.stack: ffffffff81e00000
  RIP: 0010:account_system_index_time+0x60/0x90
  RSP: 0000:ffff880011e03cb8 EFLAGS: 00010002
  RAX: ffffffff81ef8800 RBX: ffffffff81e10480 RCX: 0000000000000003
  RDX: 0000000000000000 RSI: 00000000000f4240 RDI: 0000000000000000
  RBP: ffff880011e03cc0 R08: 0000000000010000 R09: 0000000000000000
  R10: 0000000000000020 R11: 0000003b9aca0000 R12: 000000000001c100
  R13: 0000000000000000 R14: ffffffff81e10480 R15: ffffffff81e03cd8
  FS:  0000000000000000(0000) GS:ffff880011e00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000000b0 CR3: 0000000001e09000 CR4: 00000000000006b0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <IRQ>
   account_system_time+0x45/0x60
   account_process_tick+0x5a/0x140
   update_process_times+0x22/0x60
   tick_periodic+0x2b/0x90
   tick_handle_periodic+0x25/0x70
   timer_interrupt+0x15/0x20
   __handle_irq_event_percpu+0x7e/0x1b0
   handle_irq_event_percpu+0x23/0x60
   handle_irq_event+0x42/0x70
   handle_level_irq+0x83/0x100
   handle_irq+0x6f/0x110
   do_IRQ+0x46/0xd0
   common_interrupt+0x9d/0x9d

Fix it by statically initializing init_css_set.dfl_cgrp so that init's
default cgroup is accessible from the get-go.

Fixes: 041cd640b2f3 ("cgroup: Implement cgroup2 basic CPU usage accounting")
Reported-by: “kbuild-all-JC7UmRfGjtg@public.gmane.org” <kbuild-all-JC7UmRfGjtg@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d036625..7975b20 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -649,6 +649,14 @@ struct css_set init_css_set = {
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
 	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
+
+	/*
+	 * The following field is re-initialized when this cset gets linked
+	 * in cgroup_init().  However, let's initialize the field
+	 * statically too so that the default cgroup can be accessed safely
+	 * early during boot.
+	 */
+	.dfl_cgrp		= &cgrp_dfl_root.cgrp,
 };
 
 static int css_set_count	= 1;	/* 1 for init_css_set */
-- 
2.9.5
