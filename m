Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCE9391845
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377318; cv=none; b=ocVn1qkhSBwSjqsBwDGzCC7HM101Bmmor/WcWnZC0es9FrvL62iUAahilQ0zQiJRkup5i0V2tKAL37MUkmwDmMVNd9B6nFGzptcjQ/6War/4/aFaSAjq2ylrbQqx2M90a2dpxH7cPOXuPSIc7wyq4v+puX0JvjRJGOo/feuMzm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377318; c=relaxed/simple;
	bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FMr2yaCX4laywpxoGOL5KxPJV26MP3QXzyq04OWeg6Cdo7PdWHrEupiG5n1ZBOvNeuTkPw49d4ot2mzE70F4CwZUJdsycbYExAljlekD04GhNiJkQB7e47ew/au+f8mcwyOPqDAlaxSyQyxqO1aGeGKtidatSjKSnn6OlxeTckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=cyp4TDkJ; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=JDPyE/Ge; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="cyp4TDkJ";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="JDPyE/Ge"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IYkH0538657
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=W+SY
	Tc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=; b=cyp4TDkJ/oQOm+m66PZI
	il+NOHHVuNNz2gQNwdXPGNEWWpTrOs1GBJhDaoSJv8d72xfPywp+rtCgZ57E69YW
	gboVG3IA8fyYSTjVKaA3c/AWVKakwWikrxM3emur4TII9I5G4yDWyieQNZUWBtkx
	dtkvRHE5BvLIf22UUryNiYdFZWjfUm860IfIf3COFuAkZJfU3Rw1B6j9jS1s6w5p
	Kr639PsuoUn5LjYTk00BKLQIY1PDzVoMZ5RELLqMAryoDlj6dLBH+v3rFriRTY/L
	XF7B/9GHbhjZNds+5S2FCxe0COjjolet0Xc6UzeL0getQ8U+v1IYvq+MafORGNrY
	Ng==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gefkbmu22-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:24 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90ce9ff466fso30529536d6.3
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377304; x=1788982104; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=JDPyE/GeURL17RW7BChJAs+NBt5TA47FyTnaxqMilk9t1cBswGb0YS2OaLkqHrcAMW
         eD67T130j2KmO7dpbupl2rWNOm/IWwx8phmePJ8GrvvsNqCL+n/r4KYwuhGyVt0FP0Xu
         Lu8AX1lTEBMpDcrTVVF5Pyk7c+ul0+iLddGoGVQBqugn4fgVTO5rg7ULxZKNhdOgZ5B3
         wLK2CoeWNsPNinkUMBCPpaMzLpBo7auNXz70J9eMHmzAiCEvGUH45XSJkzfz/E9X3YgI
         rFzf8i13HF/iEccSeMdAqspvcZhjs1k5GibCE2+hBqIbBAZCGbjTChigry7HdVWC4Arj
         ZBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377304; x=1788982104;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=tCzrd6cdyw7Usape6bD1KdDU5y7OVv7jViQHbUKoCGCFr5sRv2cazryoW+pvetHd5V
         0cQY4QsNgW60AZgyELH5wTUpC3L5A9sH5agZ9rqQbb007nA9Mesvkl0i4mFTRP5L9FU0
         H1II4v5DK/EWdhREHevBaGy0VJhfG8rWhQ5dOrYujjYhtoPB/IsgUfhIXY2qDL6W5iDd
         niIJqEBWKnhQSjOmdzYq1C2ZpTTTOPvbrmpbuhNw9AdNaITc2YgxAje+1KjwzpROUrl9
         TaGtFxfou+zGohXm4QFYSi0hrJ33wIYNlNc3vJYNjw2nmx6h6ZORb1bjInfxU3akRprN
         IWyw==
X-Gm-Message-State: AFuF++nLSQI/KDhn9bQ9KiJU8Slj5/9Tk165d3Yus6KVA7ywAwm955nS
	69OFcu/qCZOSyBIICDorBksGYypTiAKVYI1jn+LNJBNr7BlDW8l5dejvNx1c4q5cAPkiOqmg/hq
	8wT1zRPW4wH2DQQyjMmW4mu8HphcY1SDq7iwPsWp23WvO2Xv/OPRkt68=
