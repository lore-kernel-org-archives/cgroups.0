Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85425803A0
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883079; cv=none; b=si1bZRHwfoDt+IqYRRBt2ByqK1CJesYE4A+ZMZKqvIR0+OrlbJ7l+h0NFk8dOsZU/bheP3zV9IseLJ+oaWDehYtqS2DEAG7JKQWJF3Nm9JlCVdSQd7Y355L37MqdgrFyNf+KXYLDrI9Cij/2lfeQ0ewkJI4B14/zneK7F66+9sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883079; c=relaxed/simple;
	bh=gH8aQB3aEdF5B4e4hdlbYc0wkoHxT4I3NtGuwmHbbfc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AVllNcG5zwenfe/oZDKv9wq+LtYwaTMwUpQeiJW2o+/pUmkyO3hrPP98gEBqlY4kdKqJcKUFF5WN9mLq4oCKNIMVVjFNvdkGN9aTozDpof48upvZxWAHh2AmzP+ComXQNb/+QdCxw34Rx2ltbKvUJkVR4C2+eIZTJYZGTSDB+xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=D2nnI675; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=RC5//1XP; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="D2nnI675";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="RC5//1XP"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbbxY1250149
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=X5PW
	EhvFbG4ZLGGFHF2CDXRQunTpS+Rjx6EOAyOcHds=; b=D2nnI675QKoW3vsTbh84
	noxvPtrO0oIE+oACTsWTer0nTGC6SuY5MV1GkuEp98LsqCbADqgXG2AfPS3hZ9o2
	SPbG9MYVulpbvkiOEfNlvAkzA1whzn9torjbtPPXMGcACkdZG3ad5Wx9p16VuaNh
	43YABGltso8zySJOjCR1jCK9NsR7sX9XK16XxCnxu7Hj+fIv/0GOVCTaZPDnjXvZ
	/eopPLuOAqfkRLnNj+PVvHJsyE/tXrmYxBXxS+cSK08xW/R2iSoukABqrjaBs+xF
	Xt9wn70RBks0yh3iv/Q0OlWFZI3AGUzL24h83w48tPIHxDD/7GryI2CHVHtwtMQ8
	PQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjhqkts2t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:55 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52d33c89a29so106161851cf.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883075; x=1789487875; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X5PWEhvFbG4ZLGGFHF2CDXRQunTpS+Rjx6EOAyOcHds=;
        b=RC5//1XPeCDRY/FdhsaaRb2dcELOklqSzY0FUBR726Ao2Wc6OGAIV46qTjevl8J75p
         Q69/LJmvKDaqLOyothxi5VABP0CNZ6p8uOiW+IaeNOM39NLW/FLaFadsfOmGBXyuIpDn
         621Az8jxP5eA4RoveDR4qWm37ULU/wyBXrbanDMmpKAvIBsnobpAMsoA1kgP47XWCQ/5
         nmuYYQESWo2BVjrKp1k83QKnOwLglgy8r8OnI6vpwkC0KScwcJD10pzwPmspIydJ4KvV
         cwNto3FlfsZUrwu3KXo5p7lyrr6TnWEMDjHcJFmQvIrc2iIDNwwphXiDL5/OyEt4NCQ/
         dpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883075; x=1789487875;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X5PWEhvFbG4ZLGGFHF2CDXRQunTpS+Rjx6EOAyOcHds=;
        b=TmqgxNO+gE2osEyVJOayCIm92LX1EgP7bLNCcxqWBVvmGryFKIuHpzroFeJf3W2GUJ
         wsIUzfJ2ShjtfqzqeodHHmO7hFVYn8EmB4m1o81bmxGUSAars7/FK70Kjob+JqPcBPKR
         Yn0Dr7oaMttoMazNhOSDm50OgFbMHYDY8h23np9vUaRmRUTSydTx6n4GfwT/qoQ9Gr1G
         VVZgh7jgkUtjAZ+ghBgEmcWq31V4JOFx1IkxQrLfiO4JsMrxuv9a8DUFsUBvB9jEEF+5
         hMazqyA/Utabi1JPPNwNaqWn0d3PvikijFNVzHKL7Ku5NOKWF2JEHvIHKhLhOkbGI1Lv
         3ryw==
X-Gm-Message-State: AFuF++lWIYzECNAfQsPphw+8p0gPpdSx5hjQY+uf2nsIbBcjxd+yUk5M
	FPpZOl0bJJvMcRsrfz54b9KJpqN673wEl0SdR3kczocqK8hQJp1zKndSbbLXZmqHNnJsvauCAaI
	MiW0F9cCqNFCS4O6Dw3UPyFpscKWR/GU+eyARwMf5NijoCsK7mrt87Ys=
X-Gm-Gg: AYBFou2h4gV9c7LMLZ54ael+UCqdNGWpWLBY8aKifA6p8Jv/vt0hUzylDT0wXjC3ZaK
	Rg4R7X4bOmJWFZW7UEj0PDmiwZiZ+ITGehdFpzNmPYvm8YEoguJQgXVJCPv0Y8k8JB4RWxOhCBl
	a5MhnVcFAJPXB6+n6isq4eJEbjEHxRq1c8mhr14i+xkfRpt8x0fnBWQtIpIbIbSP9JTWMZfcgsA
	h8F0XDl+pHlKu4KaDGjWD8k3knL7I/Wcdn5ZgV7H6QvGaGd7I+4zXegd9advwxKpEZDdYcvmM2g
	h/Fx4L1oM89Lch0pkFFuIjf0WED9jAvp1DBRlHQx1vv2Lz9YmAFj0iNOecO5S6toaMHJmDze/sX
	rHE37Vr3f0nCeSKJGcvHoTGe7ir1npGXU7oAj+SwZJWKz42jF
