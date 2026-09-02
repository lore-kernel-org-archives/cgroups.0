Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7E6395AE2
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377324; cv=none; b=BQbmbg0Jz5AODWPVPmjC/pxg/1lwBuDF7jqVooATLw06PqKhjWaSouV6y0tDZ/jE6c2dWVDxCSe7lxCW+RrOjOqYt+TIOSHmK/JKJ1Prbxfo2EsYU1KxsoXulJsHa+XBDNyLyyQvJwhZVjVKIE5GpBAvlObEreMncoJeZG/kiJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377324; c=relaxed/simple;
	bh=YiGk7IcTyC0Eps0s3N/NbbC9x/40tMeZu+bwBaHwqiY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qhFkAzwU+n+rv679eBkInxNFxi16FV3VhIWov+UKpV38SxuQSu+LPXbTu4g3OCvLLMQx+mnrMif4Jif9qizNosQ+XISWOFKieR6Th1dHr+JVillVPQuJjweVpKByeCCxsXXQxcgQ6Z3SagutH2P3S5g3Yqms17T7UgxsfgzPGVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=XHD8wSIc; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=pplFgONP; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="XHD8wSIc";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="pplFgONP"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682JCXqW1004510
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0VAf
	iqCv4eQS4h3nZSDuv6RC9EOG5S+Brh1R9wZYHWs=; b=XHD8wSIcL8iM08UN/g/6
	dIoF8wDgXZJ4Dnlg9+79gn9pf70m/nnqjC/OHKQpxxHI1SHWwsYJzkxnZsmU4Mss
	CRV/C6DkaZvnXRTDQcrg60W9/361LGUz9RJJmiUSHsyRhaULNUBqFU3ljokdNG0S
	rtfVpeupCo8yKCtQmpamprXqf1M7BTku95awlwwBK52HE5YcfRJYJEFOrhDZbViT
	gwrUzT5lP4EbLyrk1jjQd/7xXfS8j/Mue6yCMDBSJCKutDeCi71fE0yvkrzFZWT0
	u9afCEMWmtwZzfaBuJdkV6XeiaPrPcZ41hxu7LsXU/J/SLxk79mfucz///VrjnWZ
	pg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gesrr03uu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:28 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52fb2a46cb5so38278951cf.3
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377307; x=1788982107; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0VAfiqCv4eQS4h3nZSDuv6RC9EOG5S+Brh1R9wZYHWs=;
        b=pplFgONPXH+L00sZW3Ddyav3KWlt9ZlJ3q/8vaDM6Ed8TdBIBWRsqu1wmnfvH9bvwT
         6zFgBcs1yPAWnHdWHKh6ArQKCd9o0MN0w51tnrTeONzqwSd7A704VKkA4ixl+BItOgES
         DU8G8QkkFOq2BiNOshmz80HMz5VY90IlJsmC3z1YlKmHir75yj8kgjDwhicIvgx6wxEG
         wde/EISPstiaJVqbAIZbx4hTPaIsOlXjWcsL4ORfw/xpMl0NW8I9yGZOLrBcVA1nwaxM
         54r5NgsceivKD8LbbgVtEa1JBsk4ETQ7R6dvpNCBogMysDFyeFFWuBVffbUgLrpZ7HoZ
         bsNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377307; x=1788982107;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0VAfiqCv4eQS4h3nZSDuv6RC9EOG5S+Brh1R9wZYHWs=;
        b=WZG33IjIDL50D/LBd2gJvBq4Bt3Ry4+USGmJDYY5SLjhb8cU0a06XCKjAyxSHK9ur7
         2LEmmMYAJhjnzQYglGtNEDiaK3Mbnqhg9r93lLPuw9Cr+DaK1qD2pHTyIU+WYVDax8R6
         Df9RO+bikPEUQcjYCPqZBuPItdCMc39GVzedkS9h47kUZryQcSzJW8YI8n59KA7mO4ma
         HmJyzxrkVT2tifH2VCTqnJlwd4aGc3YEI9Nc7G/d8kMqX/bWteou7jCWFgbW5rqBMW9m
         dXqFr5+l8Aaxy/q49EISog4S1v4w5+pGsdf8CdJm1gIK+Kuldpm2Ulejz+WUlxu4qm8f
         6KAg==
X-Gm-Message-State: AFuF++k+dYuJP6cscuWHHj7i8ph5X3AMFfAwBRga4PVobB5iBF4okZWh
	IxbI93FwH3iayO9qNw64pli1ht9KjpokCHmPbUtb7z7M5cPcEhULA/wFmXT2FumDXf2j7eg1glo
	hAxHSIhC0Lkaece+kcYBDx4EhTBsFvoMgnkb1h8T3tWss53uoEsMlV7w=
