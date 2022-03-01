From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9] block: cancel all throttled bios in del_gendisk()
Date: Tue, 1 Mar 2022 18:29:01 +0800
Message-ID: <Yh31bQu3gbXoDBuK@T590>
References: <20220210115637.1074927-1-yukuai3@huawei.com>
 <YhuyBgZSS6m/Mwu6@infradead.org>
 <Yhxnkg0AEaj36t+a@T590>
 <YhyYpWHGVhs3J/dk@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646130556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MyK8CGeqc8W1ttSv05bq0b6rSbbQ2JkU82/9ujV/uPI=;
        b=jORoIMPJ2MC0KT+04w0PMGCB6tc6bPPatRJx0ToEJl+be2vE+E/38UMDW8RDl6AzoGWo/7
        twPGjOENWQhzYUKPWbffN9eMAF/xWwU/nu6XR5l99xg/e/KLwbmvVNzTOmeXbYpsiIH1Zc
        b02C7EGDKNXucLTp14RFgFXcYQ3yXFY=
Content-Disposition: inline
In-Reply-To: <YhyYpWHGVhs3J/dk-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, Feb 28, 2022 at 01:40:53AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 28, 2022 at 02:11:30PM +0800, Ming Lei wrote:
> > > FYI, this crashed left rigt and center when running xfstests with
> > > traces pointing to throtl_pending_timer_fn.
> > 
> > Can you share the exact xfstests test(fs, test)? Or panic log?
> > 
> > I can't reproduce it when running './check -g auto' on XFS, meantime
> > tracking throtl_pending_timer_fn().
> 
> From a quick run using f2fs:
> 
> generic/081 files ... [  316.487861] run fstests generic/081 at 2022-02-28 09:38:40

Thanks for providing the reproducer.

The reason is that the pending timer is deleted in blkg's release
handler, so the timer can still be live after request queue is released.

The patch of 'block: cancel all throttled bios in del_gendisk()' should just
make it easier to trigger.

After patch of "block: move blkcg initialization/destroy into disk allocation/
release handler" lands, the issue can be fixed easily by:

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fa063c6c0338..e8d4be5e1de3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -82,6 +82,7 @@ static void blkg_free(struct blkcg_gq *blkg)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
+	blk_put_queue(blkg->q);
 	free_percpu(blkg->iostat_cpu);
 	percpu_ref_exit(&blkg->refcnt);
 	kfree(blkg);
@@ -297,9 +298,10 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	blkg->online = true;
 	spin_unlock(&blkcg->lock);
 
-	if (!ret)
+	if (!ret && blk_get_queue(q))
 		return blkg;
-
+	else if (!ret)
+		ret = -ENODEV;
 	/* @blkg failed fully initialized, use the usual release path */
 	blkg_put(blkg);
 	return ERR_PTR(ret);


Thanks,
Ming

