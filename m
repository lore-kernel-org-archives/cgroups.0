Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15613B3888
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041792; cv=none; b=DDd2d0aTMTgq0Abqw0200Yg8OnUEqtrpXOMLzg/t5mJrh3RwKu+5iC+HlM0eWegRGNkHNe53b1X8zrq72w8GnVn5gyY1wy1MSA/ufR92M2nQz/O4+NjCd3je3EnjAyn1VCaZQrofjz+dDvDt+MYpFCee0IC8Xq637z2ca+/CwMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041792; c=relaxed/simple;
	bh=k1/KSPa5L2DOT9UD7QQB8WB9l25sWbdPKEqNWKJbyWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tas9jcPZGg3KLzHqyOMBAdSIR7hZrra2Sf2wJ2Da+S10kDJhKvNp90B8LDDcNp8CPpD3aS3i8vMS0V9quU5xUonRlLfLcrsPCvQPQU3R+LWMJ5pPgVC22F4zjSbEGgxpj0zHDNNGEtOIvXYOVL6RMb/J/SSMfFZqdtwvh81y1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DJrAUnj/; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DJrAUnj/"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e9f1f24cbcso1269527a34.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041788; x=1786646588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JkErdUV7HA1hqz0H4I2ABEL6H9gZP+ZkKpUGTLLTXSY=;
        b=DJrAUnj/RSFNrEFyG+jPHuwV9T2LlnbHdhs27v8bfpEZgj6aU5vxmHQkMGMY22mNfu
         UOhDkqe1Se7Ll7UvEKzHNCMhqQG38ta7IFbT1s4Y4/gZQTMerfhW0pZi1pCKTh+eLeDL
         DAhHEB+EYejIFd/BwDt6ByxAkUdTD30zBKFRQfp/ewG4fMcYIxaUcoFtxVB7seJtEOFe
         8916TftEGV1K8xmcU9wt223IOScQ7mXGFcAhgL535PWdar6a//Peoj8uf0qmtsB0Mkjk
         GgcpVzYqSpSVwGNWroSgIaAlbYlQivHCWY+8VYRQyAiZleoa+xbUkmHBoRPepJC/1Q6y
         +yzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041788; x=1786646588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JkErdUV7HA1hqz0H4I2ABEL6H9gZP+ZkKpUGTLLTXSY=;
        b=rBUtUlpRBPRkyQ6FuS76Tp1uELYsAnsb2p3A8cG1HMAAAIQp3nS94+ZhWz4UaCdxCO
         OAh93hB8IxbSzEKIGhw0rIPss9nIXzWaBjOEdXZUjrdQlmlkWOaYNiepFtIOahUWW/oX
         3B1Z2J8Wxe5l75MS8/EsvXD1zf4eIWyNFTnJ1gI0QyW7FmKznTWtxggVTVbjd40DMJjq
         fijPef6q089AHAznkU0sRtKeUZkmbiEA526JiB0lOdx0N84dCWbDfsOnEvnqwmjtew4o
         P/2AN4t5fESUWGlCNcTrrg83gXu4otT8/rYlEweDVKGkjF1qtruKzqAdd5wwGv+10iz9
         YpDQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrjl9XCNLYmX1rzmbzGCNB2UwLUOyFQl4Oh5xgb5XTs4hDTp8RHVx+pSFWtBGtq43Bf/drqDo42@vger.kernel.org
X-Gm-Message-State: AOJu0YxVrbFz1HOjYZ8wt0C2tBxLzFQazuy9uZSpp81jqP7IDNwr8jht
	6hF6YeYzHwKtgiywxhRLN1TzK8YTQ56tTgQYM2miIb2Niap0EgtPmyJr
X-Gm-Gg: AR+sD11cELd9m2JAV6zrOD8M+2CilJcV7EZZVbi8ZYYI8soCx4DOVVihyfj4ZfPsWbp
	Dre8SrdAw/D59r+lEit6kXBRwETvmGN/LTlXlHGzN5YfOfKu1mus38QtCSI5UDUZrv7TU4qCmeQ
	hwZmDdfMmE7nw2fuL9rWnOLqYvH5qpQVTaJmqoloD6ySy70iGoZzmEO9ViALpwoDURZ9mvS1K2B
	f7ieltsjtpf0peVOG7Z9SNwqojarx4fhYqWKPpYKK4a0xZSrmct8tfxk2Zz8MDSS0C3oI538L5E
	blTCbkHqFMBB5/vPLpa778OhyXjw5Gb5+LiJ8sMpSvPElvclLrXUVqQwsHyTmezbX151dR+Tf+l
	bCxdjYSahODQzRtX1JQOEwkj9GLNibjo0MEuHtgcMPTrOHvLVbmihFoC8HAFM+DPze/LkcMsBRS
	2wf63hq0RIGzsPKdB8H2hpewVQFIh7oqE5K/dKyGaCzbO7vGiFsIztLQJdGJvAAp04Kh93oWUx0
	dLLSxqD2w==
