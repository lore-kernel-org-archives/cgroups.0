Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601084A2A5E
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 23:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789514441; cv=none; b=ZJzYHVzorwoEJMZ20x2jMzX73fFu3FYiEiEhFc7YUdwnau/prqbHeDEy9DeKFWbOX8WONZmpXNPo1PhjnQW4sKiaWwkYR8zYeMaIUW9P6UIPTW+L7M2Lq2N3XS/g82FrbrZJbhW8zAZylLc8NR8ZKuasjksKXaHZSa/hZ5CQzOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789514441; c=relaxed/simple;
	bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rfT+09Jxc7+oa/ojQ9XBMpcXUhbG0uMoSscXCPb4T3RFsuX0QVd4FQ+DX2wusVDzsZo6053Lc93g9KKLcjo6iUstQjEU0bujvwlze8UAiwB/3njH3wqghC6g16DS4hN/qvh/yFYgvj7FmOs9vQ5KbqGH8/PNV9JYnlpb20A9LcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=WbCDuyao; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=dgKgnxVh; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="WbCDuyao";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="dgKgnxVh"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbjx62489702
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=W+SY
	Tc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=; b=WbCDuyaob2YbGQCiOozV
	yIe9RC4/zmMA0eLFXwM7A73YQNwsOwZmCv8DBOlacrAHw2eYuzW+Ia8uFSxjLlpx
	iXtbUFdPD03BZEqAJh2oES9GzKodFOni9hMXu+dhWUkpEahBYODAw8XpEL8hil6w
	JMErRevg7CLUpghoITPIUnJN2Fb8toEGDGAOzchUxuY73PxZK0hf24WEE+Ne991c
	cPmiQdPC40zNLagsBqSmndt7DVO6fl0oOUMqhN16VdF0E0taTzXeUc7+mBizPKY5
	WKumJ8gBkpFfNZIRzIz+cEP9mLpYCpHfbKctlMN4YSF7hUJ9rAIbpV8Vkr76HIrK
	ew==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbwdhsnc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 19:20:32 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93918756165so967767185a.0
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 16:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514431; x=1790119231; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=dgKgnxVhuIYMG8G63SuNkfLW9L33RPE4gDyR0bph4Km3PtGx1Q4vZ3MMhZxGuqDDt6
         ml8xc9d7ILiNUbxhobG5Beu2jpMBmN1GNknAKp6fr34xbjmCsYip+yH1+lxo2ZbSePzF
         fdVlOsUMC4rXkvtHJNUwO5tFx2lw2c6f0WK2ykemhSLgXStWH2rBzEyAgJSSDESrZ+wG
         Iu6eNqrOFw2xWJfCGTrCTNQMKIdEQ2H9JHBV94ZDGAqolvPZtZVStjfaX/n/7jYMgSDL
         cX4NKJxtc0nv025myem2KyqVMFzm/60JEnqthkSsPqGUfbENAxGFRbUUTk7DhQSQahFp
         Kjiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514431; x=1790119231;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=BvmT9pFeKZFlVcYoVhg2ZBdLzkxUTxUfQsfYSYHLasqvcUFSZwXubw/Fpg4N0IhAQ6
         xrRSqHdaQRGDD6WTXyUcsVue3GSGL3VHN1desPDiAzJN62+/eP3L+BhhXeasGBlOCvyy
         g1ZU7uYuFfM7Up75zhuKsfzAkmW/FvhlJLXQjohDL+qSBGNMNrfXa2rSDpWynZDh0jXv
         2njNquryShB8WyokeKG25fpJ4Acm0woPm7W58v9uiP7oKAO2Cnd2JGjCDCjlUzBk1Wi0
         9wZrCfd/H5g+soqE6/PpB8oai+cknDh3xtddU8jwHiUPDN9mu1YNTo31LZYj8cKGIY07
         E4VQ==
X-Gm-Message-State: AFuF++mfghFc0+Np13EjPMGYkT1MruxneGQZETwTuRy52n3pi1mkaad+
	oLtPfhskPWPKu54Hmh2u6VwHQDsOjWxjoYC7ld47+BkieWhMkZS+6fg1noQDw07Jy1P8Jto3KZe
	HBhh+G1DFBSTj/RgduO9qUefiFdSkYPaRYn+ZlNBR9JKBIn3UZi6yrCOdwC/D5No=
