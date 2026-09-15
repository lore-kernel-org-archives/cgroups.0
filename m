Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AB64BD79E
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514440; cv=none; b=pI9l6NQO1NfHWzDLydVvIToxb1kJ0AnhY1WrYJ9M+BDFxzV/sYoie/4KvA+5MpuyMFQoStA0p1CHVb7WpJUD+RjUQ36qraBVB4qh5ztpIUrXaukIexE47g2QHbHg4jNzvjfPb/GObrx1hrjcE2D1rN1SEVWcmNmokVtFFDcVvQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514440; c=relaxed/simple;
	bh=QErkJjMmQvmsS88jxAIrE9Ky5O4EbrTfoXBaycDxTEs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OzDjDJs4x4UKewpxhpo+dkH42FBF+n9MT8/QQx2wZmXViL8Dy7vSI/mN9AUVP86o+PPb7n2nfPkPI71OD/8CIWczMICQRykiqLL5k0aYNbvD83+cnTjIg0aZ1PgZhMXPVmzG1fkm/tJ0siT+uYen9ojPStz7qEZ2vHroRgmtwLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=fr8WCK0j; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ySbkz0g9; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="fr8WCK0j";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ySbkz0g9"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbpd32571919
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xI8O
	6nUTdr8vwkC89YCiv/sTDb7PohQILvZ2tXdjQQ8=; b=fr8WCK0j0BHJre1/OWYc
	k5BDY+cpsNa2PQwGj9KsK9N7d0k32tcZueGCtDIq/Rank22cYs+usAlylHDOYvQb
	+kOK3USJNUZapFNdcIevYYedCV2jOsHR2R5UHQ21I2reof8c5hxEZp6RRr2LADYm
	W9CNbaMXkPXGuVwFyre9saYk4PNoNhpzvZ7EbGT1ApZqziM8RBlfSUhu8bDSgku6
	Cp63F9erILoQAlIxsGHRLXgKL3bxtLRivH9MM73b2VuOKcmT/S1Edgo5CpSgurrs
	sNDMwTYePbHISEo87rrduWZYOBeaqNbJrkrWgNjH1/U2BAv9agZBSjXBm5pDay6a
	cw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwd9sy8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:30 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a183a0e93so584074485a.1
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514430; x=1790119230; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xI8O6nUTdr8vwkC89YCiv/sTDb7PohQILvZ2tXdjQQ8=;
        b=ySbkz0g9Fe7rELskIwTPk+Uu7LxfFBQlC4iEzSAX4VoTgeXqOQHVR6oT8cmMfT+0gz
         YXgyh4bG7eLWA+3CsGKDG2omxWeyhpgUdAt4OxLkcxb470C7j+BCrGlg60eHzdI1llyE
         sk28U/xbmDrWO/2YrYZZuXvAAvpEiZA5UiWU/PnNS/TZGnme6TC76I6nXuDV6RqyClr/
         y2HhTKQHlLdAyETorHIif4pWqloEAocQhpU8iXmd3zj81Z9AF1/pQwnYD3Cu99yKIml0
         bfNkPInG9wkJyD3YfjTHRMeCteVgm/2uGz2pBfgZvEyExdP7d0QVdN1QcTaRGaAn+qvo
         529w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514430; x=1790119230;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xI8O6nUTdr8vwkC89YCiv/sTDb7PohQILvZ2tXdjQQ8=;
        b=Rn3EXr+aZfIiU+N+CGoAhkh60Ju6Q1HbxdqW+btiWNzZWVYpAO3vTEMeeytrk2C0NC
         95qKGGMydgG5JWp6QGFvhra/Y0M933x/f6viwDCnGhNTLuP5U1guzBaO8I9/7uLKRAfD
         N+JOdJ1fnUHeOSmI3rgAZ8m43ZQ9uRXkQvisyZ/ni/mqQFg3lXmJF/56oPGIYCOeie/g
         pAkHHOg75NWleNaO8aVxbEFPcod+EjRDbqZ2OnN37sNz3Fc7q5eWXCh507zk3NYXNtzR
         e59anR1Sv+4t2LFbNCj2U++fbt6Pw1lkfF2rlIvHlTOLE/Lr8kTrgpJBITji8sndcGBN
         qO0A==
X-Gm-Message-State: AFuF++lJPakE23w8nGNL4d3180DaDdAhYfxP563AXzryl2/Cf4iVs2Rn
	uFGFLh88il6rz4udF3G70xUt8xKGrMJE/fW4Xt2IRP6Y4U4O9uDHXF5yhbzJCGg8Lt+W7xmVC/N
	VFqF6/U1wqvCvKuS0fhAUwwLve1eYq086qODQUlnnA18T2nofJsktyV6DlhFnIsQ=