X-Received: by 2002:a05:6830:6d19:b0:7e9:dabf:fba0 with SMTP id 46e09a7af769-7f3444f2529mr1882168a34.15.1786041783901;
        Thu, 06 Aug 2026 11:43:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f1df34556asm5010219a34.9.2026.08.06.11.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:03 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
Date: Thu,  6 Aug 2026 11:42:48 -0700
Message-ID: <20260806184254.3790858-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Swap a large folio back in as a unit when its vswap entries share a
THP-amenable backing (a contiguous physical run, or all zero-filled),
instead of always falling back to order-0 faults.

A zswap-backed or mixed-backing batch is still refused, and the fault
retries at a smaller order.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     | 12 ++++++++----
 mm/swap_state.c | 17 +++++++++++++----
 mm/vswap.h      |  7 +++++++
 mm/zswap.c      | 18 ++++++++++++------
 4 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ba84565605a1..a1e106a5c5e6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4815,11 +4815,15 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	entry = softleaf_from_pte(vmf->orig_pte);
 
 	/*
-	 * THP swapin for vswap is not supported yet. Also, a large swapped
-	 * out folio could be partially or fully in zswap, which we lack
-	 * handling for. In both cases, fall back to order-0 swapin.
+	 * A large swapped out folio could be partially or fully in zswap.
+	 * For vswap entries the THP-amenability of the backing is checked
+	 * later under the cluster lock in __swap_cache_add_check, which
+	 * rejects ZSWAP and mixed batches via -EBUSY and triggers
+	 * order-fallback. For non-vswap entries we still need the
+	 * zswap_never_enabled() bail: zswap_load rejects large folios with
+	 * -EINVAL, which would SIGBUS the fault.
 	 */
-	if (is_vswap_entry(entry) || !zswap_never_enabled())
+	if (!is_vswap_entry(entry) && !zswap_never_enabled())
 		return 0;
 
 	/*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c61bb3eef62a..479814d19f50 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -173,6 +173,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	enum vswap_backing_type type;
+	int ret;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -201,11 +204,17 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return 0;
 
 	/*
-	 * THP swapin for vswap is not supported yet; reject the batch so
-	 * swap_cache_alloc_folio falls back to order 0.
+	 * For a vswap entry batch, reject if the backing is not THP-amenable
+	 * (e.g. uniformly ZSWAP, or mixed). The order-fallback loop in
+	 * swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
 	 */
-	if (is_vswap_entry(targ_entry))
-		return -EBUSY;
+	if (is_vswap_entry(targ_entry)) {
+		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+		ret = __vswap_check_backing(ci_dyn, round_down(ci_off, nr),
+					    nr, &type);
+		if (ret != nr || type == VSWAP_ZSWAP)
+			return -EBUSY;
+	}
 
 	is_zero = __swap_table_test_zero(ci, ci_off);
 	ci_off = round_down(ci_off, nr);
diff --git a/mm/vswap.h b/mm/vswap.h
index 239b47b577d5..a921620f08be 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -378,6 +378,13 @@ static inline struct zswap_entry *vswap_zswap_load(swp_entry_t entry)
 static inline void folio_release_vswap_backing(struct folio *folio) {}
 static inline void folio_release_non_phys_swap_backing(struct folio *folio) {}
 
+static inline int __vswap_check_backing(struct swap_cluster_info_dynamic *ci_dyn,
+					unsigned int voff, int nr,
+					enum vswap_backing_type *typep)
+{
+	return 0;
+}
+
 static inline int vswap_cluster_alloc_vtable(struct swap_cluster_info_dynamic *ci_dyn)
 {
 	return 0;
diff --git a/mm/zswap.c b/mm/zswap.c
index d0c6ce2aa092..5dc338188a29 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1630,13 +1630,19 @@ int zswap_load(struct folio *folio)
 		return -ENOENT;
 
 	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
+	 * zswap_load() does not support large folios. For non-vswap
+	 * entries this is unexpected on the swapin path: WARN and
+	 * sigbus. For vswap entries __swap_cache_add_check() has already
+	 * filtered out ZSWAP-backed THPs under the cluster lock, so the
+	 * large folio here is zero- or phys-backed; return -ENOENT so the
+	 * phys/zero IO path handles it.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (WARN_ON_ONCE(!swap_is_vswap(si))) {
+			folio_unlock(folio);
+			return -EINVAL;
+		}
+		return -ENOENT;
 	}
 
 	entry = zswap_entry_load(swp);
-- 
2.53.0-Meta

