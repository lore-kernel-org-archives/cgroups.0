Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD78958F086
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883077; cv=none; b=fI6d1fWiZ29DReooiEZ2SlU49WdPdwpj0l0obAu7+ztCu6qtW3B15Su+fKwMEs53sPkG6SxysjdBq4kQNEf2vFCsSsNONnkLOfGm1ibPbHLM3tsxhrpHkqWh9jfj4viAqrviRF1KD4bV3+4PZL4PIZKfTABd11k0S1oX7RYxIyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883077; c=relaxed/simple;
	bh=ilFeF7WzmkT3DE3smE1F3wtCBJfDaUSUcaDgXIyabqI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JXe4ck+hbjVOpgSJmK9S54vehuw58ab3TDzW/WeUrmCLKyH1rJqYsg401FyWuznnQdtClHsr5ZbqoPK2vj2NIJWgAKDAAULeoQfncPhKhOnnooVVCF7/hn4IDv1Cl1zPMEftmS/Mvm1apBgYmQ1Rv3AUWRoEoetM+QSYoNs8tWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=HWoN4fX9; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=M9428slS; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="HWoN4fX9";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="M9428slS"
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbE9q1064813
	for <cgroups@vger.kernel.org>; Tue, 8 Sep 2026 11:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Q9N4
	IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=; b=HWoN4fX9O6PM4r7xxWZK
	B1LWKD4v1Hu5nou4SvaRMrpd6IZO7jqvWe2U+PVvmOrjbwS8ABb7hSkfsI7BhS0Y
	TuDA8AuxsSOfwWwQnYZCfipiIlEWKUEgpdMZzlWt+afPmD1nrMhVXJeqLiLrnNvL
	AbjOkKB9GLdmzqkpDBdNxUStkiMDje8SrS2i+2tLY9hnBi+7/qoAZIXUrHZMm1dV
	QUg3dxoRkTDKlgR1CHPtvh6jmHrZpXiQwXQzyvsnFi287sQAxd07X+9JSMSidai4
	8EcJTN56/hm9KzhA2xpbr/Aq7l5qlYd/Lre+ncP9+Gof0Ky0r2792JnjgxsBG37K
	TA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmwm8bqn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 11:57:53 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fc16ac179so86887231cf.0
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883072; x=1789487872; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
        b=M9428slSRHu2Es7IXWTw3BCT/3KAsKlC5clk2+1zXHoECP2LldwzLjHu3Pbavj/R59
         xeQyZFATgqbumrHcZP+eBy4RQRCmovHz8fpqh38tR0LPR5NkhmhgEb2p3QUVLmCZpQoI
         TLLyk1m1nztmwgf0Bq1G+gyFmZQHAzXARP0QGzoZQzC+ofvyZtTenDVg+ncowIP4t6An
         dMABkTWQ8h5DOsL04rrmUC0aEWDgNNMye8ayJ7dnJVI7DcxWRmKgB0z5NrzRq0Y6fUcg
         jm501wFFuCPrf4kMyWQGGjfzJZhD1kOnkZupgq7G0S/QSuxHZn1vh5XIWIeWjs9tFFSZ
         MVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883072; x=1789487872;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
        b=mm5Tc5HaNrIesDWt9xNg1YuA5dv4ivIjpJ/wBryi0SACIT6vNzLb7tElYK+F1Vi8c/
         JoMZl4qKrKXJJ+pkxsNKfX9RpuZMtUJxISF9Av9Kd7T+FE/tCgwAEkCLoVDyVFcjsq9B
         mcLpW5LXpc+wVX8JxifYLCDmWFRaulrMOb8nI6dgHQoFELQGVDegWQldo3WrQHUkQuhi
         C3t8WUeEA0niqYe9I9Gyes1TxezYRf6Z15xWHOOc2bz0ewcfncuEsyyrIgCipjifOQ9b
         ELYvTHPQ1eydn6qRU/HKAA/O5Q32u7xTlo9ZWHHPRw+fhj9p2g9KZRbDzIFTGGronYY+
         oksg==
X-Gm-Message-State: AFuF++nIlHHdjYQqJbyjhIv6G0Gkd7yt0lVdGZpzipUJ8BKgzRKTHMgA
	Y2GQGvVYpwsmRcciAUYmRxBxRQhzJAUfHy4Kz7kM9PNNLat3v2VOQV053z+Pm1Q9SZKDZJrGLNS
	kham5jyfrlI/6AKfkBXKPmxZaR7t4rwibPPzqSjn8RZ+O2wBnSw61Rbg=