X-Gm-Gg: AYBFou3QUI98UG472zCYn/4jXoSB0nyquOyzA1mplH5H5xnAh7PHSMUnrsUQVk7AWPQ
	rqpU+HmTij8VKWtInXpB+FdYvcmkThYoVSV7v/z82TkZvM7IjQA7AtXmCCHrJ1Du/914AiBU+oU
	i5Ra/KesFMU2ae3Bro3CDC4ZVmQo2xD+9nSDLNiTSBz4ThROvoNHMq8R2ch2VPOTmuVThpD9aCN
	PcbdM2m62CncelM3dfXh9mtAPYm/exmyXT7m9k08hUHvrBVX21gBkO73Ol6TPyA8sblI7RJW7nI
	4j0/Eo40jCs07oi2eA3tBXlqo0Lms0Fm0qALRJggvttLuZMdulaiUUSy1XZLBy53wQddf7PwA4g
	tyUv83gnZJ18PfAHspHe9OYKkAvfbN8k551tXzAT13V4spMJK
X-Received: by 2002:a05:620a:462c:b0:915:83f3:780d with SMTP id af79cd13be357-93bb785be63mr61980385a.32.1789514429838;
        Tue, 15 Sep 2026 16:20:29 -0700 (PDT)
X-Received: by 2002:a05:620a:462c:b0:915:83f3:780d with SMTP id af79cd13be357-93bb785be63mr61974785a.32.1789514429367;
        Tue, 15 Sep 2026 16:20:29 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:07 -0400
Subject: [PATCH v3 03/11] mm: memcontrol: constify the lruvec helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-3-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=9069;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QErkJjMmQvmsS88jxAIrE9Ky5O4EbrTfoXBaycDxTEs=;
 b=B32sWF75c3qlH0UPqHe1rOYhPDsSHtgFDH9HH2yVkg3R8Bec/IIENkJk8Ee4OtAVS73mwx9fx
 bJqShL+MhmoBs6F5daqgJnAUlGS0n5d6CdZEhIIS8WR/gpypZaSjmmj
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=JeEpPkKV c=1 sm=1 tr=0 ts=6aa9d2be cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=KOoHFShP43Ts9fVHKv0A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: yRJa4H5g0SPIPWoKJvLNRFsZZ9GJSvyy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX4qBBsCmTDmns
 fFZpRf2JuJTgQeGXSrBhvU5TBmPAbvMEuZMm/rbXbaiDjNmUKb/Fr9/5AIB9vFNib1lgGLmjPVp
 C2IY/Peuag4qJlJ6eYGMqfvLU5KUe9GnKGd9sgt5GTvH933E9C9QIprufvsccLMrppCImmjjHWi
 oj5jRqdfChPowMb535G6oacJSWXCtW1QZpT64wYdwZ9KtgoChg22ia524e6D24i9LLAs6izv0em
 hOgv/AL7vwnbXJX03kpkoPkGBO5mIwcwPqLY7Og4KSm2BS5lqXjSxNb4jGGT8V5z031VF7ytjgE
 hfi4hFJKndUsGAsDqDow8tvGbyySRwxZ6/RYs+KVJrZKcBVJaNh6MOmdIabMypBoMQciMSHb97d
 qCfhZkzW92tMtRVL6R516NVd2V6B9QbjchzxBZzUgAqVtQdUDyPIZIvqnMW4SRWMXchQiqX5s/2
 vj+/6OyzswCJmG6GwFw==
X-Proofpoint-GUID: yRJa4H5g0SPIPWoKJvLNRFsZZ9GJSvyy
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX/Q9383KzNrS6
 3DGE/+DaRIcjTc9MxrieE4tc2kJ6ZmzwnWUEA2opdhAavjALzyVH2xnZyTZBmktOgLR1Oh2JeFD
 Doc6GC8/wziZZ8gAk57EbJ9GN8tqcynI9futtafIokQgYRD3+FIA
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=10 adultscore=0
 impostorscore=10 malwarescore=0 bulkscore=10 suspectscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341

The lruvec lookup helpers only read from the memcg, folio, or lruvec
they are given. Constify them, along with lruvec_pgdat() and the folio
argument of the folio_lruvec_relock_irq() helpers. mem_cgroup_lruvec()
may update lruvec->pgdat for a newly onlined node, but that lives in
the per-node structure, not the memcg. Similarly, lruvec_pgdat() still
returns a non-const pgdat and does not use container_of_const().

Use container_of_const() in lruvec_memcg() and
mem_cgroup_get_zone_lru_size(), so the const isn't silently cast away.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 46 +++++++++++++++++++++++-----------------------
 include/linux/mmzone.h     |  2 +-
 mm/memcontrol.c            |  6 +++---
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 65cb45f4be32..436934030d79 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -722,7 +722,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new);
  * @pgdat combination. This can be the node lruvec, if the memory
  * controller is disabled.
  */
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
 	struct mem_cgroup_per_node *mz;
