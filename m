Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B405139934A
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377319; cv=none; b=ql1CupfhTvrkgJYMrC9mcozBe5SWq+UsHYFjOIMNKAePSsQoNbEyTBi2/1u/O9Lxn+zeAqf815O2QrmJYRYbC9srMd6vl1q7Su+JYNAuXfFyJHLEijmoAh8aKJFUPpCqwoCE64PSaDzC5hmprfixKl2fLxJ+Q9JTI1edh+h+D1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377319; c=relaxed/simple;
	bh=YeEds/rFaDomadG9QFfipJEUkETcVxHCgrtHyNs5aqQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=okoW6lO0sTgyWRjaZEASNpNsJOzQ4QPsIsS4B8Tbd3DnXuaUljGhfWVGy/1fy4CaTFmEBM0SNsRYM6DgDOX6ZzqVIsbShEx0KFkyWtVlVIHqYjD/psZosrJwet8vqVaUa0nmCRjvjWKhvhcK5n08Ye5loBmgyEuywfih+v3DUMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nWfy+fZf; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Gyhawj6f; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nWfy+fZf";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Gyhawj6f"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IYmvx538675
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GHax
	PxMOgikVuJcnfWXWkSW1ONdTZEU9BqII1mt/0J0=; b=nWfy+fZfM8qfCpaZpSpQ
	L1JUtiIJ59dCMVZ9Ut5IOrT4+VyVTClww5bMOuN007okF3VkENvnewDoL6uiLpC0
	3cf1ykLAQR1xKyPo1en5vZV91LlKkLJsw1YVNbr1MGJYti+DxhvCo7tThpHdpf3X
	4p8alJ2pftoeZfLxDH3gZole91XX2qVreDF74ETDjOWhJgSH/qN5Ih4ciGIVto0F
	7Wu/28XSxqBivuWfE9EIEA2LUyx09LxHr/q6rV2yWAj+sHpfIKZ3ERqqGfl7tenG
	sKgkVPQFpV+O3olgkG04NrOVYOcwpe/hFU8rdPbMhWSSO0efzF0YNF0q0ohDsVsk
	Pg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gefkbmu29-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:26 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1d137a68so40054611cf.3
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377305; x=1788982105; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GHaxPxMOgikVuJcnfWXWkSW1ONdTZEU9BqII1mt/0J0=;
        b=Gyhawj6fvKImI9ukqRYmV0M4lUL7v870+8fMhTRIpIgSu2Ae9GrLWZGyG7PCZoCioc
         9mbfDm1BK0PoEOUPH4cxHeATWqp+HzTiyUZvNAOyM3YJg2+HdVKBp10tIY1DFm1Z/5o6
         vxhfb2LlIikPUnBvlYOcrk68bfn1+yBW0gUvGJ0cU+wI/WpLPqv9RvHrkNgrdTZrPlvX
         SBhWLdTq/bOQ9Jo5JzcyMzalohzSYwmSh5uH0tBucTdQxHovfhc2l/KJdpFOV8jNZPEf
         PA2wmRb53BzamcwcVrTLjyjJtnYtu06FNHnv5Okxl1F/wRTqGG+3JbNnhSlwytZizVTY
         4++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377305; x=1788982105;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GHaxPxMOgikVuJcnfWXWkSW1ONdTZEU9BqII1mt/0J0=;
        b=kecVimAugf+xXYq8vFm+r4zzLqT3OXThEla4S5YfDKMpDqxMKuikIwwOBOmC3ZzYyL
         e9s0Rgz6I5XME+oidjqrsZYt8t/mskyu9qsZnRYkZUYZH716TviQVPF22enaqUF8eo24
         avX0U+xYRTxDwE+QIjtEbfzKW394/G+yuI/krYD+u3D8vMm5s1w3G338cxEA8LpngFZJ
         HnbdsxnnBXU/zU4OYO5hyH2bM+70UpoXCqsECfTpmJ2dJUDn6p/QOYA+Aw1BriHNxM1L
         cG3onYYyJ2wS3znoVnmf1wUeIy65KKNXKgLfDcp/J3HQfqz9w15H+zZRAe4c+Xzy/2bI
         3uTw==
