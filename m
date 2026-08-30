Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFBF241686
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 04:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064181; cv=none; b=lveBR7JBFdOIgzHyYPhdzhGQobL+RAPJmwycAC4lMORdD0X3iY2MkYWNn/DxcXpJ4Q8yS/gKMEa+NspjsvxanLOs1tHcNUdAUHDXiHHWYrvID6sGBI17PsVGaTSySEiE4UlvwmbuVW1SAMgjNmAcyP6zgjDADtbpzSQ2JYvMvWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064181; c=relaxed/simple;
	bh=Z2P/u8p2VN2KJWt6zvZw7BNx1xVUliqSH9psL0YD++Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwMW8nRFBRDgThHeHqxYgiEzS7yg0L4dTbLJw38guhwK9dNwy054kKvl1iQw7M0wxWuo2VUCgJL532/N7lHrUvpdDjNfqzk88zyN3hfuuZrjP8AGzdl2/nG10VpT8UI8Bh7nDsMdsTn+ejwaBpdJCrECLpjm5dPx4njXjDB+dhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mL5HnAV7; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mL5HnAV7"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d01548ac96so2413525ad.3
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 21:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064179; x=1788668979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
        b=mL5HnAV7XbmoU5X2+cf0KqtXXrvJ6SOvOTRUyZUQAMZyWgoJY4+UnusyN9lP/Kl2Uw
         b9rJH3skBNhfpMO3BR9tSY1X/guvQfdUV1J9/OnbQP/Sy7ThbdDlCxLtNRa76/NZzYVx
         kQwe9cRXjw9qmOk/TxNpXY5hZWxXI3uOkpXaf966fWLdYUGH5sl6w93Yb5gfZ3+4B/Zh
         DEW+O5VDQlAFAN6bRvkYtxLevYvdYZPeM+XYU52Xfy21N+jxbVe9vE0sUUJVe2ixeQDB
         T5/47mxM/KYN8MtNldYrHo4xTP6QOFF86eGPHpD84zhdt3NGBT292dvjMQCTpQ5Cc+uS
         6lRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064179; x=1788668979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
        b=sf1pIQ+LvZwPqws/eSKBZHFQydXniNIDnYGHKgx7Iey8k85M3GuqDTFKS6bwyqF2MN
         HNek5UTLOHgYke34SwL1cUqnn1CvGmPndOVt3uL7w/hav4fj1z22BVucpWI+GTAdYfJo
         xw2NbyWklZgLGm4wtWMdP2RLx1VWObx6+H6HVj6uO81aq/3yKZd1+4g73FuRITtllRjl
         r7EDQ5eNwTQZOFsv1nzvSkT3LXzTVnpC6/OBIloE7zW1oapGCNz2WNoMKnRQOPwul2r3
         g87RiYQxXrXgM5RsxElvqHKoKQAlFd+APp+XPWBahRr9rdQ08ulZPdDO3zfRpKflF+ES
         B+NA==
X-Forwarded-Encrypted: i=1; AKwUvBzoe1yZ9xdn+PmlXT6OCGDbTz1j7YuVcbUfKUB01W0OWOeOREbapVP/kLuUyTM75wPdivfWkI+g@vger.kernel.org
X-Gm-Message-State: AFuF++mr85zJpiEiCL/kTea5Yt9xgDQwxYFXhMI8Zk+SDScqxSK7uccC
	CorOmZEM4Y6U4c2p95MKWn28fNoHms59k6AdbSnodRhIgFGn1gDNwETy
X-Gm-Gg: AYBFou3c/Zu8d9k6TNiI1C2pxwM4nsJgnAD6vQLvhxT/QlVBTCoOVIw1F+JOy4JtVDq
	wXOVmfq4uC7rdt/q6tTw/8PILXHHeislnZrbC9s/Y39E0l3DoY8Adoi13+s8JKKqE7MrZxldG14
	c2d7xRtEpBPdvybF3wh4u5NwUCY4Lg3+v+30L9b1ZexN0J50iwPq3t/8A80/nOhDe2UTaGOQqo3
	Gv0wxkuwg1btJOBOFdY5dfInyVcA9QU1wd5har6YtXaqm226w6JyI/NDKusiczDNXbvurMwotUe
	RQl/l3EcHK7VF6oLeTdKEKuDbV6DII21Ov55ERjSOZWsFBCWOjsVmiJdoiKLY0JkPYBUEAbu5J/
	7swSq0CmP9vZk6qhX5yAooEKdWsbxEs4bJtQkqfBWKT5GhMQMwaRqWlvDFWbGyKkBUSkUgQEoOA
	5qOe6bY3CS/W6xtLTLmjaRLcIvp3hPuIWwfvxbkPBWsS00ABie3KsU83IbLbbwztuXBmvO/tPSc
	QW2fV6wUjXeEwOyUSXfcA3GJXjsy/amuRDfB8GSZ+zAeCKzjQ4=
