From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH 04/13] blkcg: introduce common blkg association logic
Date: Mon, 3 Dec 2018 15:58:42 -0500
Message-ID: <20181203205842.GA90035@dennisz-mbp.dhcp.thefacebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-5-dennis@kernel.org>
 <20181130095209.GA17103@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181130095209.GA17103@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, Nov 30, 2018 at 01:52:09AM -0800, Christoph Hellwig wrote:
> >  EXPORT_SYMBOL_GPL(bio_associate_blkcg);
> >  
> >  /**
> > - * bio_associate_blkg - associate a bio with the a blkg
> > + * bio_has_queue - required check for blkg association
> > + * @bio: target bio
> > + *
> > + * A blkg represents the relationship between a blkcg and a request_queue.
> > + * If there is no request_queue, there is no blkg and therefore nothing to
> > + * associate with.
> > + */
> > +static inline bool bio_has_queue(struct bio *bio)
> > +{
> > +	return bio->bi_disk && bio->bi_disk->queue;
> > +}
> 
> How do you ever see a bio without a queue?  We can't even do I/O in
> that case.

The case I found was with the flush bio in dm which is statically
allocated in dm_alloc(). The issue issue is that bio_set_dev() is called
on a bdev that isn't opened. So, the bdev wasn't pointing to a genhd.
I've fixed the issue with the patch below, which will be added in v5.

I think I was being overly cautious with the change and have taken this
out in v5. It seems that this should be a one-off case which should work
with the patch below.

Thanks,
Dennis

---
From 3ee13402af369ee8618549b63593d68ffca574ca Mon Sep 17 00:00:00 2001
From: Dennis Zhou <dennis@kernel.org>
Date: Mon, 3 Dec 2018 10:56:34 -0800
Subject: [PATCH 05/14] dm: set flush bio device on demand

The next patch changes the macro bio_set_dev() to associate a bio with a
blkg based on the device set. However, dm creates a static bio to be
used as the basis for cloning empty flush bios on creation. This
association is with a not-opened bdev so bd_disk is %NULL. To easily get
around this, we will set the device on the static bio every time and use
that to copy to the other bios.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 drivers/md/dm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a733e4c920af..b5e996c5c709 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1417,10 +1417,14 @@ static int __send_empty_flush(struct clone_info *ci)
 	unsigned target_nr = 0;
 	struct dm_target *ti;
 
+	bio_set_dev(ci->bio, ci->io->md->bdev);
+
 	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
 
+	bio_disassociate_blkg(ci->bio);
+
 	return 0;
 }
 
@@ -1939,7 +1943,6 @@ static struct mapped_device *alloc_dev(int minor)
 		goto bad;
 
 	bio_init(&md->flush_bio, NULL, 0);
-	bio_set_dev(&md->flush_bio, md->bdev);
 	md->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
 
 	dm_stats_init(&md->stats);
-- 
2.17.1

