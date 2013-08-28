From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] blkcg: relocate root_blkg setting and clearing
Date: Wed, 28 Aug 2013 14:26:50 -0400
Message-ID: <20130828182650.GA18971@mtj.dyndns.org>
References: <CAOMFOmV-k_0RxNwY2JEXn9sHmsoJYArWwURNj1-Srph=FzbFUQ@mail.gmail.com>
 <20130823172424.GN3277@htj.dyndns.org>
 <CAOMFOmUKwvkhgB_9ywRk+2OR01oXjVpFz0w_AZOXgeaJcLC9Qw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Lj+oQ+KU5YtHwKyTFmuHzzFqdCyUgJKA+Whlt8jFWxY=;
        b=dW2c8QhdLthaItoZjkeSucPYS0aNDXSKMZk3Hz72FOL9aJ/rmkYy/TAa6hR3Mquj3d
         Kf86QsY0kHxjEnUj+5XHOO2aua7WRm2M3DQeOCm1vRA6rSXso/50p6XlkTlgA0lxugcn
         zXdAe7ihnMVWs3i1dsSz34o21PLXzKEHeqslKzpPEopN+NAX+WdmZLCTOTPu/Q6eiv4Q
         8dhzHWrHeMm49fZ5EwJFY4BVMJvtUg+0Tnm8h2pIZOzila1zvSHiYgTKrjdVh61AK5Y4
         RDbKuqMZ7tsRUIrQ0bHDXI8uTenTgNPVajNZxEXaA6iLHZX4exj9ML4J2qtD8gPoM+5q
         yCeg==
Content-Disposition: inline
In-Reply-To: <CAOMFOmUKwvkhgB_9ywRk+2OR01oXjVpFz0w_AZOXgeaJcLC9Qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello, Jens.

The original thread can be read from

 http://thread.gmane.org/gmane.linux.kernel.cgroups/8937

While it leads to oops, given that it only triggers under specific
configurations which aren't common.  I don't think it's necessary to
backport it through -stable and merging it during the coming merge
window should be enough.

Thanks!