X-Received: by 2002:a17:902:ec82:b0:2d2:a952:2628 with SMTP id d9443c01a7336-2d74def63efmr160857695ad.2.1788064179371;
        Sat, 29 Aug 2026 21:29:39 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:39 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 2/4] mm: distinguish large folio swap allocation failures
Date: Sun, 30 Aug 2026 12:29:18 +0800
Message-ID: <20260830042920.2280454-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

folio_alloc_swap() reports most failures with generic negative error
codes. Reclaim callers consequently cannot tell whether splitting a large
folio could make progress, or whether no swap space is available for even
a single page.

Classify failures using both the global free swap count and the remaining
capacity in the folio's memcg swap hierarchy. Return -ENOSPC when global
swap space is exhausted, -ENOMEM when splitting cannot overcome the
failure, and -E2BIG for a large folio when allocating or charging a
smaller folio might still succeed.

Use this classification for all folio_alloc_swap() failure paths,
including capability rejection, swap slot allocation failure, and memcg
swap charge failure. Callers are updated separately to split large folios
only on -E2BIG.

Suggested-by: Kairui Song <ryncsn@gmail.com>
Suggested-by: Barry Song <baohua@kernel.org>
Suggested-by: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/swap.h |  6 ++++++
 mm/memcontrol.c      | 23 +++++++++++++++++++++++
 mm/swapfile.c        | 26 +++++++++++++++++++-------
 3 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0544b2ec4c56..b23108d992aa 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -525,6 +525,7 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
+long mem_cgroup_get_folio_swap_margin(struct folio *folio);
 extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 extern bool mem_cgroup_swap_full(struct folio *folio);
 #else
@@ -538,6 +539,11 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
 {
 }
 
+static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	return PAGE_COUNTER_MAX;
+}
+
 static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 109c08be91cf..4b42f3fc6075 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5676,6 +5676,29 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 	return nr_swap_pages;
 }
 
+/**
+ * mem_cgroup_get_folio_swap_margin - get a folio's memcg swap margin
+ * @folio: folio whose memcg margin is queried
+ *
+ * Return: Remaining chargeable pages in the folio's memcg hierarchy.
+ */
+long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	long margin;
+
+	if (mem_cgroup_disabled() || do_memsw_account() ||
+	    !folio_memcg_charged(folio))
+		return PAGE_COUNTER_MAX;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	margin = page_counter_margin(&memcg->swap);
+	rcu_read_unlock();
+
+	return margin;
+}
+
 bool mem_cgroup_swap_full(struct folio *folio)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 70b90fa9c2a0..651682b1fe63 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1735,7 +1735,9 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
  * swap cache.
  *
  * Context: Caller needs to hold the folio lock.
- * Return: Whether the folio was added to the swap cache.
+ * Return: %0 on success, %-E2BIG if splitting the folio might allow swapout,
+ * %-ENOSPC if no global swap space is available, or %-ENOMEM if splitting
+ * would not help.
  */
 int folio_alloc_swap(struct folio *folio)
 {
@@ -1747,11 +1749,11 @@ int folio_alloc_swap(struct folio *folio)
 
 	if (order) {
 		/*
-		 * Reject large allocation when THP_SWAP is disabled,
-		 * the caller should split the folio and try again.
+		 * Reject large allocation when THP_SWAP is disabled. Check below
+		 * whether splitting and retrying can make progress.
 		 */
 		if (!IS_ENABLED(CONFIG_THP_SWAP))
-			return -EAGAIN;
+			goto failed;
 
 		/*
 		 * Allocation size should never exceed cluster size
@@ -1759,7 +1761,7 @@ int folio_alloc_swap(struct folio *folio)
 		 */
 		if (size > SWAPFILE_CLUSTER) {
 			VM_WARN_ON_ONCE(1);
-			return -EINVAL;
+			goto failed;
 		}
 	}
 
@@ -1775,13 +1777,23 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
 		swap_cache_del_folio(folio);
+		goto failed;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		goto failed;
 
 	return 0;
+
+failed:
+	if (get_nr_swap_pages() <= 0)
+		return -ENOSPC;
+	if (mem_cgroup_get_folio_swap_margin(folio) <= 0)
+		return -ENOMEM;
+
+	return order ? -E2BIG : -ENOMEM;
 }
 
 /**
-- 
2.47.3

