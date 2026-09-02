Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402F3397AE4
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377329; cv=none; b=TD4DOhOJQ9vv6bJppiIluVyiGmlYyMPMoAUHnwp6k0tYqpLhtG3fW54ybYZJineAG6H4U9j2ZoKj4T1hTHoDBszrt6fWN/fPe0+mm+R7PXLU0knpjJ9J5cnB6VD1XJ1mKAhH7aNoveq7vgn2vUc6in6NcVjGhOVTMCCRytGhHQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377329; c=relaxed/simple;
	bh=wC5jQEJdvXNDOvELuZJOYHxO0UgTX5KCQayPHi7yS98=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HxuoJ/s2VfPT+NSwT8gD2euFjv7ZmZiOC5pNczX4PvHSLt2Z1us27pPdCtdruHtUVqbyvOuI0zGHe6PpgYhV6QrZ0iSgE/QamqzhwbeOtWnFllIu7HdE6EO9MCGYVvGqcBGb7p5yzx00awGLUEJM+hIK1hYqy8RLS3UIiAWL6RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Q/m498FH; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=V2FX1ZGl; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Q/m498FH";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="V2FX1ZGl"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682JGUcW1442256
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ek2V
	Vn7iLRLT1FSUmgwG4l23Zd373ek/nG0bZLHscu0=; b=Q/m498FHzhHCYykvxZ4l
	v21h3KKPs5xyCNbckieb5WDouZ3XbqBGjLJTiWts0FcYyBmiTndo97Loj3VabsHC
	Tm9WObX3qSXHySDlyDAkC3BLbbfJYWu9kD92+zldreloEy2rlIVY6jhWX+Vbz6Ro
	SCbotox1nmHlZz22+tpevgw8MQUqt+B7GYLXRZ9WQwFC5YZg/jc9lAL20e9kyfa+
	r1j3rf1w+I2uCPlOew/9fUMuGdsSjwAqw/HXjWm+ZhJgnGVaneHfkV0fsyBJQeKf
	DcQ5o+2WA1o5DqJY/7x9E5m9SnXsxVP0HNBppg1A9zkmLdiDaS/eifkWpNy5Iz0L
	Bw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gestjr2nc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:29 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90ce8ad8002so28387006d6.2
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377309; x=1788982109; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ek2VVn7iLRLT1FSUmgwG4l23Zd373ek/nG0bZLHscu0=;
        b=V2FX1ZGlxIXcH/zoZRzWhv1M5C9sJjZJ5DWTuReWN08DAG6UfVLmADvpxj2DzCbsNc
         sIrgFPiJmSHRUPaGKq8kyAdr9k6JXIA0Pz1RTL6JbVAeawPfejQ7epFdoUyVT5GI2Of9
         WjJbiTIatYWLMlUf8borWdZcslpm+r3MhDij9IO8ojq6CHmlRn9J14lm7wQxRWZJSZ13
         NGW9yUZoVJbvlqXYJpa57NRvHtJSetDFSsfUk+88Zh5G5Hyo4zlHzq7QyBGk/zHBE+56
         yrh+7nFgj8FLuaeZRwk4+7nN1Od9eeF5LF6vgul/iVK0rsKMwYiNCplNjsquZDIJQaSx
         Bl8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377309; x=1788982109;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ek2VVn7iLRLT1FSUmgwG4l23Zd373ek/nG0bZLHscu0=;
        b=DexguqM4tJhnU/YI3GZpMGOYxLOLi4lhw19DwA3C00w+MtfZcU82LE5JwoE7Dmee1X
         gSwGXXE7i0XwYmupKAXeN3PQYgp57VFAaopaDxyZX8WBaaabVHItFb04LdWRJkcDdM/6
         6IlFGR8H2+jjpSWpHt2aRo8UcXRe400Jhtdt5zX9vSEg13SjC1MUlvm2CZLjoe8I9y5g
         RnzVMUFNLAuYXEqoygK5vDsmEc7mevx02QtQSlC61yYwLmiRCZZ9HLot1w16S9DJNTj1
         nZIlwmvBIz/ljlOMVJHJsAQArcrrYxvbzMSbujWI1QeXF/Znm6zcrSrkf1XG5kq6gLQk
         nzTQ==
X-Gm-Message-State: AFuF++kRRWlH7xhGnLww9ps8ZVFO6bs85mzv7Z7IdK4DMSHPphhPYihZ
	/xPz2bD1sNhdjwWlcmBC8YfXaPuhUmZYBhCZmhqtokgAObysxuoJzzQs/hM8dl+GuSKa8TjfFj9
	wbM1zTvdGU53xNHKEulu1H4jpWUoikMOFZf4gIkA6tm7TUtx0ER0Q7Zk=
X-Gm-Gg: AYBFou0ERu9X+9/rCkC+9M0wEylqR5tmECGz6Xo+CAR2b7QRdARN09w1CDRgjm33W0E
	bO1xLAkLX4Hcgb/idT8nWq0VllkWmdHju3qhj+hcgoaSPBfJ/iB/JJBgEtshWQZr3ahgbGCPpve
	oyVrTqZN0Vdb7mOEuWVbwS5+6y4BjyCqGRwS8d8axEZ4E+LGkgNNNMvo0cPqUfNh5pPB5Yoy79C
	+WOkZgrfVpdW9tZKsmCWVIlMxGqmITXuJWLhQCiHJ/qDIbZBq0iugJnich643JcdDChxJpHlFrQ
	+oyC5NxDsyVdFUyS8PeOa9IuXZ8aC+bpdLF92pwfvj57kzlfNoXF3AAz6W/HURH38cBdw4USujm
	4xcsAAVAcl5zVrGpx0dqC2fCR9jdp06hQqyugYsIRWopAMnZAwlwwjg==
