Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466A2446C19
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576109; cv=none; b=fpHTXCnsBFBi0sMWw/iKVWaAnBLLlSJ2QHir35YOegVcpZEFUuA0+ARAWeuUOM3/+hJ1ffW7XauorYmAZ2albCc/UmMdkH+Tss48FwylFx4cfzk0CNSMO6pNEV07FN6EtAxDd2PDBDFQD21gG8jWF5GnD1UfEOFPlkJNlzHFY1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576109; c=relaxed/simple;
	bh=oEaRFOVCjSclinhDXeejGJ2Wds4vhFfHEOBs8ywWypA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Px2zW6spQxo5dyAn/s4Cs65sjxr4lKdh10rPOU4OGL6kjh8ZXFbtq2b0+1LtFE7c8EDHOo3LStuJmHzj8bev+KR7CXisb9dR460R8pqyel8+9GtRY/GAdWve4ceQizmCo1EW4LQNKIXx51dSrOW0XeRC47L+popKRDrA2s8Rgfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=MwMA56gA; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="MwMA56gA"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e50979c71so1168464685a.3
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576104; x=1785180904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ln8pgF9dZ6WMfDl05evHGvg0v2GxuZj6EnExRSfvexU=;
        b=MwMA56gAfaC0fBcaaIde/3isfnv2azl3awpnsQjjcGOF9iLK9X1srKbTx3OWW5OwEn
         CvOMwR3cCIxB6PBs5trfizlLm6GZevqcW1kJc0Z4sM8ZIDjqgLY0O5YGI0LGub83UoFH
         FuU3Us2vfBfRm5E/5zOdctv1N/KVKRzH24WgRBwkxNLnK9P/rhFePEf88O+HQF8PwW3e
         5kk75iziV0meS7GS3JSNDADOvedjFSOpLUanCsD6cOngF7czMnRw51/IHvWZ4LEJmPpc
         bnbIX2faDFbcgkPM+mozEdFlMcEgdqkIEg5yJVl1+9UsFYEMTLAs317RulcgbDa43C/H
         f10w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576104; x=1785180904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ln8pgF9dZ6WMfDl05evHGvg0v2GxuZj6EnExRSfvexU=;
        b=DDDa6gUb7q33e+kRHPKDFK7ggu2pNRmCHC0CaKnrn244FEKu33XaDlqarQ0pbx5BnK
         QeT6yfVGt/SWAeGAShr5rUtRZXE7HTGR6BrF6sRggLADEwmGrYsqBlOY7o7D4SvFD17Q
         QWxptxRfpnjPkiTVOuXOhwUKn0OHIt1N3GaYZwR0cxnTcJ9zr5Rmglt0Vo09APR/Y0BI
         ZtNkA697oa/joJPLv/sNL5bv34Is9fFrcrJf932JurKwWkR35h9HSTkE8FvogE00STNy
         eldVaDCCf1dKR+S2oZe0yhGAlsNVDS/MV09S7sySCgmhWtSsyTkzVu76AOIJ2Xve4+LV
         /coA==
X-Forwarded-Encrypted: i=1; AHgh+RoHVafAVkBlOMNuSRrEMLQcKuDCdvz7LT713Ti6/ZCse8ysgR6EIY+GSEICV57fNhcMnEsZkBJ+@vger.kernel.org
X-Gm-Message-State: AOJu0YwSxIzdOUReJpAFxZWfClzCoTYAof1qFl9bLNVVL5NqhNmEI6V4
	oCPSBmESZxo/OJ03BLVQgZiNKf7ws5Kmk/ku8gbJKv96oeM76Dj2CEuEzv+IIJSLTAQ=
X-Gm-Gg: AfdE7cmFynopra7VMf12V4Sccs8m6Og2ZV5IylUd1zila1pIbLILFkL4K4YQ2yYUXwh
	f4lzozjVMc9AXqb3CSevDuORdWDIkVqSkjTFKgW2dW2Rj2UKTd1pmyMdumb8DiNTsjdfSu8Apdg
	rdXC+ad+3j+wURaAErfdb00SFaGF6P63FnSwx0Rfdt29m1JjObSU4qpgXiqmnehB7oMmYuDTCxU
	SGYA2nxBFyW04JmQkWzxAQdQNlF8FYYcidKmYfECEqRgw+g0GLnyh/FXrj4sO8kdAY4nyP3+1vU
	wB/71DFsn8N8UnRUXH1fq7ldnjd4Y1i0WNnIbY3McVOBCA2koX3JGcvIPoXYs5pITzyx90NinDP
	T7yWAzQl9ts1Io/qMySQt557LvYMbdGStMphrttIg0vqfl3WHsBZym7DVVkGbbGeCwLy+JdQB2r
	V+FWs6JLJeAdyN9btERH+gWtW5mPLIrpYJGgFuLGTAncQ10WVok7UY9NhYZkUo+3s=
X-Received: by 2002:a05:620a:45ac:b0:92e:c117:9eac with SMTP id af79cd13be357-930b43971a0mr1537518085a.90.1784576104470;
        Mon, 20 Jul 2026 12:35:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 10/36] mm/madvise: disallow madvise operations on private node folios
Date: Mon, 20 Jul 2026 15:34:04 -0400
Message-ID: <20260720193431.3841992-11-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the same filter locations as zone_device, plus additional filters
for huge pages to avoid madvise operations on private node memory.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/huge_memory.c | 5 +++++
 mm/madvise.c     | 8 ++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5bd8d4f59a7b8..1df91b4e5c2bc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -37,6 +37,7 @@
 #include <linux/page_owner.h>
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
+#include <linux/node_private.h>
 #include <linux/compat.h>
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
@@ -2338,6 +2339,10 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 	folio = pmd_folio(orig_pmd);
+
+	if (folio_is_private_node(folio))
+		goto out;
+
 	/*
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
diff --git a/mm/madvise.c b/mm/madvise.c
index 07a21ca31bad4..29f35a23919a0 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/node_private.h>
 
 #include <asm/tlb.h>
 
@@ -395,6 +396,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 
 		folio = pmd_folio(orig_pmd);
 
+		if (folio_is_private_node(folio))
+			goto huge_unlock;
+
 		/* Do not interfere with other mappings of this folio */
 		if (folio_maybe_mapped_shared(folio))
 			goto huge_unlock;
@@ -474,7 +478,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || folio_is_private_managed(folio))
 			continue;
 
 		/*
@@ -703,7 +707,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || folio_is_private_managed(folio))
 			continue;
 
 		/*
-- 
2.53.0-Meta

