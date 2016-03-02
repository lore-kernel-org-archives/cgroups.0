From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] block: transfer source bio's cgroup tags to clone via
 bio_associate_blkcg() (was: Re: blkio cgroups controller doesn't work with
 LVM?)
Date: Wed, 2 Mar 2016 12:56:56 -0500
Message-ID: <20160302175656.GA59991@redhat.com>
References: <56CDF283.9010802@windriver.com>
 <56CEB1BC.4000005@kyup.com>
 <20160225145314.GA20699@redhat.com>
 <20160302160649.GB29826@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160302160649.GB29826-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Wed, Mar 02 2016 at 11:06P -0500,
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hello,
> 
> On Thu, Feb 25, 2016 at 09:53:14AM -0500, Mike Snitzer wrote:
> > Right, LVM created devices are bio-based DM devices in the kernel.
> > bio-based block devices do _not_ have an IO scheduler.  Their underlying
> > request-based device does.
> 
> dm devices are not the actual resource source, so I don't think it'd
> work too well to put io controllers on them (can't really do things
> like proportional control without owning the queue).
> 
> > I'm not well-versed on the top-level cgroup interface and how it maps to
> > associated resources that are established in the kernel.  But it could
> > be that the configuration of blkio cgroup against a bio-based LVM device
> > needs to be passed through to the underlying request-based device
> > (e.g. /dev/sda4 in Chris's case)?
> > 
> > I'm also wondering whether the latest cgroup work that Tejun has just
> > finished (afaik to support buffered IO in the IO controller) will afford
> > us a more meaningful reason to work to make cgroups' blkio controller
> > actually work with bio-based devices like LVM's DM devices?
> > 
> > I'm very much open to advice on how to proceed with investigating this
> > integration work.  Tejun, Vivek, anyone else: if you have advice on next
> > steps for DM on this front _please_ yell, thanks!
> 
> I think the only thing necessary is dm transferring bio cgroup tags to
> the bio's that it ends up passing down the stack.  Please take a look
> at fs/btrfs/extent_io.c::btrfs_bio_clone() for an example.  We
> probably should introduce a wrapper for this so that each site doesn't
> need to ifdef it.
> 
> Thanks.

OK, I think this should do it.  Nikolay and/or others can you test this
patch using blkio cgroups controller with LVM devices and report back?

From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Wed, 2 Mar 2016 12:37:39 -0500
Subject: [PATCH] block: transfer source bio's cgroup tags to clone via bio_associate_blkcg()

Move btrfs_bio_clone()'s support for transferring a source bio's cgroup
tags to a clone into both bio_clone_bioset() and __bio_clone_fast().
The former is used by btrfs (MD and blk-core also use it via bio_split).
The latter is used by both DM and bcache.

This should enable the blkio cgroups controller to work with all
stacking bio-based block devices.

Reported-by: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/bio.c          | 10 ++++++++++
 fs/btrfs/extent_io.c |  6 ------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index cf75915..25812be 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -584,6 +584,11 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
+
+#ifdef CONFIG_BLK_CGROUP
+	if (bio_src->bi_css)
+		bio_associate_blkcg(bio, bio_src->bi_css);
+#endif
 }
 EXPORT_SYMBOL(__bio_clone_fast);
 
@@ -689,6 +694,11 @@ integrity_clone:
 		}
 	}
 
+#ifdef CONFIG_BLK_CGROUP
+	if (bio_src->bi_css)
+		bio_associate_blkcg(bio, bio_src->bi_css);
+#endif
+
 	return bio;
 }
 EXPORT_SYMBOL(bio_clone_bioset);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 392592d..8abc330 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2691,12 +2691,6 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask)
 		btrfs_bio->csum = NULL;
 		btrfs_bio->csum_allocated = NULL;
 		btrfs_bio->end_io = NULL;
-
-#ifdef CONFIG_BLK_CGROUP
-		/* FIXME, put this into bio_clone_bioset */
-		if (bio->bi_css)
-			bio_associate_blkcg(new, bio->bi_css);
-#endif
 	}
 	return new;
 }
-- 
2.5.4 (Apple Git-61)
