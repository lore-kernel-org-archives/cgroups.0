Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB6758E2A9
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883070; cv=none; b=jnSIt8hvQ0L9nZBjxSebfF6HdpqK+GSFvs31+Rcq+HOk2X+dkX98g0jPLwL6YepNymeiwQPFhG8MO0rZhIV9IUpDWoaeNWRHZJvLTKW1f0Hhxqw9K04nsGIzqhFMN574ApgFQWB/gFkjcf/kH/hpJe/T0L1FuQwkYGluRIGqXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883070; c=relaxed/simple;
	bh=ugnKiN2qF100fvbO6aZoM7EJjqjdGQ9b7nhN8W8O0/M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NMVYuRCgExnIlLQkGbL9mgDHcJv9Jeq+0RxrJZNJM76IXKakY2M1OIUxsW+PBY122w/n/dLcrH2bx0kWpCyoJFuKlmblTyk2+Uotj/9hdzVLtk9KkZE42Ir1hDMEu+CDHIOMtMB2/6uj1N84vJRyBBikRccEQfL9qKFG/vxbw20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=H0X9Gg7d; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ffU5sY3U; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="H0X9Gg7d";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ffU5sY3U"
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fb0Yh1774963
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=a1Sa
	gTgITL5NsRvzAQglokC1slbC5Sjoi1TsTJ0PiCE=; b=H0X9Gg7d+NgnDVZ1sJdJ
	YhoeRED5c1/QYDjOyFwx02Xm1hNGpoVNdlNqlTjhc2Riq5/6DGf3nd+oa33l2dx+
	T5NyLuUFBqGGZK1tf8QaXXJKbLUCJvJ7EqbR7bY8qM1gIh2kKzVE9VIFQjknEyvk
	XpYIPxzwCwKBwlPdvpcif8QlPp87S1qU8NayRxTfoNpuaabuTedHjRVJjB5R7LAz
	2DGU7rvnFpWI4kP/rkcb76KAS2mmrkgW4AXG45tmMwVNmGjansQn645jk8mZz6Sr
	v9BgFn5F8Bqjf+94ChbTA4y5DiibtB20WcN42/ZXqicVM9Zbkcxl/P5Q4sp33lHU
	dw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmwhgd13-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:47 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c1d137a68so63036301cf.3
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883066; x=1789487866; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a1SagTgITL5NsRvzAQglokC1slbC5Sjoi1TsTJ0PiCE=;
        b=ffU5sY3U2XK/M45oZLaJH4vnMBhMglsjZ4rtbfHdzLt77UfxCnwc5jzWZm+nHifFf+
         RDhwITDz9GTIdPTy+lagvP9NuxNyrpBepHIQGnETrpQQxiUglSID7ybxn959DDuA1ca+
         Sflcr/9yY3bwUPWRJnk2u9mLKrM3h/Tx/WDqfErD/dsK86o6JjqTAZXeELcx4jfdoPi9
         Ou2wKPfyhRJ5TxrMmMxP9DHeVaz7/D2WGtf1W2UcyGX7h6jb3OKJyois6jlAEM8TIW9E
         b6jm7dHh0iICZMp0zU73PzPCqrem+wzN8wyMk3tG7LcKjVOZA87pzs+l1A4b7ujeRR8a
         GbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883066; x=1789487866;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a1SagTgITL5NsRvzAQglokC1slbC5Sjoi1TsTJ0PiCE=;
        b=WS6A4EZ0mEL1O1DU/uQ5E2EYDyjrCM7G/bBS4Xx5oa3ew+uZ4Q830+vwIAxGOhcRzX
         oy9i29xRVrLdTiK0NLeFyV89iIh6T/iJ8Zk8irPnv+YBuO7InN4eIBg0xc4l1NfzNTMT
         zSyKC0NYDYfa6aZ3EJ2sah14iSROXHOHmoLdChFNY549df7FaoqvXd9BWb8uWbxCvu/O
         0aTb2pXCBAAa/3DCwIXL6ChaKmSgNUaY0ioyZNAeCLXR82iH5z8bgBsu9n5+c2N91N8b
         t6Ex7zFHXGkA8bd0+KWuFDG6KqbBNd3FElwxfjQy0b0/Y746Uy/fO9Rgt5vpstWwHmo6
         OW9g==
