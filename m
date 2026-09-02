Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2083C3955CD
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377323; cv=none; b=V8O/Ddnp8i36/pm9Vbi52SrDAGriWly9sALQEbKoybkDVINJEa3vq8CQ5vWeXI5QtJhtOIPQGzRCbVY081NXlHjsqCqZpBEwTN68G6nCWNnY+ipizbwwxcqxjTwO44b85I8kq3lc3uyw9xNlHi/3MLf+JLrStERCqKnMUQSRBRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377323; c=relaxed/simple;
	bh=ilFeF7WzmkT3DE3smE1F3wtCBJfDaUSUcaDgXIyabqI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TmD41yo7j7BfnS2jiNJJLAOpKpUJ1iUSsB+UcZ4sSoylQCWoAAzBkBTT2Dz3ijiciWZnZJ+VXbd8Nwo899l/PREYLftBX+ByyWy3R4wmb2TQqG2/U/M+3rouE4aIwfiK5SOyRZfY8/Q4Tqf12yg5UQdW+p7E5nPtsggDbaZ2T/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=hVsrrlYc; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=1O0OHiKI; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="hVsrrlYc";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="1O0OHiKI"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IYirJ767439
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Q9N4
	IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=; b=hVsrrlYc59XuGvwMLBIB
	79hF1PI9iXwfcm63Ba1eZwxd/Fbs7FreqXrwsb8TTjULXlpYWKxGzaKJ3pyGpVKg
	VsHUeNz9wzapy2ZAdNCzluWCQjTVjcSwQ3jImhqREivNoqu6zhk+dS+ytImdiu3D
	k/YR02g0i06qnTSTHiEpEH5oKyA9ZOLmvDefOspbZBDH7EV9dYl63cNpXi4YcXky
	GRwLFl0+VjkxNCuFaRcseKqydKfQpXoZJR4lkO18uo9aHWWpBxiMPIv9RdMUrUDQ
	uiYn0VlKBw2/8SpolixLs/UstwsHtSREwFrz/7As9/3QeUQBuRikiu7RKfL1Cfwu
	AA==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ges5srekv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:27 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90ce7ebc25bso30115686d6.1
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377306; x=1788982106; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
        b=1O0OHiKI3BqIIt2lqOOH/R6S2fmu17AqlvFeULdamwFf/IkK0C8Y1X8QloR8iYDqzQ
         6bljSu2dy7xuCuSQGHcyk4CGArpNgDbxiuJ5iIMnwQRbNZ3f0XAG19AvnXPJjdn7ghpR
         4bZIiJvb/aFzG2Ys+zXeN2ilByIR2GGVJOmGy5vKYj9WVkHzuYwtOBG2G0nYL+WT+eB+
         ymapez73gySvALqm7pMi7QZ/lxqm64JIXwE3GaGzTtgr/Q5bpGlVnziUK+c1+R5lZBJ9
         rn0KR1KVfsxXzwWmhC0T+OCRIHn3CpCkyhvzaMMkd+fVZfgyuukk57PEL1Kto4EouMhM
         3+aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377306; x=1788982106;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q9N4IW0Q0HkN9KT6h8CVRGegPfku8TwgZZjZ8yH7Mw8=;
        b=ILIb4b3ZcIxgmtT+1YeN8ak2t4qHIbQeEhgQb3I7E96YuSle0NTuOMprs84NqIBI5b
         5ZbUq/0Evy5dEME0AKNtx+iXhTcvELcvlcaxb/bRCGoHpoh6mRIIqV93psqhT5oWH7UC
         6oMjtCM6vzssFkHen+jiptZTtM4mbjq2YTh1X7TlXfL1klkNp4V9fRdktWhu5vt6PaB8
         WU27sodV8zphlk61sm25KoVMTz91Z2hwVMFk6QzqQrpe+zuzkarLBYIl1xvMzob4lQMN
         zJEunQeDVFfdTeFeN1GKxXGPA/jhzIj+H1mIm35iqabVu7fQ75BWqfuCjKwz9uXDZg2y
         0cpg==
X-Gm-Message-State: AFuF++l/BHy4w55Vl1O0r3NN+pOCGsKF64xd9wOJdrecvYrKTGrs4yuQ
	xhz009g8y1e+Tp4peZBbxeJSVMJKXHUYPkYGBo8+JWWzpTotYFJy7Y7fCiToj5+nG6jkyb/WPqp
	xXfoowCutpFgmMwKV7o9dkK7X5K6kwGQcRewuPOtaR3wjbwBMO3YvDE8=
