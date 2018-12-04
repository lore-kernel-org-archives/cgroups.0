From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 05/14] dm: set the static flush bio device on demand
Date: Tue,  4 Dec 2018 13:35:51 -0500
Message-ID: <20181204183600.99746-6-dennis@kernel.org>
References: <20181204183600.99746-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181204183600.99746-1-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>

The next patch changes the macro bio_set_dev() to associate a bio with a
blkg based on the device set. However, dm creates a static bio to be
used as the basis for cloning empty flush bios on creation. The
bio_set_dev() call in alloc_dev() will cause problems with the next
patch adding association to bio_set_dev() because the call is before the
bdev is associated with a gendisk (bd_disk is %NULL). To get around
this, set the device on the static bio every time and use that to clone
to the other bios.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
---
 block/bio.c     |  1 +
 drivers/md/dm.c | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 452b8e79b998..41ebb3f8e2fc 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2021,6 +2021,7 @@ void bio_disassociate_blkg(struct bio *bio)
 		bio->bi_blkg = NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(bio_disassociate_blkg);
 
 /**
  * __bio_associate_blkg - associate a bio with the a blkg
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a733e4c920af..a2d6f8b33d23 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1417,10 +1417,21 @@ static int __send_empty_flush(struct clone_info *ci)
 	unsigned target_nr = 0;
 	struct dm_target *ti;
 
+	/*
+	 * Empty flush uses a statically initialized bio as the base for
+	 * cloning, &md->flush_bio.  However, blkg association requires that
+	 * a bdev is associated with a gendisk, which doesn't happen until the
+	 * bdev is opened.  So, blkg association is done at issue time of the
+	 * flush rather than when the device is created in dm_alloc().
+	 */
+	bio_set_dev(ci->bio, ci->io->md->bdev);
+
 	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
 
+	bio_disassociate_blkg(ci->bio);
+
 	return 0;
 }
 
@@ -1939,7 +1950,6 @@ static struct mapped_device *alloc_dev(int minor)
 		goto bad;
 
 	bio_init(&md->flush_bio, NULL, 0);
-	bio_set_dev(&md->flush_bio, md->bdev);
 	md->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
 
 	dm_stats_init(&md->stats);
-- 
2.17.1

