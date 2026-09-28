Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF71471CE1;
	Mon, 28 Sep 2026 08:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583693; cv=none; b=CZo4Hz78+kPexwtLXQsU9y82nByF3m8WfC2zz3+p9b2glqukXlBaBg1j/dCrFe3aFJ2962cWOUKq/DScQIbXH1dPJTLScAQgeedSFPy1NiuEsrq1s7/iHKXyuuswWvqx7dJOakJav3Af2l/YlXRA44vxLJEnvC/v2nJU3uXOw2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583693; c=relaxed/simple;
	bh=mvQWMzaO02aE8Nk55ThBBhFBKrmvTfppQpcdRv2cfsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ez8Tw6Pf+z+cIFVNwhaFLU/djo6+CKFQ8RrbYnt798gaAsmzvmF9+k0ZANjwK9hpiISk6k/zRhJbDnWEopfxpCZe18Afreu2w/DGofZ6iyBkvKyIwsFBq8HMalsCrBMyx9mXHThWdmeyzYwPy5Om0Ug0/i7RZ4q3ZIDEIEvsRBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 20BD03EBCC;
	Mon, 28 Sep 2026 08:21:16 +0000 (UTC)
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
Subject: [RFC PATCH 2/4] mm/zswap: turn shrink_memcg_cb()'s argument into a flags word
Date: Mon, 28 Sep 2026 10:18:37 +0200
Message-ID: <20260928081900.4187482-3-alex@ghiti.fr>
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
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEpuKzi+9nZy15nMgJyn+LYM68tVW6nw40rxZ2FTtj3LkINJ8XpzVdLNzm+4dPd95uwxkyI93VqgXgJKruJ5Zx87IWGb9/o5Cg0CIuB8fLJCUAhJCMsfIbCjrnaJ8jpiGh/113ZE4AwYUpMCteHajJRR+jCW0CIdVCAEmf3ip5wCzp3jqTh6yehydxzWU4OQncDlE0Fy9xk5KRKwDJiCdo8BzLvhyOaB28rIgpKDh6opr+ObwRBiI6Yzn3uKDeXjqYlaOgG/XGiiuJ96Ejgwm2eSNxFkynogMVHXUeYQfH4jxVmcqhC+6wcbD0TSVlZCcoKPR2vq/qFU65Hn1PjOKTnPF5CVTzvPT4crn7Rw6CeOm/etPj9O5fA4XnHWKmMg1BDdylPSbvxcpE+2nYlnYLiNPrMnbQp7OrNxSVHkjitjAVvgLl7C207BsVBVFyBlt+p6Oa9RLhV8hQhZYDrqH2ZuYh85onxqT/6kkScowRiJit2XbFOyX0fUt4iMngHQSHHw042D8CFK1m65CEBQV7ZDSDpAbJUlAcrDkLNpH5xIete8TfYe6o0vwg9BI56zPruHwFaAs91/NxDUrMaE9z2O4jQgbJBMpjl5E2dyZUEbdpXTXQma7NV0M215RavDQ99CU/jhJt+CF0XwqqbNCSAG/ktF6zdY3SnukjDhyYPUA

shrink_memcg_cb() takes a bool pointer as the list_lru walk's argument,
which it sets when the walk stopped at an entry already in the swap
cache. Make it a pointer to a flags word instead, so that callers can
also pass flags in.

No functional change.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..8925b6100402 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1065,6 +1065,14 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 /*********************************
 * shrinker functions
 **********************************/
+/*
+ * shrink_memcg_cb() flags, passed by pointer as the list_lru walk's @arg.
+ *
+ * ZSWAP_SHRINK_SWAPCACHE (out) is set when the walk stopped at an entry whose
+ * folio is already in the swap cache.
+ */
+#define ZSWAP_SHRINK_SWAPCACHE	BIT(0)
+
 /*
  * The dynamic shrinker is modulated by the following factors:
  *
@@ -1091,7 +1099,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
+	unsigned int *flags = arg;
 	swp_entry_t swpentry;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
@@ -1157,9 +1165,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+		if (writeback_result == -EEXIST && flags) {
 			ret = LRU_STOP;
-			*encountered_page_in_swapcache = true;
+			*flags |= ZSWAP_SHRINK_SWAPCACHE;
 		}
 	} else {
 		zswap_written_back_pages++;
@@ -1172,7 +1180,7 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
 	unsigned long shrink_ret;
-	bool encountered_page_in_swapcache = false;
+	unsigned int flags = 0;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1181,9 +1189,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+		&flags);
 
-	if (encountered_page_in_swapcache)
+	if (flags & ZSWAP_SHRINK_SWAPCACHE)
 		return SHRINK_STOP;
 
 	return shrink_ret ? shrink_ret : SHRINK_STOP;
-- 
2.53.0-Meta

