Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1777F58E2CA
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883073; cv=none; b=eXAkvxVIrQaitSYqar+YOhUQkcLLWRrZ4a0Pm4EBsf6HHo/oS78N+iFbYYX/alaz4BzAJ1sIFGZLjRbByvAIwGTGMyMOtag2DidexIt9duxnfKZUdaSv+2YUOa2Rl809sRMtPV2opYsb4ketD+LurBux+8k4vJV7v4DyzvaUSa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883073; c=relaxed/simple;
	bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JXwiPbGYh6HmNUBkVBkQozkchOg9O2vCN5bFAcqRe+j9lVDw1nvxV2KXrn8kR/2RKnjiefvVR7RYbsxv3B6mxOGbkazs/7B7Olw758oQfrgYnr2tbcDrInHXIHalaSvMYEwcrl4BwJkGbYBSwgcN1UBicyLV9tC5Ql5aekaeYBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=X6wJmGAB; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=29GvxU1h; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="X6wJmGAB";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="29GvxU1h"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbiEj426516
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=W+SY
	Tc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=; b=X6wJmGABACvVcn/8A580
	VUgc4bV7zmwzLAWYWl7bPh0WrxFjtYEvbCCmiqoIBKQSAJqduelA4iHiY1zEnHo1
	QenyZxHNHaouUWRkC5nG5Ffsgq29G+oQiO/hcD1QsI7lTkEFGAv8foaMB2LGtlIf
	oQivZkspUeNV+lgfyiXLzmqwqvTpLMIJMTQHPuo6mJg3NJ0N1Z4T5I1LCNZfVGS4
	4xK9m0dQiLswilzwD3wzVhh/phO6hpwfJxgH9wwV6NNVsx92v3xhhzDshASIksDG
	/Na67ZvNnhcTdoHutnkY1J6/BQPjqLYLJ1u3LuL9VL7zm8DZh3pLenrQJlafdrwx
	lA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmv7gf04-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:51 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9104215fbdbso113942256d6.0
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883070; x=1789487870; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=29GvxU1hfKzGBiTlK9iyfwxtU9UPfg669EfKQrg/85pHZjdJ59pg2CJq1DqGnNkukX
         59cCg9rAYRtJSbUotSGRBorsjV/ERLmm25tEqJbnxq+/OK7ieLLdELANXlzUadEQ7Dz3
         iv/O9ddEojS76F1xu/O7Sb2K+FW20HKaH7eOQASwG1WmjH+LOBN1zCnBe2+ovKNif8Ah
         7XiPbcCpJRn5Nr3WbpHWDKpD0TVCOnPvvKdmiCIvhsgDPe4OlVUAlNxTYhCd48Mk0pEK
         u4FRqXhSKeGtobuLgjfDnZqe5QxP2pwEcamyy7btm5CAN4/I8ek/0/zMsCpk5ulK3032
         cHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883070; x=1789487870;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=ZRtiO5/KZPd8ztdouOBB8SlMz6LIqXVAmp1HtII39i5jw2iQ4RYyQlhO3iiDlZe3Dh
         d8cfFpx8Saj58NADOtoLKQWiksXin2RuLad+9KfozXP6JdD743A/tFeif9PqHKGQOHin
         AiLM9rdUIi33wuRhp0LO4mmRvHALnXsOjloEuqD5EEnN1RFoWzvhBFVGvq5/8o6fTGsp
         DGqiGKNKgD/Q8sGf5qqEpgB/09hcoMRWuZMZp1Tiw6fGOA7gcN+5O3cXy04NZlizRpNp
         nfXFPGBqQ87ifFibNccTDVJMso95ZQFCBkyY5GWiDNIqB2fVnwAgG/2ViDQG1k8knAJj
         3H5w==
X-Gm-Message-State: AFuF++k7Hw7qidN7hOJmPx1oJZ+7GofUgskPxIuty0/qD3g88rEWlVkp
	rbNYzB8vvkUa1WKayIX1gODWDcXU+x2VcoZSnylk8A5rzvZVGlEZIWoR3DUIH9DI6+TOPCcFk8f
	6zfG0KBMpJusR9VWuWz8OxgTXrjgBSUOeHbUzQ6ZwvrAFuw2mtzvTCxA=
