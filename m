Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4DA4D90D7
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514444; cv=none; b=phNiBMDIYKHsoZbIpgYYK5XG3qe33GaK2X5velYr5QUYRH8+v7wuER+8bQ+CogZg0FVXyNCoBAuTtdEJsUawLaHCbDPcPsB4Q3SYmEXLOWgrbTFD9ttowgVbtbxvrta9OXVCQGnUNA9WMVSp82oZc5vxDZT9DSVfpYRMcFWRk7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514444; c=relaxed/simple;
	bh=wZ7UnBf3QaZVjgfHJlCjkDQs5ZCx1m2hy7FBVH9jNJ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sn6hRFGTqe/1D3rKG/cexjKZUFOMSkXYNBwcA1uTNPei4DSFCSx9ceY2O6HhK5u5DlU189GM2u3qrXHE3a6Th5bnHbAZqP1hswvOKsoK1NOwfDM9W79lrbL+eZsxEd4tfR3rVP1JpSstTPRpV100wCVw2gG43zc/b4IWtFhpd2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=S9rK6HyP; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=aqU2zy1H; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="S9rK6HyP";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="aqU2zy1H"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbVKF2571546
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=I8Bx
	BffBm5AN+TbnCPlm79JDerV+EaqITRnbuFkY/pc=; b=S9rK6HyP/h7A4yGqszKk
	zM3hQPXjLzadtt72/LiNjWiSpMSiAC9FPRsS/wcxtzKR1JCC3IQiaFjfi2DLIfdb
	X0TK93p8VJJWSlgRtA7aDm/QdN9UM3D5OIkpcveq9x2st3xVmMVPdgIQyDqchoRz
	Jp+3ZemsV8+s/4IlKN6BxFbyiCAOsPMsgjYgNAxbXmO4qLp1Ii9/X6T0QGKdWP/8
	QvllnTi7BbiHAo1gO637scqE4IJstR9xZG4IBjdVwXtW5Uz0LKnJdkIrg4yD6bng
	X/MKcgToO3WxcCaN4zAElmfY2WP6OiR2I3D3ZTzDW+7q4JK1/+i47CTRlI/8KK+G
	VQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwd9t1c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:40 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a1b824e84so599673485a.2
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514440; x=1790119240; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I8BxBffBm5AN+TbnCPlm79JDerV+EaqITRnbuFkY/pc=;
        b=aqU2zy1H56r3I2nuZ+Ghy4+W29kXceb/4Uovo4GSy0omI1DoE9xHDkFCD55mCUh12i
         F+HzEpOW7YArdhaZAzXg2b0fVH/9szEeLct3iRaka1SRceZvqu8HU3sx5UkuDvnWmw89
         V3qZWcIp7xLAFBchPu6JogvwyhULy75oQ9Wo3VO8bShDow7B5TSAYtZipPNkFfIhzO8o
         Z8wBhp3WMX8VpsaJ0dfxKuwbZz71hWjNMXsGLH1DLoiKLk0F9gjV5dscGM8RznHXfzj1
         Fdiw5/CfMTtTe/tT7RafFGn4BI57mOw2CjNs8R/6oOFVPLEF14Rxy3jjXvjrCZyqLq6d
         DDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514440; x=1790119240;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I8BxBffBm5AN+TbnCPlm79JDerV+EaqITRnbuFkY/pc=;
        b=u+Gkgcpurm/yMywQ95ipdbTBNia41qgrRGHbvDT5lDZ4wV0EBqX8U6Jc0prkf7p77v
         3CyPWQJVikiPJa+BDJAskAlbeYQnI4F0ezh6f1QxJ2E8GyBYxHLu1SanTfiuZ60q1jqN
         niTf38fvTZGUM/G1UyVjvScvgTDYZqRN+px+eqxutL5v8qoHoRj8XWtNTQ/MGKtF4TCy
         Jm7Bnra6WUKFSKzIh6KrH6obVoc8GvhZZ6JNjd+tBc+wJkqizhpmZ3KewmVluSo5t8kz
         wvLmXU/erLIcfs574Df5+l114fUZFn1XIytNb42HJPxnn9BVH3DO7Ct98cCJU+TgQUEL
         DQ4g==
X-Gm-Message-State: AFuF++mCfFGYB60QlSX1pd3u08gtjPNghHr0EZN/MOMCGMCGAbsDeA1n
	h3SXVqwiWH1Xvbf/jCCTdutSBUXQVTQ8RtC0FHo9Ei3CwpA2RvKM7EGA1/YQwQPGaz4GAhVEyu4
	/kE6nDgVaB+NvpD2IKCtDVM/SX3wgcF07Tix3dCw6gf8px/BfRtMfpcBRuF3Td2Y=
