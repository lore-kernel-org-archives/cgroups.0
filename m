From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/5] writeback: laptop_mode_timer_fn() needs rcu_read_lock() around bdi_writeback iteration
Date: Tue, 29 Sep 2015 12:47:50 -0400
Message-ID: <1443545274-18787-2-git-send-email-tj@kernel.org>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5RHNjeLDcITapkDlrzRPwA7GXnid9j15um2y5TwD97c=;
        b=OArxD9z8olAi9dBxKHYN8/JzJxPykQq8KLhkfOmuRN4CXR4xdEkuR1kbts/J0PEPer
         chEGV/8KGiWStXzqTAdjDXkib23ZnGslQz98/I0EomtzFQQI5Nhg9maJNucwtUUjvHgX
         WYV3lDAPLk1AgaaTTwrEGDKaMewe1ADc9ahJgR1h9HIKKgAvUGdFVqk1FbRmUFQYK3Iy
         aGDWjjgUm8CeIKNbwbqRsFf/054aEt9EF+xBj5XCQd4HNpXlqhPvnmmUllxpU+UI4tE+
         5fJUMCgNXLgSoCuD73zSdYC/BSlFYquiYo2dOOfYc6QyNQKeAy3FVHyDD+Q3MC6xPA9m
         +5TQ==
In-Reply-To: <1443545274-18787-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

laptop_mode_timer_fn() was using bdi_for_each_wb() without the
required RCU locking leading to the following warning.

 WARNING: CPU: 0 PID: 0 at include/linux/backing-dev.h:415 laptop_mode_timer_fn+0x106/0x170()
 ...
 Call Trace:
  <IRQ>  [<ffffffff81480cdc>] dump_stack+0x4e/0x82
  [<ffffffff81051912>] warn_slowpath_common+0x82/0xc0
  [<ffffffff81051a0a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff8115f0e6>] laptop_mode_timer_fn+0x106/0x170
  [<ffffffff810ca8e3>] call_timer_fn+0xb3/0x2f0
  [<ffffffff810cad25>] run_timer_softirq+0x205/0x370
  [<ffffffff81056854>] __do_softirq+0xd4/0x460
  [<ffffffff81056d69>] irq_exit+0x89/0xa0
  [<ffffffff8185a892>] smp_apic_timer_interrupt+0x42/0x50
  [<ffffffff81858a44>] apic_timer_interrupt+0x84/0x90
 ...

Fix it by adding rcu_read_lock() around the iteration.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: a06fd6b10228 ("writeback: make laptop_mode_timer_fn() handle multiple bdi_writeback's")
---
 mm/page-writeback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0a931cd..902e5f2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1965,10 +1965,12 @@ void laptop_mode_timer_fn(unsigned long data)
 	if (!bdi_has_dirty_io(&q->backing_dev_info))
 		return;
 
+	rcu_read_lock();
 	bdi_for_each_wb(wb, &q->backing_dev_info, &iter, 0)
 		if (wb_has_dirty_io(wb))
 			wb_start_writeback(wb, nr_pages, true,
 					   WB_REASON_LAPTOP_TIMER);
+	rcu_read_unlock();
 }
 
 /*
-- 
2.4.3
