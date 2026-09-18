Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6CA51C062
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789754576; cv=none; b=rlJXX1ctqZhI1mpsFr9WKclT3INBHWV6l5MFAu6fLzRw3dvnQMCmjJegd8mSCFka6DwNc0kNBq+nAveGGJaqTWPPAKAPZdaC0Zla7fkKX6wWQlxTcMcBRP8hnWLNBrm+BKsRK5DISJK1OFCzzTZ/oLOSu7jvv2OfsdGWgXKxjR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789754576; c=relaxed/simple;
	bh=RO9jvV3V9zXQK+hpLOst1hPa/YVS04E+RkiRewZGdwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8/RPOXrZmmscxjLW4xe84WsXJD8/kJiCBI+Oc4ZncU3qRtkX/LXB0QKqPl+Mefu+W0IAefsU6xJhXmLKUOE9/Pa8ca2ZA23KP2r1lyZ68dp+KGjugQ3FSnJeOZmEdnGkeu7JJWXuMgf5Jh1dt9aZ4DKztwMx2Aq3OaM2egkwxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DWdgEdz/; arc=none smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DWdgEdz/"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-466ccab774cso659977fac.1
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754572; x=1790359372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=im6K772PTWgmT32pMTVGaO8Gd5j7dB48NMbCPlbIlg4=;
        b=DWdgEdz/BUB875vJORxYqGWY3TkyglLZYuuR7Z5GNVQVm5du70FyAfIOVk6GUiW8xe
         BFm929V/GFhF/9TPAdxkScjQHcDVG4xQx/LDIxljcN0mJnXWz1q5dVQL8/R9SSHAYMJq
         F2Bq6c14ji3YNKv6ODmBXmCFkSVMTQDhbECMkaWni1TbIkQuDSMWa6FUYX0ttDcgYp5D
         iAlS/k4VnFq2NhGZwxGd6ikyid176zOe3zI0XA5EmTdCLmlQjtoLU1FRVPYZGIYFhpCn
         0khAwgWmtTUU0+gYcIUbSb8kvGLSwVMBLElo+H+SYqFY3vop9/oJpLv2MSmLM3gQ0grO
         DHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754572; x=1790359372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=im6K772PTWgmT32pMTVGaO8Gd5j7dB48NMbCPlbIlg4=;
        b=I90QBsTpjvz1Q9i1OR8v8RWxO9tCw+PQHNrWncPGcjMbfsrQlHXbX2kpl0K3Kky3bb
         /s6OYGvphIYU49VIu0M7jCKUlXB/byqDcTkx6vCaYEiFF+g9YOyiwzFQtJJatzWz3aNZ
         49gpN3ttP7/zu+YdhNq5fPsspdYvKxPtpOZRVdsHj5cuPGBRfaHQ2M4BV302OM2IOVZe
         FStWAo+qR4cNEJy+4uagnXaWw4W1v9WoBYGNICocWZsX3+KCqVzV1TrIpg/6o1Vvt5so
         M2GVnCldwa9Y5ibLZIHodRZNpq6zsh22MAIDa9pddC7h0VfoygFPZLl7mdLcqFpI44Qv
         id/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxd7iVPNU9UmbQZzAqqffDQMh68LgLmWnknBYKvvU79lPLb7dLOtPH2/EoD2tx/2pI1j5al3IBC@vger.kernel.org
X-Gm-Message-State: AFuF++nrlqWBN8AS14pLWykSF6x00pxMSYRie+D2/J6OvXwLe9uA3xuq
	2vDmAKEE2ZSz6Bj2umAXfmHvoE0ZYm8GZhlq1uR391/BNCVa0iphJi2X
X-Gm-Gg: AYBFou3VXCWtZf87f5UKS4extwoa+GVbJDPOqgCQjvJv3T86+KZQoKORiIE+zmQm/A9
	iXVg+VqbFZjZ2vtsF+YJw39mEsS2qUVh8DR2k3aSkhIibb+KhdGGC880HFAFI/vqOcay9TqI6D2
	kro/WZxMMbeWG8MucikLBdFs4xIAwG9NdekUnI2DqRsDewF0UO0gub6o3I6U5QiONFrPGTEA00w
	Dy5nuL4vJr5Rqi2CoklGu0PrDLxTo7gnBhRwdh+WKiKux9HD1r1vT18LBe5Cqn4bmTZTYH7wsc+
	bAsd/5n5t5leoTEeahTgFRvLPLmvxFTGdBMCbWgOpej+TbU6ehiLz+bg0ozswP5DE1d4cu+peXe
	RlIpff/7/pxYhoXiK2UZq21osQmXjrXB8LYCxVDdVivcm/x9hG1a6hZWVLaKZSBanAbYTaJG3fM
	P8ZffHJxCodW3sD5xp8t/73zn+bGlTHalsHtKwzlBuF+6v/YEGg+vwizxG4iiO/PcizoBFl3JFe
	2tKx5Ppo9+StufSspoz+g==
X-Received: by 2002:a05:6870:b402:b0:47d:a38a:6218 with SMTP id 586e51a60fabf-486e6ac67d0mr3577258fac.25.1789754572094;
        Fri, 18 Sep 2026 11:02:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-48739852afasm1601298fac.7.2026.09.18.11.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:51 -0700 (PDT)
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
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v5 05/11] mm, swap: enable THP swapin for vswap entries
Date: Fri, 18 Sep 2026 11:02:35 -0700
Message-ID: <20260918180241.3424851-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Swap a large anon folio back in as a unit when its vswap entries share a
contiguous run of physical swap slots on a synchronous IO device,
instead of always falling back to order-0 faults.

A zswap-backed or mixed-backing batch is still refused, and the fault
retries at a smaller order.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/memory.c     |  5 +++--
 mm/swap_state.c | 17 +++++++++++++----
 mm/zswap.c      |  6 +++++-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e9e05e31c4f8..e052de3b4461 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4882,9 +4882,10 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
 	 * lack handling for such cases, so fallback to swapping in order-0
 	 * folio.
 	 *
-	 * THP swapin for vswap is not supported yet either.
+	 * Vswap entries are checked later, under the cluster lock in
+	 * __swap_cache_add_check().
 	 */
-	if (is_vswap_entry(entry) || !zswap_never_enabled())
+	if (!is_vswap_entry(entry) && !zswap_never_enabled())
 		return 0;
 
 	/*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 657622cfd7f1..2107d05ae8d5 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -165,6 +165,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	enum vswap_backing_type type;
+	int ret;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -193,11 +196,17 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return 0;
 
 	/*
-	 * Reject a vswap batch so swap_cache_alloc_folio falls back to
-	 * order 0.
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
diff --git a/mm/zswap.c b/mm/zswap.c
index bbfaeac00355..3e1aa295f9dd 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1688,9 +1688,13 @@ int zswap_load(struct folio *folio)
 	 * range on the backing device, so scan the range rather than rejecting
 	 * it outright. The caller has pinned every slot, so zswap cannot start
 	 * a store or a writeback into the range while we look.
+	 *
+	 * A vswap batch is checked when the folio enters the swap cache, and
+	 * its backing cannot change after that.
 	 */
 	if (folio_test_large(folio)) {
-		if (WARN_ON_ONCE(zswap_is_present(swp,
+		if (WARN_ON_ONCE(!swap_is_vswap(si) &&
+				 zswap_is_present(swp,
 						  folio_nr_pages(folio)))) {
 			folio_unlock(folio);
 			return -EIO;
-- 
2.53.0-Meta

