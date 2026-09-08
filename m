Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF9458FD1C
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883082; cv=none; b=G+n3UYTUo/Hrr2k4ear7yRvw8qV0ogbfztZ/NIthok7iMIgoR0jW5r5gIgbIKh01VxD8TjW0ZEPR794knLV0OZTugzjDIMN3EvdfJ7vgWS9D9gxMMPWGKq725o8xmFXVu78z1aNrn+6bRB8dur5+P89w4l75ddco3qM2XVEiw+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883082; c=relaxed/simple;
	bh=RGpNqosEM7mzuly6uvRrlBbYNHGessdlxA/pengEqCY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q5RCEryUwYCc5qSDYcV8veLHkN64CN72c1Is2tr3AQBwEr0NsnSz2mVMuZ60Zkpd16uAGG3LOHiBXmSN1/emMU+4ELlgXfjdayI+CupvgL/r8zZQJ+bJL4ZI/roW2amcX7MH2paT9c0nT9NgsLc6soPd41bW3I0nFyF2d78+BOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=lxeRvEac; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=KnOw+u/o; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="lxeRvEac";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="KnOw+u/o"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbhiA426485
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=y8aH
	Vipjt+6jENEFJCbll5KzX67toHrm1mK00n1KR1c=; b=lxeRvEacj2CaULKnGj7D
	G070QUPMJYU2sjFsGzNrfg9ZL7z5QhvqjAiT2NZaVnRKkEii7DomukliQ3x0q9vN
	y8ICEDwRwh1u3TvZ9muB9RYSmrMHJIjcVa2VSfutXdVGbvjKyQGSY8Z9aV5l5bFH
	AVNkSf408qYKht7bAbZxIKCdu1aZyG8wtfv1mqqRzqUI02JsYeUuxjLVNutaItyN
	MHTK2cO68UnylVxld7WZEmCnYJdQd+UiQW+RIjbLvmCuc2DOc2Oy4a8zCOHQ8Ti1
	QfGu98zQ1mh7IXZXoNbSDCyu2oY6HMtbTTCFNPFATLiMLau5+y5XVew8TgWLUwpm
	XA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmv7gf1w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:57 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52ef04756caso92313501cf.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883076; x=1789487876; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y8aHVipjt+6jENEFJCbll5KzX67toHrm1mK00n1KR1c=;
        b=KnOw+u/oVS5MCWoWvKYEufwB9FrfoB/pwkHU/s+aLRr/U1Z76P/CffWioDIGpm9a7g
         569czVuSynFBidbakHHswEUuw+WOfnpjWkk0qn7fokepRODt9WIrR87AUS5UnpAtDZz3
         jouWYZPdp2k3tp4hbKXMHDiDltG/pHuOhKahTbeApl5qaVgo3pzMTLnsH5nhFFw0OPjx
         AtoIq1RI1pvSi5vP2+CxlV6u/cgzgQnUxeRWittu6LBKdLtuv1EU6Hyl4RsvG+Ln1ybl
         vlyqXi0n5crJg2AQStRn8RVVcfHuv8UTSJ78AkE57NXeX3m1s43z/nEizgS+T/85A1XD
         YhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883076; x=1789487876;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y8aHVipjt+6jENEFJCbll5KzX67toHrm1mK00n1KR1c=;
        b=JgsJO+KYXvR7kepE/DEZGX4UP/aAJ1wXi6+DFNzBAwNOhARUs6KsNkFEmw6T12T17L
         owOUONDohO19vx+lf33ObD+DzMCwnQWg/EDXSEqjT3sfByZDZDzjX0Lg5I8THQL7juPS
         f4JT3OpVIluhgzSh5+2FVEPt+zpFbljVubQnK0aC0S/DE/1b2uWiGlRzaYaFSt3thJM0
         +BUBRWSZOqjdf0N5spubgc6OULIIiY7HA9TtmM9yBdjdg39sn7iDY9IgI/yUPIpuxvXH
         fd9f+QD64eZtv9gN/G+KslrSd7OTn04T4yQbOJ0iXIbXLvGvQLzdzHIq9bqbEpXkDf6P
         EVHA==
X-Gm-Message-State: AFuF++lofmYpSACJjEO7P3eiGfM02siOf0xV2J/PtjYZEN0ygdcG84kq
	qgtfySxPmp5JzVdr28+5v8AMgGkXViPLFW2nymfAYzYwzYB6+gdYdRDux1ntZDCRKWSIIBLz9Hr
	9vFOmxNGKqVXpb9SEBTlfB+lbCRk1MAl13zmmroOga0btKkZ3pulKfqY=
X-Gm-Gg: AYBFou3Kv1CLhLikh1SNU4dx4NUywWY3lvIGEbEv9NkYBMh1Qlv/DFq1DExsl8YOG+E
	dEqDJtfewrFZu1khARp6ey3Nh26j+OUF8GiXtnbBZ7k7H4HN4trCuyRqwA7vEDSf2VKZuFYUmFp
	L7NmB3hgScRYwaRh4XHSbeNX9xC6/j1p6cOc6DDxPFj0n3nSINxQASqkYOBkNPADDcJQ1qkKWQj
	JOA6I+GvuFzUGWhxDfC38eyssM6ITFKWzZABcUi6nL1EhEqHl8y8UA7D/2RbuLpNWi25Il4Mx0S
	mA4X/AN5YyXeq5ATbRZLQWnKFi0BrMsVQ9GjEMNFhQzjjatC3aUFnn/KH/aI3f6tEkoc1AUrkZf
	LI1RVUcDvTw5snZwZcP0zlscHZ6C36VvtMYYfbfXQfH4ZY8YE
