Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F5058F06C
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883075; cv=none; b=NQ9ZNZDqHckkmYwGrlHhoaNHK5H0AUo8fKVNVQ4rkykoWu+G5rzfHD1LYwFnNB585H9GthW8hYA0BBxTfl+9VUGXV+Q2/azuu20s1UZGV1ZIS/yBwgWKuk1fExCNP0wChBxXF+b7WKWAV32HvLokGdN3hY4LA1wnB6Rf6r+5njQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883075; c=relaxed/simple;
	bh=jiPYBXKFlzm0BDkhwYK0OYvgkcvR4Sv/E5MM2St2AWA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Yj64j6pI4MeKbcivZI4S5e3EIHXSqxpFD8LC5a44cNPx8kFh+gqIidLFp5FcT586LNfp/y3hoJvRsW26nLrRXRCp0KwTv9ASVFFSxis24kyPk4/0YQhnAIPJN/65xqtVBx88ktub0G/+ZerwiaF7UvI723ohFQlDN36c1bRV3LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=SzZChqUC; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=LVuOr/rA; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="SzZChqUC";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="LVuOr/rA"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbElY1064826
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=JPu+
	VsqhHnWUC/7nK3d/oNeXmy+5WO8f/JPtHL06E8s=; b=SzZChqUCj2RrrRu26Vbb
	S+hFBEVl1fnRrfLGFU8PJWD7t0hsYEOxdJRXby6zo8p5u1coJXOTqmGeqYNVdvbk
	cvtn5rdl0dM7Q64T7MzXFaU2SbwNy4445lm10hBr9khR0xzC9srsOtcHdohfDfLk
	FNT1U0MVWmn45fOepEmR8kiMZ2sMEyJSnTGri+FPMJzTNqWvR8/I6owy8SxNFYo4
	eyiGMMnXVauH8BlFyO51yyCTE2DwgNiRPFgr40WnM5gmsvKLjQdSCmXgoDh1KABF
	EKoZLWsd353Dihl2cTy506WgwEmJCQcrlcprxMrn+Ch5EPYMil4dji6hXgsukFFH
	ag==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmwm8bqd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:52 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c01ff996dso53619841cf.2
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883071; x=1789487871; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JPu+VsqhHnWUC/7nK3d/oNeXmy+5WO8f/JPtHL06E8s=;
        b=LVuOr/rAhM8Es94Nn512bylV0x/NqBWKK8Y2kntGO3C2FLVBPCY9zM2ZmwBrwBogJx
         iKTpMezVDqv/PaavuardbZbBme7+vBFl8b2pqrzxC61KCA8m2yaiovGmI7PCNZMMu5iC
         /Xk+w8zkQZfuJKUj5QLoK/Rphr/kDSA7cQsVx+1/R2d6oq5DWNNhx93EdCfFOUFkwkEY
         suuZLGLsVXr9qiPL6VlOJXG6VY0jaktrpHMvAAm742KwF9N2zUdLnEjioyI37wcUfn9h
         phnA1C3sR1PJDGzohRj6gZxipaJY12P/Wc/yQeuic5obBXEiyCl7DqqqLZ4Qf0oTq6F4
         svlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883071; x=1789487871;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JPu+VsqhHnWUC/7nK3d/oNeXmy+5WO8f/JPtHL06E8s=;
        b=PaEzAoi6qZYnDHVcarFs8n+WRj0Eo99tuZDlSL+9rlrnq4mX6C+69g1mZg5meSvtTT
         oxuJIeed/JoqLGFhxUw5rEj91E9ljjgxXya0TJx6w8NFeCLdQOMWqr7gsb0PbcRXpzEP
         YTDs8WnAhFa057UJnagYSO7F1se3UOMgqs/L4yDMpreYbZBDdx2XZv+3wibGGIM3Nvgv
         j0IM2kMrL4D5avgBCHI2nx31QK+VL8/zMpaOjBIib7xvHVrc+6lp73mLkkYNn4p1AEZ3
         wLGWY88QNNjZlV1NnkK966qBrSDuykDwIOXKZQAV2swx61hLNq3bLseoC5ErEBvtKsCg
         nEPQ==
X-Gm-Message-State: AFuF++n2Fy7kA6z9orzvXUQVbalvh0J8shvxnZQF2Gb77WpyzCLlQCO2
	GjShA4HN63oXcEcueTYrY1B0R5QZ38Iau1D/QRZRQ4QeScg8Lj/HTQc65ooHsi6w4SZXR1CM5hf
	3WpEaffB7Jv1O4q2MdGfHlvokJfPdf6tYrdkvg+SQz2acukyttka/Xvc=
