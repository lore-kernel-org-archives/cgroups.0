From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/5] block: add a queue_has_disk helper
Date: Mon,  9 Aug 2021 16:17:42 +0200
Message-ID: <20210809141744.1203023-4-hch@lst.de>
References: <20210809141744.1203023-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=XU6ud6GFQfd/gs3ssOGWEAi2zJPaSrUQBYHYU+p+0Vs=; b=gY8TLua/+YBr0U0KXj8dTN2emm
        Vw9fqV/WUIYfS0rIBwQ26vKkcEXtAV8qJ5pmxrfp5OIhVw9lMuk2w1G01J4F3H27FusOakvMWFa4F
        O2Lrg//IqS/IbdJdY2vFHeCsPOTukFvSgB/SpztcvKDHTed8ZAJkZ8mMVikeQ1zW0yd5fYx7qx9N3
        Nb4EviWcZ4K4Mr7/s5cSlxXC91CYuscyXCb++mzWzXUPReRDHIHtvWihYw0icKUTxiBjepHalsP95
        iB7sF5CexQRBeECPSWLeBnINpRtXyX5/tuEsod50hTKPjsl/Tar7ef2ujYyxA7efcTK8v3L1QcKqc
        X3apWGFA==;
In-Reply-To: <20210809141744.1203023-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Add a helper to check if a gendisk is associated with a request_queue.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/blkdev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ac3642c88a4d..96f3d9617cd8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -664,6 +664,7 @@ extern void blk_clear_pm_only(struct request_queue *q);
 	dma_map_page_attrs(dev, (bv)->bv_page, (bv)->bv_offset, (bv)->bv_len, \
 	(dir), (attrs))
 
+#define queue_has_disk(q)	((q)->kobj.parent != NULL)
 #define queue_to_disk(q)	(dev_to_disk(kobj_to_dev((q)->kobj.parent)))
 
 static inline bool queue_is_mq(struct request_queue *q)
-- 
2.30.2

