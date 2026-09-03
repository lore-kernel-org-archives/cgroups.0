Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07D03793B6
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 07:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788421874; cv=none; b=s1NWC/Ssp0OTS+OHNDYezWQVjY+OZW7EINWpvZwTQtztIWK/2Uj4DS3EVXtIQ+Z4gz7CCUA6+SQ1qJmB+MXCtKwmszALm8GS2gZJKSSQHNYAwuF8NbN5CXGydRSZ9BBGwrF8XYA3osNqHS83YYbqc6my9ICQSkB+/HRkwrU2bYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788421874; c=relaxed/simple;
	bh=Twa+Yfd7YrJh4UKgw+MdhWaC2+lUEvSCwdgdLUXkKTg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qkyw4wi42T7KwiqMO9fr3onFXOLU02o/teKh7aJ8Wyo1vU/8wISokpAqUgtEtzEMILJRFrB+n6PTz6rE672icUVZdjGJ5Hmzy0mbQeBEga4qcsfUmZB+xRs9dAmA4V+h5Hbt9tvFK23n1gKKdgNlJSDQ6LQV/MuoJss5X5ptAyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aWN6hwBu; arc=none smtp.client-ip=74.125.227.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWN6hwBu"
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-3896ccc93b5so622045a91.1
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 00:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788421872; x=1789026672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ICN4jGrb/nR91jjnghtKbxqLBDgDgvVDNKC+0blsog0=;
        b=aWN6hwBuA/5k/BIJ5/3BA+whAr/t4JYufhYK1xiwejKacW2mLbRKgIGyLuYDlExdau
         ytbiqdxnohdzj1z495GqiTjhib0t0h3dQUQILeLtalizL2cECCep/KvpBM1oKptb5uAM
         l32Om1VKlo9+6uLTcwGlUZjtAMIgD/kL1/AyF2z6GtcL3t9NOVFh17cMZ3ZwIsVqIsWn
         k4Dqft+aNl0R795qBqclNe11OUh6ZsCC66RuL9gRQbnCnJEZVT0FPJJnIiOOoRe9QyM2
         jbxdbVi64KZy6sidOP89XMXN/Kh8IWuLc4oVh0J4zb+mHFIKVSGqCS0XK7MDqKGmP7ky
         suzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788421872; x=1789026672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ICN4jGrb/nR91jjnghtKbxqLBDgDgvVDNKC+0blsog0=;
        b=rM10zpdHd83QUQpJEvb8lF6eDlmwMY1HvyNA9J/TLjGpg5q2H0bDMggYf5QuRnzZ6n
         PXikPDrOOqbRTkKbYofxwKxIqqECHeZzXErrvZlsl61txvUpasCykN/FushFrt9yPbNS
         o7IcGkMOc5nUObsHOPbrqZco0DIKwdnfoKbvFWsiA9aHRxqVtXHQa/KqfUnFALVYQ2J/
         iRivyqOlOc1RjjLYJ8N/rLINtsZ07rJHMVlK8lfVKTZX5X98ZHUlAxGKpOFOIQdmf1xL
         1gJAKMo2SXxvgbnaBKyKHi5aTfsJ7qCMeafEnXIWU0UGPrv1dqAq9mNOwZ7YS8QxcajH
         mf1g==
X-Forwarded-Encrypted: i=1; AKwUvBzY2nmllL3fZKGLzR0Ju1OflKLmdc8Xf+ikgPlqtMmueWP9KsoqprPHc2lhEZ0FCt4xt3iIq74N@vger.kernel.org
X-Gm-Message-State: AFuF++l2L7BAxVa4TDrpdFyIEIYanmljHJ6LNOwD2frf3xvx1rM/uLMm
	Oa24KOYiJdJUXMfdKc7m/g+/4zrS95q2Y80rYAlqOMenfs6fPuE6qtcG
X-Gm-Gg: AYBFou0EJRXPvj+2nYtUo+H0iEjhJ6xhZwOKmiZgxYX5j2X/AsdHiXiWcbkVb+Zxucd
	FTG9lrgk5zKJvYMtNRqoRM7/vmYD0TXaRKK6XG9LFBvNNkdeLKNw5vw+tM4JtJRMPK/4iqhGxzl
	TeSD0BiW73GRI45BgMXfyfLYS3yXMjOoE3Hj/Tq/J3DX0njKRcxz00/wN+K6kX89DnMku8wL+SZ
	3V6ECeGzq1Vna+/oNZzRvAPrtewTEPvDDvcmOnY+vGF2OyeasYe8y2wwQUh1Erfh2HTyfIKHUri
	hEhnyvbvJ4eFKkcH4ZegtGbqyQM/2QyV03Y2B/t6BXHQc+RrXuj9VNe4f2k8dha0QdrN5LW4/W9
	7d6D/tTy6Sv6ko2fpq0rwK9av7+dgUne4yKD07mZoNjvCstzHLNkzk4C8U3XLK+EOrYGYbUIAtx
	Y9rPwmn/paoiKtUJxlsqGRtGyTiBZ5KmKo8p6jsKFArMqc6rlUeyfAPMetr5pipDs+3+XpkBkOe
	gvaHVZsHNyJTO1bg8Pwqbo=