X-Gm-Gg: AYBFou0ljS09lt3sWuEqZyZptRtpN1HzRwYeQ5+9E0lGs2J7i8FPG7gLRwZNxCRAQ7N
	LPWomF3uDlRtt3oB52P+XhYrECcKNw+NNSyTLO3aAlgrbjD96TXjSqhqAmXyJjNE0nJPRftWzTm
	MmpQ4mnIY6Ods95nQiKaIqkzsYivI/a4aSdwc0vKpJgc0hE+NWCcFgv26FmuBB6+eyb9CVTiuRr
	VY6gQSnUvE8KEOdT713QtDsHIl/KlFNuozKdjHfQptmH8TZE1haOvXl9QBlnlV1J3N7PLzBTTea
	+fks1jQfV57mWil0rrnnl5qEWBQ5yufd5tRz020mObPy/+xrcIUGbVYSmhTCAE/ieAZk3kw05cz
	mawHKJLZaj0QUGyNtBFeWFu8W0ILPT7Df9A5zM2/oFDnQ56YN
X-Received: by 2002:ac8:5913:0:b0:52d:74ac:6ff1 with SMTP id d75a77b69052e-53054955026mr345684211cf.25.1788883071145;
        Tue, 08 Sep 2026 08:57:51 -0700 (PDT)
X-Received: by 2002:ac8:5913:0:b0:52d:74ac:6ff1 with SMTP id d75a77b69052e-53054955026mr345683351cf.25.1788883070534;
        Tue, 08 Sep 2026 08:57:50 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:50 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:41 -0400
Subject: [PATCH v2 05/11] mm: memcontrol: constify the mem_cgroup accessors
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-5-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=7131;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=jiPYBXKFlzm0BDkhwYK0OYvgkcvR4Sv/E5MM2St2AWA=;
 b=JvaWaS81wg00VnUqUAX8UucBmzqegdvFjSzAalJyDxkAPhhk1S5Ihi4t5Xpt1f9ZIcc/maHCv
 2v3eahfSrU2A/nvyuy9V5fT1uiBZNATglvBHDN5Uc+sueiccL2fj+Ik
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX2jSu+K/m6dBd
 DT+xMadMcJDG16GoKRNlN/RgYwDz0W6Xe77QBzugeFC3vPgwowQC3jj9/7rw87ysvvDDV7Ghud3
 QlJfGp7Lc+1+AUEi3I4+tDiizR7AxO54lhflHw8MGRl4vqR2T3e8BqT+PInOT53q7OGvHZdhqPj
 9wDH47Rk6EIKTUEn5gqufQTfbfsrZqwoDCmP0rAegw1Ag1Uv8NRfpZLS0r6Y2BVf1LFUpNI4vZD
 RWgzyPLk64UDiogu9YyA4b1kubMAMJaO2ZAa9l6fAH+FaD4kjeoEN5r9ccYhU+Zh0GSocONdUuz
 DQw4fsWMa2TDb4ohhP91wGx3zNxntlUPXoW7Ga4xJET6+/XgBXjg3uGaZfRGGwNyrC2vDGCTXe2
 G8OppiMbidz2SAc2YZqX8A4yOy0tKlPIRSeNeX9cFQNnR8NADqsKYK6RcUfH3F+nUhr8Tml++Ly
 P6JBp5OafsAVSkvET4g==
X-Proofpoint-ORIG-GUID: jlkHayw038kwUSw_ivlQIuxQPEAUmvB9
X-Proofpoint-GUID: jlkHayw038kwUSw_ivlQIuxQPEAUmvB9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX2ECzuhnk8ebB
 h2pvl6DvpLfFtc/HOnbDSnrvvASovkqpHL+fk71eq8W8pfqP94xetdMLNIFSCaAcwXwdHaa1OC6
 qXBQ9kDC860QKCQdD3GVPovFLFdqjiK1kEsVK53AcS3SX82d20ct
X-Authority-Analysis: v=2.4 cv=JPELdcKb c=1 sm=1 tr=0 ts=6aa03080 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=J-BU3SA5NDMaAVagD6IA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=10 spamscore=0
 priorityscore=1501 bulkscore=10 impostorscore=10 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172

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
index dde828a1206f..c434a567bf57 100644
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
@@ -1952,7 +1953,7 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEMCG_V1
 bool mem_cgroup_oom_synchronize(bool wait);
 
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return p->memcg_in_oom;
 }
@@ -1970,7 +1971,7 @@ static inline void mem_cgroup_exit_user_fault(void)
 }
 
 #else /* CONFIG_MEMCG_V1 */
-static inline bool task_in_memcg_oom(struct task_struct *p)
+static inline bool task_in_memcg_oom(const struct task_struct *p)
 {
 	return false;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 49d2e7e3c023..2456ffeb5241 100644
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

