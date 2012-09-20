From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] block: lift the initial queue bypass mode on
 blk_register_queue() instead of blk_init_allocated_queue()
Date: Thu, 20 Sep 2012 14:08:52 -0700
Message-ID: <20120920210852.GC7264@google.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
 <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
 <20120920192038.GJ28934@google.com>
 <20120920195759.GK4681@redhat.com>
 <20120920201815.GB7264@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xFeeBl0Je88CWNGWksYnrHD+IbkHlsJpctpMW2sSDo4=;
        b=m5DA1l8GoOsH7UgmQL68Knbc2aLcEh8BdrsBGn9sFdnhewnNTuIFDwZ0RujnsNU457
         5fLXLAKVK3tHECqNxCCWBHr1mXLsQYGcgIAZDMV7Wm3YUgnw9+gw71QIYpMqoacHi2zP
         n5F7U6mYnw9VaK8C8E6Hak2wnvJJDXE447jVFzZATdXMO3dOZkV6X4UBgOPSGCpPcnPY
         /sErfwzoy4bCvClDWHz2KIFBJiLk2TGGZbFD4qNsZP+RnwzCUGs5lHvtk7/eF1GG+RUC
         C5dTBp1KF9bzEJTBF5OS6eLPPP69WHpWzE0oF4TJvFGg222ZZX4ya1iyDWud4F00j9hU
         gJ6Q==
Content-Disposition: inline
In-Reply-To: <20120920201815.GB7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

b82d4b197c ("blkcg: make request_queue bypassing on allocation") made
request_queues bypassed on allocation to avoid switching on and off
bypass mode on a queue being initialized.  Some drivers allocate and
then destroy a lot of queues without fully initializing them and
incurring bypass latency overhead on each of them could add upto
significant overhead.

Unfortunately, blk_init_allocated_queue() is never used by queues of
bio-based drivers, which means that all bio-based driver queues are in
bypass mode even after initialization and registration complete
successfully.

Due to the limited way request_queues are used by bio drivers, this
problem is hidden pretty well but it shows up when blk-throttle is
used in combination with a bio-based driver.  Trying to configure
(echoing to cgroupfs file) blk-throttle for a bio-based driver hangs
indefinitely in blkg_conf_prep() waiting for bypass mode to end.

This patch moves the initial blk_queue_bypass_end() call from
blk_init_allocated_queue() to blk_register_queue() which is called for
any userland-visible queues regardless of its type.

I believe this is correct because I don't think there is any block
driver which needs or wants working elevator and blk-cgroup on a queue
which isn't visible to userland.  If there are such users, we need a
different solution.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Jens, while these are fixes, I think it isn't extremely urgent and
routing these through 3.7-rc1 should be enough.

Thanks.

 block/blk-core.c  |    7 ++-----
 block/blk-sysfs.c |    6 ++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -608,8 +608,8 @@ struct request_queue *blk_alloc_queue_no
 	/*
 	 * A queue starts its life with bypass turned on to avoid
 	 * unnecessary bypass on/off overhead and nasty surprises during
-	 * init.  The initial bypass will be finished at the end of
-	 * blk_init_allocated_queue().
+	 * init.  The initial bypass will be finished when the queue is
+	 * registered by blk_register_queue().
 	 */
 	q->bypass_depth = 1;
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
@@ -714,9 +714,6 @@ blk_init_allocated_queue(struct request_
 		return NULL;
 
 	blk_queue_congestion_threshold(q);
-
-	/* all done, end the initial bypass */
-	blk_queue_bypass_end(q);
 	return q;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -527,6 +527,12 @@ int blk_register_queue(struct gendisk *d
 	if (WARN_ON(!q))
 		return -ENXIO;
 
+	/*
+	 * Initialization must be complete by now.  Finish the initial
+	 * bypass from queue allocation.
+	 */
+	blk_queue_bypass_end(q);
+
 	ret = blk_trace_init_sysfs(dev);
 	if (ret)
 		return ret;
