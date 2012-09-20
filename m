From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] block: fix request_queue->flags initialization
Date: Thu, 20 Sep 2012 14:09:30 -0700
Message-ID: <20120920210930.GD7264@google.com>
References: <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
 <20120920192038.GJ28934@google.com>
 <20120920195759.GK4681@redhat.com>
 <20120920201815.GB7264@google.com>
 <20120920210852.GC7264@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eAc+/szMU5i94nZnVvedgSh9TSUpWNUB6k1hfrVeooQ=;
        b=CynFGbCqAKG9DErPyVYK++ExmmhwXPNcalpcmxLuG2JLwJKCNdijMIfRS8Uzjqys/7
         8M8OLEGozXdrvzpLZovd0jaQohgDGRsdWRStSmaPVfGIXkUb0VgNFsM6sVF1Rdtr2ExQ
         wVAu4ZbMk7/m+EOUysq2/I4YJPl7bCXyYzvPRT02X+ViQH6m91hLKUD/kozuglGut5df
         NeJMX09VlYPNSobfQCp2Y3Jhdrss0A4GhU5MJ2ZcO8Bn2fLyJqvFrNk9ntYPaG09kDiJ
         YtiMhTH8j2l/AZJUs2QddKP3HtZm0xrA3Ldi9feeTQ4tZME+VyP7Y6VbiEro/+tdPJym
         ow2Q==
Content-Disposition: inline
In-Reply-To: <20120920210852.GC7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

A queue newly allocated with blk_alloc_queue_node() has only
QUEUE_FLAG_BYPASS set.  For request-based drivers,
blk_init_allocated_queue() is called and q->queue_flags is overwritten
with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
initial bypass is still in effect.

In blk_init_allocated_queue(), or QUEUE_FLAG_DEFAULT to q->queue_flags
instead of overwriting.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -696,7 +696,7 @@ blk_init_allocated_queue(struct request_
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unprep_rq_fn		= NULL;
-	q->queue_flags		= QUEUE_FLAG_DEFAULT;
+	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
 
 	/* Override internal queue lock with supplied lock pointer */
 	if (lock)
