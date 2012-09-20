From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 3.6-rc5 cgroups blkio throttle + md regression
Date: Thu, 20 Sep 2012 12:20:38 -0700
Message-ID: <20120920192038.GJ28934@google.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
 <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=X31YkrNI4dM2qr3Cg2OwKqXA0nabTT5zpj5Ra9aIWhI=;
        b=MenkWE+dvo21F92whWulL4W8kfTE6+y9kiPW0vM/tcZThmbV9XFspqgEg++4OGY/rf
         6djuI/6xJgsS6d5N2KpdL7fN0mkEkK2LPJT/dKBWNdhXcjOMVVEkJ8G7MIFNqvncv+cK
         TsuMITxY5VPR6Pk93ir/YqrPYJSZfcfYX/bTykUiA6VOAqCGmgJiTjBOLlMyJXljKCV1
         ozqRmZD+AFmj+5jMx1zZq6JTohbpr9araN5lAiast9okZSvUAqGFyYggWZyqw+FEBwz7
         U6AiaBRiHDm25CSGiANgugNzK73bapYDjCgs0E8ZRw5gSV1MTCkZ+dk0AnjOpuVahvXs
         VgLw==
Content-Disposition: inline
In-Reply-To: <20120920191716.GI4681-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 20, 2012 at 03:17:16PM -0400, Vivek Goyal wrote:
> I suspect we are looping in retry code because bio based queues never come
> out of bypass mode.
> 
>                 /*
>                  * If queue was bypassing, we should retry.  Do so after a
>                  * short msleep().  It isn't strictly necessary but queue
>                  * can be bypassing for some time and it's always nice to
>                  * avoid busy looping.
>                  */
>                 if (ret == -EBUSY) {
>                         msleep(10);
>                         ret = restart_syscall();
>                 }

Yeah, I incorrectly assumed that bio based drivers would call
blk_init_allocated_queue().  I think we need to move the initial
bypass_end call to blk_register_queue().  Like the following.  Not
completely sure yet tho.

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..cbb019a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -714,9 +714,6 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 		return NULL;
 
 	blk_queue_congestion_threshold(q);
-
-	/* all done, end the initial bypass */
-	blk_queue_bypass_end(q);
 	return q;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9628b29..f53802e 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -527,6 +527,8 @@ int blk_register_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return -ENXIO;
 
+	blk_queue_bypass_end(q);
+
 	ret = blk_trace_init_sysfs(dev);
 	if (ret)
 		return ret;
