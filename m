Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2034157F750
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883078; cv=none; b=s/78c1hCvuFvhpj9+rcBr3Cl1igvIbm49/iEk5JxMiGDKOkCsWfn8j8/wx5YUlg6GabmbmnssBj23K8Smxb5WgpjNudBOsupny2UCp3LMAsafr3YCeZr4vOT+ER2DvHyWRACWZ5zI7t886R/NbdZaPtsomgi7jujsz0IFrPAyDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883078; c=relaxed/simple;
	bh=kvV44+aJCJM4fB77OGbPL56etuSFfl3a0wSY86ZeaTk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E+MXNYxu9xV7oO1qSp8NomkEWzG31qfge3QdKKSfofeIbxo06cvx6ExgSCUGel4fOFC5ULvS71hrMxL8QG23wuhlj384wiGyxmZrZ1i0v7cJn1mmhQJA5aHbMCf8wcF3Fqr5DZIbFk91qKat5ij5RQcyRHIl+YBzMR6xteHUmUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=sWPgyd4k; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=LpaY1izN; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="sWPgyd4k";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="LpaY1izN"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbhZp2588895
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=SxtD
	+AQL002KfnnDsmRr+07OlI5SPZR1PCTXeAbvZWM=; b=sWPgyd4kPNiYtY26W90P
	qYzZMBmjKfERC8GP8MEI+KU/9IAvN/2/7fAkKxvwb4eZLXY5bxazu5SnKiB2hOqf
	W/uVN4poCvg/Cl0EpaUuzJjmkPBltVMZot7yuXqHFCDBWBf8WZSSSOzVcAw4LJSl
	Qf24SrfzC60zPlewBKKh62WiueCKH58K5xwFBZFZpGWRo/KCRxOkz7KEsk14pw+1
	AA1coU29U+jptJ/YLzlcTKjV6BxDTQ9WoYlT8xhFIwgMnmYXNWS9tnO9g2oa6B2+
	2hGpDC7lyFLlblFiMqAPmL9LqgDsI6iQx2MxC3fcwPXgKgHIQdKmTyC3GlAKPUbs
	Hg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4d5dm97-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:54 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52fa5c5a4a6so104344611cf.0
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883074; x=1789487874; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SxtD+AQL002KfnnDsmRr+07OlI5SPZR1PCTXeAbvZWM=;
        b=LpaY1izNUXUUOrNTAx26/DrCBJs5gb+Tv+CqnMBLz079vpJart6WlhbmmWGP5ibhHC
         9kvlPee+zHiev0I7H2i9odvFQMhCJa07b1ms9/L8iCKBuHt/Dv9boQvxmp5+W3VzTlrT
         wAif90UX7WMIfHbvtGxFstPeNAV6hn2jixL+LPpoXnPFmlBL6Pt0v/4zFS3aOuCy3SEG
         UR0c4Zv90f9E/6bhsx73jl/P0fQ+/5o6jKQTzbA52i5G2gdCaEZfYBmexoG2kN7coZak
         Y7xvB92QdGpO6EFBQbbFPsL/6UU6ogGtQHz1iRUs4anLmY1Q8IKlBrArWYAmI9QZ52/9
         IO2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883074; x=1789487874;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SxtD+AQL002KfnnDsmRr+07OlI5SPZR1PCTXeAbvZWM=;
        b=pgZ7b+blZNucHmTV7htyRfmQdX9PAg4Xfp2kGXO6K9fro3TXEWagc366uquAOf+6wN
         lY+sN39vPjQHatk//kZK0YZcxNrWb/6oNs4iQ8oKkcpTVKMzBJphi6DzuFdBpNDjQBxP
         bQYj1pNhSiA1oSY9z+98RmiXXRL8FAaESVVXFCJqM4lrvzk1KmQwFdYEsB7qsy+CVKtp
         8Ec20jArSZMXb6FMXvW3nL4DyxKC8UutV9R1Bp2oB0GKMtlLK0MGvmMinN9OVJ32kqX4
         rp/CSyAlzdUP2sjUtz+yXcIfSMF5Eudeko7t1kQo9qlmVMnIzPqHFnhNB99Ha2PxWyiI
         9J4Q==
X-Gm-Message-State: AFuF++nJHqX0iRnW63SCtc1EhvB0zQeIPLRwarMsajEDxPsrU2Qcy1fV
	TY54jQUorCMFbTzQ8SxEBVZR5kve188AaqcQiO3YGSHBYNf+4JfJy7Z+e0Yqxu/2tm8JRYQrDyV
	G7XJdHhtE3bLBQ7T2UdDplN6SFoJTAbJ1C9r16xoUushv7goXy+sB0AE=
