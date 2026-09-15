Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9BC46F4A0
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514437; cv=none; b=b1P694nnzyunHIyIvstcS28T5MGpbk/P+2M1oEjeWYmt2Bu1xgsmhQ8mloaAKSzgj53NlgwrIrWBCFD3Q++hk+OxhA6lJiDiw86qcr4ifNFbd4W37GfQt3uT9mje3/0tc0LgW3NXWbHA8n/tCy2UlrSD9c8VfC0AfN9JXQ+EfJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514437; c=relaxed/simple;
	bh=mGW09hkh76YIeApZZFaqV/ozCPHzHyH1NGa5yMwc4ME=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EGn3HY/LCSnRBnQh9wBIl1lKydBm+wiPkzmVUtkaX+wVDl02BIj788yBl6A9vdKyoeV614y1oEAWRTSf1YGfUc9vNRrdvY0wVUAo+Jj9XmyPrpEUswQ/Kz4jZ7JHPSEf48Y4aJg/zcSRJJ2PRNZPFtlOPQnKjAhKkyYwet1GtSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nnNJ5syd; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=QRUeRVIj; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nnNJ5syd";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="QRUeRVIj"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbbQk2489595
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=MiZA
	kQwQ5PL8bbCwdU4saftvpJtTaNFXLndAC9A1RYw=; b=nnNJ5sydtfrpp0aZfz+I
	epA46FThJFmAO9Acy9qFAMU12voDDysm/IF1iuYdmhTj/67CDILG3P8Leb4F1ftM
	FJQvEKmSvI1xBPW4omPtcIIkPe8myDvLtSHwQdbGroFMjBXZIsa0sfWu0cdQEZ9i
	kWti1Yqhx/D97Ym+awvzmeUFcg373CuvvWW3mOcs41/q1gEyE8xF8L6+BphH47+W
	KH1yfLdB+5tiXrazaO6LNb+AYMEfsMf164J8VskyvKyYFSVdMPT27iUCRuKN1zUj
	76zeOOgGFDvm3uk01zl99HKcS8SuxY9EtHDvr7bj04jaMGUadRls+ohCRV8enqN+
	DQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwdhsny-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:34 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90ce8ad8002so113946776d6.2
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514434; x=1790119234; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MiZAkQwQ5PL8bbCwdU4saftvpJtTaNFXLndAC9A1RYw=;
        b=QRUeRVIjJWnOdVA5iY2NzQ7oJL5qKekiXYhnoSFvTenjP+BwpTbGEHLX9iLLOEHtfF
         gQJ2g58l9Pw7NMjeNQsHxse77eAoB/gKobYjoPWFdolVej2R352aSAjPyOWlYVEs3gsV
         Ami9Jz218IB2VgTcsLXzR6G+WCOOpg11d+y/nSPhggX9SGQyO9NmfL62Lvqzct8NNWHO
         53XMeVNiQQl0uwU/OAbRCe+ev8Z5gcC8gkPUZmOvgAr7yekBamzbqDRSIT1eeeIPjLtm
         j5ERf7mWb4fpYAgId6UICUtgePYisiB0KHKwmOcnH2iVTGmECz+xTgfRsF3kcmMoIJlF
         lWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514434; x=1790119234;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MiZAkQwQ5PL8bbCwdU4saftvpJtTaNFXLndAC9A1RYw=;
        b=WjQJPNQejOpPGzJedES8BlPpqV4OSjFzymd/zWIv/SKzjPwMQhXOQ0wRpE5Z3Y/pzG
         fEhfOqsRPyCoPEAGiS1Jx+tStcDXp9pp9IanN0YnZhu48IYeO/UmjOcuAlQs9x95ouw1
         3bjtpQb0/Bnyfd8neri+orFpCED7frWeqy4snHFZJCY8RTLaFAxcleLc93WSdX9VJBLq
         njIDWxr3UV8ZjGTukA8Kr/uM3+db2kKiKaHoh0qO48U1hpsbOAUm9ONeLaY8OWrhdPvD
         7a8rSaCtxWN75NfVO0y1YcCZm9lxgQPMQwHrUC+a8XYIY3dqUmyICP6G/l5IATCPTIyT
         TpQw==
X-Gm-Message-State: AFuF++l4+OqlBKLKVRcoz0g1Yv6hlL+bei2DG6m66kgzGGQ9D2dOkkJO
	JBA108mpcnsaYqqL0Gg9ChZdr5a1HvxLobZ4JwwyUesXlQLFth8eEu8k/AAoOySq9R5hHnASDkI
	xfjGo7ItX6P8+safP6vSmu4GDucTum9o68RCOXySe+mxaoBCXYFR20wu55jwUZvQ=