----- 8< -----
Currently, q->root_blkg and q->root_rl.blkg are set from
blkcg_activate_policy() and cleared from blkg_destroy_all().  This
doesn't necessarily coincide with the lifetime of the root blkcg_gq
leading to the following oops when blkcg is enabled but no policy is
activated because __blk_queue_next_rl() malfunctions expecting the
root_blkg pointers to be set.

  BUG: unable to handle kernel NULL pointer dereference at           (null)
  IP: [<ffffffff810c58cb>] __wake_up_common+0x2b/0x90
  PGD 60f7a9067 PUD 60f4c9067 PMD 0
  Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
  gsmi: Log Shutdown Reason 0x03
  Modules linked in: act_mirred cls_tcindex cls_prioshift sch_dsmark xt_multiport iptable_mangle sata_mv elephant elephant_dev_num cdc_acm uhci_hcd ehci_hcd i2c_d
  CPU: 9 PID: 41382 Comm: iSCSI-write- Not tainted 3.11.0-dbg-DEV #19
  Hardware name: Intel XXX
  task: ffff88060d16eec0 ti: ffff88060d170000 task.ti: ffff88060d170000
  RIP: 0010:[<ffffffff810c58cb>] [<ffffffff810c58cb>] __wake_up_common+0x2b/0x90
  RSP: 0000:ffff88060d171818  EFLAGS: 00010096
  RAX: 0000000000000082 RBX: ffff880baa3dee60 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff880baa3dee60
  RBP: ffff88060d171858 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000002 R12: ffff880baa3dee98
  R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000003
  FS:  00007f977cba6700(0000) GS:ffff880c79c60000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 0000000000000000 CR3: 000000060f7a5000 CR4: 00000000000007e0
  Stack:
   0000000000000082 0000000000000000 ffff88060d171858 ffff880baa3dee60
   0000000000000082 0000000000000003 0000000000000000 0000000000000000
   ffff88060d171898 ffffffff810c7848 ffff88060d171888 ffff880bde4bc4b8
  Call Trace:
   [<ffffffff810c7848>] __wake_up+0x48/0x70
   [<ffffffff8131da53>] __blk_drain_queue+0x123/0x190
   [<ffffffff8131dbb5>] blk_cleanup_queue+0xf5/0x210
   [<ffffffff8141877a>] __scsi_remove_device+0x5a/0xd0
   [<ffffffff81418824>] scsi_remove_device+0x34/0x50
   [<ffffffff814189cb>] scsi_remove_target+0x16b/0x220
   [<ffffffff814210f1>] __iscsi_unbind_session+0xd1/0x1b0
   [<ffffffff814212b2>] iscsi_remove_session+0xe2/0x1c0
   [<ffffffff814213a6>] iscsi_destroy_session+0x16/0x60
   [<ffffffff81423a59>] iscsi_session_teardown+0xd9/0x100
   [<ffffffff8142b75a>] iscsi_sw_tcp_session_destroy+0x5a/0xb0
   [<ffffffff81420948>] iscsi_if_rx+0x10e8/0x1560
   [<ffffffff81573335>] netlink_unicast+0x145/0x200
   [<ffffffff815736f3>] netlink_sendmsg+0x303/0x410
   [<ffffffff81528196>] sock_sendmsg+0xa6/0xd0
   [<ffffffff815294bc>] ___sys_sendmsg+0x38c/0x3a0
   [<ffffffff811ea840>] ? fget_light+0x40/0x160
   [<ffffffff811ea899>] ? fget_light+0x99/0x160
   [<ffffffff811ea840>] ? fget_light+0x40/0x160
   [<ffffffff8152bc79>] __sys_sendmsg+0x49/0x90
   [<ffffffff8152bcd2>] SyS_sendmsg+0x12/0x20
   [<ffffffff815fb642>] system_call_fastpath+0x16/0x1b
  Code: 66 66 66 66 90 55 48 89 e5 41 57 41 89 f7 41 56 41 89 ce 41 55 41 54 4c 8d 67 38 53 48 83 ec 18 89 55 c4 48 8b 57 38 4c 89 45 c8 <4c> 8b 2a 48 8d 42 e8 49

Fix it by moving r->root_blkg and q->root_rl.blkg setting to
blkg_create() and clearing to blkg_destroy() so that they area
initialized when a root blkg is created and cleared when destroyed.

Reported-and-tested-by: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-cgroup.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 290792a..db30b6b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -235,8 +235,13 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	blkg->online = true;
 	spin_unlock(&blkcg->lock);
 
-	if (!ret)
+	if (!ret) {
+		if (blkcg == &blkcg_root) {
+			q->root_blkg = blkg;
+			q->root_rl.blkg = blkg;
+		}
 		return blkg;
+	}
 
 	/* @blkg failed fully initialized, use the usual release path */
 	blkg_put(blkg);
@@ -335,6 +340,15 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 		rcu_assign_pointer(blkcg->blkg_hint, NULL);
 
 	/*
+	 * If root blkg is destroyed.  Just clear the pointer since root_rl
+	 * does not take reference on root blkg.
+	 */
+	if (blkcg == &blkcg_root) {
+		blkg->q->root_blkg = NULL;
+		blkg->q->root_rl.blkg = NULL;
+	}
+
+	/*
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
 	 */
@@ -360,13 +374,6 @@ static void blkg_destroy_all(struct request_queue *q)
 		blkg_destroy(blkg);
 		spin_unlock(&blkcg->lock);
 	}
-
-	/*
-	 * root blkg is destroyed.  Just clear the pointer since
-	 * root_rl does not take reference on root blkg.
-	 */
-	q->root_blkg = NULL;
-	q->root_rl.blkg = NULL;
 }
 
 /*
@@ -973,8 +980,6 @@ int blkcg_activate_policy(struct request_queue *q,
 		ret = PTR_ERR(blkg);
 		goto out_unlock;
 	}
-	q->root_blkg = blkg;
-	q->root_rl.blkg = blkg;
 
 	list_for_each_entry(blkg, &q->blkg_list, q_node)
 		cnt++;
