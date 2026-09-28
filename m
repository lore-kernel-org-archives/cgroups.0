Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843D81CD1E4;
	Mon, 28 Sep 2026 08:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583626; cv=none; b=Xzygeuyf3nM87n0eNX7pcK/mmm9SUsVnD0Epd2FswrnASEqcETByJuzbpMS25ZjQCPZAK9RxBvhBV3RTl8wUnILRG8bn3TLQ/VgA2J9p5HnRWD4DS6R24DAXmY41dDFqRUPKqHTGTVMd2TBZ8XqAF0kkHHGUU4GjbZmIQMzWDXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583626; c=relaxed/simple;
	bh=EIOlTxc/PUvmWAXCep9gmlZnbbjYSFRzmdX6+vr4OJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aND59Z5sQoX2eGglIDWgmFGbs5P/Nez732hlAaHRxsLv1NmC2YiLd4jKgCwvb/GZcW/kjcrFyZoGcLqSQbb512LADC4c6Ebyqi55VLFHKYT7O6XX5aM7+J8rmiXttO/vKmqvCRLdYPZGeZZ43LUPC/YOHlmwoG0AUq092favUBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 669973EC5D;
	Mon, 28 Sep 2026 08:20:13 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 1/4] block: do not issue background swap bios as root
Date: Mon, 28 Sep 2026 10:18:36 +0200
Message-ID: <20260928081900.4187482-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928081900.4187482-1-alex@ghiti.fr>
References: <20260928081900.4187482-1-alex@ghiti.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGtUmpjxhEfx2k/XMvfS2bDqEP9+dB5zZisGhxTwA8bQzLw3TIzq2waSv+gTQCne6+EBQmyW7bEzXaepF5Okak6AT+sDdJyFRS8JBxX5eWAn2dKQA+IxAW5YOKg6RuNOZXqSmdOPVtik4kDkXkMveBkIhwLfHH6+oJtYNWba4phVM5VwK3qK5PwYOtrhYesE5w8z8mqi5VPr4rtOenhStP9HwF40aqyUg3ojWVSxtNC6vSsJqOcXNUU4pC8KocXQZNj6qmJ4vmZaKB0nGV5McglAJybgGAm8g3dYpUDEI9WO4UM4y91lgaIcJNucAmybGIzNLZsbSjgKfmbti5QxXMMfUvFbT1AkH89G/MMj38j4q74p5XkbfKyohiHv9XRW4UD/pdec83V4NQkOXrvURbOT96oYYrYHDxmjFK1KjchHzgYg8zGemrbUaVE2vKPg16rjveWSO9xAGHGqh2ADS0qK/PcGf9ne04mTtbDtfkNij3DEXnMjJrdi8Taez2DFKDdhwBktDyq2o77Np8WcYQcvmTb1BxknF8+K9IJQOe8OcxYY8ciEPlX5n7qaSNaXmtsI1/dOMqnOv3F/LfNKoKqg8r98gWpdvostny/4LmW7Tli5vDVhPTM8H2Bd5lnbS74gF4KOUwMJJD9BuWbTC+IniWZc2wyvhDuRx60ETwFBg
X-GND-State: clean
X-GND-Score: -100

bio_issue_as_root_blkg() issues every REQ_SWAP bio as root, bypassing
the cgroup IO controllers, because reclaim cannot stall indefinitely on
swap writes. Some swap writes are not urgent though: zswap writeback is
best effort.

Such a bio cannot simply drop REQ_SWAP: dm-crypt and dm-thin rely on it
for limit_swap_bios, which caps in-flight swap bios to avoid a memory
deadlock, see commit a666e5c05e7c ("dm: fix deadlock when swapping to
encrypted device").

So let REQ_BACKGROUND, which already marks IO that is not urgent, opt a
swap bio out of being issued as root. No swap bio sets it today, so
nothing changes until a caller does.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 block/blk-cgroup.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index e67c69839129..02009cb45495 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -242,10 +242,16 @@ void blkg_conf_close_bdev(struct blkg_conf_ctx *ctx)
  * the bio and attach the appropriate blkg to the bio.  Then we call this helper
  * and if it is true run with the root blkg for that queue and then do any
  * backcharging to the originating cgroup once the io is complete.
+ *
+ * A REQ_SWAP bio is issued as root because reclaim waits on it, unless it is
+ * also REQ_BACKGROUND, which marks it as not urgent.
  */
 static inline bool bio_issue_as_root_blkg(struct bio *bio)
 {
-	return (bio->bi_opf & (REQ_META | REQ_SWAP)) != 0;
+	blk_opf_t opf = bio->bi_opf;
+
+	return (opf & REQ_META) ||
+	       (opf & (REQ_SWAP | REQ_BACKGROUND)) == REQ_SWAP;
 }
 
 /**
-- 
2.53.0-Meta

