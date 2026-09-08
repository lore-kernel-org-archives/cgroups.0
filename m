Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0558B6AF
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883069; cv=none; b=KkFEEBJqiqCQayUoqBDKvjJV64+4K0frn6PKY1o28qdHGaeOvmfJG10Awq7wOlgS9ggQRQTkIyp+u7AnCEn2X5ffiDeVSIMnB4BHZi41Z2boi0CMP4VDjDhCgSUvgjGtcr+zfAUxB+gRkJkBCcBFybXJPSuxvDVbf7zuFPNDYas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883069; c=relaxed/simple;
	bh=hj+Nv0WF1d95Gjv7TrdlCtnL4rlx46A03j7UOfRM5nU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=FAfTBqdMQrLbjZoT7lFq8iNkjHb1A6kcKn7zy2QYyAd4Y8Bf3wKuHLFLDhvaqsyVtW/43CgDoNZkIlsulSY6abCTCluEeKtfcn2artDxmhCRZvCRyVMK2LN5HJLccFooAys6yDijB1N5n5zFFH2rCs3mmktrrqa6GoCAINBlHR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nbNFtHL9; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=HwcXoEba; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nbNFtHL9";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="HwcXoEba"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fbd5W1154483
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=NifX4Rb1WDw0wxtWlVThAQsW+j
	ygu9Vf8Cny+Iwc1Mw=; b=nbNFtHL9MXnWtK26BxA1gyl68MUKnXXXxoueCQqUDN
	PlAAxqnECyGfrI5luVVHgkn5aO+soguWzHRqqKc5XoFDmbdhwuvLilMM99IFcYTj
	+JMRcn73qCpmaZ/fWTKKkSatKo8L/US1KBq7wxr/gMhukyyBM3tqhRZRDJqV+PTz
	BNPwJMOiHkFnv0ilHeV2vGi+c+rMDYMQ+GRq2EIfM5V8QkTFK6agkdniSQrtaMGv
	5nwebsxdCctFhRbY1bic7XQ+mrRjg0RVx1tPhg9fdt7WBnf0r7ukd4MtVXQdEI89
	jlgmXgdAt1/o0W4fgk24CIkvLrkWTwRHE5bwZ+V0zgYw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj50j5h17-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:46 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fb6c7b680so62327791cf.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883065; x=1789487865; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NifX4Rb1WDw0wxtWlVThAQsW+jygu9Vf8Cny+Iwc1Mw=;
        b=HwcXoEbaTAwmRH2QxWJltWnPsYtWr4hQDxDV3oliZTmaezj4cLpGGb2fAdKp/EAxIz
         OKgRDw1WL42dB8A+3BCWeSAYsJ+6IqBmMAvEZFh7IDN+KmAg//lOWcJX0+v6dZWn15OR
         Zbs4/gu/5bWblvlSt2xZ2xOA3KpFqxalq5z0LhYRrLMQFPXyVpUHkpp3cBe5/e09M/TF
         TBIariIH0BuKoOWYukmVvYRe8vaj7evSq8Zkd9wm6s3bc2Q6DyRHlXRAUBqtQQKhSszm
         kX813aWVserf/IBkXUoCdFiJlU/Ib+cKyI7VyPk3KrVw69NCUVaumlCiV6I0em7stSNc
         mpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883065; x=1789487865;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NifX4Rb1WDw0wxtWlVThAQsW+jygu9Vf8Cny+Iwc1Mw=;
        b=gdmg27bMJDeLmnVH/Cc6mqiIyiHBqtA5pMT8FPbSSIhzKZLrMV0+9fUfP4Gr3lP0nf
         d7mCz8euKr1seYI/33mQMOGDM7BDoaDPlEvtIcPqEJ//yNOaXQFdTd8TQlvfz6ZvIsGP
         6NtsaGE5ExgIK23yS+iEYAE5g4djH9CCYOGpQ1ojxTzgofP5OkhN2RO8UGW1HewYfeBB
         kpCa/YCOpQxpZ6uAL6kLgar8K97t/AZJxIAvnO7iwgJOlrcZrXgpCZNH8/Lum2FtNmsD
         QqvFyfj4rXVgdQN9Q7tIclJYIYo10J+jsKN8wnA5SRPwCsVFDhYnAlTYU/dx3rO6wjQg
         ApSQ==