X-Received: by 2002:a17:90b:280a:b0:38e:250b:122f with SMTP id 98e67ed59e1d1-39aee085053mr15681059a91.16.1788421871755;
        Thu, 03 Sep 2026 00:51:11 -0700 (PDT)
Received: from HXDQXTDYHN.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b083e6e3asm4021341a91.2.2026.09.03.00.51.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 00:51:10 -0700 (PDT)
From: Jinmeng Zhou <jinmengzhou22@gmail.com>
X-Google-Original-From: Jinmeng Zhou <zhoujinmeng@bytedance.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/hugetlb: charge folios to the target mm's memcg
Date: Thu,  3 Sep 2026 15:50:48 +0800
Message-Id: <20260903075048.3316-1-zhoujinmeng@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

HugeTLB folios are currently charged to the memcg of the allocating
task.  This gives the wrong result when a userfaultfd handler populates a
HugeTLB VMA that belongs to another process.  The UFFDIO_COPY ioctl
operates on the userfaultfd context's mm, but get_mem_cgroup_from_current()
charges the folio to the handler's memcg instead.

This can be reproduced by placing the faulting process and its userfaultfd
handler in different memory cgroups.  Have the target process register a
HugeTLB mapping with userfaultfd, trigger a missing fault, and let the
handler resolve it with UFFDIO_COPY.  The hugepage usage is then reported
in the handler's memory.current instead of the target's.

The generic userfaultfd population path avoids this problem by charging
folios to dst_vma->vm_mm.

Pass the target mm through hugetlb_alloc_folio() and charge the folio by
using get_mem_cgroup_from_mm().  This preserves the existing charge timing
and error handling while making HugeTLB userfaultfd population consistent
with the generic path.

Fixes: 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory in memory controller")
Cc: stable@vger.kernel.org
Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>
---
 include/linux/hugetlb.h    | 3 ++-
 include/linux/memcontrol.h | 8 +++++---
 mm/hugetlb.c               | 9 ++++++---
 mm/memcontrol.c            | 6 ++++--
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4caa126..45ada75dc04e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -699,7 +699,8 @@ enum hugetlb_alloc_flag {
 #define HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS BIT(HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS_BIT)
 
 struct folio *hugetlb_alloc_folio(struct hstate *h,
-		struct mempolicy_interpreted *mpoli, u8 alloc_flags);
+		struct mempolicy_interpreted *mpoli, struct mm_struct *mm,
+		u8 alloc_flags);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, bool cow_from_owner);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..362af58e50a4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -662,7 +662,8 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
 				   struct mm_struct *mm, gfp_t gfp);
@@ -1156,9 +1157,10 @@ static inline int mem_cgroup_charge(struct folio *folio,
 	return 0;
 }
 
-static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
+static inline int mem_cgroup_charge_hugetlb(struct folio *folio,
+					    struct mm_struct *mm, gfp_t gfp)
 {
-        return 0;
+	return 0;
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 785772845795..5ab5a5141574 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2816,6 +2816,7 @@ void wait_for_freed_hugetlb_folios(void)
  * hugetlb_alloc_folio - Allocate a hugetlb folio.
  * @h: Hugetlb state control block.
  * @mpoli: Interpreted memory policy to use for allocation.
+ * @mm: Memory descriptor of the allocation target.
  * @alloc_flags: Flags controlling the allocation behavior.
  *
  * Allocates a hugetlb folio and handles cgroup charging and global hstate
@@ -2826,7 +2827,8 @@ void wait_for_freed_hugetlb_folios(void)
  *         -ENOMEM if mem cgroup charging fails.
  */
 struct folio *hugetlb_alloc_folio(struct hstate *h,
-		struct mempolicy_interpreted *mpoli, u8 alloc_flags)
+		struct mempolicy_interpreted *mpoli, struct mm_struct *mm,
+		u8 alloc_flags)
 {
 	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
 					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
@@ -2881,7 +2883,8 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	ret = mem_cgroup_charge_hugetlb(folio, gfp | __GFP_RETRY_MAYFAIL);
+	ret = mem_cgroup_charge_hugetlb(folio, mm,
+					gfp | __GFP_RETRY_MAYFAIL);
 	/*
 	 * Unconditionally increment NR_HUGETLB here because if
 	 * mem_cgroup_charge_hugetlb failed, freeing the page will
@@ -3020,7 +3023,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		.nodemask = nodemask,
 	};
 
-	folio = hugetlb_alloc_folio(h, &mpoli, alloc_flags);
+	folio = hugetlb_alloc_folio(h, &mpoli, vma->vm_mm, alloc_flags);
 
 	mpol_cond_put(mpol);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..0b795bf1e6cf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5233,6 +5233,7 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 /**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
+ * @mm: mm context of the allocation target
  * @gfp: reclaim mode
  *
  * This function is called when allocating a huge page folio, after the page has
@@ -5242,9 +5243,10 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
  * Returns ENOMEM if the memcg is already full.
  * Returns 0 if either the charge was successful, or if we skip the charging.
  */
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
+int mem_cgroup_charge_hugetlb(struct folio *folio, struct mm_struct *mm,
+			      gfp_t gfp)
 {
-	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
+	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 	int ret = 0;
 
 	/*
-- 
2.39.5

