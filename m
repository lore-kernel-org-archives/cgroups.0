From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: __blkg_lookup oops with 4.2-rcX
Date: Fri, 4 Sep 2015 13:13:02 -0400
Message-ID: <20150904171302.GE25329@mtj.duckdns.org>
References: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
 <20150902145307.GG22326@mtj.duckdns.org>
 <20150902153255.GH22326@mtj.duckdns.org>
 <20150904104602.GN29283@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=q7ABA2Nz2lmN2Rm7OW3t8lnLMeoQ6dWu9FtE35RLCjk=;
        b=jjFeiQ2Clm86lagZZT9bvHfUOpJPKQDD9LsWs6+yUe7YNJ4Hm8EbKyxKdeLphixzTS
         ZrpidSf2yhK9f5kt8Q3bZVJHYcE/lmzghUIKgjhhiYa58fd8SeFTaK6cky47M3i+oQQx
         QQGyl2X8Evt6HefxT/MLh/21L0HkVjviB6BX+u3qpYcc5kUMlvhgLxufXjwm9IMASlT/
         vQgeERqo9lq8NUWH4lCy5ZcozRX20T5t53S/47rORhRUAV+I0V5L3vcwm9syK0WFjrVk
         lv839Vrcd6hZ1XfrWOUvAWfifg734/ZK/TRNrraEmQh/qEktLnPKPGwKWoplt59JW8MR
         C/7g==
Content-Disposition: inline
In-Reply-To: <20150904104602.GN29283-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Fri, Sep 04, 2015 at 11:46:02AM +0100, Richard W.M. Jones wrote:
> $ addr2line -e /usr/lib/debug/lib/modules/4.2.0-0.rc3.git4.1.fc24.x86_64/vmlinux ffffffff814107a0
> /usr/src/debug/kernel-4.1.fc24/linux-4.2.0-0.rc3.git4.1.fc24.x86_64/block/blk-throttle.c:1642
> 
>    1636         /*
>    1637          * Drain each tg while doing post-order walk on the blkg tree, s   1637 o
>    1638          * that all bios are propagated to td->service_queue.  It'd be
>    1639          * better to walk service_queue tree directly but blkg walk is
>    1640          * easier.
>    1641          */
>    1642         blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
>    1643                 tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
>    1644 
> 
> Rich.
> 
> [    6.784689] BUG: unable to handle kernel NULL pointer dereference at 0000000000000bb8
> [    6.787605] IP: [<ffffffff814107a0>] blk_throtl_drain+0x80/0x220

The only struct which is large enough for 0xbb8 offset is
request_queue.  Hmm.... can you please try the brute force debug patch
below and report the kernel log after the crash?

Thanks.

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b231935..09426e4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1639,8 +1639,22 @@ void blk_throtl_drain(struct request_queue *q)
 	 * better to walk service_queue tree directly but blkg walk is
 	 * easier.
 	 */
-	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
-		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
+	printk("XXX blk_throtl_drain: td=%p ->queue=%p ->root_blkg=%p ->q/blkcg=%p/%p\n",
+	       td, td ? td->queue : NULL,
+	       (td && td->queue) ? td->queue->root_blkg : NULL,
+	       (td && td->queue && td->queue->root_blkg) ? td->queue->root_blkg->q : NULL,
+	       (td && td->queue && td->queue->root_blkg) ? td->queue->root_blkg->blkcg : NULL);
+
+	css_for_each_descendant_pre(pos_css, &td->queue->root_blkg->blkcg->css) {
+		printk("XXX pos_css=%p ", pos_css);
+		pr_cont_cgroup_path(pos_css->cgroup);
+		if ((blkg = __blkg_lookup(css_to_blkcg(pos_css),
+					  td->queue->root_blkg->q, false))) {
+			pr_cont(" blkg=%p", blkg);
+			tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
+		}
+		pr_cont("\n");
+	}
 
 	/* finally, transfer bios from top-level tg's into the td */
 	tg_drain_bios(&td->service_queue);
