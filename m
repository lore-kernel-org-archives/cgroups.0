Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B8F3AFCE8
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 18:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786041794; cv=none; b=Z4dlYYvMURiQ+TlRW9f+D8eEots1jL0krEjxJ5KNwk3k6jRcNlDW4B3QLYXsqYnk3yqV6mTcKKzGsusTBLGd80nJDfkS2YdWAsy0gO7iLYTNsctkdjzgHT5rRHqED0BAoHuVPTojSl8gV911iXfHEmbRgepWSKT3D/nrj7ytlY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786041794; c=relaxed/simple;
	bh=SNocFtXa8C4f89zudX1FgBzt9ndc5ukWPrs95OuM/mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ccb+9aPSoqDAwBD7RC4Or9sfElf7Zg8KrbDdCeRPIVz7JfYZL685nwYEQfjX8oLeAgPDsakOyLObho+5MBBFGE/Ctp97l0n9P6Wl8YqsYoFjKIZWKSMDQ1Vx6lZAslN3xt1VJMTbLPtj23zc2zEIrpYP6l3WgwgHgBVuksRsjI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ptmri/R6; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ptmri/R6"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso1838220a34.1
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 11:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041791; x=1786646591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XJDCmTvRD2vNfT2YGrgT7EosXDcYWyreOqvvzwLRIg0=;
        b=Ptmri/R6ZldQ/qJl2OO758kFbjzO5Ug6DAyl44CthNFbeD7UqwI/8cClwyM9iMzvJ6
         nterH73G/ggywFCtl0Gr8Q6F16EN5VeK1t6N9kI8B7mSQ1mSOc8rGMOSgY7Yw8L6TWDt
         fhrxOlmM/QrsqAceSfFvWWB+uOexdgIEvgVPcB+gMfFQgoPjnvCXWtq5M2LWFGWkiQuG
         NT14HIu8f+VIgIZDeaVAcgzkRuIjvQtDvQfz+rglaEKm6wuTe76L0r4vSFx8i5jcdiyG
         Dk8TBnR4k26DzBbnf2J+S3V6e7HRpHznE+euBtEJXL3Qm/D5RZTLgneNcFeIvwFGESfy
         xmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041791; x=1786646591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XJDCmTvRD2vNfT2YGrgT7EosXDcYWyreOqvvzwLRIg0=;
        b=C64mWe6P5LDv9IC+2W/ScFeoV85dmSh3XcHVlupxXTrcrQjYnFTU7Vqhm6BjPFzde/
         tD5wirfnMnNWcYrRBBIV13EBZPaIxJ4wxVgbwvuIvWQA198BXZWndSojiJpQJCGtyPEh
         jSLL48w6BuQeumrBmfG+6BJWYO/+tdc6ugdxxgxovGkosViexHeCUIwF8hGcIw9eITQm
         WRYUm0uuJgBnYZCYNf0FCCGJ9OTCOUguUbvfud8s3maTbYJC5pj1u2Rj6mOpvU9QZm00
         0KYpSpVbxOju5agwQryCi0lmO97slHyFNuo+ilZUKMJsalTV37BRtMbt4w20TAoUynKh
         hfwA==
X-Forwarded-Encrypted: i=1; AHgh+RrpnvI0x9zTb61jfem0QuwgF/yaaX9gIcSKr2o8NjPOZoZ1EHpER/kj33KHq5l1rtlWxTguBp3/@vger.kernel.org
X-Gm-Message-State: AOJu0YxujjBI8SEPC4bAzqZkwaCiHHUpQt1QW+p9i8eUwC6J5TvT/IDj
	7fAJkJ3ABXVi9BwMSF2iUArWOOgjUXR3PzEQQXz/sf4KsdIM8AE3RZjy
X-Gm-Gg: AR+sD129aORwbNBZ5mr5dAGrOgD+A9bTNhlfQ1IeYcwlBB0/0rLYXxR3O+chG5zvKP4
	njtNoQ7gpLCnm7FkDVz+o9wotXz03x9ZmM21KvNU1G5H61UiMXe9q7KKb+QTzGPEqPgvSpdUT9a
	9b7nCqzeCv/au1kksL8sLtwmtAKTJg+N+LNf3rznvR8dgvsDkXcq6geGLahwa4GUUISdxpzYF+C
	ZblfYY/sHejwEP2EuuJ7ENssTQRPJyOXTmCaWGjFKIKA2qCC5eFkmGRPDyPGzt8SfQAq8Ca+ehH
	TCotZk6xbIwm2DRjCJl6NJb4Wm5+9UUoNKi0xbNLpf54wFDliHDx9aYlBF+ZBuWwF80UhaJHGv8
	Mo3rwsQqRZgMgPxR6hbyka9At3jqN1dl3JS7qdZ4LDwk+NT8dr1/v1JYxYFvED8tgwXXCN5S1Tg
	Iu0muniAoHpb0zPA434pD8r+G0qHiwPvaK/cwhRhBXveo4RXaGNROpbkJoZdw969o2zfDVmfIa2
	2RbFm9IFgUHYtjW9tcPKuY=
X-Received: by 2002:a05:6830:6404:b0:7e9:ead3:4449 with SMTP id 46e09a7af769-7f1e5d0f423mr10084761a34.6.1786041790716;
        Thu, 06 Aug 2026 11:43:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f1df5a4f9bsm5051028a34.23.2026.08.06.11.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:10 -0700 (PDT)
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
Subject: [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
Date: Thu,  6 Aug 2026 11:42:52 -0700
Message-ID: <20260806184254.3790858-10-nphamcs@gmail.com>
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

Add /sys/kernel/debug/vswap/ with two counters:

* used: virtual swap slots (pages) currently allocated
* alloc_reject: cumulative pages that failed to get a vswap slot

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1a2d9d9625fc..b4d7af21ca1c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -133,6 +134,9 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_t __maybe_unused vswap_used = ATOMIC_INIT(0);
+static atomic_t __maybe_unused vswap_alloc_reject = ATOMIC_INIT(0);
+
 #ifdef CONFIG_VSWAP
 static int sysctl_vswap_enabled = IS_ENABLED(CONFIG_VSWAP_DEFAULT_ON);
 
@@ -2056,11 +2060,13 @@ static bool vswap_alloc(struct folio *folio)
 	if (folio_test_swapcache(folio)) {
 		/* alloc_swap_scan_cluster updated percpu offset already */
 		local_unlock(&percpu_vswap_cluster.lock);
+		atomic_add(folio_nr_pages(folio), &vswap_used);
 		return true;
 	}
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 #endif
@@ -2665,8 +2671,10 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (is_vswap)
+	if (is_vswap) {
 		__vswap_release_backing(ci, ci_start, nr_pages);
+		atomic_sub(nr_pages, &vswap_used);
+	}
 
 	ci->count -= nr_pages;
 	do {
@@ -4862,6 +4870,7 @@ static const struct ctl_table vswap_sysctls[] = {
 static int __init vswap_init(void)
 {
 	struct swap_info_struct *si;
+	struct dentry *root;
 	unsigned long maxpages;
 	int err;
 
@@ -4896,6 +4905,10 @@ static int __init vswap_init(void)
 
 	register_sysctl_init("vm", vswap_sysctls);
 
+	root = debugfs_create_dir("vswap", NULL);
+	debugfs_create_atomic_t("used", 0444, root, &vswap_used);
+	debugfs_create_atomic_t("alloc_reject", 0444, root, &vswap_alloc_reject);
+
 	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
 	return 0;
 
-- 
2.53.0-Meta