X-Received: by 2002:a05:622a:4807:b0:52d:f63b:94d9 with SMTP id d75a77b69052e-5305498463bmr430145681cf.30.1788883074834;
        Tue, 08 Sep 2026 08:57:54 -0700 (PDT)
X-Received: by 2002:a05:622a:4807:b0:52d:f63b:94d9 with SMTP id d75a77b69052e-5305498463bmr430144561cf.30.1788883074196;
        Tue, 08 Sep 2026 08:57:54 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:53 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:44 -0400
Subject: [PATCH v2 08/11] mm: memcontrol: constify the memcg and lruvec
 stat readers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-8-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=6756;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gH8aQB3aEdF5B4e4hdlbYc0wkoHxT4I3NtGuwmHbbfc=;
 b=fX+qGaKT/C/xwXemduVzHicWQARbEqeguciHNhrCLFBOcRm8ooCp70Pe9tfr3DXKYwmxfLVUP
 WqflGGr5E4mClUzFmq5z5bHbLQODv5Vq8d1JNxXux1xLmaEQgXEGLz+
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX4hWHKloU+MKM
 c7JkTFVONmE0M38MqEGpqcYC/B4+ASfx1izOQDCvxxUzT/HAyYDa0eTait1KdRw9Rg93G3mSEw+
 yEOGgJ08V9pHPpRB50ZvX4/Mc+84xEzI12R8wJOdgV8dgFo6uK9rqcqu12rmz3LjkwZXzC9inCJ
 xzWIfIDSHw7bFviD2CXfwFHe5uwXQ/XVCgfXrxadnqU5tb2mGnEAZU9G3r9jF1WXRAn+1hlSc5t
 wSCoL4VYPRsCjRbpWGTcL1jDpRmgzVYVlWZHaQVue6z+T6vSyPytGdZ7wo7G4EDQNPwekYwId80
 4hJY+BMPf3l5RmEaYTv4WU1eoCDlDZA7jpG7kg8gFUOEGeSDe2jX5bXffqt/JuHxBsqREeU1Uz1
 zaFuaAvOFkOp3Wvwz/Agy8swKQIyo1eVRvAz+PYIar5/xE+AxBQY6YgIdkJilGuKQRV5UaHvD2V
 iqiCBAp/a4ixD2iWkMw==
X-Proofpoint-ORIG-GUID: bbFB6HaaeLCGu3EG1PgFnWqAAgEo74es
X-Authority-Analysis: v=2.4 cv=CuOPtH4D c=1 sm=1 tr=0 ts=6aa03083 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=Eo118cYSGe3kRcDbF0AA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX29468CzNM8rz
 yvCGPgOpuwj8voTR5OTUn7QdDX5IP0iH5FgsTFByTxfa66uVhRNMrR/bi7mfeHZIttpqYvQy0EY
 RknymMzZxJuUkwmzaeCv6N8XQieTRG3Z4j75K1ATVVCC/IFMXhr6
X-Proofpoint-GUID: bbFB6HaaeLCGu3EG1PgFnWqAAgEo74es
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=10 spamscore=0 bulkscore=10
 clxscore=1015 impostorscore=10 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080172

memcg_page_state(), memcg_events(), and the lruvec_page_state() family
only read counters. Constify them.

Use container_of_const() in the lruvec_page_state() family while at it,
so the const isn't silently cast away.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 23 ++++++++++++-----------
 mm/memcontrol.c            | 24 ++++++++++++------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f04d2b2b47e7..d8600f1444df 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -971,15 +971,16 @@ static inline void mod_memcg_page_state(const struct page *page,
 	rcu_read_unlock();
 }
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event);
-unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
+unsigned long memcg_events(const struct mem_cgroup *memcg, int event);
+unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx);
+unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item);
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
-unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
-unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+unsigned long lruvec_page_state(const struct lruvec *lruvec,
+				enum node_stat_item idx);
+unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx);
-unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
@@ -1412,12 +1413,12 @@ static inline void mod_memcg_page_state(const struct page *page,
 {
 }
 
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+static inline unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	return 0;
 }
 
-static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+static inline unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item)
 {
 	return 0;
 }
@@ -1432,19 +1433,19 @@ static inline bool memcg_vm_event_item_valid(enum vm_event_item idx)
 	return false;
 }
 
-static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state(const struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
-static inline unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 							enum node_stat_item idx)
 {
 	return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
 }
 
-static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 						    enum node_stat_item idx)
 {
 	return node_page_state(lruvec_pgdat(lruvec), idx);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2456ffeb5241..ad9f5e558814 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -490,9 +490,9 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
-unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
+unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
@@ -503,7 +503,7 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	x = READ_ONCE(pn->lruvec_stats->state[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
@@ -531,10 +531,10 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
  * monotonically-incremented event counters are stored in
  * enum node_stat_item.
  */
-unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -544,14 +544,14 @@ unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
-	struct mem_cgroup_per_node *pn;
+	const struct mem_cgroup_per_node *pn;
 	long x;
 	int i;
 
@@ -562,7 +562,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	pn = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
@@ -827,7 +827,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
-unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	long x;
 	int i = memcg_stats_index(idx);
@@ -1113,7 +1113,7 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 	put_cpu();
 }
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event)
+unsigned long memcg_events(const struct mem_cgroup *memcg, int event)
 {
 	int i = memcg_events_index(event);
 
@@ -1715,7 +1715,7 @@ static int memcg_page_state_output_unit(int item)
 	}
 }
 
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item)
 {
 	return memcg_page_state(memcg, item) *
 		memcg_page_state_output_unit(item);

-- 
2.39.5

