Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5585E41A903
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514436; cv=none; b=kNuolEb99u6xSGZA6klxiHHyxp5nijX0UDtJCmVjfivVEWQMX6gq195t/XatTfitQpPo6wg7uVghGRCOYZckTGBKTAADYjlcJ4v2dY0rulx5Bo5ylvTN6M7dNB14XbslTzzZxo2TARx+UaejBu/RWr3FLQa93OBPpopdQfA/WXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514436; c=relaxed/simple;
	bh=bDvtL2wz+QRX9/VNyJZjloak2gmuOXGwsId1RmEh0qM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=imVP/AS8MCyKzdUPZdsoKh3PQuhL2OHmjKLAn0l8yKsXGamjYcv8FOt92OjD8JJCE7UuVyh72jimEqzg8u25fJdCno7oo9cWZaW+WYOPKFzcwN/TpZghcapXC7HOZF6lqEsHipvS7rwbYHMNdnaolFXc3rb8ilVvQjUfV+gEZgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=JI1AfrpG; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GFhgGPz9; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="JI1AfrpG";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GFhgGPz9"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbNt04080968
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3A0c
	795kjeVp04m0X3RgV/nXXLo89+Yqy/uh4bIfeQg=; b=JI1AfrpG+w8AnKn7QscG
	cHXWdBdfUOmF4ZEwHbvxEFaOKJ7qvLzmh51lvDMEkWjQ/pOLNeKd20N/CFpzyXvM
	Q0/GqpmVNIE+Mh3sisXovCHiRlz/fSIXZtof9/OZcv0oWqtAJlZCG9e/8Z8qu4p1
	/YX4W1g6Ua/LoY8E8lNySyifthRdhHu3W4hHz/RFatvx0CZOiK695OqAuoYMlNVU
	IMZ1Gb9BZ739TgZukub6+Gweh/6c/u16x6Fhm6fnbT/G2+bmcXzVLjv1XuiJYzxP
	aPC5lPwQ8+Tib4bOg5pSZjQ56H8wQnp81BG5Ahs2TCM/5mr66w79KdHUrJz/hIsh
	IQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwaj2g7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:33 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e82060977so288595885a.1
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514432; x=1790119232; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3A0c795kjeVp04m0X3RgV/nXXLo89+Yqy/uh4bIfeQg=;
        b=GFhgGPz9E+EK/9ZokZa6F+YBdWMA/CX/sGkmvt5Kde2GXs6Bql9spTTxAkwF8g3sAl
         NKqvDGDaN4JI6Mg+DtvC3yfXrpTViG3m3J/Q7oEUybYaxjHsROi7zfF/wVgtTXfJ/Z32
         aBC+Lby0CXCanvWIRaUYS7zGVryQC0HoEErm21VVIBFAvp245HDNlEtAvaMXUnJmRqS4
         DjxcfCdUJqtpcipXbQySLEe5tTBfZzxnBz+rU0ZBJy8nPlv7OrqPkFVmEbpvbDZZJ9tQ
         XYAs3STgplqBoOKNbWHxjXy9DbXcSacBsmQ6IAl2G9Fq3jh8o6m4JI3zG7Mwn7swZsu+
         R+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514432; x=1790119232;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3A0c795kjeVp04m0X3RgV/nXXLo89+Yqy/uh4bIfeQg=;
        b=iY4J0I5EiTRsMJse9MuYyga5UVED0XQLz0B8E2lVtPpeNDmMfuu7mgWXXq/5V5cApv
         mjNQOgE36DY2n6OZtKOfBDLctOJDz3G4TxyeExAzTp05oJJZTca2M7aqf2IrN+OIO4j6
         +tnazP1tqxC1uWtvcrzdTd1LkNSRXdO4sUwLiuF/jNbRX+n7kyaZXUKyDLApPmLgnHyb
         /2QludZ2qKcdiZ3ZvSu9wYQwooCoUEKI/95ZNaqARMxTjHcwUM3OOqmeX8VIPHB3DuLb
         eRGCd4XAPx1/pQIn55+nnNweHCrA76dcWNh69XER5jxIBDl78M9U/wjzaI7f3tp6EmJj
         2G1w==