X-Gm-Gg: AYBFou1Yq7ozPH6JBUsJhmGWkWCoocVc0UmQIWvyGtmO05adMxo+9FSEXbXt2k1+evQ
	HVkYLqHcpbCZmia5d12fGWuk0axwek8t428pRiF7LZUt3LuLNvMCLRhUBUuYM+ojrV5AAvppnzS
	gnEORh6qrNlUKNy/2ghI11+3bpsASnaMpogHTfmmTIPL4iYDOsnnne4uYyYh3wHjGupOAbUPq2f
	Zl7Cdc/LIbi572joRz2cDnReXnD2d31tff1n0uX9dV13yp+azgHWkUVbicE4CbBzX7PeE5MAJu3
	OoVeN5caKwkkrMILhCzeb12pFp6GgyE36EqWMbkf9vYztN+nL30jwIaCNDAiajuF0DZNwFMAm0r
	YJhJhbbiBGIJaz7kSk0Qqo1n0yExTAmmetHjbX77RkCUXM0xJ
X-Received: by 2002:a05:620a:4621:b0:939:deae:8ca1 with SMTP id af79cd13be357-93bb793775cmr60423685a.44.1789514433883;
        Tue, 15 Sep 2026 16:20:33 -0700 (PDT)
X-Received: by 2002:a05:620a:4621:b0:939:deae:8ca1 with SMTP id af79cd13be357-93bb793775cmr60418785a.44.1789514433398;
        Tue, 15 Sep 2026 16:20:33 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:32 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:10 -0400
Subject: [PATCH v3 06/11] mm: page_counter: constify page_counter_read()
 and page_counter_margin()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-6-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=1723;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=mGW09hkh76YIeApZZFaqV/ozCPHzHyH1NGa5yMwc4ME=;
 b=DUenCOQT0K+st93DFFRNvmdZs/ls99b6FAGmw2v32/XZVcMUKm4spMJRgdm/dKJIfaSSVJUeh
 BHHac3BvuFaBQ1rihynZ7hxLlVPIobPduaPZYAkwQMwfspXkpDvMt4z
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXzGgBtSv6OLDc
 ccU3NRJny+dfNkysmd9k671wLq7grzG381S7q04aUPkcDALCQsUZCX0selRyRdMCTndMkXgkubz
 4Q2yJSICsjWckuBdTzEsA+jrJi1Com4AkNzjSj/StE3SJRdHnJ5ThM/mOdihFjhQqu9FtnghcvI
 +cqlOfoOB1JxsG2679VdIWiP3fDfOw+NqV6GJp+4gk8JpIWtvAoJaWM6v7lUOTlgmxgcVi/0DAl
 i1+o49820DTmA5XXTbXeMRJ8ozbV/JjFjHR18TZvVPnMhKTjMn2wtgRA94ewVgXcmB3vF8MIa2+
 /rcjJwFMiyT5c3RgNC3/ekkko8YWAiQEZs8nd0mDlqzQrMQRy/4rUNN9ZxpKv/0GEBo6TKXX3EO
 A6QxKQwCjg0wIdlIYIteAEcC7bD0+bw9QXDRuLJBPrO1SJm0ly6RhKtUzWDqqmt/8yi0RpHoAtc
 ggbpcDsIa13iaGA1K9Q==
X-Proofpoint-GUID: 9MscaRDpy7otSslVdj4uyjbItCKKZkre
X-Proofpoint-ORIG-GUID: 9MscaRDpy7otSslVdj4uyjbItCKKZkre
X-Authority-Analysis: v=2.4 cv=a72lZkSF c=1 sm=1 tr=0 ts=6aa9d2c2 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=qClW_BUTj_2nsftnHKoA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX5Mxyhy/Vf8iy
 fSfI+xsnuG/V1V5RnSamB6mwUU8ALyLZgmYSYXmiOMoM5vCG4iLPPZn//5QUmDo8P4MuLo1mfkm
 ZpQpSHoS3KKlPdDXLVhGnpXVj+8xT7F96VFinyKEutgLgOmeNnr2
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 spamscore=0 phishscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=10 malwarescore=0 adultscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150341

Both only read the counter. Constify them so that users can read
counters from const memcgs.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/page_counter.h | 4 ++--
 mm/page_counter.c            | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 07b7cb12249c..2baf7a2b29b2 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -63,12 +63,12 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->track_failcnt = false;
 }
 
-static inline unsigned long page_counter_read(struct page_counter *counter)
+static inline unsigned long page_counter_read(const struct page_counter *counter)
 {
 	return atomic_long_read(&counter->usage);
 }
 
-long page_counter_margin(struct page_counter *counter);
+long page_counter_margin(const struct page_counter *counter);
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 98322803941a..9167ffd1380c 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -54,7 +54,7 @@ static void propagate_protected_usage(struct page_counter *c,
  * Return: The minimum value of max minus usage across @counter and all of
  * its ancestors. The value may be negative during a concurrent charge.
  */
-long page_counter_margin(struct page_counter *counter)
+long page_counter_margin(const struct page_counter *counter)
 {
 	long margin = PAGE_COUNTER_MAX;
 

-- 
2.39.5