X-Gm-Message-State: AFuF++l/O17icVgc4sKd+2LT7hIbzw/xPVxpRcIYbkfEtnCkGHHKL4iO
	//RJ5Yx62kaj3TWeLiM4O6+faeFvfAxNoMvGhem+3wrhlZAQH0qHUvb9ZILO7PsZ+DMnG1ZCqkA
	i4DstvGFiH+JK04zuoC2kjNJMDenL9Eyu2dDMack6Psf37RjliTaiWaM=
X-Gm-Gg: AYBFou08kv+JjgDc4vo9PWFntTL3flQcdR0TAOl7VkF3ZUkgXAobWGD1Td2dtKsfm+a
	velBQx35HUpzrIEnJF2o5dRI8hKtVEHKPAg+nJYSPuZ5BhvrwQhJGFGgufA08j3OQC4SjZLPaaU
	WMgcGUjsIdqPvtXrKGxPbzMHd+3+xCTb3nXJEU1RJxz9hC2M7ZPeS9pTKm0VmUfRFehMJTZRnlv
	hXpwsmq7JLx8imPsr/jX940TvR9HU1wTyDfg0ae3q1+d53cm8IeZ+XoPidQZtDakNxMLPv1/B/j
	qpqxFDqgloy05a15IP6z3cl95GmNqtt7b4t2n93Qt66MGbjbiNFWJ2U78Hwq0BZnCrYyElM/Gln
	eDPLf9PBBUqNmEPd8M44N9mqXkN8hJkGcIzjf3RIvqqqJzfBh
X-Received: by 2002:a05:622a:134d:b0:52f:f072:a1d1 with SMTP id d75a77b69052e-53054819272mr349899271cf.11.1788883065115;
        Tue, 08 Sep 2026 08:57:45 -0700 (PDT)
X-Received: by 2002:a05:622a:134d:b0:52f:f072:a1d1 with SMTP id d75a77b69052e-53054819272mr349898481cf.11.1788883064429;
        Tue, 08 Sep 2026 08:57:44 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:43 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 00/11] mm: memcontrol: constify the read side of the
 memcg API
Date: Tue, 08 Sep 2026 11:57:36 -0400
Message-Id: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHAwoGoC/22Nyw6CMBBFf4XM2poyqYCu/A9DTGkHGAOtaYFoC
 P8uj63Lk5x77gyRAlOEWzJDoIkje7cCnhIwrXYNCbYrA0rMZCFzUfuO/bOn3jTCeBcHoXSWk5J
 WFZcK1t07UM2fvfkoD45j9SIzbKHNaDkOPnz30yndvKN/lfinP6VCCkKTWo2IKrN347uxr1ify
 Y5QLsvyAyiWWWDHAAAA