X-Received: by 2002:a05:622a:1f8d:b0:530:42e4:1b5d with SMTP id d75a77b69052e-530a2dc44demr11256021cf.42.1788883076223;
        Tue, 08 Sep 2026 08:57:56 -0700 (PDT)
X-Received: by 2002:a05:622a:1f8d:b0:530:42e4:1b5d with SMTP id d75a77b69052e-530a2dc44demr11254981cf.42.1788883075618;
        Tue, 08 Sep 2026 08:57:55 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:54 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:45 -0400
Subject: [PATCH v2 09/11] mm: memcontrol: constify the swap accounting
 helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-9-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=2888;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=RGpNqosEM7mzuly6uvRrlBbYNHGessdlxA/pengEqCY=;
 b=PCxMwC11hDWIhBZYDJPTOn75inbk2rXcicdxcrk2psxmlRzrBn5H/SvPaBYgZlzebUmYpnvK9
 p523Ms9PBDrBJZRhUDFKp7xLpQVujN0EmkmE022/SnEWdLWMrHaAH4e
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX4QYQysm5Q6TQ
 mGgqJPOsVYz2kyhPaULmUBakQNX/5g/c95lZauHc3cqN1ph8VUyhlJ5g2cwjF9RQXEnkH5JUSWC
 YARMWf2ficaquvah+5+IepBKFUBycA+JZSmU85FAY0ioL9i/RY5XGKhiodf40k6Hc6HXhXQTO4k
 Sn9AhgYsS1mo4U6yaF9cTTPsndTOk2KlA0qk1Ow3+oITC3EKCDvvIDPjTQEOgjvDSb3nXbxM6RS
 ad3d9LjT+cWlu0W2TdfKHkNXZobvjjpm5eAPbjvVU2WCGxADoSe76VWquC8HJJpUCp2fU2oGZ3h
 COYp6mloLyk5RpummgdCgAezd0Enw8xDaUa1vtMdV8Qz+jBQHBrOWXA+OvzLO6cDgemWqqS/0+U
 V+3cmkt6ZKle/dIFjMXvzC79kz2KNSWbn3z22iT/vp6tbFUmVarVZe2XGE23BghJxqmVZn/EMSc
 iQHQg4e66hnG2hJ4Y1A==
X-Proofpoint-ORIG-GUID: 8zZAF-TZDGGLmjiqWVx0KoMKD8PCauCx
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXybCZkvBvsHfU
 h7VjdcjdqDHkdsbWR5yY28cki4cj2IaHgf5lp1EKICneC3FdvuF2nE+d/ZnCa10Mp2Nq7foWIeD
 NHW4ByhZJvVDMTOsJb2i4heMtqh2tKvDNgfgvZbln7vXATi1C0BB
X-Authority-Analysis: v=2.4 cv=fpnsol4f c=1 sm=1 tr=0 ts=6aa03085 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=vlTQYXqq4tgfiFTJlkUA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: 8zZAF-TZDGGLmjiqWVx0KoMKD8PCauCx
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=10 impostorscore=10 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172

mem_cgroup_get_nr_swap_pages(), mem_cgroup_get_folio_swap_margin(), and
mem_cgroup_swap_full() only read swap counters and limits. Constify
them.

Remove externs from function declarations while at it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/swap.h | 12 ++++++------
 mm/memcontrol.c      |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index fc290e29e4a9..843d70680b8e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -505,9 +505,9 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
 	__mem_cgroup_uncharge_swap(id, nr_pages);
 }
 
-long mem_cgroup_get_folio_swap_margin(struct folio *folio);
-extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
-extern bool mem_cgroup_swap_full(struct folio *folio);
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio);
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg);
+bool mem_cgroup_swap_full(const struct folio *folio);
 #else
 static inline int mem_cgroup_try_charge_swap(struct folio *folio)
 {
@@ -519,17 +519,17 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
 {
 }
 
-static inline long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+static inline long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	return PAGE_COUNTER_MAX;
 }
 
-static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+static inline long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	return get_nr_swap_pages();
 }
 
-static inline bool mem_cgroup_swap_full(struct folio *folio)
+static inline bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	return vm_swap_full();
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ad9f5e558814..0fcc0ff587fc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5958,7 +5958,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_unlock();
 }
 
-long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
@@ -5974,7 +5974,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
  *
  * Return: Remaining chargeable pages in the folio's memcg hierarchy.
  */
-long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	long margin;
@@ -5991,7 +5991,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 	return margin;
 }
 
-bool mem_cgroup_swap_full(struct folio *folio)
+bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	bool ret = false;

-- 
2.39.5