X-Gm-Message-State: AFuF++nYaUR30hx6msJhRKbprUz6hZilMyK7GWsiVr6XaRqn5sJwswbf
	yxJFfIKKsBU6xMn6bIdUWmR2ecs5X+VpZ7hlVbgPZCIIVluth6OfpTuO//ta+lpuI4bXXRTrLs7
	UjPaagjkkxGMvpfzP6wagpR4ITVlyHmTL/MCYouItuotJVCDQBbU2Za2yatPt3Z4=
X-Gm-Gg: AYBFou2Tg81CLYdJOqePSHk+FKVV+ux8/b7tyHh+ALjqB90NJxF1dcZ3nGJECuFoyXb
	Z9vuXMNoRIu9LTinIrD5Q3tgJvgPf/pTp7QbPC4RLW0SG7qG9OiiBV9ue20R23kCLnj7dB+LOj/
	NxOpFUxR8f4wxYQXjedw+Yu4/Jxtc/sio+m/QC3KJT3E7BpKrWz78m4KOS07gsFtIuPdjXCDmBO
	PlSpYE0Dr6Vm2Q1lzwBejjdbiKqHc5UFFZkZXbYCmqZSif/rCJK9N1mesyKLfZf1M5+KMg7kPpr
	+F4wmhrd1Y1TDfm5dZwRK4IYVInEv7O0AjAZiFFvrRuF/sxkrpzpdlob4jfbYPC0OAk+JY2IAuH
	WHsZhtIN9+pMrho5wJA6d1o6dQibQWyi2RJONbvBkE4L+UBm0
X-Received: by 2002:a05:620a:438c:b0:939:8e06:45d7 with SMTP id af79cd13be357-93bb6f34ab6mr61124185a.0.1789514432462;
        Tue, 15 Sep 2026 16:20:32 -0700 (PDT)
X-Received: by 2002:a05:620a:438c:b0:939:8e06:45d7 with SMTP id af79cd13be357-93bb6f34ab6mr61119885a.0.1789514432031;
        Tue, 15 Sep 2026 16:20:32 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:09 -0400
Subject: [PATCH v3 05/11] mm: memcontrol: constify the mem_cgroup accessors
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-5-c239a6010b58@columbia.edu>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=7131;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=bDvtL2wz+QRX9/VNyJZjloak2gmuOXGwsId1RmEh0qM=;
 b=dExCOGR95BwlR2j0umAJm8kuB7Y5PPVWGGNWYfcQOUtxfTCnvXIMgrU1BeG4198ozJ4GUes5c
 sXUNARWn5VJCOkluJKmxZxDJHzCsGgLGw4nZuktlF1BJVk9u87aww/f
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: x7gzzDIhxEvbctyP0Yu_uNNmKp2wTH99
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX6Y+QFiq61zIR
 wvBytWxaQ+dtqAcwRO6Q1G83LUtFyK/ZUd3/yqdozhR5yBqSz6EDwpRvmRwrPi34FYGFQ5j3WPS
 +9mfuhBlC+hb0su+j1PlZdgMlE371E0vZDgr7Y110pil89m7xYo4gR7sNQfhnRDejhGsLpb2UNJ
 yzH9EglAHgPBreGXmfe4pzfWtwbonF4Kg0Zaiu/3qSZQd/Q/6lB2BYE6lYnNAAJABBZhpqyz2IN
 BKAxKA0MxDRUtOvx0nQpYZ182K306ErtAt9Ffkif77wdZ3VrNOzJSoex7XzDyFdWv/M9adPlaDg
 GjPuQYPqIcK69XUbcHv7zUvOMtZAyWJkzivC55LXkddPYTr6hgthPt340rBGUAl/wrpv/PPzC7H
 2K00b6a7dIznxAQko/tv3YGFniMFjoSMLeCBNucEceqVl+T7e87+szcZI5Zf5c2GR13ROiN21Dc
 UHZqXZir3vHnKI973dg==
