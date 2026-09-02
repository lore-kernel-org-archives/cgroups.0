Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC9038B150
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377327; cv=none; b=KSoesV0GB2jPGKLerj9995x7+y4J9/9RCwNs+BISpsFJrfARR3S36IKi5wfCDlG9hUDDa2LnqWKx0NEitiNeHgqMgNpV68qJjeTlNrz/2LvXQAJoT8DQfyockxtaCfJNftaCIyXA7hHsnw2DcfOTaKfKtayEtiOoiw92jYh77Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377327; c=relaxed/simple;
	bh=TSz32dlKErH2sHKGkXoZorQQsSCc5csvXiTKsSs8af8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T76wU3JTQF7mGjV6I+xebQVqxD7+0bGQpNuDWp3udG9Fxk/ZVRw+C+SBHbV5e+lLXcF77x4VYac9qbifiPkaYSx1qPfYzaSv/gusx4xN+5GnA9HFex23yCU6xJ1MKYYhSnLyBlhAeeYTnh27pxBNJ61FPUcg7Ja4WGhWQWtDgE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=K//DCJp7; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=YWhef4Cg; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="K//DCJp7";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="YWhef4Cg"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IYrjv881982
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=RRD0
	l8Ri/Xtt5YOzEf8unqF1fg/jROr3HiauectlFwY=; b=K//DCJp7WgpW3EhluvHb
	mxXUG9Fb3PRtnkEWPz60NFmBC0MAx91TgdqCGDany6pjl/eemgTV9tqsZCdZ09b8
	Pnfo2Z7acPGF+Kf2yjLzi5rlDdcRED25bblFwXz4C5GTQCpVDDu4YmsxUGebXn3x
	yT3z+zt+7t/lDyD5M5Yz/Y9OdXJc+07bkCWLG2OaYNInncTeXLPlIz+62PQASuvV
	hP8DulwrXxGCDEak4wZKQ7QOH8IaVzDSYslbmyB7qCJ3JN5/w3PweLz5mlLgFiCR
	tREMaIy0dW12A5PGs+cht8YW9hS9xBFMhD+wChNjsfk0kiF5+zuwX2a8A4jiivu8
	GA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gec25nmnd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:30 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-53033887f50so34919191cf.2
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377310; x=1788982110; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRD0l8Ri/Xtt5YOzEf8unqF1fg/jROr3HiauectlFwY=;
        b=YWhef4CgFMbMkeiRKbkrOQqNicNgWmNXpprCNK4PmZlS1To3dQiUywJnb0iWdTq9Ue
         pfNqQqz2DLlKpBqWn34iggASauLmP0U7b8Jf7Iwki7pfYgDSWXz/ywCrh48AzZU/EJPT
         IM+CNqjofKU5bc4h+lX2Y7Cisaq02ketXRweu6eJFo5Qj05QZlantkYyv4ooiU9AevN4
         /7xPQY8WDUuP/pV6cdkOeVTzDCblXUGGSqplK4GfW22LGIwVvf9kgJoyobWmGC23x2qF
         7tUQwUw2y10hTbrhIJa65HZbg4Je0CN0Pmz4er+2dAJ8TjtoC3KVc3GIBQteWC+nkgVI
         e4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377310; x=1788982110;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RRD0l8Ri/Xtt5YOzEf8unqF1fg/jROr3HiauectlFwY=;
        b=M8v84hRCE/Ny0fnR32ddrsqA+J9Vb5TeN3F4vOjGll2TYWBFKRIq4aTtEDcy3VBlhv
         qQVEKmEAYGinYt81e+dGg5j4JHIPfMg43RZ5EeTI+e1xM+I4B24g4KjvM46Y4R0kEMLI
         mpORNZWc0iy4a91ZMeGv12StrEk17rYdiOi/KCPJYdEsmBFVk3kcXTAtmkBTprXyXF1C
         1g+3I7T0hWGW6UU6y8O9pgqCS2/Ogs/EzMzL0KRN0Ho0t8NQaB20Hmm5yqsLHWEW+cmw
         ZHfaIgfgwjko7QTld/SslB0VwIxt2fHTPuJJsTYw2Q/pctf/CCzgsVfDgWnvCeHG4MmE
         UprA==
X-Gm-Message-State: AFuF++kJgFjdwI+eIhU1JRKinByefI/8kkeMUpBirNBOfNes8oo+I04/
	YSkLSoxCNSfY3TPOnesUvKFSNu068LFesI2eVpEdnQKOzIzkvNeW73IOu62PMIjqhPdes+I+/ZM
	I10R3V9C25MsqTw4IiqsRA1V+/5pYhZi++63+C0UbP2ovzo2K/hVodos=
