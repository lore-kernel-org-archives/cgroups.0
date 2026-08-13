Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717EF41686A
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 07:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607454; cv=none; b=fjpayBsGYTaSuADMGIh56zk6pax4bA84Qe2mduq+0QPdIL4Nc/lDQCIOxlv86miSvKO8v9N0JcFmRvWbhgHi4lflsszOMzke+6t5jp9KBm7zPk2eMlWxDvD4JLEFr/3f50UQJ4DJHpLCR/WwZEhejoPtEmfKOUnbovAG4cYDnTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607454; c=relaxed/simple;
	bh=Z2P/u8p2VN2KJWt6zvZw7BNx1xVUliqSH9psL0YD++Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAyVdBfoGmkIWTRXV2Ko3bhRMK8wCU4iwsp2f4gTnOhGL734B/1Bj2Zz5qnm02f3Aipyal1oJI0uyPIlIUwEwsHgICxDe1qTMYkQRbNwCLxqkYKovqLOGdd8cLCtfRTcoboVPBFSv0WpDWIi/0o2LEjRJqTFjpUyz2/sjt0e9bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QfnOmuza; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QfnOmuza"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cffd93cdedso3056545ad.3
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 00:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607449; x=1787212249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
        b=QfnOmuzaLlOBfJSRQt+6wNtmExoJv0vM7YL9mHMqnjtzA6CzAZTjbv5yzMggdI58pG
         5Eirj8cFraWRpkSUAqsToDYBhKmsDjuyHflXNTWcv68WU/+ltc4bRM1MyDbXc6ch4Z/x
         NhaNXeazH0FE399QHZThXznibpsENxkeY0/elk7YNWlYpFTKRGlvxquwxDdtF9IIdfJE
         DNqQf88HAkjhA8jI1KT7XBsZOJrV6fdmZNi9dWX7zBXYRmd+oLgtJzYMx5+IduOoL9k6
         e6uoJL3zd/FvI8qUeBz8kWDM2gcBjoCRL2DaYtt/otPiOGC2MFjwxY0Vhw076kxwEi4Z
         h8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607449; x=1787212249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uO+fdQnTYZ+Aocv+Kahxqh7F24JHdH1Qim2aviwHKRg=;
        b=J+5C4buESSrKjTtSeTpmljVZw+lez/AxKS7SKn/EqpkHajv1oJQvewFhiCwJKFQSrk
         oj0fdXfc2FYpB+2lzCMnZQQffPic1Im1N6YHJvpQnKKxNGriNp+Od3oHJB4WX6W2C2ti
         p/oq8RbJP/1Jq7ZD/4UM5joLEKJIpzBUT5F98h1Y/JBTEyVb6KI1jNeghWhSxunVy+xc
         qeo0X7duq77gi/qGzxtE1OiMBWIMVcI5KKbZ0um8bFzdQG82LO02naFXlp/QPjJnIHBE
         TCBmkTkbEPMU10FOV71U3jGAUdh//8VsycvphxFdWtXaITB8XaVpd04JX7rwyU4EKhHi
         Phdg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/8vKCoz6jYn/4V6L8/Y94l8g8Ya7dq7iLlhPC65hBUUvTFjZEJ+ymQj2nzuw8BfWopmyLT4iq@vger.kernel.org
X-Gm-Message-State: AOJu0YwRW4/K9IYT/28BTnk85oGOS6/2yUmXYfx41KVP5+EmFRgvVu2I
	gYd1l7j9KaePFI1lwHHFk6WrFevpFrFrLj5LEQ6yF8i3D+ApF5t0SJ8m
X-Gm-Gg: AR+sD10oivcRCu17hkv+6CBqIeVs/YTJ4W7KfW3bFD9KACjc49M0Wf5g5MV/4XoTh9R
	2YirUEba4ayXQ3PTCSCxsrX8V19xKsX8GdYpErFeni6Gr0npNGHGyv+MSDLcJKPnw7fR/+JHFc3
	dgVB8N6TnGhvfgaPQI08LbYZ/ORjakwWcoMtwoHAqnGyn2x/ihzH8bFM2qM0+fYYc+Lw8Q/7Q7z
	FRqzGlcVc8D1BGjc4veWbYn1RJwKexTzuGT3/5flng9CQ06nphvPDjrDj4AkdZ1pI4vn3XTiEDn
	lrH2Ds7YeSVQxArCss3qZgQEXA+lO72qSycdZDIVl67BrfHKGMV/1ntp0szRtRkfqrdsoNKheR5
	s55hhs7Pm7twJcWU2UmxFRRnVSkadHvzBqsoEW8To2mg7Ksj+BvxcaOtwAJKZWoNVttl2ePJkqy
	tchgUrL2iqj47VXwsIr7twQ4USwB1pUD81LyoQBI/DjeVz5PAG1lYOiTq0LasLFRiSuLdyjYvB9
	vHcBXbKtS+FD/ZjHmNxo0XOh3u5hkArdqbr/DhuaAmJRxGvyvXtC54KYyiqhHKZTR6nRPz+eWoP
	xxDa5OTuNa7OZA/j
X-Received: by 2002:a17:903:4688:b0:2cc:d6de:d58e with SMTP id d9443c01a7336-2d37f237867mr34765455ad.4.1786607449116;
        Thu, 13 Aug 2026 00:50:49 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:50:48 -0700 (PDT)
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
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 2/4] mm: distinguish large folio swap allocation failures
Date: Thu, 13 Aug 2026 15:50:23 +0800
Message-ID: <20260813075025.1406585-3-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
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

