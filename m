Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792562624;
	b=VbCUfsXb+9dXwcKP9hJFsQadgkdksh74Sh6yCmN4nMfm4yNDGa95UayqLrJ0g2mRDrzz
	 8iWFxDK/O32MUA49PpAd9a0wPr/hxdd8L7scH4HU1nkGhKcCLkKfQMMarv1BQto6gndhG
	 DDcFlIpk9odvyHqzqAENM1OEyZf5SLqztmdyqwtnZKcsJXRyiav7HQpyrAZbcd+m+Vr5A
	 cqHzQN8extM0KBCylQ71vbMWqZ7jVtVCN5kDdkuojZtH73r5gXqOzxTfVYOmhiWmeiMCr
	 7C5TtRA1emInMHNRhgVBOkWoivceUs6zk29v2yy84quL8jeuuFCIDAve+7CIon4TShA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562624;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+TsRxErWT6koYb6Xgo6QbB8vqh49N8f3WZDdlHz9iT8=;
	b=kPqcGZ19cybZ9boCJ0cfAdwQNBp972bDsrOBazsizddyou/kpezy6i9Ph/Vxo2e0rhVb
	 3X4KnKQhqo66fcZdDCspEuDtPYiNCxeGFMBz+Ey2bwtO6QGlI7LJF1rC73v3ogC9k/Hhg
	 SOJGjwNIPXk78gcQLYxYmTZRSmnUPQ2L80bCpZQ4Hnee1MlFPT9rxsIbQJqdng3hUW++a
	 CPPPiEGzBcrVO+mMcDma13kYLLgSu0KinnEyNLc+OCc6vdGdwe1zsTN4LaLSVK0oYDWdw
	 /eGYh1V4UPMNzdKxQsTC70U3nTtgUBYJTivys89ymbKCXfMKIL5Muv4D0T91Fmlb04w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NsPaKD2f;
	arc=none smtp.remote-ip=74.125.224.51
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2F060A2637
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 06:03:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC2F060A2637
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NsPaKD2f
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-679aeeddc6bso378496d50.2
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 23:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562623; x=1793167423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+TsRxErWT6koYb6Xgo6QbB8vqh49N8f3WZDdlHz9iT8=;
        b=NsPaKD2fIf84Pt4WIbaiiZ1JbCcqSw/gidqj7LyzXn+G5xJ/6ye97icBsoIewABXlN
         bzoQhxfB+4qvA+XPI2BamI0J5lDZHqJNI7rQ1JBAbJ+ZC6APEhToIIXKHIaGGO9ggfcF
         2EcTcF8JH77So0rLNX19lRvlPA05qFrTNoURxcgUE+WpweFR52daI8q0EokVcJ9NtEac
         qZysdlhw9H2y3bs7ACAjb0gkfpl7BcNjeWtT/nJb1CS/CQb78FlXbaNDoUpbPn1M+fy7
         WtBfmZGC+u5baOyyqrW9R7cpsazBfaKu6A3iMmwkefSRyb1MEbS7KR9WS4P1hqvtCXoO
         9XVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562623; x=1793167423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+TsRxErWT6koYb6Xgo6QbB8vqh49N8f3WZDdlHz9iT8=;
        b=NHcpxzTuJpmLkFGe6Wtn28AFqHoUqyO6fTMpg+8MqfUYpQeGY+hfZiqaszszaud8HT
         BQZhr61BGodt4fXVEdyPze2hGArcNWywPOk/wUWRQbdgiaO01lnojC9VpymZUuA4V2tZ
         1UDUl+qLm222FQQho4MYW9AUqYQ7uQcGL+l8PPaLHBBHEbQMMH055l76TuPS/bLPYp+B
         YFbCCjXBRI47jKMaClpbH46UdzHmSTmWlEj//H2asj850NINQwp11t/R2mrH9iCf91qh
         TJ6LqwHyS40SlafPYdHnRKyP+bmEP2cbrqSaNcC18IKGh/wSXa2Cc8NJLmDe+EsmSLok
         qNtQ==
X-Forwarded-Encrypted: i=1; AKwUvBzldgwEtzzPcpx2RuX++ThT8z30fdxk8vt8FBjHXizHnltYhZ7WjdP45WSDH7lj05eR3T1EZiDy@vger.kernel.org
X-Gm-Message-State: AFq9FYL+dZT5XNYCKgkly81WRGxZpnCYjQJOe7bEIhBSWcx9hw8kL6uf
	znvrtXZ1WeFWOAiotWMu+w3HCANTOk9V4YXVRbuxWkWebCThaX504usC
X-Gm-Gg: AYBFou2ltqgbeGPanvN0TL+h2Q2RlSryOkBLKXfx1oNz6ssMAIJQlkPylkkRVRZFcAU
	M3fsOafHisTTUL0cMECJdyZdzTU0sF1VmrsaioeaoW56kQ9YvBnExGUzNpGIWWRspNEXqH9eO+c
	eMAs2tGaR4CIKQNmb17t79Pz/xoRPrXQGHB11oAzH+05fhUsKQ2Q9fJPSZ9L04DV2oAJgyLw/S0
	c/jAt/DN6/i5uElmSebqtJe/El/j0nD+WMC84W7HOHEOm5WQDbuywQ2lgYAUq1Upkjp81p9xF2l
	BD3DcRO16h/JwusbDzDyGNRBSIJ1KeEK20vXk2ZE2YFAhqNH40Ias3sfv/oj09naxuxsxtY5Nvo
	42i0v3O3d243Ser7OfufEq95RChk+yCuZt/kBAMAGFGJbdeKotDuU4rY58ACqh3bLb+5aaPEupx
	8o5C3KF0SMtqXEWhGbECDfpmxVEuphW2xCJhsymaWkJFq2nDXUTvTZ6MhVVGnwoptCStZ70fFU2
	CBecj827drg5oGtp7ogsGLiCEvb9dgGHPRRKVZv3ki138r8LVyCvRJdFRGURmfA9HSHRBiyG9Cw
	6ihWxU24q1/RYQRsD9o17jHmblD7Ry3Al8IZLtwxv47YbklUeBG0u6Jd4El3ywm6d/KS3nE+Y4U
	Up09Wgg==
X-Received: by 2002:a05:690e:488d:10b0:679:8c5f:3fb6 with SMTP id 956f58d0204a3-67a0e0417acmr381635d50.9.1792562622988;
        Tue, 20 Oct 2026 23:03:42 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e496732sm619480d50.5.2026.10.20.23.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:41 -0700 (PDT)
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
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 05/12] mm, swap: enable THP swapin for vswap entries
Date: Tue, 20 Oct 2026 23:03:16 -0700
Message-ID: <20261021060323.553433-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
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
index 9f651d247eef..430b83900ba8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4885,9 +4885,10 @@ static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
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
index 3900975c675f..6c8e8f49e349 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -174,6 +174,9 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
 	bool is_zero;
+	struct swap_cluster_info_dynamic *ci_dyn;
+	enum vswap_backing_type type;
+	int ret;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -202,11 +205,17 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return 0;
 
 	/*
-	 * Reject a vswap batch so __swap_cache_alloc_folio falls back to
-	 * order 0.
+	 * For a vswap entry batch, reject if the backing is not THP-amenable
+	 * (e.g. uniformly ZSWAP, or mixed). The order-fallback loop in
+	 * __swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
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
index 24c4e7a73d56..1b91dba992ab 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1753,9 +1753,13 @@ int zswap_load(struct folio *folio)
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