X-Gm-Message-State: AFuF++lZSeZBcbJVYYvVT8ZJTBN6PGQ+mEFj+WNhSEnDR8ApZ3EDdG9A
	MSHzWUAASR75DRBArgpyhC+KCbMM/5l8UwstO4AMLekygi2cOYsQ2zjd7DTvaCSFcK4eVTciG/i
	qviZhWV+7ojdLmuSvrWEj5ENoEDp6p0SZ121/niF/c0pPtvtNCpoVjjI=
X-Gm-Gg: AYBFou0dcwISbePAOG4sk1pb7Y5trNy5BenH5mlN1bJuv7Psumhqr+zR7qAeckoF05X
	vHvbfKB87/iTtZMQpMvkSPFWT3OhMZp+hGPeFFyIfmr7G+qP7AFU1FsKuv9BShC9Fd+sAgW7xo+
	35y8cayxNZzXpVf5IF15EV5/FmCrwAkxhKGDIs4Gs7bdkgTRaakJNUtoDDWzXqz4yUJcJV5xAqT
	pnirc6WrxXsXS8tC2Fih5feJ8Ljn/UBK+dmvaYjF6iJuq3Wy+z8osQ8QddH3jLwAenyZLzDTpOy
	++fBz1iKW3hC0fflXZRnesZyKwAiluMO9nHXH63B6wnNc0WONb5rEyHCFVmvbRrbyvEkqrsC15B
	6RjyeLS/pCsnmQbmt62oQ45V2jISajvcXF0vfxtDmpqLcI6ZgN9k4rw==
X-Received: by 2002:a05:622a:3c6:b0:517:9570:c1bd with SMTP id d75a77b69052e-53036cc7af7mr83271501cf.25.1788377304932;
        Wed, 02 Sep 2026 12:28:24 -0700 (PDT)
X-Received: by 2002:a05:622a:3c6:b0:517:9570:c1bd with SMTP id d75a77b69052e-53036cc7af7mr83270531cf.25.1788377304282;
        Wed, 02 Sep 2026 12:28:24 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:51 -0400
Subject: [PATCH 05/11] mm: memcontrol: constify the mem_cgroup accessors
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-5-e2c1da22246d@columbia.edu>
References: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=7131;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YeEds/rFaDomadG9QFfipJEUkETcVxHCgrtHyNs5aqQ=;
 b=heNyU5KL6+13ZfVbO+NJTfkfC82stDaN9oZEnTLjBt5pKCexJPD4SAneseDa6P+7Wpc1LNyFG
 ToQ2yZIbJB5BriA9ZaYMx0Iy4rO0B0wK9sTwqxZRCoHaaT5qgV5iXpE
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: sqLxqf4XRKFUc_m6CSHkl2Y9YPJkrkZ9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXwfJwsYIUCuXd
 5o33kNm+sEjZvrAF5ZW1RDfHwAh+6OtpVujx+7G6hEy/YbGFsLMR7/a+573Q/4FQKRX0iNgJk/l
 fUD/dir8whWVkk9CrGs5mNNCRR9ybr9mYeM+Q9pb0kH2hsLkUEEd
