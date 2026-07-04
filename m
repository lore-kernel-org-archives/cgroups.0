Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3A530D3F3;
	Sat,  4 Jul 2026 19:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783194799; cv=none; b=HYqW+DjL/EOdOrh3vbZtpuEr/bKUtss76fFSdysoFJm1xOC5sI+l1hhwC6qxoLPj7alnaiRdKR2BSxtjcTma0GZn7xa0V+K9EH+5snoPGY0yyod7z/xNNBnj1Oud6ZKoo7YAZk3tu6Q4qjL9OEf42bPUTrEppsx2xO05auZfFQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783194799; c=relaxed/simple;
	bh=UX88PQAy7lKUE9CvWi26dKnnFq45t2DlmPiyO010Ktg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnGqJIAbyKNk0SttubDMfYs94nhanjjZ6zZ8cz6PK2QxUx/T4Sxdl9lJDPIUpEAamU9IwQPqDec9UTunkStgqj2KXI8Qy7SWro1tveyFroFqvFDnXfcajWjn9Qt8WXJcBf7flSdAAco0gum8zVBsQYCLImpwskspD/OeUWuLhfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+c6rGky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+c6rGky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF5A1F00A3A;
	Sat,  4 Jul 2026 19:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783194798;
	bh=OOX++ewQg78wECJAGHPUeEMc5Quzv2keNF1I002bjOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+c6rGkyEMK6P9/fA3zL0Y4SHxsybxvP8Hqa6uJbUpkEt0wyim3m5oDHLweWoaDRD
	 rKsp4lY6RdY780yCDOrQPuLst/K1KHE92XxDnkPPVWp4TbxSSst1IA7UROSkgHc7jn
	 7U5cDoLQZCXdaXND3yBanJSkpMWzTeuu9gXK6L8ahDj2rRS/upcEDxaPqQBtn91Q38
	 eqwN57qpnvjXN7VwSA68WIxP61VGgk+OpAK6TIAqC+F+77Ov7un0Nc9Ek6gzk/jLxP
	 J6U9pxL7ZmsZOJsmxKzjRtgtcvntzZX0oqHu/rXzhZZfX9JMSASMUJCQ3IhPyFstHL
	 A7P7rXlca+5rw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alasdair Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Josef Bacik <josef@toxicpanda.com>,
	Yu Kuai <yukuai@fygo.io>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org
Subject: [RFC PATCH v1 08/17] bcache: avoid sleeping blkg association from locked paths
Date: Sun,  5 Jul 2026 03:51:15 +0800
Message-ID: <20260704195124.1375075-9-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260704195124.1375075-1-yukuai@kernel.org>
References: <20260704195124.1375075-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

cached_dev_cache_miss() allocates cache_bio with GFP_NOWAIT.  Passing a bdev
to bio_alloc_bioset() can attach blkcg state and sleep to create a missing
blkg after blkg lookup is protected by q->blkcg_mutex.

Use the nowait bio allocation/association path.  If the cache bio needs a
missing blkg to be created, fail the association and fall back to the existing
miss submission path.

journal_write_unlocked() also resets journal bios while holding the journal
spinlock.  Reset those bios without a bdev, set bi_bdev while still under the
lock, and associate blkcg after dropping the lock.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/bcache/journal.c | 9 ++++++---
 drivers/md/bcache/request.c | 2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 144693b7c46a..49d2fb9a5f20 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -714,8 +714,9 @@ static CLOSURE_CALLBACK(journal_write_unlocked)
 
 		atomic_long_add(sectors, &ca->meta_sectors_written);
 
-		bio_reset(bio, ca->bdev, REQ_OP_WRITE | 
-			  REQ_SYNC | REQ_META | REQ_PREFLUSH | REQ_FUA);
+		bio_reset(bio, NULL, REQ_OP_WRITE | REQ_SYNC | REQ_META |
+			  REQ_PREFLUSH | REQ_FUA);
+		bio->bi_bdev = ca->bdev;
 		bio->bi_iter.bi_sector	= PTR_OFFSET(k, i);
 		bio->bi_iter.bi_size = sectors << 9;
 
@@ -740,8 +741,10 @@ static CLOSURE_CALLBACK(journal_write_unlocked)
 
 	spin_unlock(&c->journal.lock);
 
-	while ((bio = bio_list_pop(&list)))
+	while ((bio = bio_list_pop(&list))) {
+		bio_associate_blkg(bio, false);
 		closure_bio_submit(c, bio, cl);
+	}
 
 	continue_at(cl, journal_write_done, NULL);
 }
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index c2b7a694ea99..647ca5018d07 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -932,6 +932,8 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	if (!cache_bio)
 		goto out_submit;
 
+	if (!bio_clone_blkg_association(cache_bio, miss, true))
+		goto out_put;
 	cache_bio->bi_iter.bi_sector	= miss->bi_iter.bi_sector;
 	cache_bio->bi_iter.bi_size	= s->insert_bio_sectors << 9;
 
-- 
2.51.0

