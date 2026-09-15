Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D9C42BEB0
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514436; cv=none; b=AcwWv3S3i69ttnQKSKKlFCyv5VKfqT1qbTUxTljMrLGsqCaTRmogFPoFRew46fHHb05LAQN7vcAnqFFmckmSWi6v6JCUXxVzMouJZNIGN3RtDa9E0Syl3Q+KIvxukAs/dyL4fP3DehUoW3Q7WycyAhRTzdRUhRSqETsYMrCcmO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514436; c=relaxed/simple;
	bh=TBe+kpZpnxYCh+hDOUW6HhNWIRW2j11TxbbwpfMI934=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QZbWYnmTURTXhZdPbsQYiUiUGS2lvneOVelSXEHFqBFOswfT2u7MXMVMqSPTgiKzqbitDlFZEtVJyuyW+OBvULjmMUGI/J+sq6xGRsBkpx074rYdDsE6DpszL1dXolerTSAatSxBLGCIHv2A/RnomsPGlG0dFNa/vGVrhp/3i5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=L4aJ+zBw; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=MLSBBbK6; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="L4aJ+zBw";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="MLSBBbK6"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbcfm2693120
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=FBCJ
	eWJhLkITyU60MQhXX/77TTuK8hwKJ9mvj3P2k/k=; b=L4aJ+zBwibRg4UAsnrLX
	NddmpMUEA7UJRhoX1tpUqJr43HyM0cil8/vMIHBdBV5pA/1i+hOYglCttwnS4oeg
	beownRoNkTnKeVFn4oH/PAK5vgphDUDL+H/A0rSAirgdYfQVtIPxtp5IUkS3reXr
	sEvVy7rYjCuhQqsti2XvXwpbkwSoR44gcQ+b8F9HMEXVbuC73L8WoXTYwTDi4Trk
	6K+X/0V3JJZUZtCl2a7kbrRnuDQBh5jRE1YxWRklyALr1qBXfhROG25LfjxP2GVS
	LRcktpE71RZGxkG4MLGBE9sJl5345uSFv0Blpp1QwXn6RBPsdOz/Ujk+YJyH6JrH
	cQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gq9n5uj3r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:27 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a1bffc2eeso785867185a.2
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514427; x=1790119227; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FBCJeWJhLkITyU60MQhXX/77TTuK8hwKJ9mvj3P2k/k=;
        b=MLSBBbK6cJI0WoQs5zGAc2HZ6174qEEN/tSVG1eUbcn0FarW1gs29r2qJ1KkwJqgss
         7RodkW3jZC+Tv8omb+73IM/rM78bBeICkgII/Wn38W6Xht0+Ri2LW2b5uXMLz8+kWSlM
         gzJkzWlRXCRk/EvwifN83IZV7vYcU6hsrS791PmXafyH7D2Wx75W4UPKYSPKragecG1A
         zrB80FJ/7+AxQwFJs5BJQZt2UFpyzyis/y4aEIPwOi2afepoYv7OXM9Y+XLz+3k0UuZ0
         iu6bJLydDQG+/ekm1Ozn7OR18aWAvstnPzjQe2CQYGSoBhaKpGvGRJbYzUgRPUMNhbED
         Ve0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514427; x=1790119227;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBCJeWJhLkITyU60MQhXX/77TTuK8hwKJ9mvj3P2k/k=;
        b=QzVrU8q/oMxV+Qd2K+yTyEA7ScjvtnvJbFPyJhyTHt7CGA0Tjylz4kIEAfEkVMAD78
         p9DQHnurvfO8/0BBvlCJ6tpVHOjixQZkCwMT/ji7qUMEsztej2c8O7I7cWZpsp7EHibj
         9efCWSKnmcynAKU+AgUoBsTlAyiFe6dFqFK7n0LxW+ZOjiI9UApoVsXYEk2B1+DC4wZy
         /uAfYUsQQ8WDPQxYHC43KOtUbWzb0BnQXNFuQkSwsXGqWba9Cv1RA96SwTvATJfQO8J6
         dZGMuuBKA//sR+rEDuPBNG3Ve74/hK0Ry9ezqM6qMbsG9EAc9kvuhYKF33y7CyDWAdnW
         v/tw==
X-Gm-Message-State: AFuF++lodJCVQtYD3fyFEqP3/Wc0gv7mXpHNEHa1g9OwEid105U3SFKQ
	qDqh1UPLQiUY2qaf+WFG6xjkaw+KAsB8vFbjmzFQtndyZXH4W9SA+7bsEH/LzJMi4tpOiy/TcJF
	8ZXuX/7yd+YxikR4s6F14XSe4crdmoztxAMrC9Lt7WXGebpIYJEBNH1RNXC/y3Cs=