X-Gm-Message-State: AFuF++nD+XCMg4pDnvyErSi329filQH3yWiKpWc7vnc5OE8reB0c1NyT
	24oDgiLNXsXrPx8KEAJ2YqbTKneMqWI4Ati0MGkMxcf/zkxa0AjfARe85zV0JXhCYYbflkGpbC6
	T2ooeXoTEwkbuufQJPDX6QzTi4WsR1mB5k85D85SZEtvqVYr+2Ni2nsY=
X-Gm-Gg: AYBFou3hE3/n3WtXsHHt0DW2HcqIXbcxEeHKOfPW4L9drzs91k2oWMSfJvwGhyde/Ah
	uicEA9MgRCeAm3ag2FHEE2PGej0mw+4vwpBHM3ZdAyNbtaWVh4FSxELekNrXxtAGtYlJVVHYBTX
	fCuErLB60A+9RK2F5GPoqdsW9pE+68xWUrGsO3EqVQojpDQGLoYqYwLqMnEQZ43+aBipzW4sHYG
	IAzgZ7emfSg/55V51GZn1DNh0wyGtAIUqhQtGp8xp5Kuq1LsAf2Lu0K0JGVxCkiws6e08rROB5I
	po3NN+nW/umVfwSrHNZmn1X9zrYMh87uJalL9rAHqdnv6oY3ZpaqjwLN262UJEkeBhxztPOGYZq
	EgIDYkC5NZbPK0PEgVcpE76Tw8xU4MrXyuWnD6iRb/+jMNiPX
X-Received: by 2002:ac8:5987:0:b0:530:178a:9de8 with SMTP id d75a77b69052e-530547d74e5mr351510541cf.22.1788883066252;
        Tue, 08 Sep 2026 08:57:46 -0700 (PDT)
X-Received: by 2002:ac8:5987:0:b0:530:178a:9de8 with SMTP id d75a77b69052e-530547d74e5mr351509611cf.22.1788883065571;
        Tue, 08 Sep 2026 08:57:45 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:45 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:37 -0400
Subject: [PATCH v2 01/11] mm: memcontrol: take a const folio in
 folio_memcg() and friends
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-1-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=8676;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ugnKiN2qF100fvbO6aZoM7EJjqjdGQ9b7nhN8W8O0/M=;
 b=+g0EzX/rIcUaVH8Zv4IsAN/c7ulNBIIEwyCkRhsx2EFbcdwzmWsb2G9SwUbw6+YoxNYAfRbC7
 SvAM1LqY4mNAxiYEXzzRzNdjo8rO7TReAFS/jmUKrvbnENy32ljtI+w
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Zubd7d7G c=1 sm=1 tr=0 ts=6aa0307b cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=mS-MXv6ntEAvCgPac54A:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: WHIjb85obWUnM7tEWyZShUoXWzF0ZxMG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX+pT+i0qehRGH
 8tvw/7jLkiUnY7Wd6PZny4yTpJPsDMHOEMxNS41oz4tfyQxEsmhezCxyK598QjDTF0686qZ87WB
 cBbvFDFUO3WOy8bcSNzFvDyPQjoQNXWaBpxEtSgojg3SCgWRo6RFCFpxDWfpfM9Z4BbCk2oxl/1
 s2gP5Q6m+/9jJOasCoJMI+3s/DknrlY6s21uELV9sZlDBIqtbbIUYt1EX+WXz1scv8t8Ynbam10
 4aDr3zYpJ/6xROorfeJbEgG13QndYkSUu7rVV47S9Nm5xlJl7qBwMbuPHulsJYlUVV7kWRcoxZE
 wGVbp1JWKAF2JB9JC/kjxhYBAnip6Wb6ncRP0o7QNGVK9IfEVqEi8/phpYmJKiT9kgY6hypxbcN
 TuuBQbHJauP84ikwDVcodVlGwM0D87whNktlC0cfncFfdTW9F1Sz2qLu8L2c6ciYow1uqTG4x9K
 AvCqawXeN/cPsCHU0mw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX58wgIFkeVE3E
 1AzBQ4gdEZqipeRT6gU7+Yn+4xkC6/v3cLeR/u6jO9GaQmpPi26kiR5w3YUeLIYMWhVaMdELoQX
 VslbIpnHeIXyOuTfirQTcCkKSe5y8TnARbgskVdXNk0YfE8HRPdb
