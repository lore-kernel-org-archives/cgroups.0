From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/14] dm: use bio_uninit instead of bio_disassociate_blkg
Date: Sat, 27 Jun 2020 09:31:46 +0200
Message-ID: <20200627073159.2447325-2-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NlgrihBG7jLl3wBy3//te4S7VLbqg8KMSQ1SCyyAmko=; b=L6XusXQSYNrkbPY1ZdnER6a0Nu
        Py0nKSkGK+tqq//lZU3f6lPIlLqG7AwZDlD80X6uiQQANhC9Ki8YdsEqf9AWVeG36X7qV8wvG7yQN
        l7JSHH5pmxXnSXhQtKZ5GfBXasr2Ed+pL5T8qBFltJr8Q3fMZih0pDDvewnEKHD28qc0qPykDOhkh
        RVbyPFhCwYMvDErZaaz3FWTQvFdWCrRfJCEysY6/qtq9tPk+ZEZvyZNQrZszBQBru7LQTLFoLMubm
        FzUcKEhDSMKiq+Zp2Io/VybxiZLnRBMn+cv+M6efXuH/gGtFhunXjbuF7DZ8bshY/XNpJ5WpkEbdO
        U9MgZkRQ==;
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

bio_uninit is the proper API to clean up a BIO that has been allocated
on stack or inside a structure that doesn't come from the BIO allocator.
Switch dm to use that instead of bio_disassociate_blkg, which really is
an implementation detail.  Note that the bio_uninit calls are also moved
to the two callers of __send_empty_flush, so that they better pair with
the bio_init calls used to initialize them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 109e81f33edb2d..e44473fe0f4873 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1452,9 +1452,6 @@ static int __send_empty_flush(struct clone_info *ci)
 	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
-
-	bio_disassociate_blkg(ci->bio);
-
 	return 0;
 }
 
@@ -1642,6 +1639,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 		ci.bio = &flush_bio;
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
+		bio_uninit(ci.bio);
 		/* dec_pending submits any data associated with flush */
 	} else if (op_is_zone_mgmt(bio_op(bio))) {
 		ci.bio = bio;
@@ -1716,6 +1714,7 @@ static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
 		ci.bio = &flush_bio;
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
+		bio_uninit(ci.bio);
 		/* dec_pending submits any data associated with flush */
 	} else {
 		struct dm_target_io *tio;
-- 
2.26.2