X-Gm-Gg: AYBFou1rV9NN1/8EkjSbxTKMemWVY6Sp6EQzaUJPW9J3QDzoHy/fC9iVtSGlr7JJKKs
	2tmjAFXDza39/Usr309UZQUlslzbf1RwbtSt18Qhlt48mmWGV0/4yHb0u+56n0x6/7IRCdj8ChQ
	vWtuBXK/K+weekiwy+tN1WzJ4vPIrKoTYe9VE0Tp2ykfiyCNeQxM1M0umK7/VtUYUPar89Ji23n
	1YTsDRjdA0jpgT8WFzKuQCLOn/vSwmAMxj1gU4ROrFr5312j5H/oaWatFzXsgiA9ZyD2H5cHkOM
	wkSBDMOhyCsbSNxayLflveOIxClcz7eaaKcZHgmXgz49p29DHU2PmMNJwqpwqmbtGM+eXgJatgs
	9jUzOgFcuIVZ/ZanDdJONpClZFTKm2zrknoQOPakBZ6UE5LTZ
X-Received: by 2002:a05:620a:3910:b0:939:e93d:a66a with SMTP id af79cd13be357-93bb78f7f4dmr61547585a.32.1789514439965;
        Tue, 15 Sep 2026 16:20:39 -0700 (PDT)
X-Received: by 2002:a05:620a:3910:b0:939:e93d:a66a with SMTP id af79cd13be357-93bb78f7f4dmr61541285a.32.1789514439451;
        Tue, 15 Sep 2026 16:20:39 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:13 -0400
Subject: [PATCH v3 09/11] mm: memcontrol: constify the swap accounting
 helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-9-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=2888;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=wZ7UnBf3QaZVjgfHJlCjkDQs5ZCx1m2hy7FBVH9jNJ8=;
 b=uQOuh4Y4lcarwBt0PjaPQLOIRjitIWOjUpkIOJTKiZT9gi8Z6zqXMWbVyhurz9h9MOSuF8ZZ/
 lJj8Mrj/5nOBz5sF8o9hxVOYzRvSrTFDO4XuzZtHYt0sUaQOOzg4iHb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=JeEpPkKV c=1 sm=1 tr=0 ts=6aa9d2c8 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=vlTQYXqq4tgfiFTJlkUA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: 4qsrCsJJF_fwkOmMkOG31-wroGcBE2wh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXzQs9AyhoiASt
 jVgg81fCbIOxxegoaIqycXlU/e/t71BmHnPex3MMSYRv2s5SRHsa4irgvpyhAe2gS1t6u8QuA5W
 kYPJy3U57cqBB86MyXNhC5m4S1TBLO+x42M/RaXcKHJuGlPx9IfmH5p0l5oY4t2X9Pw/l0xUbxN
 FeTCMcQpGofpeNOO3siB/GcIYDHbF3rh11TuL+kOtg/tG0KhbjSm5SAnHlqGgfPpH04eI/U+muj
 FE68kxFd1WpRMK1GQ56sMX1gFnZZQyy+BGMCMQCUF4H3oRPEIqsPPgwp0tqmacCJ7dulrk+J0Go
 5CWiAfpg6v/aTDuWWLSe2jejzK3KiaMyKJlDlttJNhSySXTaEIbAyOBTypib/EbLnDlTmxNMDxX
 iz+LtagOmoZb79V+/RzEoEeqU7hs97N3z3L6D5VEoVrO5EYefNWy7HBGqx0jIJPUJv1/RuUuq+j
 40mQbHeikEqP1EUFECQ==
X-Proofpoint-GUID: 4qsrCsJJF_fwkOmMkOG31-wroGcBE2wh
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX8a4HOxTLikaL
 vv6KelfR2T7Hj4r3PUj5sVdGf+IcSaMpaC52qDYLYELY6j03nnTTBW2zBx8hBITmI8lSo9zNd01
 Wo7uiE/rXPjVbJGhqoIDhNPHzQF8xYlQYZ5Mxm6/VAZLv7d9m+vW
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=10 adultscore=0
 impostorscore=10 malwarescore=0 bulkscore=10 suspectscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150341

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
index 43155e122b5c..18f833a448fb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -529,9 +529,9 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
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
@@ -543,17 +543,17 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
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
index b13f5ed74a5a..ebf325af7acc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6003,7 +6003,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_unlock();
 }
 
-long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
@@ -6019,7 +6019,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
  *
  * Return: Remaining chargeable pages in the folio's memcg hierarchy.
  */
-long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	long margin;
@@ -6036,7 +6036,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 	return margin;
 }
 
-bool mem_cgroup_swap_full(struct folio *folio)
+bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	bool ret = false;

-- 
2.39.5