X-Gm-Gg: AYBFou1rpnTB5N5HqkSWv6+F3kbsj8/gd+vqCRBNMUPoA/v/mhnHOcpt72LvzoQyDJP
	hA4uvU9qRaN0d5Yas91wnXht61ksZ+pKpB+g+u8XcPAWJ2UmS/h1YGHsrrGGZLlLBxCnQ/QwE59
	IOgxsyLN6mttz4QTP8POm45AFZBhQHfMUOUcQve0y7axpm+FwvfTSb98fqyRNDRbQl0Q8uda2z8
	GPnXbDGCv8NdJUreqd6fQ8zshwaAi1dtd8JdB0XKnDHOL80/9z8noqQnnBH7l5SCFvVyDUFh6ZA
	d6HqiQJXhTxXU9087US8KrK76WH6gAJfGOFx/e9+6OZxF/hkegvgbV7r1xdHPGo1XsNanwExeK7
	BRaxdNMz5oCH2VWVUYSp8zc2SA35bqB9GuT9F6rFZ1Ab/Av59
X-Received: by 2002:a05:622a:1aa9:b0:52f:b372:2ef9 with SMTP id d75a77b69052e-530913411b4mr76747691cf.20.1788883072415;
        Tue, 08 Sep 2026 08:57:52 -0700 (PDT)
X-Received: by 2002:a05:622a:1aa9:b0:52f:b372:2ef9 with SMTP id d75a77b69052e-530913411b4mr76747031cf.20.1788883071826;
        Tue, 08 Sep 2026 08:57:51 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:42 -0400
Subject: [PATCH v2 06/11] mm: page_counter: constify page_counter_read()
 and page_counter_margin()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-6-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=1723;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ilFeF7WzmkT3DE3smE1F3wtCBJfDaUSUcaDgXIyabqI=;
 b=qs/aOiqsuEwnuRCgRoj5FQu98XRLg2KKKEUPKSnBKV8A8y1YbwgcE1thOj8GxB+WCzIUk6eKx
 rHBTQ7yU7hMAMKRu4yHXq5htNrT3t0tXfWjfpvFQvUXQOrRY8cOdrEt
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX66mhu31P1qbL
 qTg1jyShPFsCc4I1jPV2PO8JJY4POezTi7lhMq/vSiuAhD2Faqq4NgY3/lhDlHH4kgDpRaqpw4/
 PaRUD81We/ZqXTFr/ld8J04bRoJ8RsjowSF9/6AyOq2k03tIHXt7X695WJLM1NryazIIhkf69mI
 wFAlWwf1tgKu2Isi2z8Nd9c8lZeOcIRcFujHkyYWodAFpeiVsiCfeH++j4y/r9a5ECGwZujAwGC
 xtUume8K44UgeYCY12LQRro0EhqwjUlrSH2ixIwkXw1HkVbRncC4gsE5KF5FhA/8xhwTwRYtteT
 eaK3DkSwr0weniKzVRhmZv6ft4BU3pCai1fQl82tzZ7ZbgLjUCGrg3Jy9ntYsvw2XiLEIJOclVP
 ZYpN/+asUsSF96VDhrOfnuGYn8FLvgr4ZZI8r34IGI24hNU9fzH79KhuHsPnR2vagIeZRqAPIhw
 yFYtnL501wB07gupwOw==
X-Proofpoint-ORIG-GUID: 211091I-ZSn3_KLCCu_YgEuOPESA9EFw
X-Proofpoint-GUID: 211091I-ZSn3_KLCCu_YgEuOPESA9EFw
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfX9TuZOwfUYrBp
 q9xXTr/JatuBS+JlIVOBlkCv0rK656qcLPN/mC2gMJylMq8oIJV2sPE3CwMb1ZnzkyX1I/b9dud
 QjdBakgOVtFSpmousV5U4dkuWT71OPGEuXvjNYoY55uYNscfks5n
X-Authority-Analysis: v=2.4 cv=JPELdcKb c=1 sm=1 tr=0 ts=6aa03081 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=qClW_BUTj_2nsftnHKoA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=10 spamscore=0
 priorityscore=1501 bulkscore=10 impostorscore=10 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172

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
index 450543f4b318..8c6f3b45136b 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -53,7 +53,7 @@ static void propagate_protected_usage(struct page_counter *c,
  * Return: The minimum value of max minus usage across @counter and all of
  * its ancestors. The value may be negative during a concurrent charge.
  */
-long page_counter_margin(struct page_counter *counter)
+long page_counter_margin(const struct page_counter *counter)
 {
 	long margin = PAGE_COUNTER_MAX;
 

-- 
2.39.5

