From: Xianting Tian <xianting_tian@126.com>
Subject: [PATCH] blkcg: add plugging support for punt bio
Date: Thu,  6 Aug 2020 09:54:42 -0400
Message-ID: <1596722082-31817-1-git-send-email-xianting_tian@126.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=+kkkBx1bxSHF0cNmAc
        mdtGqYc15xx5yDg7pnYwZu2X0=; b=frS1DJFLGX4fnq8DPpkPzrzBNlUdQF0oAl
        OByLZL/oh0uRwQOqWrbf1nOSNUXkqdCAH3q5tAuTs/FpHF95mdaDf5Y2jRIDQgn/
        Yhnm4ye5dHSqkaNpPT7U5g3xKULcl3LE4qSzaHuBJf9t8RWQDJ1TLxUWh3YO+iAI
        h+F4QZKqE=
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

Try to merge continuous bio to current task's plug fisrt.

Signed-off-by: Xianting Tian <xianting_tian@126.com>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0ecc897..fe5d361 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -122,6 +122,7 @@ static void blkg_async_bio_workfn(struct work_struct *work)
 					     async_bio_work);
 	struct bio_list bios = BIO_EMPTY_LIST;
 	struct bio *bio;
+	struct blk_plug plug;
 
 	/* as long as there are pending bios, @blkg can't go away */
 	spin_lock_bh(&blkg->async_bio_lock);
@@ -129,8 +130,10 @@ static void blkg_async_bio_workfn(struct work_struct *work)
 	bio_list_init(&blkg->async_bios);
 	spin_unlock_bh(&blkg->async_bio_lock);
 
+	blk_start_plug(&plug);
 	while ((bio = bio_list_pop(&bios)))
 		submit_bio(bio);
+	blk_finish_plug(&plug);
 }
 
 /**
-- 
1.8.3.1