X-Received: by 2002:a05:6214:2466:b0:8f0:afa3:594e with SMTP id 6a1803df08f44-90eca358387mr93200156d6.8.1788377308911;
        Wed, 02 Sep 2026 12:28:28 -0700 (PDT)
X-Received: by 2002:a05:6214:2466:b0:8f0:afa3:594e with SMTP id 6a1803df08f44-90eca358387mr93199426d6.8.1788377308183;
        Wed, 02 Sep 2026 12:28:28 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:54 -0400
Subject: [PATCH 08/11] mm: memcontrol: constify the memcg and lruvec stat
 readers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-8-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=5368;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=wC5jQEJdvXNDOvELuZJOYHxO0UgTX5KCQayPHi7yS98=;
 b=29lTNNsiv989SgHNrVYYq1ulj9KInk5RyRFJF1EeMhjajtR8sVabNMOFw3PWq2CkX9nOTKWI0
 K4q2P2wcva3DUoxcEdjh1/PTJK6MBR4o6aEDcXIu8XArbq+1DYS5biP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX9BIdiQj2b+2X
 fCqfMRSKAiFPxmNYIccPRYLGml0w3Ba8/sEqr670umru975rxDOS/iLIVZMMPnMX8o9nEUR8DRs
 GGwjmGSHpENxZxlwLrURiHSJ7xKbQLQonrkCuCwg9elldC3n1rwKF38wP9cfJJTmivg3nhhwDt/
 dCgJ0l3TJqLpgR36m5Y2dRarDX8N/OQD7wLoBK+iIE9XDYhhLJ9HMmq9/Z26npSu/OUdZzDQPvI
 gvGN5ucigmK8uIcEirbFBIkYkIza8Ix0P+Wc0fSsfprGlNh6Z2eRpnUMxGadCEryuckWqsiaDUt
 5TEvquwdUXQvHwP5OeeHhVr/tAVUGdAwbI9/Zr0jao+FkyvZ+eHGEZv82HuGi5bOItUHtBqg9rJ
 Ia/KgY/ztCPvgnOxjD6l4UaaUCc0bTaQ7x/CA8NTbPsYSfoyXaBEZFLxzJZFmk0Wvuu1Ruftchs
 vB7FnlqcbJwBhaq3EgA==
X-Authority-Analysis: v=2.4 cv=OZKoyBTY c=1 sm=1 tr=0 ts=6a9878dd cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=ndtaMpzIUFG_VZog7AQA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: AK-BldVCz4fbFVH5mjJg01OmJkm5VmEW
X-Proofpoint-GUID: AK-BldVCz4fbFVH5mjJg01OmJkm5VmEW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXwKvvoaqa7l7W
 hPpwQcXITQbRmP/eNYsfM/AUo15kXYT4N4MbTUoYT63dAdeY5zN3hsB3URJYN2PxcO4XFgECgDy
 oWS6wzi5PoDMsx0eTVJ9KWpnsjGy72PRER/DtEzV7o9blc5pjxRx
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 bulkscore=10 adultscore=0 spamscore=0 suspectscore=0
 malwarescore=0 impostorscore=10 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172

memcg_page_state(), memcg_events(), and the lruvec_page_state() family
only read counters. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 23 ++++++++++++-----------
 mm/memcontrol.c            | 12 ++++++------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bd82628d0d72..10a197886f31 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -932,15 +932,16 @@ static inline void mod_memcg_page_state(const struct page *page,
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
@@ -1372,12 +1373,12 @@ static inline void mod_memcg_page_state(const struct page *page,
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
@@ -1392,19 +1393,19 @@ static inline bool memcg_vm_event_item_valid(enum vm_event_item idx)
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
index 35f924c9f2a3..3d3eadddc130 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -489,7 +489,7 @@ struct lruvec_stats {
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
-unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
+unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
 	long x;
@@ -530,7 +530,7 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
  * monotonically-incremented event counters are stored in
  * enum node_stat_item.
  */
-unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
+unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
@@ -547,7 +547,7 @@ unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
 	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
 }
 
-unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
@@ -799,7 +799,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	queue_delayed_work(system_dfl_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
-unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+unsigned long memcg_page_state(const struct mem_cgroup *memcg, int idx)
 {
 	long x;
 	int i = memcg_stats_index(idx);
@@ -1091,7 +1091,7 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 	put_cpu();
 }
 
-unsigned long memcg_events(struct mem_cgroup *memcg, int event)
+unsigned long memcg_events(const struct mem_cgroup *memcg, int event)
 {
 	int i = memcg_events_index(event);
 
@@ -1709,7 +1709,7 @@ static int memcg_page_state_output_unit(int item)
 	}
 }
 
-unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item)
+unsigned long memcg_page_state_output(const struct mem_cgroup *memcg, int item)
 {
 	return memcg_page_state(memcg, item) *
 		memcg_page_state_output_unit(item);

-- 
2.39.5