X-Authority-Analysis: v=2.4 cv=aIzAb79m c=1 sm=1 tr=0 ts=6a9878da cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=J-BU3SA5NDMaAVagD6IA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXypI9DGW+YxUZ
 SPJLJ8QcSQ+IS42LBbQHoi8HUunOBJ+9xLLS5AjOzG5GuDW4DJizVjEShs5qMrFR4NhrNmfeuWI
 sxz5HCCNJziQBvPIJDPhbdC/0ggyDCrvW9Q2KfEtmbasZGiq/rWtHZCSWku2voEo+fWxz6Ga0xP
 X1hIDVKKaOocTEyR94c7jVLCzol1gRKWj7ctWS4wipoXmMn5qcsIV0ISnMSuL+ECQ95q/5A4oZe
 1y7YmVIFz0aN7cPg4ofF2VzMLgxshCXu6rV1wWrjoBNiF58bVGkvrVyVb/HI4JULu5EjjnxXBmw
 JHWdpgeSyhPA51ERt0ypZdX2jafegDPkaPPwvjIHQryVW7cH+7l+HAdWMkAxaY6xM4giThEIUaW
 807ERexOwNCkH4VL/1Jx5FG3LEL6hjHWkPdD9q9DGP3dLhPlOMz0eQbyllKp2HKyztt4fWssgJq
 IoQKWEbVNhgBfVZBrcw==
X-Proofpoint-ORIG-GUID: sqLxqf4XRKFUc_m6CSHkl2Y9YPJkrkZ9
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 adultscore=0 malwarescore=0
 bulkscore=10 clxscore=1011 impostorscore=10 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020172

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
index 4b7cc97e45b2..bda969b3e1d9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -506,7 +506,7 @@ static inline bool PageMemcgKmem(const struct page *page)
 	return folio_memcg_kmem(page_folio(page));
 }
 
-static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_is_root(const struct mem_cgroup *memcg)
 {
 	return (memcg == root_mem_cgroup);
 }
@@ -522,7 +522,7 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
  * and do not honour sc->memcg can use this to early-return 0 in per-memcg
  * contexts.
  */
-static inline bool mem_cgroup_shrink_is_root(struct shrink_control *sc)
+static inline bool mem_cgroup_shrink_is_root(const struct shrink_control *sc)
 {
 	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
 }
@@ -806,7 +806,7 @@ void mem_cgroup_iter_break(struct mem_cgroup *, struct mem_cgroup *);
 void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			   int (*)(struct task_struct *, void *), void *arg);
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_disabled())
 		return 0;
@@ -815,7 +815,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
@@ -844,13 +844,13 @@ static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
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
@@ -858,7 +858,7 @@ static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
 }
 
 static inline bool mm_match_cgroup(struct mm_struct *mm,
-				   struct mem_cgroup *memcg)
+				   const struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
 	bool match = false;
@@ -904,7 +904,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
 
-void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
+void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
 
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg);
@@ -1080,12 +1080,12 @@ static inline bool PageMemcgKmem(const struct page *page)
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
@@ -1187,13 +1187,13 @@ static inline struct lruvec *folio_lruvec(const struct folio *folio)
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
@@ -1287,7 +1287,7 @@ static inline void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 {
 }
 
-static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
+static inline unsigned short mem_cgroup_private_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1299,7 +1299,7 @@ static inline struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 	return NULL;
 }
 
-static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
@@ -1337,7 +1337,8 @@ static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 }
 
 static inline void
-mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
+mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
+			     struct task_struct *p)
 {
 }
 
@@ -1773,7 +1774,7 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
  * A helper for accessing memcg's kmem_id, used for getting
  * corresponding LRU lists.
  */
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return memcg ? memcg->kmemcg_id : -1;
 }
@@ -1845,7 +1846,7 @@ static inline bool memcg_kmem_online(void)
 	return false;
 }
 
-static inline int memcg_kmem_id(struct mem_cgroup *memcg)
+static inline int memcg_kmem_id(const struct mem_cgroup *memcg)
 {
 	return -1;
 }
@@ -1912,7 +1913,7 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_V1
 bool mem_cgroup_oom_synchronize(bool wait);
 
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return p->memcg_in_oom;
 }
@@ -1930,7 +1931,7 @@ static inline void mem_cgroup_exit_user_fault(void)
 }
 
 #else /* CONFIG_MEMCG_V1 */
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2845f761e37..35f924c9f2a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1812,7 +1812,8 @@ static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
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