X-Gm-Gg: AYBFou3YUopkQiu4cGjPGlgRi7N16nznyouwlaBdzPcBetnzp1kRlVZbqaK54fhEhtb
	kX66Zrl5V4bV7UkF8Urx23t7b4KaSHnaau1VVNZWm9Cr3BGfKpz01cyW5I6O8ed6flra3yH6L8v
	+P6eOgf1ozVaJMyx8eMaH4eSdR62e4Rjqd27kc9jBs9Up3kXqkNT8cfqAEEnD8J8govKeTgro3s
	oA4QiB/BJMQ2hLTndtVabSjzte3fhpDcRORRP4zyIwU+Yi05syONGQBIRuOlaTIluLwHrlyCgbG
	YbfxzIAFAkLK2vYvQOLg2WrY+0mabNWNvKO2BjOjgvzqreJ5I5N6cpK+VT57C45/Qby9ZWf7DkE
	lHMtog0eYtlCF8O6ty3XKbYPr0MfkgRoIsioJpsn1dpROHeUod385sg==
X-Received: by 2002:a05:6214:d0c:b0:90d:3c75:138e with SMTP id 6a1803df08f44-90ebab5f849mr91931116d6.17.1788377307486;
        Wed, 02 Sep 2026 12:28:27 -0700 (PDT)
X-Received: by 2002:a05:6214:d0c:b0:90d:3c75:138e with SMTP id 6a1803df08f44-90ebab5f849mr91930346d6.17.1788377307002;
        Wed, 02 Sep 2026 12:28:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:53 -0400
Subject: [PATCH 07/11] mm: memcontrol: constify the reclaim protection
 helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-7-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=3509;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YiGk7IcTyC0Eps0s3N/NbbC9x/40tMeZu+bwBaHwqiY=;
 b=+WNVrqutl1n0CQduNp4rYfXSeoz4yiffisjzUinopL3RaPXOQZV9JDwvQLXCYFHMgo2xokdY5
 lcqg5i9omW/CqrsaFK/UszHRH5fR0tR1CM3irMoIXnvbmUTPXB6vbRk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX4eYt6RIDM3A5
 MjvX/K7NHAWJUA/TR0psI6wdCqrlwm4bMWmjHQZK/SaQzzCuxZFLitJCHB7Ce2cbaW4ERGIbQtB
 QZtev4gTGLezBM9cQqFPnFfiuQ83yaCknD8ggoQfvSYoSTfl4XmM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX0QePgX/Eopwt
 Le1MvqSUXStqgzwk0KvADkpUIJHc8PN5Fq+qgcyGF0Z3HRbSV/iUN956PbztRyNaQHSWYZ40jTt
 e5N8gxdm9vJA5BxUQopGrB0I6KeMvgqUla1DdKl02y+BlbyTZ2WpLXmDEjzcMspeW7m4A0xuMDd
 C91vxxIfOU+Rs25COGdZ7snklXhOFNuZv86xCoW7vFms5nba7JhvgNLgaeH6aYIXcN39nkwaB5f
 K6/ooqEfnmr4gdndQk4ML3vVDiwfbNA1wkHvrb9RIzuPALudKIS1ObwsS2VemyPnYDNXg8rWWc5
 rNiga0u/BrcNnV5DCXY/l+ewc7VKpeKcuJGiZlda6eqn3H0UrcukaEfnt/fnsth0UR5e4vcJ4tm
 4Bt8HRxZg5YU8O0f2pwnHEvg+ttUFZYknZYrqoJTEdP9jBp4vReGfjZAmzIZGYbp5JgrSFGOZkH
 dbMMFlF7YclApIBGUgA==
X-Proofpoint-GUID: __pNdbtAH8pKN0duUCqiqKLQvjaaq_qT
X-Proofpoint-ORIG-GUID: __pNdbtAH8pKN0duUCqiqKLQvjaaq_qT
X-Authority-Analysis: v=2.4 cv=cPnQdFeN c=1 sm=1 tr=0 ts=6a9878dc cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=Qozanl9KyY-oOybludYA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=10 priorityscore=1501 suspectscore=0
 spamscore=0 bulkscore=10 malwarescore=0 adultscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172

mem_cgroup_protection(), mem_cgroup_unprotected(),
mem_cgroup_below_low(), and mem_cgroup_below_min() only read the
protection state. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bda969b3e1d9..bd82628d0d72 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -537,8 +537,8 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -592,8 +592,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	/*
 	 * The root memcg doesn't account charges, and doesn't support
@@ -604,8 +604,8 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 		memcg == target;
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -614,8 +614,8 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -1110,8 +1110,8 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -1124,19 +1124,19 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	return true;
 }
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }

-- 
2.39.5