X-Gm-Gg: AYBFou17eiXPXPpiuXbBcQ6MMYVPzmdmt0eDINmMgV1w+SRyqeP81/xuADnJGqfJiIq
	z33TzY0VBuAfqzlADCis15aYp+GtbV96gIX94XzlDZdF33QIVHya3gAd553T85qy4N29Zab4coX
	BChysdeXq4wXl9no7kJylgvncf8GwhB1dIwIDfrsj6kBZgljXsm90ZjWlFyhX8iVGsf/wP35+OU
	T1KZC2JnttwuYLExm7VyvIhESyVtZaz7SLr3Eoz3fHsQNNduLmCI8jLuVC8TseeZJ8cY02NIT+h
	snLaZ5FT240WMRDOuJxk0lXk1bmLHf9GDa4SqVMQAvS9aVPadEDZPJ0vnnI0/E0gU/E6zwtJse4
	BHWBwt03GtHaQ5wMU1PT6wEUeanuc22QpblbmSjaE1sycZmFH9M5Ibw==
X-Received: by 2002:ad4:5d6f:0:b0:90e:95ad:ba56 with SMTP id 6a1803df08f44-90ebaff078fmr101878156d6.9.1788377306338;
        Wed, 02 Sep 2026 12:28:26 -0700 (PDT)
X-Received: by 2002:ad4:5d6f:0:b0:90e:95ad:ba56 with SMTP id 6a1803df08f44-90ebaff078fmr101877186d6.9.1788377305632;
        Wed, 02 Sep 2026 12:28:25 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:52 -0400
Subject: [PATCH 06/11] mm: page_counter: constify page_counter_read() and
 page_counter_margin()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-6-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=1723;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ilFeF7WzmkT3DE3smE1F3wtCBJfDaUSUcaDgXIyabqI=;
 b=7SvjOSnQHJqga+RWSYxTfjhpAi2s6De4EDJuTDdt12VyGEw9fCStCgXHcbh3kEzsD2y3neQth
 Ez75ezd5GfbCGX281htE3Y9/bLU4GHSZi9xp5qDT8cGrFVNQSwXUwV0
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: OnGaWD65N7NVUDZefu3_q3Zf9D9PuIOs
X-Authority-Analysis: v=2.4 cv=DJq/JSNb c=1 sm=1 tr=0 ts=6a9878db cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=qClW_BUTj_2nsftnHKoA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX4OgSugX06QGH
 QWTcwf0R+2LDqqarpqSVCb0XhFUXG5U9yVOGw/EVBWy9L179n91iLfxAk+xaJ9LlCr16Ns2HVAu
 i+DIm8whQ/Uj6QIikiRwLTpaMHJ5OcTLpBeh86h2u5tXQzNCiJXz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfXzu+41cCANezv
 NvReeQvx/DsJlz6c6bCtuGkMx/tCf3KI6Pdw9D+az09k8zn6jvvwEl4ny8eUN/4cUI32FkrkK/J
 V6hSZdVi/4EvC+U4/HWYjsYuQfaV8iWnBmCnhw+76gGqzE9jJxney6KwuI9WuKVyTrM0iNsvNDB
 BPsKrT+xYLMOqDrogaG/NW38r5upPuUG1LScGI+yIsey6ZRUcqfe5Qk4y3XLhMQ5kRomIz6Un40
 SISl3+mFRkdAC7Hx4pR3e38MMqXZXDrx3UU37MYIjkAXQiBqHiBM+QwiPFikd8MVoHRF/veFxwI
 hCfRdGr397Cg5xWFf5oUwOHPOKPLW587OoELmw06cnmZk5k/0lq5O1QxgZPHrqRK9XA0txuG5b8
 U7Z+Ly2+EYIOl9oq/D3lS3wTBSxofmKIUqiJ0/aPhmS0V4sCx07pCbs3vNSyG1X3mTwI66dzQIn
 hUdTODWIknzSALg1JSw==
X-Proofpoint-GUID: OnGaWD65N7NVUDZefu3_q3Zf9D9PuIOs
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=10 suspectscore=0 bulkscore=10
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 impostorscore=10
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020172

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