@@ -763,7 +763,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
  * their binding is stable if the returned lruvec matches the one the caller has
  * locked. Useful for lock batching.
  */
-static inline struct lruvec *folio_lruvec(struct folio *folio)
+static inline struct lruvec *folio_lruvec(const struct folio *folio)
 {
 	struct mem_cgroup *memcg = folio_memcg(folio);
 
@@ -779,9 +779,9 @@ struct mem_cgroup *get_mem_cgroup_from_current(void);
 
 struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
-struct lruvec *folio_lruvec_lock(struct folio *folio);
-struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
-struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+struct lruvec *folio_lruvec_lock(const struct folio *folio);
+struct lruvec *folio_lruvec_lock_irq(const struct folio *folio);
+struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 						unsigned long *flags);
 
 static inline
@@ -861,14 +861,14 @@ static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 	return mem_cgroup_from_css(seq_css(m));
 }
 
-static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
 {
-	struct mem_cgroup_per_node *mz;
+	const struct mem_cgroup_per_node *mz;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	mz = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	return mz->memcg;
 }
 
@@ -919,13 +919,13 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, long nr_pages);
 
 static inline
-unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
+unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
 	long val;
-	struct mem_cgroup_per_node *mz;
+	const struct mem_cgroup_per_node *mz;
 
-	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	mz = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	val = READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 	if (WARN_ON_ONCE(val < 0))
 		return 0;
@@ -1215,13 +1215,13 @@ static inline void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 }
 
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec(struct folio *folio)
+static inline struct lruvec *folio_lruvec(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	return &pgdat->__lruvec;
@@ -1281,7 +1281,7 @@ static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 }
 
-static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
+static inline struct lruvec *folio_lruvec_lock(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
@@ -1290,7 +1290,7 @@ static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
+static inline struct lruvec *folio_lruvec_lock_irq(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
@@ -1299,7 +1299,7 @@ static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+static inline struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 		unsigned long *flagsp)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
@@ -1354,7 +1354,7 @@ static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 	return NULL;
 }
 
-static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
 {
 	return NULL;
 }
@@ -1365,7 +1365,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 }
 
 static inline
-unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
+unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
 	return 0;
@@ -1505,7 +1505,7 @@ static inline void mem_cgroup_flush_workqueue(void) { }
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
-static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
+static inline struct lruvec *parent_lruvec(const struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
 
@@ -1568,15 +1568,15 @@ static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec, unsigned long
 }
 
 /* Test requires a stable folio->memcg binding, see folio_memcg() */
-static inline bool folio_matches_lruvec(struct folio *folio,
-		struct lruvec *lruvec)
+static inline bool folio_matches_lruvec(const struct folio *folio,
+		const struct lruvec *lruvec)
 {
 	return lruvec_pgdat(lruvec) == folio_pgdat(folio) &&
 	       lruvec_memcg(lruvec) == folio_memcg(folio);
 }
 
 /* Don't lock again iff page's lruvec locked */
-static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
+static inline struct lruvec *folio_lruvec_relock_irq(const struct folio *folio,
 		struct lruvec *locked_lruvec)
 {
 	if (locked_lruvec) {
@@ -1590,7 +1590,7 @@ static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
 }
 
 /* Don't lock again iff folio's lruvec locked */
-static inline void folio_lruvec_relock_irqsave(struct folio *folio,
+static inline void folio_lruvec_relock_irqsave(const struct folio *folio,
 		struct lruvec **lruvecp, unsigned long *flags)
 {
 	if (*lruvecp) {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f8a2d823f7de..9c9c3119277d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1661,7 +1661,7 @@ extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn
 
 extern void lruvec_init(struct lruvec *lruvec);
 
-static inline struct pglist_data *lruvec_pgdat(struct lruvec *lruvec)
+static inline struct pglist_data *lruvec_pgdat(const struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG
 	return lruvec->pgdat;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 54937efa075d..1f660af3bc3a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1463,7 +1463,7 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
  *
  * Return: The lruvec this folio is on with its lock held and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock(struct folio *folio)
+struct lruvec *folio_lruvec_lock(const struct folio *folio)
 {
 	struct lruvec *lruvec;
 
@@ -1491,7 +1491,7 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
  * Return: The lruvec this folio is on with its lock held and interrupts
  * disabled and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
+struct lruvec *folio_lruvec_lock_irq(const struct folio *folio)
 {
 	struct lruvec *lruvec;
 
@@ -1520,7 +1520,7 @@ struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
  * Return: The lruvec this folio is on with its lock held and interrupts
  * disabled and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 		unsigned long *flags)
 {
 	struct lruvec *lruvec;

-- 
2.39.5