X-Gm-Gg: AYBFou3HXr7fzFvwef+xM4mJINphEg8HEggwitJHQd2YgeaHTfB0sp+gWSsO4n1vUws
	PSwFKbAi5PX+mLEfr6kP70xPOnYfW3KzDAk+n3CFiV+YE6KPAnLHdhetdYC394xP4UMHQFHUaqD
	SpHbkU/+rIjRZeIv/OcCVtDkHkbrskXDnOKuSyBSDyvMwc2o0GC3TMnycjP4EyaboMdg+oP1jIp
	GXdQ1MY9MjqCaq4/sb9JZqdmKGnpzMBe6zYPuEQAQRm2CfVnqL9LKe7lE1qhZXlyojKivh6tBq3
	aNkOp3smFE/qwJBzSkF38L9lXdzBZ7Z8k2/LYgEI5PKnnUDZXiuz5zIVtq1ZOtr3rJWwB4LCXHs
	SQq2zD1uaSCxza6g6neywWpNXUodZ5SoDxBmiicMNzK7mqX6L
X-Received: by 2002:a05:622a:c7:b0:530:4327:6c8c with SMTP id d75a77b69052e-53054a35c32mr336955081cf.49.1788883069959;
        Tue, 08 Sep 2026 08:57:49 -0700 (PDT)
X-Received: by 2002:a05:622a:c7:b0:530:4327:6c8c with SMTP id d75a77b69052e-53054a35c32mr336954491cf.49.1788883069421;
        Tue, 08 Sep 2026 08:57:49 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:48 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:40 -0400
Subject: [PATCH v2 04/11] mm/page_io: take a const folio in
 bio_associate_blkg_from_folio()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-4-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=1933;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
 b=8/SxO4FLsM5OCzLi0nlD3CTL6XF04Y6/eTXATxHGLojvR37DUuTf/wd83bHyMJ3AJGQZnLJV/
 uEAVipH37guCcOZoITV71ESfMo/6Y7Sc8NLmzp0LsxSiktRTH57GuJ4
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX6FSvt0tDZmvP
 KLo8GknG5dtQUl4BteYZYxeiG5IQlLXqoNByg5iv0cNBY53B8TZ+GFkuLiwTB4vtMAhbikJYfQJ
 EhlS6LDX9JUSkoB6dkV0DCgP0pLYA+5WCScBia+n+mj92OOpxyDqtCW1Xw7wOtPTZY2gZgWBzNx
 C5RmCp0J8D/XCityk6l0cgo2j5qnNvNdXx+TvmROEiwG51FINjTtSKoAVwABY6kNcxmJ8DJn9gc
 lKD6Mb/tgLcEsB+IhS3vWm0k5N8XaVVVXw39DEguUQen5kNahNOiuW6p5CG9UvBA9xv5htNc+7x
 FpRMcwBrnSc6lndBfL11DotjkKFEnLx/c9D0O05k3NuzUGqjFZ6eM8SoCdfJnkbKqLcOxT4rp6Z
 BuyGipxkkloig7k/KQ2MwDXBtHCocF4ndQdESFO4mAUCdecgtaOaZr388b4L5jz0nzpgMJTV8KS
 WDYgDW5++u9r+jlvwag==
X-Proofpoint-ORIG-GUID: 5I2Jqce0tegrv8L4QwXGja06W2YRXep8
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX0NwW1GvVc0uC
 5pBLEYb51+aOsXb25irhO+ZcxJLL3YWqmDKSedjVcJ+pyyXr2zVSDUyawYPEkr0WeN3psGokjVc
 YleFZ7cHw+mu3rQn6/2nUUz6cQheccphdgD30dFpDmqrMuPEH4tC
X-Authority-Analysis: v=2.4 cv=fpnsol4f c=1 sm=1 tr=0 ts=6aa0307f cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=4JVmFDg4bpWGYAirTr4A:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-GUID: 5I2Jqce0tegrv8L4QwXGja06W2YRXep8
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=10 impostorscore=10 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172

bio_associate_blkg_from_folio() and its helpers only read from the
folio. Constify their folio arguments.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..5f7756e370f7 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -256,12 +256,13 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
+static struct cgroup_subsys_state *folio_memcg_blkg_css(const struct folio *folio)
 {
 	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
 }
 
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	bool can_merge = true;
 
@@ -277,7 +278,8 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -294,11 +296,13 @@ static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
 		css_put(css);
 }
 #else
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	return true;
 }
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 }
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */

-- 
2.39.5

