Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B48239A040
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377339; cv=none; b=WnyOrp3Sa6mmmzyxpFscg190NA69JE8PW50LdWKSo7ztFOGP2c6DkbDVNQSET1hNs4T5M9iJVyrYqBPKYX0o0dtZLS+DuttR+KcssMW8LitCVLt05g2CWXM8xinUBeQTsksvOcANn9GPyDSbOFhL+MOMulS4KojL30nHy5y6m3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377339; c=relaxed/simple;
	bh=qY55MTnqibpTPmaITCcOknY/TskrjruIzBjhjSvoJq8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LfSR8WHSGIXQ0F1GxIoOV6Qk2Ux5zvYQvzMLm/aTjpzxUdsDTEqs32NX7Lzfg2h4FmwPxo0LGNVZ+nS2i9+/OdKKIX0v5Fonj8GL2PMoKYkiikwKdb1GzY8iFOioFEdGOVBmr0QjlvsejW71sWg+y6EcsZjp15v3qAgninBd0tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=VcbRIp4J; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=bL5qUXmz; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="VcbRIp4J";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="bL5qUXmz"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IYdvW538496
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=zKnV
	zljslWEn654S8LhmKqCkQWwfR1ZqpbkHiEttZS4=; b=VcbRIp4JVvQ/3ejpIWPP
	caZTh/F5tjCRdvFZ/W4BJovJXlZKNdSkFZS17kv8udRIKw5cuUQxZvRHb38IW5OD
	LQ/GwWFWKi14Q98Qqt8pl4Zi9ZCNICDsIn/zbyYdpBtISVYL0Kby7OOydvSI8Pjq
	GO3ILRPBcard5zQIfPI+Q3RZTHtYbgkFru8pWAOQ2/f00YWwHgWwXMiHVG6WqiF1
	vGSEFzCpH0/td4+0cbc7Ng5fnIRrgQ2h2PEalAq4fw+Evle7D/vWnFNjVTZDpYqL
	96MXSyd8+P0h/PSauYCwlgtRfq/U5iCS3XyTMdzODvpYYJft8/oEVhN+Yx+GC131
	4Q==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gefkbmu43-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:38 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93494cce712so298304885a.3
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377318; x=1788982118; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zKnVzljslWEn654S8LhmKqCkQWwfR1ZqpbkHiEttZS4=;
        b=bL5qUXmz9DdFE5srnZUpOpIqHLn5noxag+qtCYuKk6KQ3tg5kP5zywaYX3u31lUKT7
         lP8sS5xZscmfNQPY4CHuWcYR0RTGMUfxvMMF7nnd8ccOYoWgJNApeGJ50poYV5qqcVP/
         eHjopj78fAL2Y5YavNSRJ2lbqUc8/4VkO69mD3cN5gsKvJGo+BOSH81xrrpAZL3hck/Y
         ks4TX6QWVkXz0aeGsfhXlK9j4EiDKHit4BNnMYRb1L6gcGM86TVH9MKy0RPKea1Rpm5r
         2PgDV4IjQT4NO0iM1ubOSg+hQR0dLMyBNtxHvJbBjm1TRXKwreMyMfys8440xfGNqw23
         UClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377318; x=1788982118;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zKnVzljslWEn654S8LhmKqCkQWwfR1ZqpbkHiEttZS4=;
        b=j1PVfW9/to+TAj5PfC+11g3aa1BOMf3JHtWHEHJGaJrHAxIQOEzGuN86hjUzoUAAia
         ocwNcktYvX9KJdwBZREwL9W8x+/LSGKauvm8o1a4eUDXv27JesJm05N4g8TShLnOikK1
         o2CrT17r1/fNnW/4eeoDuXzE5tF4OmKON+X4V8flu1zCJd+zhMEKm2yCVqwpM/j1RN/v
         CVt20GDq+ub5voBiNq0LVrAIZsX7FXkzkyAXFCBmiYQJtTQtLuPQhSU2CPt8mQFni8Zn
         phb51rzLLbEkvU17hlkviZQ6Eq+B2WKt8Il4hJD7EF3JG/tMbal31r9vxaWr5/1jR4QC
         yGog==
X-Gm-Message-State: AFuF++mcbdbzB3eQyG2rTbkaWDFWCq6xncZSYb3zL+REq2oHC9QNcOAT
	3kIkwP0NvPvffwPQHrPUlWGP4Gf/CiUpbdEnjwnGOhllUhenOpgm0BjB30xVUkvlqny1NQwU5Cw
	s3vGX75UWUlYAqU03VdsGB3mA1TIUcwGTOOIRLZ7+ezvva1C6Kon1VAE=