X-Gm-Gg: AYBFou0HxdbQ1HZWzC3c/Hds6aqZb0muVswjqc/fZoGhyXaRGNaUYEJ8HnIbA5wCnK3
	1eQIIidbsFpFPzjMCtpQX4MdWpJ7ebLwBjcWOlgrj2KLEFq0h7wkEdoqhkNsKOJLgFj4KALSKZi
	ux/lRW/Rw7qTNb9ALddiu+yofVg8HxbIcmQYO/oKHDEtR0sl+omAo0eisXgE4NWSnD4J/sTB6NC
	FU+TfrsrVkqP5x34+4xVsAp6tkOat/1ZIxO97tAP2ZXuuq635nBHU6KvwZsKZx9V/5SZ/HPIw44
	L2A9Xo7QyCZcoqNf5pXj8F2LdOuwMBU0CKNHpstog8u5d3wwQWgazZmABw7MessgM4FMKkG6w7v
	fO+nCQWBTJ0hre/1wT1bRkCdiAWtlRfD67wkKilJB1WveJTu7hGt+Iw==
X-Received: by 2002:a05:622a:a08:b0:52d:8679:ba91 with SMTP id d75a77b69052e-53036b915a4mr87035541cf.8.1788377310028;
        Wed, 02 Sep 2026 12:28:30 -0700 (PDT)
X-Received: by 2002:a05:622a:a08:b0:52d:8679:ba91 with SMTP id d75a77b69052e-53036b915a4mr87034531cf.8.1788377309441;
        Wed, 02 Sep 2026 12:28:29 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:29 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:55 -0400
Subject: [PATCH 09/11] mm: memcontrol: constify the swap accounting helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-9-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=2888;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=TSz32dlKErH2sHKGkXoZorQQsSCc5csvXiTKsSs8af8=;
 b=Ofsue+qcEl7OkCtIeQUm5s0CmrvlITgSUOJlrBEvUC9pTU1FWzglzUQkk9b6peUbGaadFs/oC
 dhZIsw1VOyXD4Lhobqfa8HoXX2OiRc6aLAq9gXxycrY3BVJApmYidjS
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX/s+c0ZrZNJH7
 FQKf8fSBVyj2qefIgq3c6cG3Ig4oybAfEl4+wQLzU/CUghMiI0C6hdx1dqLwg7CqiaMDpaQE2vZ
 fH9NHdZvN3+C4HUvuXdfesbAjYb/PBBHjMn7SIK5c6wrYXcVrgNH
X-Proofpoint-GUID: AMUX8WxS9EpZp3fyo3mwwTT0u04wMF7k
X-Proofpoint-ORIG-GUID: AMUX8WxS9EpZp3fyo3mwwTT0u04wMF7k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXwYFOg8O7NRNJ
 DsaIUjZql8+JzId+KVOQ5Ng7ahlxPSWb+q7tpJ6xP4OPPrcHenjSGlVdEEckFJc66d+yzQD4hM1
 SGUlFFkW1+bb82aULIT/hvfSD5zxcN9Fhj9Pbm6UQY1QqmMITPUAKMjO3Mr/NxFUJkAjD6xubSx
 bCx0cPlw98Ktot7M2bUuncklBili0XmrrsNk08SyQPk6xK59UkUnPs3NZNt5SlMvZ739RR8kARu
 3bYzRcui4cEZOdLke+hvo52ZA6KJYNUFiUDspeJcaugxWkgk2JKmOwfkzErCYkWDnmurdZ63v9X
 Sm1vCuDREWeIcbVPktdFPPHONnjQjqV6ePBNwm15uWIWUEMxTNI2hX/6KzhXfGPC2d5HJAuvHXj
 XfEU7E+wGWCcTErH1vnYL+NcNKgobHiFsqxxolBzz6/JumczhPTtZapT/qBOzm18+yfF3Dbkkww
 +ei5CdTz9Qjq3WzQBvQ==
X-Authority-Analysis: v=2.4 cv=BpWtB4X5 c=1 sm=1 tr=0 ts=6a9878de cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=vlTQYXqq4tgfiFTJlkUA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=0 impostorscore=10
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=10 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172

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
index a72ecf12c00d..a64b5d37bf36 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -510,9 +510,9 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_p
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
@@ -524,17 +524,17 @@ static inline void mem_cgroup_uncharge_swap(unsigned short id,
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
index 3d3eadddc130..2b8705a88f6a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5839,7 +5839,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	rcu_read_unlock();
 }
 
-long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+long mem_cgroup_get_nr_swap_pages(const struct mem_cgroup *memcg)
 {
 	long nr_swap_pages = get_nr_swap_pages();
 
@@ -5855,7 +5855,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
  *
  * Return: Remaining chargeable pages in the folio's memcg hierarchy.
  */
-long mem_cgroup_get_folio_swap_margin(struct folio *folio)
+long mem_cgroup_get_folio_swap_margin(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	long margin;
@@ -5872,7 +5872,7 @@ long mem_cgroup_get_folio_swap_margin(struct folio *folio)
 	return margin;
 }
 
-bool mem_cgroup_swap_full(struct folio *folio)
+bool mem_cgroup_swap_full(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 	bool ret = false;

-- 
2.39.5