X-Gm-Gg: AYBFou0kcEPB77oxiBNHCPKtNs//Kpki+nE8Pl6+28Hz8imSsMTUY+oEV0ywmAsDSiD
	Rd8rO/teS9WkglcXCfJsk2+q//pjc8yO58DMha6WFuM2eE2H6SL9Jqkf+RMu8dkTUNvW0/gs4EK
	PAl6sHm25AB2s4Uy9H+6MujWomDNkJzBR9J9K98vl+5JLZDj60s6nbBhGZctwDfcx1gbsCSokaj
	mJU8l1xtbaa2pPaZ4JRl0KIA76UGGXEsDRhnp9Px3sD8B+J7w4hl8Uj1W09OCRDfDR/jJwjsJrH
	wscWURrOtsOHU7W4OECUHP6seF/8d03aR9HW8c1H4TdhIzO6xt/nv0m3sIeeL9DLY6ZHw4vwA9I
	N82ya3+rhyQNNrpPGCXhBVJ7NzGECvUIvs7bUkyoULdYZR5iw
X-Received: by 2002:a05:620a:390b:b0:939:9eb4:888a with SMTP id af79cd13be357-93bb76a62dbmr56955685a.1.1789514431094;
        Tue, 15 Sep 2026 16:20:31 -0700 (PDT)
X-Received: by 2002:a05:620a:390b:b0:939:9eb4:888a with SMTP id af79cd13be357-93bb76a62dbmr56951585a.1.1789514430668;
        Tue, 15 Sep 2026 16:20:30 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:30 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:08 -0400
Subject: [PATCH v3 04/11] mm/page_io: take a const folio in
 bio_associate_blkg_from_folio()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-4-c239a6010b58@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=1933;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
 b=ErI8Po+B2rZxjluBv2tCvc/GAMAH6HlqV7iBCu1F52BrrDIeskYGbPgmeP+1GO+PyjKeg9FBh
 iNkFxzPrOAJCLaYd58UfeF2w1r5vQcFDYNXXhpcTcYTxktylhrjEiR8
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX/qJyuZdaKHeR
 CQnFuiK0eO9ayObwecVqUSKwaVa3P0h6DH+fuhNedCRPqFBQURWjLkIWnpRwbLNiTVyko6zJzyA
 n7zczKyQdOH0pteOOWozw5IhJGfaVIVCHjEjKorMwDaiCZgjHoqYMjsWnBGgqK5DN9pR9rVEdEq
 Qyo+w+VCVNJy6oxPzHIMHSn+IFtU1TL5E8y6aaf/KVHuNWPxHY+jGphEZJukYCQOPIlkbXedW1x
 f8YmwlsXLAcq7qAMyVryHwqHLsupvTMwt2agaCaFfsuZL9C3Pu2GhvFf+1WoyIMsgfP+HEtNT/+
 ORhiVXqLLWAmzpmV5t/Ccn8itMh7p6wjex2EKE8rUeP0ZLPYiHOH5ueu+5MJr7OdnBg65Z9EsFo
 jIjyrVIBksZe91bOy8QHQkUdI4M2XY7IZpLlG4VbiyLZZ0NNicIm23vyURmrnhQU/pp8IsdgE+J
 cPJOpe1sd3vJVNCB+0w==
X-Proofpoint-GUID: 0fhJ8W62UM8LE98j_C7KC9r-hQvQaXc0
X-Proofpoint-ORIG-GUID: 0fhJ8W62UM8LE98j_C7KC9r-hQvQaXc0
X-Authority-Analysis: v=2.4 cv=a72lZkSF c=1 sm=1 tr=0 ts=6aa9d2c0 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=4JVmFDg4bpWGYAirTr4A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfXwlUU8uorkV+c
 9YNbcQec6VCPZEq6dx4q3DPIyhhUSmhfc4eS3hXsoxwt+f0YDEfvYtyqbwjUfeqzHSnTiIqgEXZ
 Q513UFAGluuUEttm3BCrKFCZgyh0i9PY+yuuCVC5FJQIecKx5IDM
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=10 spamscore=0 phishscore=0 suspectscore=0
 clxscore=1015 lowpriorityscore=10 malwarescore=0 adultscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150341

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