X-Change-ID: 20260807-folio_memcg-const-4a67e40d485b
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=2237;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=hj+Nv0WF1d95Gjv7TrdlCtnL4rlx46A03j7UOfRM5nU=;
 b=Eq+dpJKvk9whXLlAXSzv+mq7m+3iea9TQG0LeUDcbezPns09wXcAvBEa2NVPavbZ7BAUmO63Z
 PSK81m8Ob4hBtmnLts5McXIWX4J153hefwW3tg14Hbs4ZiWO0dXw4fN
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXwGNTAxGKkE1h
 ayxDeYY5LyMbvH0+6NIpUEJQ/a+FLWBXus79FQOXeoTUUTzm2RDFkxRpzzw5BJhidAOI8ghldHl
 wWkwVYqlgBwI3YwHb5zOOWO5dKkkJg7oLAx2S26cWvEEm3KRFWe4h8P1IQEckvbISIOe2ks1ntI
 RzBwmee0HPqvB7E75zcOb1gfgHTf0IaZvpovXgu9/KNmx9rvKhLIw0NK6fhKoGZI/7vTjmhRM9o
 wGeYcC6InyCSF+YK/jWFO0n7cRngEgeUbhW0Az7r1hFJQfDZUYHE3e7x0flasW2zbB9ZfI9R/o5
 fzrE8VOKeA0CHXWovON1hCh4/1kgBQkJj7bxygIdO1OQlbuwk0epGAYuEp/geMKNvWI85I0srms
 Hu5TKql7FrZKL2w3B31v75OBHg9fyMZfSNBko5XKr0KSF04+OMaLlXNV3gGKra1i8Q++cOeDItC
 GjJzPfKI/ImPjE4/Kog==
X-Proofpoint-ORIG-GUID: Xy7WrqebNUhwhJWRXZsP3cWufIrRGfcg
X-Proofpoint-GUID: Xy7WrqebNUhwhJWRXZsP3cWufIrRGfcg
X-Authority-Analysis: v=2.4 cv=O7gJeh9W c=1 sm=1 tr=0 ts=6aa0307a cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=bC-a23v3AAAA:8 a=b6ln72opZJ-VCPk_GP8A:9
 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX7M0XNMh1lJDZ
 j/hfPOvSAn+cTIX9YtWZ3DD7Cc4jrMfNcgq5fNlRzQPPiTStVNxm5oKleKz7lBnzzpB2far6ajo
 2IokeLIzDlhTG/x6w6ATUMhTUNQr82oq9Sr+YH7ebnlt/oWzTLOO
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=10
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172

The memcg accessors, lruvec helpers, and stat readers only read from
the memcg, folio, or lruvec they are given, but take non-const
pointers. Constify them, along with a couple other helper functions in
mm/page_counter.c along the way.

This started as a follow-up to [1] that quickly grew in proportions :)

[1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

---
Changes in v2:
- Patch 3: Constify the folio argument of folio_lruvec_relock_irq() and
  folio_lruvec_relock_irqsave() as well, per Sashiko
- Patch 3: Note that mem_cgroup_lruvec() updates lruvec->pgdat in the
  per-node structure, not the memcg, per Sashiko
- Patches 3 and 8: Use container_of_const() in lruvec_memcg() and the
  lruvec_page_state() family, per Sashiko
- Link to v1: https://patch.msgid.link/20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu

---
Tal Zussman (11):
      mm: memcontrol: take a const folio in folio_memcg() and friends
      mm: memcontrol: constify obj_cgroup_memcg() and friends
      mm: memcontrol: constify the lruvec helpers
      mm/page_io: take a const folio in bio_associate_blkg_from_folio()
      mm: memcontrol: constify the mem_cgroup accessors
      mm: page_counter: constify page_counter_read() and page_counter_margin()
      mm: memcontrol: constify the reclaim protection helpers
      mm: memcontrol: constify the memcg and lruvec stat readers
      mm: memcontrol: constify the swap accounting helpers
      mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
      mm: memcontrol: constify the zswap and socket pressure helpers

 include/linux/memcontrol.h   | 204 ++++++++++++++++++++++---------------------
 include/linux/mmzone.h       |   2 +-
 include/linux/page_counter.h |   4 +-
 include/linux/swap.h         |  12 +--
 mm/memcontrol.c              |  49 ++++++-----
 mm/page_counter.c            |   2 +-
 mm/page_io.c                 |  14 +--
 mm/swap.h                    |   2 +-
 8 files changed, 148 insertions(+), 141 deletions(-)
---
base-commit: 9d3243fc689fef444f87e0a703b4c99653137e1b
change-id: 20260807-folio_memcg-const-4a67e40d485b

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

