From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: move the bdi from the request_queue to the gendisk
Date: Wed, 11 Aug 2021 13:51:47 +0200
Message-ID: <20210811115147.GA27860@lst.de>
References: <20210809141744.1203023-1-hch@lst.de> <e5e19d15-7efd-31f4-941a-a5eb2f94b898@quicinc.com> <20210810200256.GA30809@lst.de> <20210811112514.GC14725@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210811112514.GC14725-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Qian Cai <quic_qiancai-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Aug 11, 2021 at 01:25:14PM +0200, Jan Kara wrote:
> Well, non-default bdi_writeback structures do hold bdi reference - see
> wb_exit() which drops the reference. I think the problem rather was that a
> block device's inode->i_wb was pointing to the default bdi_writeback
> structure and that got freed after bdi_put() before block device inode was
> shutdown through bdput()... So what I think we need is that if the inode
> references the default writeback structure, it actually holds a reference
> to the bdi.

Qian, can you test the patch below instead of the one I sent yesterday?

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index cd06dca232c3..edfb7ce2cc93 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -283,8 +283,7 @@ static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
 
 	memset(wb, 0, sizeof(*wb));
 
-	if (wb != &bdi->wb)
-		bdi_get(bdi);
+	bdi_get(bdi);
 	wb->bdi = bdi;
 	wb->last_old_flush = jiffies;
 	INIT_LIST_HEAD(&wb->b_dirty);
@@ -362,8 +361,7 @@ static void wb_exit(struct bdi_writeback *wb)
 		percpu_counter_destroy(&wb->stat[i]);
 
 	fprop_local_destroy_percpu(&wb->completions);
-	if (wb != &wb->bdi->wb)
-		bdi_put(wb->bdi);
+	bdi_put(wb->bdi);
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
