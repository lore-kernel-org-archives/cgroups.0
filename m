From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH block/for-linus] block: blkg_destroy_all() should clear
 q->root_blkg and ->root_rl.blkg
Date: Sat, 5 Sep 2015 15:47:36 -0400
Message-ID: <20150905194736.GB8231@mtj.duckdns.org>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org>
 <20150904104602.GN29283@redhat.com>
 <20150904171302.GE25329@mtj.duckdns.org>
 <20150904204244.GQ29283@redhat.com>
 <20150905153439.GA18461@redhat.com>
 <20150905154840.GA19460@redhat.com>
 <20150905183801.GA8231@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=h95EfxBMZvHpculgY/F8JuyvkKgANtq8wVy8q3aJnkY=;
        b=KiTUpds5ZnGnvJm+8M1ytdvgEyZwzAByj3mgeE1pApdHx1wG8E4iusk5tkgPmKV6we
         vY+9UzhtgnWycIQxCplmfWKcNVV0GLAEqzKHdWQmOD2CMoOVlI04v0705m9SO+DBooGJ
         TDenxYWdSjZ/c7LG4l+z4M9GaG2T3RXSXyF5/nbWdigl3mO4pzqpC8zasLhSRs1NFR3q
         L9YYD7d9ov9ZS5QbmMjRvP7s+UBhX4/1TZejzBw+tZeVxTGl5scywjXQjDI4yF6IsaRv
         YeQ57nykiIWqG+5atiRbUv+dTeiYJoroHZ7R+FJVP/vnmisGryfXdYfD58klHEJnzRSq
         1UhA==
Content-Disposition: inline
In-Reply-To: <20150905183801.GA8231-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

While making the root blkg unconditional, ec13b1d6f0a0 ("blkcg: always
create the blkcg_gq for the root blkcg") removed the part which clears
q->root_blkg and ->root_rl.blkg during q exit.  This leaves the two
pointers dangling after blkg_destroy_all().  blk-throttle exit path
performs blkg traversals and dereferences ->root_blkg and can lead to
the following oops.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000558
 IP: [<ffffffff81389746>] __blkg_lookup+0x26/0x70
 ...
 task: ffff88001b4e2580 ti: ffff88001ac0c000 task.ti: ffff88001ac0c000
 RIP: 0010:[<ffffffff81389746>]  [<ffffffff81389746>] __blkg_lookup+0x26/0x70
 ...
 Call Trace:
  [<ffffffff8138d14a>] blk_throtl_drain+0x5a/0x110
  [<ffffffff8138a108>] blkcg_drain_queue+0x18/0x20
  [<ffffffff81369a70>] __blk_drain_queue+0xc0/0x170
  [<ffffffff8136a101>] blk_queue_bypass_start+0x61/0x80
  [<ffffffff81388c59>] blkcg_deactivate_policy+0x39/0x100
  [<ffffffff8138d328>] blk_throtl_exit+0x38/0x50
  [<ffffffff8138a14e>] blkcg_exit_queue+0x3e/0x50
  [<ffffffff8137016e>] blk_release_queue+0x1e/0xc0
 ...

While the bug is a straigh-forward use-after-free bug, it is tricky to
reproduce because blkg release is RCU protected and the rest of exit
path usually finishes before RCU grace period.

This patch fixes the bug by updating blkg_destro_all() to clear
q->root_blkg and ->root_rl.blkg.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Link: http://lkml.kernel.org/g/CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
Fixes: ec13b1d6f0a0 ("blkcg: always create the blkcg_gq for the root blkcg")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.2+
---
Hello,

Richard, can you please verify that this patch fixes the bug?

Thanks a lot!

 block/blk-cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d6283b3..9cc48d1d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -387,6 +387,9 @@ static void blkg_destroy_all(struct request_queue *q)
 		blkg_destroy(blkg);
 		spin_unlock(&blkcg->lock);
 	}
+
+	q->root_blkg = NULL;
+	q->root_rl.blkg = NULL;
 }
 
 /*
