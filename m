Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB0E3803C7;
	Sun, 23 Aug 2026 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787499022; cv=none; b=l9eHt1SjdAM+m7EPwBbt+xn8h4J8NvmtVfA3AjmY+9jMybEzTSodovfm4TpkG2kImzmD3OSVmCRlnTaxX5y2/goW1hpnNhhw6JfhSIR73G7qAXATv9QOdmAppcpZw+od2p1q5TIU4y/IRjLpPXt6GMB2MfrtcfTaRK1Gao7xXMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787499022; c=relaxed/simple;
	bh=4WVHel4pOdtiOTMyEKBQUpuaFKs5xSVxjmqmqLqy7vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNPQ5Xo4YzumkoOoXZii3P0B4TjuOd/Bd9fox+vuIDxThr8S11rfuEPd2idbsD6bXM6eMW64E91XeB9uKmeOaxmxr4FMfjtwz7I7rWNiTUVS+nZBT9aHkEwrLrCo+/RnWzHKXXj4V/UuwnwsAnsf6Pih6WaCXYyfchfyC5YaHxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bkLp3g46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bkLp3g46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E5F1F000E9;
	Sun, 23 Aug 2026 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787499018;
	bh=+2h2b9GZqMfRQ8idPJK/91YPZMHFjGy6V7Lv0AmS1VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkLp3g462ZQuOKw3UmciKrFB1EBx5ynpzxxKW1G/wfmMOaBkcFczqrT6Jp4A8fehN
	 dEMd5QR7ZkbQIlgwnMoGz2MT5tdIN7/dh+/cjKbpYwai+V9tocU2aNMLN5/lzXrR/a
	 sDaWUu1gGXmeHUTZG8HXoMn+trStGH4HgxPB1ZsnPpTGGpQjYA+aFOdEk0VE6zB2Un
	 O2tJx5hdTngCJfK1MmUsT5uc9A3ASBsaNqorjeLamJR4XEPqcCZ7qZ115nTAXiu0Xg
	 9Zu3YSG7rzaJ54HGUKEQfm5g/D6krMNy4zWsu1j1b0C9B0T8r2/A+6A77/P7pB3F5y
	 SrQA7urefmyKw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>,
	Hannes Reinecke <hare@suse.de>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 6/6] blk-cgroup: make policy blkg creation nowait-safe
Date: Sun, 23 Aug 2026 23:29:25 +0800
Message-ID: <20260823152926.1043863-7-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260823152926.1043863-1-yukuai@kernel.org>
References: <20260823152926.1043863-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

bio_blkg() is called by blkcg policy paths when they need a queue-local
blkg. Keep that allocation lazy instead of preparing every REQ_NOWAIT bio
from submit_bio_noacct().

If a policy first needs a blkg for a REQ_NOWAIT bio, use mutex_trylock()
and GFP_ATOMIC so the lookup never sleeps. If the mutex cannot be acquired,
look up and pin the closest existing blkg in the hierarchy under RCU. The
creation helper provides the same fallback if atomic allocation fails, so
valid policy I/O always gets a blkg without blocking.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 31afb433ab18..9895d6661070 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -28,10 +28,11 @@
 #include <linux/atomic.h>
 #include <linux/ctype.h>
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
 #include <linux/part_stat.h>
+#include <linux/preempt.h>
 #include "blk.h"
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
 
@@ -469,10 +470,24 @@ static struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
 	while (!blkg_tryget(blkg))
 		blkg = blkg->parent;
 	return blkg;
 }
 
+static struct blkcg_gq *blkg_lookup_closest(struct blkcg *blkcg,
+					    struct request_queue *q)
+{
+	struct blkcg_gq *blkg;
+
+	rcu_read_lock();
+	while (!(blkg = blkg_lookup(blkcg, q)))
+		blkcg = blkcg_parent(blkcg);
+	blkg = blkg_lookup_tryget(blkg);
+	rcu_read_unlock();
+
+	return blkg;
+}
+
 /**
  * blkg_lookup_create - lookup blkg, try to create one if not there
  * @blkcg: blkcg of interest
  * @disk: gendisk of interest
  * @gfp_mask: allocation mask to use
@@ -2066,11 +2081,10 @@ struct blkcg_gq *bio_blkg(struct bio *bio)
 {
 	struct blkcg *blkcg = bio_blkcg(bio);
 	struct gendisk *disk;
 	struct request_queue *q;
 	struct blkcg_gq *blkg;
-	int ret;
 
 	if (!blkcg || !bio->bi_bdev)
 		return NULL;
 
 	if (bio_flagged(bio, BIO_BLKG_REF))
@@ -2087,10 +2101,29 @@ struct blkcg_gq *bio_blkg(struct bio *bio)
 	if (blkg) {
 		bio_set_blkg_ref(bio, blkg);
 		return blkg;
 	}
 
+	if (bio->bi_opf & REQ_NOWAIT) {
+		/*
+		 * Nowait callers must not sleep on the mutex nor allocate with
+		 * sleeping GFPs.  Trylock the mutex and create the missing blkg
+		 * atomically.  If the mutex cannot be acquired, skip allocation
+		 * and pin the closest existing blkg instead.  blkg_lookup_create()
+		 * provides the same fallback if allocation fails.
+		 */
+		if (!preemptible() || !mutex_trylock(&q->blkcg_mutex)) {
+			blkg = blkg_lookup_closest(blkcg, q);
+		} else {
+			blkg_lookup_create(blkcg, disk, GFP_ATOMIC, &blkg);
+			blkg = blkg_lookup_tryget(blkg);
+			mutex_unlock(&q->blkcg_mutex);
+		}
+		bio_set_blkg_ref(bio, blkg);
+		return blkg;
+	}
+
 	mutex_lock(&q->blkcg_mutex);
 	blkg_lookup_create(blkcg, disk, GFP_NOIO, &blkg);
 	blkg = blkg_lookup_tryget(blkg);
 	mutex_unlock(&q->blkcg_mutex);
 
-- 
2.51.0