X-Gm-Gg: AYBFou1dkZUpdMlGTYBl+gc518f62KfTx1f24zmL4ymdjAb6NBPmKHFY+7fmbGq9MQN
	061TjgOut8p2ooVwNJu1R9mIKCQ/eDezbYvX7Kjgzs0ErTUJ1Jx4h2TdI9JT4KxD+lRSFjcjmHK
	hrNqdE4naFKlBj4MfuvbVWFTxoQ1sQ+/ZRnisBqXScwz8w++xWEV3AYsReR9eOQ09Bj6rKdOu58
	i0AHKYd62vapXzMH3Re3ResdG/xJgqkgfSisF8DVmvaEMsPkgKrW1wczvfRo9ZBlzC/N9RPBw+9
	/MNgM6RTwcRwkZ/qVDIpb2+kVmNG8NqYCKVFnw/STGsl4nUj3le/JR3WLasQUkgvRqeFhPxHq1l
	6Kf8x6Ab3207WOjF2MWZMIincZnuneoyJaehNsLV1mQJx/x57r43FtA==
X-Received: by 2002:a05:620a:4448:b0:936:a407:98bb with SMTP id af79cd13be357-9396f65f15cmr67780985a.9.1788377314131;
        Wed, 02 Sep 2026 12:28:34 -0700 (PDT)
X-Received: by 2002:a05:620a:4448:b0:936:a407:98bb with SMTP id af79cd13be357-9396f65f15cmr67750685a.9.1788377310673;
        Wed, 02 Sep 2026 12:28:30 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:30 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:56 -0400
Subject: [PATCH 10/11] mm: memcontrol: constify mem_cgroup_swappiness() and
 mem_cgroup_get_max()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-10-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=2036;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=qY55MTnqibpTPmaITCcOknY/TskrjruIzBjhjSvoJq8=;
 b=XBJ1VxJgkZ7z5/jJpbpfdgQJ9HTXTIu58edJVRrSCFJGK7C1hYYjRFweIITZPR6353Ht7J0S6
 Agk9F/63QbZCBLqPgyFB2x5VwRDyz/DAkCE+H1xfhE5G+ha32Pkhl9f
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 0o1HgQCngVLDtFI4dJRxeCpCDUVgFrsh
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX4pQZclKUnkBG
 bmpQaxvepWjzkf9qhUK6h5pHBnlU5BB4pZpIi1HcNEpwHp/50sZm0VIj9tBw2Z2TvB2KXgfY6Tu
 6izZWWKPTHWX56s+9gPT8ekiT+/nwE/m380ND2nZ8d/aOFCD8dpb
X-Authority-Analysis: v=2.4 cv=aIzAb79m c=1 sm=1 tr=0 ts=6a9878e6 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=LvCEVWXYBYKFGHUOtEoA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX34tjGueC82uy
 1+RSq+vVLVVeZMcX+PWOvKuEe/uUuClJrMR3i+88yPG+4bwSDvJqNlyugJf07CjConydo3BBLus
 bmjSOn8cXdOzPAZ+Cz1/kas9rorupaey7PoGksmEFXar/OhDeyNIWobPGoWCVNYTj5GPE6fz7VQ
 t94nEScMhQNydTQJdIa8m6RYgwMnKMxJZgWYiMXGNJrwjcelDo+nYwuAjsOOf1SrhWT29LC/ckE
 xY1QJPVO0jks1fh+ESxh+2jUOLb5kXiumHZWA8D+roOVcQ6JaQCuGCnVfKrMMX+7OtE8sBGg6FU
 u4HVprfyFoBrQNj7JZRSXfofIGzB4v91ilZJxmbTtQjhq/2d0YUk3Z/NrFfXL2SgIixjoZKcaf3
 7J3sfFGsRw8g9+QvXZPL4A/vGiVs3MKkjwIygiibHvhquCPYa0m8gxFfvddYz6SbQFYKzrwyoSC
 scNvzxTfYMz134vH6EQ==
X-Proofpoint-ORIG-GUID: 0o1HgQCngVLDtFI4dJRxeCpCDUVgFrsh
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=10 adultscore=0 malwarescore=0
 bulkscore=10 clxscore=1015 impostorscore=10 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020172

Both only read swappiness and the memory limits. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 2 +-
 mm/swap.h                  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 10a197886f31..2d5e43dbec4d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -902,7 +902,7 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
 				struct task_struct *p);
@@ -1332,7 +1332,7 @@ unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 	return 0;
 }
 
-static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+static inline unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2b8705a88f6a..e28b2a4f278d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1878,7 +1878,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 /*
  * Return the memory (and swap, if configured) limit for a memcg.
  */
-unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
+unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg)
 {
 	unsigned long max = READ_ONCE(memcg->memory.max);
 
diff --git a/mm/swap.h b/mm/swap.h
index 0b5d507739bc..94714d9dd003 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -82,7 +82,7 @@ enum swap_cluster_flags {
 
 extern int vm_swappiness;
 
-static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
+static inline int mem_cgroup_swappiness(const struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&

-- 
2.39.5