X-Proofpoint-GUID: WHIjb85obWUnM7tEWyZShUoXWzF0ZxMG
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 impostorscore=10 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080172

The folio_memcg() family only reads from the folio, and everything it
calls already takes a const folio. Constify it, along with the page
wrappers built on top of it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 46 +++++++++++++++++++++++-----------------------
 mm/memcontrol.c            |  6 +++---
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4f720791a31c..8a614a36c05d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -410,7 +410,7 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
  * or NULL. This function assumes that the folio is known to have a
  * proper object cgroup pointer.
  */
-static inline struct obj_cgroup *folio_objcg(struct folio *folio)
+static inline struct obj_cgroup *folio_objcg(const struct folio *folio)
 {
 	unsigned long memcg_data = folio->memcg_data;
 
@@ -448,7 +448,7 @@ static inline struct obj_cgroup *folio_objcg(struct folio *folio)
  * Note: The caller should hold an rcu read lock or cgroup_mutex to protect
  * memcg associated with a folio from being released.
  */
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	struct obj_cgroup *objcg = folio_objcg(folio);
 
@@ -461,7 +461,7 @@ static inline struct mem_cgroup *folio_memcg(struct folio *folio)
  *
  * Returns true if folio is charged to a memory cgroup, otherwise returns false.
  */
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return folio->memcg_data != 0;
 }
@@ -481,7 +481,7 @@ static inline bool folio_memcg_charged(struct folio *folio)
  * A caller should hold an rcu read lock to protect memcg associated with a
  * page from being released.
  */
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	/*
 	 * Because folio->memcg_data might be changed asynchronously
@@ -498,11 +498,11 @@ static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	if (PageTail(page))
 		return NULL;
-	return folio_memcg_check((struct folio *)page);
+	return folio_memcg_check((const struct folio *)page);
 }
 
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
@@ -527,14 +527,14 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
  * that the folio has an associated memory cgroup. It's not safe to call
  * this function against some types of folios, e.g. slab folios.
  */
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
 	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
 	return folio->memcg_data & MEMCG_DATA_KMEM;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return folio_memcg_kmem(page_folio(page));
 }
@@ -777,7 +777,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 struct mem_cgroup *get_mem_cgroup_from_current(void);
 
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
 struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
@@ -905,8 +905,8 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
 	return match;
 }
 
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio);
-ino_t page_cgroup_ino(struct page *page);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio);
+ino_t page_cgroup_ino(const struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
@@ -956,7 +956,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
@@ -990,7 +990,7 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			unsigned long count);
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 	struct mem_cgroup *memcg;
@@ -1084,22 +1084,22 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 
 #define root_mem_cgroup		(NULL)
 
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return false;
 }
 
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	return NULL;
 }
@@ -1109,12 +1109,12 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
 	return NULL;
 }
 
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	return false;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return false;
 }
@@ -1248,7 +1248,7 @@ static inline struct mem_cgroup *get_mem_cgroup_from_current(void)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+static inline struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1406,7 +1406,7 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 {
 }
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 }
@@ -1471,7 +1471,7 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 {
 }
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 }
@@ -1901,7 +1901,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 {
 }
 
-static inline ino_t page_cgroup_ino(struct page *page)
+static inline ino_t page_cgroup_ino(const struct page *page)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 307203301a2a..1ad7de092611 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -332,7 +332,7 @@ EXPORT_SYMBOL(memcg_bpf_enabled_key);
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 
@@ -357,7 +357,7 @@ struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
  * after page_cgroup_ino() returns, so it only should be used by callers that
  * do not care (such as procfs interfaces).
  */
-ino_t page_cgroup_ino(struct page *page)
+ino_t page_cgroup_ino(const struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
@@ -1242,7 +1242,7 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  *
  * See folio_memcg() for folio->objcg/memcg binding rules.
  */
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 

-- 
2.39.5