X-Gm-Gg: AYBFou1XZEir+gxW1lGvpbSpOxYecJCwmm9HPdKrIP8yYfRNh10leZdwcSlH3hr0klp
	F1tjH4Gsnx+oOxzXoRpUcJG+04u6cyktetr2YhwyWipHVs3QagDcq3XE3EUuJuJ4a29lZ7vPrfE
	OvWlDjiLIXO+VxzveVcvy+KjPTwahtoHRW4W8glVonHGtIxLBGcEHQy7/IDOcwic83N2qIB5Q8y
	MiWSUxaaB4FCPRBDQsaKm4bfC4oZ78xJlw+M40qVsT/8rPQDQb7BSwpUOYN+8tVeDFATt46t6A8
	sCjYL0vpF2Xc8k4BnZFWNSt3GtqOUXC7cVeSWdbGcCsUOXJ23MXSnWcgNnkkkGCZXBOpXp+j21t
	/fkhuKQwPFnWP6Hi+gVBQhDdo1ByKTRJAMycrDT5IWEDgM699MmsvYw==
X-Received: by 2002:a05:6214:5098:b0:910:345b:4c5e with SMTP id 6a1803df08f44-9103475047emr16906856d6.37.1788377303494;
        Wed, 02 Sep 2026 12:28:23 -0700 (PDT)
X-Received: by 2002:a05:6214:5098:b0:910:345b:4c5e with SMTP id 6a1803df08f44-9103475047emr16906256d6.37.1788377302941;
        Wed, 02 Sep 2026 12:28:22 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:22 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:50 -0400
Subject: [PATCH 04/11] mm/page_io: take a const folio in
 bio_associate_blkg_from_folio()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-4-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=1933;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
 b=A79pQGpgugQaXZD+f5+rppwy1Fv88nCcpGb/S1P2ZfVpepR1h1m5T9Di6kxQiDuaJ1FmnPSw3
 +1svIpVjpKoBJsZ2VcU6UrLXchG5TP4f1m+DgNt8wfr2isRQsjzGTdP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: xbBz2gx7u7Fq2UY6On2nqiVjLR0brSt5
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX/TjXDkswnlrs
 L6Ld/cAz5HT7IOpI7izBTtxs7jKsqXpPrGTBYbPYS4M0dHEo2C4nF2NgviilCND9Qj/XgIBOEZA
 T9fumQEaGUaVYJlGYqMp3cZ8XLW7Ldsg3CZ+7X62sz+1yIQ3B76n
X-Authority-Analysis: v=2.4 cv=aIzAb79m c=1 sm=1 tr=0 ts=6a9878d8 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=4JVmFDg4bpWGYAirTr4A:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX+JYpJ6nJHv1J
 MTcWAA5f1RmF7B9WJHk9kiMQkYFDe/lzy303d89a0vChj58JU/0m8dJOxT3DoWgkKCG4ZRgYeZJ
 3C48TqE4H0VmFBZpX6cgUcrJWT6ynZA800AEM2pSXZzBh+8Yuq9WTEFqq0u9Sbu05p1my79y6uR
 Qs/N5umER8s0plPhH/T/anj3+AusAK0gzjirIMJBSXxphfD1GgUyTR88NNPYWGLK9wqFRqc4QVj
 8Tla5di0H43XBuzm0ZvW+AlZ4Rb79GIt+Zr7jbTDrna9+D6pVoDo1WwocglkNESlm/SamOtgO/E
 qncvwED+yAlS84judgKVxy8wbkuaB7/swzFhbLcnV37L/J9H1rcfJHsGxsnU2haBJQE+PZ1T2Dr
 tZOV1UCk6PUmSnWD4/U7bUQQ8cJ51b4CTtFb82r2xDkRedrp2JWHceWlK36tWH+qyzbhcH2DfSZ
 VkYaznZNLDuZ/uix+fw==
X-Proofpoint-ORIG-GUID: xbBz2gx7u7Fq2UY6On2nqiVjLR0brSt5
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 adultscore=0 malwarescore=0
 bulkscore=10 clxscore=1015 impostorscore=10 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020172

bio_associate_blkg_from_folio() and its helpers only read from the
folio. Constify their folio arguments.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..5f7756e370f7 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -256,12 +256,13 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
+static struct cgroup_subsys_state *folio_memcg_blkg_css(const struct folio *folio)
 {
 	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
 }
 
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	bool can_merge = true;
 
@@ -277,7 +278,8 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -294,11 +296,13 @@ static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
 		css_put(css);
 }
 #else
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	return true;
 }
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 }
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */

-- 
2.39.5

