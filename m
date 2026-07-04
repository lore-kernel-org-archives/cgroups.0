Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8B130FF31;
	Sat,  4 Jul 2026 19:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783194806; cv=none; b=BgE3h687HWYqwOwVzz6YH87d5fNqO6Bx2A/hoYhptoHenf29akagIDJyXMRuyizc5UbDFVQ/242N7026NNp/wE2WL7o2GX0vgkfenIDR4YaJ1v98cfmB3XlP2eW+cusmAQdKcBdfE3cd4NLRfjlWoIzeknJRg5eQx1lW6Zj4nsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783194806; c=relaxed/simple;
	bh=OKOcxwJnkc/ARSDUgDrCr7CN2a3rBbXYZDdk3XCqiZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwqSxi9q2DX/m8AQ8FB1o8bReEPWsNM4OaThJJdHDsgJ0Cxi45n0PF8gdoZYESoO2bpkJ4KGiQxHVOV10qQEOtKz7OqRZvoCF6Uc/vVEheha67p0KqJ2dSJVCIfYJuSuqEIN3nwwQeqZAjG6Lsqkts8nGBUR3fF2FZvv/QzGlR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaWuNgIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaWuNgIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04741F000E9;
	Sat,  4 Jul 2026 19:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783194805;
	bh=zQ8NFFnrfR/LxjP0ImdEIBDB39CcwzRHlHhlzG8LKL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GaWuNgIbCwmzP/42S9NjcYrEKh2oUpGrkIAKeT20J6b1vRH4wcKKjaPAek2aTwMeQ
	 pcr4Byu3MTJJlaWTMeqmVIqfcbjXVq2+US7UGlbSj59zTH6o6yatGKs+z6pDbJysmN
	 QhvYmsxxLbDiaXEseGwF4BD158z4u9o6dB9/p3JvLqCsitCuxqdwoQPFIMqaWj9zpi
	 +5z1Rp8rIjathQmJYXiSGDJca6vTkzlOHZ2NB86clARjAPpiBpiqy9RYPjeas9GdTc
	 BqhNcE5+57HLidXrJwJPAiIYDOZ3hr3s6j0Y6u8Ih8w1PvPidZNL4uJuH5Dp0SDtZy
	 eWs+RLcFRHQDQ==
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
Subject: [RFC PATCH v1 09/17] dm bufio: avoid blkg association from GFP_NOWAIT bio init
Date: Sun,  5 Jul 2026 03:51:16 +0800
Message-ID: <20260704195124.1375075-10-yukuai@kernel.org>
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

dm-bufio allocates a bio with bio_kmalloc(GFP_NOWAIT) and then initializes it
with the target bdev.  That initialization can attach blkcg state and sleep to
create a missing blkg once blkg lookup is protected by q->blkcg_mutex.

Initialize the bio without a bdev, set the bdev fields, and associate blkcg
with nowait=true.  Fall back to dm_io if a missing blkg would need to be
created.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/dm-bufio.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 26fedf5883ef..2002d9020dd6 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1347,7 +1347,14 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
 		use_dmio(b, op, sector, n_sectors, offset, ioprio);
 		return;
 	}
-	bio_init_inline(bio, b->c->bdev, 1, op);
+	bio_init_inline(bio, NULL, 1, op);
+	bio_set_dev_no_blkg(bio, b->c->bdev);
+	if (!bio_associate_blkg(bio, true)) {
+		bio_uninit(bio);
+		kfree(bio);
+		use_dmio(b, op, sector, n_sectors, offset, ioprio);
+		return;
+	}
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = bio_complete;
 	bio->bi_private = b;
-- 
2.51.0