X-Gm-Gg: AYBFou27l3iTUJg1mRAw/p6mt3nVk4m9L7YJxsmDAnNnOV57XKgK6ZodqCISVCay1QX
	p8aMwLL6Hp3BbCr3n/xXl38cjbKZsRVBXUgcg6cdJGsXkOwYDePpaURFplve0YhXtSyIRyTNsrc
	4W3QQy9Iuya3w1urIo3dGCEeHsbuUFL6PDuhrITXbseQKlMu3/U6Eh6oR7IxtVN2cv9K9ba7BoR
	HCF1QlWkokJVbX0bzEhoQCAhLx+im3tY2gi7RDOHbKuSz85TlrpwKmJ8MSnulH8GSVtQpxILlEm
	V6Y/8j6xGIbnDki5+Y9W/tGKHjQRgUg25JYatnEpkavEQwJILtE9Twc1F2r7v+QAZpoJcfPEZUM
	XEjKnductpw9dJZVP3ppAzR9If69q6EyidkTEM0sGmsCT+9mb
X-Received: by 2002:a05:620a:a2d1:20b0:93b:b84c:9720 with SMTP id af79cd13be357-93bb84c97afmr16401585a.49.1789514426939;
        Tue, 15 Sep 2026 16:20:26 -0700 (PDT)
X-Received: by 2002:a05:620a:a2d1:20b0:93b:b84c:9720 with SMTP id af79cd13be357-93bb84c97afmr16398085a.49.1789514426448;
        Tue, 15 Sep 2026 16:20:26 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:05 -0400
Subject: [PATCH v3 01/11] mm: memcontrol: take a const folio in
 folio_memcg() and friends
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-1-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=9803;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=TBe+kpZpnxYCh+hDOUW6HhNWIRW2j11TxbbwpfMI934=;
 b=Hj29N656xE+edsmtuesw90kLHwIh/rIPa6VxsRWP+/6l/9rtD+8QIYACCn7Z7PSiIl5K+8W2f
 SFnj2gdPx5WArdZV3hzcg2enrtim5X0lvWeXbrLxKv/6ywpcIl5Q2b5
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: mwJR2eTIxX65eAfL27UFcq90hJBgBVV-
X-Proofpoint-ORIG-GUID: mwJR2eTIxX65eAfL27UFcq90hJBgBVV-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXxF9/UAAGm7BZ
 VPslEzULiNZQBT0CftSsgITrRjE1DU8kOnEkF8blUOuULqZECOqbUrT/+tP99+aCTHknwT7tcad
 4uMm6MG0HGreQKYbLwvVtLjy0ZsD2muqjddCwNyk/I9bBkA8jg1DlZfgubrO/rWnBsqJ3SUDxor
 XSaow3+i/3+2VIHoFORBk8lYhEeqvcXfh6Paa+DhB93PZcsY7daMgkV5sFq3kd80GiMyk2NFhC7
 XjKgKRvCU9410WYPsxJ0Ha0pLVebs/46osnIJKdktI1Bx0fjEvvo1U7dKqyPgKHKxok9EambKmt
 hxNzIkIqcXxPncvpAEm1BdEaEvyWnTIVVAaVK/eBIOCsyEnZOxQZJD0e/Vgtac7zE55BOpI4oTv
 b8e/C8Y2NuddDiPIDTxHE9JzTS29fDbCta3W/nsrnXdXn9RGYGQeEwlxT9AAnaFmvqz3a0lxWaS
 Kng3dOQ+8LIMVduv2hw==
X-Authority-Analysis: v=2.4 cv=KZVHIgYD c=1 sm=1 tr=0 ts=6aa9d2bb cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=di1ooo_fNIOSg_FWGpoA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX3L8QBeql/wtd
 INpzaj9vih4TvG075/twesgEKhLyrWVdAg7p2NVvPT1ev4cgjC+FJ613Ym9p/reuUE7BUsVrcJw
 3MD4Ir/hlmxvV4K8gELSxJWBF0jk3nKre8l5D4g+SyQ5TM3AdLMf
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=10 bulkscore=10 clxscore=1015
 phishscore=0 lowpriorityscore=10 adultscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150341

The folio_memcg() family only reads from the folio, and everything it
calls already takes a const folio. Constify it, along with the page
wrappers built on top of it and get_obj_cgroup_from_folio(), which only
reads the folio's objcg.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 50 +++++++++++++++++++++++-----------------------
 mm/memcontrol.c            |  8 ++++----
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..5a5ca6814782 100644
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
@@ -1767,7 +1767,7 @@ void __memcg_kmem_uncharge_page(struct page *page, int order);
  * needs to be used outside of the local scope.
  */
 struct obj_cgroup *current_obj_cgroup(void);
-struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio);
+struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio);
 
 static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 {
@@ -1870,7 +1870,7 @@ static inline void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
+static inline struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio)
 {
 	return NULL;
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
index 1460cba53588..54937efa075d 100644
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
 
@@ -3140,7 +3140,7 @@ __always_inline struct obj_cgroup *current_obj_cgroup(void)
 	return rcu_dereference_check(root_mem_cgroup->nodeinfo[nid]->objcg, 1);
 }
 
-struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
+struct obj_cgroup *get_obj_cgroup_from_folio(const struct folio *folio)
 {
 	struct obj_cgroup *objcg;
 

-- 
2.39.5

