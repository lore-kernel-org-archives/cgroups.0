From: Tejun Heo <tj@kernel.org>
Subject: [block/for-next] iocost: Fix incorrect operation order during iocg
 free
Date: Tue, 10 Sep 2019 09:15:25 -0700
Message-ID: <20190910161525.GT2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=BzSkrvowps0g0N5g6HScYMxe8xO2mx5UwGqeLTuW+Hk=;
        b=ParuHlsgLMt+EXk5iwj5kllgfVd78Xqi8XxmT53ucKqxnnfE9HO1f70TItdD4QTprD
         NSI2+nSSvd0DYFCBc/MYuP/0c21UzIXD3t0PjcjjuelpRvBobkcN3+HCpgtP2rWKgIUJ
         +gy6rh9Tp0ZCS6BiO7coXzGiUQIE+Rg/GI+WbVE5Nx9gDt6fKH30h7tddn6FTpqTfoyp
         WbVyAMGGuFpwjE6MtE+FCUW0R4lw8vsBpG4FJAIdTV9YmqRudzlnzSX5XLtaAdJGWfbI
         E/gWUk5lSZgExw+x22kpQ2NEsvbI0H4SfrVZySWh+0M1No6viAjzSv711nFqxfPcoAiI
         bHRw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Dave Jones <davej@codemonkey.org.uk>

ioc_pd_free() first cancels the hrtimers and then deactivates the
iocg.  However, the iocg timer can run inbetween and reschedule the
hrtimers which will end up running after the iocg is freed leading to
crashes like the following.

  general protection fault: 0000 [#1] SMP
  ...
  RIP: 0010:iocg_kick_delay+0xbe/0x1b0
  RSP: 0018:ffffc90003598ea0 EFLAGS: 00010046
  RAX: 1cee00fd69512b54 RBX: ffff8881bba48400 RCX: 00000000000003e8
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8881bba48400
  RBP: 0000000000004e20 R08: 0000000000000002 R09: 00000000000003e8
  R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90003598ef0
  R13: 00979f3810ad461f R14: ffff8881bba4b400 R15: 25439f950d26e1d1
  FS:  0000000000000000(0000) GS:ffff88885f800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f64328c7e40 CR3: 0000000002409005 CR4: 00000000003606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <IRQ>
   iocg_delay_timer_fn+0x3d/0x60
   __hrtimer_run_queues+0xfe/0x270
   hrtimer_interrupt+0xf4/0x210
   smp_apic_timer_interrupt+0x5e/0x120
   apic_timer_interrupt+0xf/0x20
   </IRQ>

Fix it by canceling hrtimers after deactivating the iocg.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dave Jones <davej@codemonkey.org.uk>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
---
 block/blk-iocost.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2aae8ec391ef..7af350293c2f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1957,15 +1957,15 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 	struct ioc *ioc = iocg->ioc;
 
 	if (ioc) {
-		hrtimer_cancel(&iocg->waitq_timer);
-		hrtimer_cancel(&iocg->delay_timer);
-
 		spin_lock(&ioc->lock);
 		if (!list_empty(&iocg->active_list)) {
 			propagate_active_weight(iocg, 0, 0);
 			list_del_init(&iocg->active_list);
 		}
 		spin_unlock(&ioc->lock);
+
+		hrtimer_cancel(&iocg->waitq_timer);
+		hrtimer_cancel(&iocg->delay_timer);
 	}
 	kfree(iocg);
 }