X-Gm-Gg: AYBFou2V8xOoXLpV5jPrpHLKnCq1cFIrcak3rlKMA3AD5C6g1nwHHAXlzddbrnRE9Vj
	QiqVb3Os/9ZNrJvalGY3pCNttY+wlzhZXhUdAFJzmdORhfCfo2UQ7XLjSnj+/ekM6xVihFID+Vz
	FFL3xlaCZm7Bix6R1jvsh2bUho5aOduB2YH0/eb5Blqj3Ig/pgKrKPHQDcpxsohe8yRMhVH2Pzv
	WWk/gBB1Xn81O6H92okoYiKQ6zBkmHxUHvgLUzOwRl5QP2vjcYzepKCYiOFs7KVwEjPGeo2QdiJ
	lyZu8nuhND6yEorAY1YlC8gGGg+CcGNbkecIjvyu2rYdQNsEVGV52Hz0kJr/Mq+bypHaKy58HcB
	xs38jG9A60qLxGs3zzPvHI8bl2C7cpVhVE8UCLUlaNgiKbUQC
X-Received: by 2002:a05:622a:40d:b0:52f:f5f4:e9b6 with SMTP id d75a77b69052e-53054858afemr325153191cf.20.1788883073627;
        Tue, 08 Sep 2026 08:57:53 -0700 (PDT)
X-Received: by 2002:a05:622a:40d:b0:52f:f5f4:e9b6 with SMTP id d75a77b69052e-53054858afemr325152371cf.20.1788883073013;
        Tue, 08 Sep 2026 08:57:53 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:52 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:43 -0400
Subject: [PATCH v2 07/11] mm: memcontrol: constify the reclaim protection
 helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-7-811e9f443409@columbia.edu>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=3509;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=kvV44+aJCJM4fB77OGbPL56etuSFfl3a0wSY86ZeaTk=;
 b=ov3vX3rCMKxxUOA2NgB6If66E7ZEX7qrXVJ7T9lPrHGCKzDrZ99uuX/zCq3mtNsOMWHbjtwLC
 0waWXjMDTixBaKrxfaHAOjhASiV3wuC4Fo7O+xEpwx4PJkMcedwF4Ba
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX8ECwXbHN4xVq
 YDvw9UnHHp4Ik2vLZ2IZ9oRjskWgs82m0AJPDcqW0xfYlNGtC79oXoNiiZbhFUk+82CbR72J0Kg
 FO5hwKR6H6tCary/12PCbEW72L7YI5BKDfj+ztwoDd/tQ08R9ea8VTrgSIM6efq1djjM8TG/RUG
 N+8wT5CROyggsh3N16tVjazYzZqmkrtLrm5k2pl0JWrr3Dtd5oAtoLG7z5bp4iNW1bDagEHkTyK
 7/h0BTsmu8tDJL/9V62QfwsdLRRjSJCVZxpPqYLAP+3kHnTs8sbWvgxcA7FKHLu9LdlsAQDUhxn
 6zBJOXA29VvQMiHHsBwAt2g//1TgUe0wsInxxmLMEDPE71TVVU0PbooBGsuQ2BzoGtHQx4k7AJk
 vbkNxvYusNBn8+Fl3jjz8prD/2G+fguA9aQHF26tsFOB+8ysarbcpfN6KPiipwSVu20Y8rx0rlp
 J9MC9R6sGHDOi/v4oJA==
X-Proofpoint-ORIG-GUID: aL5wHUJEf-CulNqIBK05cx9Cnh46p9tI
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX4DUH2bU1IfH2
 ZpLUdyx0X3HNxa7mQES3JS9vdEsNtjpobJClr3GIG61vlameDRzC8OoYUEoc0orlyKt9OT8//xz
 U5Yy+TSCmBoR6iC4ytXAFOlcNn09zxqSf/MszEm0hheNygelh1Ur
X-Proofpoint-GUID: aL5wHUJEf-CulNqIBK05cx9Cnh46p9tI
X-Authority-Analysis: v=2.4 cv=BqCtB4X5 c=1 sm=1 tr=0 ts=6aa03082 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=daxEQBKrgOSOeia-9noA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 impostorscore=10
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172

mem_cgroup_protection(), mem_cgroup_unprotected(),
mem_cgroup_below_low(), and mem_cgroup_below_min() only read the
protection state. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c434a567bf57..f04d2b2b47e7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -570,8 +570,8 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -625,8 +625,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	/*
 	 * The root memcg doesn't account charges, and doesn't support
@@ -637,8 +637,8 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 		memcg == target;
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -647,8 +647,8 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -1149,8 +1149,8 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -1163,19 +1163,19 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	return true;
 }
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }

-- 
2.39.5