X-Proofpoint-ORIG-GUID: x7gzzDIhxEvbctyP0Yu_uNNmKp2wTH99
X-Authority-Analysis: v=2.4 cv=JP2uIMKb c=1 sm=1 tr=0 ts=6aa9d2c1 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=J-BU3SA5NDMaAVagD6IA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX8ozEaQLLnfwB
 246m+g24QUyeEzfrbTIdacJh9oFE/HDZlrtWE4cflYyIcQkldzm31rNNsI2u0hrHIiojscS6S1h
 3wxeTcqbgtNpiGrN0dCetT1almCUM5WT5Ha9L+ZJT4VvkYOe4g1h
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341

mem_cgroup_id(), parent_mem_cgroup(), mem_cgroup_is_root(),
mem_cgroup_is_descendant(), memcg_kmem_id(), and the other memcg
accessors only read from the memcg. Constify them, along with
mem_cgroup_shrink_is_root()'s shrink_control.

mem_cgroup_print_oom_context()'s task stays non-const, as
task_cgroup() takes a non-const task.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 41 +++++++++++++++++++++--------------------
 mm/memcontrol.c            |  3 ++-
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 436934030d79..01f74413fc79 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -539,7 +539,7 @@ static inline bool PageMemcgKmem(const struct page *page)
 	return folio_memcg_kmem(page_folio(page));
 }
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_is_root(const struct mem_cgroup *memcg)
 {
 	return (memcg == root_mem_cgroup);
 }
@@ -555,7 +555,7 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
  * and do not honour sc->memcg can use this to early-return 0 in per-memcg
  * contexts.
  */
-static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+static inline bool mem_cgroup_shrink_is_root(const struct shrink_control *sc)
 {
 	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
 }
@@ -840,7 +840,7 @@ void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return 0;
@@ -849,7 +849,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
@@ -878,13 +878,13 @@ static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
  *
  * Returns the parent memcg, or NULL if this is the root.
  */
-static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *parent_mem_cgroup(const struct mem_cgroup *memcg)
 {
 	return mem_cgroup_from_css(memcg->css.parent);
 }
 
-static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
-			      struct mem_cgroup *root)
+static inline bool mem_cgroup_is_descendant(const struct mem_cgroup *memcg,
+			      const struct mem_cgroup *root)
 {
 	if (root == memcg)
 		return true;
@@ -892,7 +892,7 @@ static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
 }
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
-				   struct mem_cgroup *memcg)
+				   const struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
 	bool match = false;
@@ -943,7 +943,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
-void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
+void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
 
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg);
@@ -1119,12 +1119,12 @@ static inline bool PageMemcgKmem(const struct page *page)
 	return false;
 }
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_is_root(const struct mem_cgroup *memcg)
 {
 	return true;
 }
 
-static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+static inline bool mem_cgroup_shrink_is_root(const struct shrink_control *sc)
 {
 	return true;
 }
@@ -1227,13 +1227,13 @@ static inline struct lruvec *folio_lruvec(const struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
+static inline struct mem_cgroup *parent_mem_cgroup(const struct mem_cgroup *memcg)
 {
 	return NULL;
 }
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
-		struct mem_cgroup *memcg)
+		const struct mem_cgroup *memcg)
 {
 	return true;
 }
@@ -1327,7 +1327,7 @@ static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 {
 }
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1339,7 +1339,7 @@ static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return NULL;
 }
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1377,7 +1377,8 @@ static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 }
 
 static inline void
-mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
+mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
+			     struct task_struct *p)
 {
 }
 
@@ -1813,7 +1814,7 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
  * A helper for accessing memcg's kmem_id, used for getting
  * corresponding LRU lists.
  */
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? memcg->kmemcg_id : -1;
 }
@@ -1885,7 +1886,7 @@ static inline bool memcg_kmem_online(void)
 	return false;
 }
 
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return -1;
 }
@@ -1962,7 +1963,7 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_V1
 bool mem_cgroup_oom_synchronize(bool wait);
 
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return p->memcg_in_oom;
 }
@@ -1980,7 +1981,7 @@ static inline void mem_cgroup_exit_user_fault(void)
 }
 
 #else /* CONFIG_MEMCG_V1 */
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1f660af3bc3a..4b7c01daebce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1818,7 +1818,8 @@ static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
  * NOTE: @memcg and @p's mem_cgroup can be different when hierarchy is
  * enabled
  */
-void mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
+void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
+				  struct task_struct *p)
 {
 	rcu_read_lock();
 

-- 
2.39.5

