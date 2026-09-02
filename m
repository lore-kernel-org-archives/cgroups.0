Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A579395AE9
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 19:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377321; cv=none; b=T+/l/Bo+yqjKbc1EGFbtW8FI5tr44aprzi+ZCM4ikG5Iz2sz/0LmVFJ07EzfsXQag6Df+N687pqT1pVt9cfq1Fpr03yGQ3Zk63IhqSnKOxNR9VJui8i1FRmg4hX245icbp2VpZOQxQkSM7xhuWoaip5p4bRrFjM0WpSS2wAR8YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377321; c=relaxed/simple;
	bh=32H1t1WqS50OuWNOahh2XKuh80JbjBLzpk9HxQSJAR8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ajNsp1vDRnjbfZfm8mtm3o5i8FipWZyPrjtgNtqf4G0PvqIxwx+Wft6psoGM+s94GZxN1P9pNNhmVvSPpdOjxQBaOmJNTKTuOhPX2fpGGv5K5IP+3B6UQZfpY/2urWVInSza7TJOmx/wKYeJbTReqvHDyMBIp2nVyuKxmsQ/mlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=FmkkumiG; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Qsz37Yp5; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="FmkkumiG";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Qsz37Yp5"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682IvVw63642391
	for <cgroups@vger.kernel.org>; Wed, 2 Sep 2026 15:28:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XPhT
	KwWu0ZC070eRJGAvJA7RPQcJokjsS4EySLq6rA0=; b=FmkkumiGvIPuvU0/9Qvj
	84xeTxIV1I02wmmXEXUfGdjLVSTnBDlnqF6ByVz85HH3FuFHtKxvn5ZJH0iHB0Hx
	giH0atIN6rUAssr3pOn2bvSD8+TLFgh/TtC2J7uR4BlfeugnCwytCZTyotKY8BMM
	Tp4PZECKpx32ClZa7uJ0bTucn8T1sK1IbkaNj0JPpt2WWf68R4eR24aICHB5H+cG
	h/PgeczlHgCmMxPU1eL6Cie44WepNfrtyFl2qxQcCx7PL83478svCyyqzhMtKYaN
	H7GFr4HsFSvzR4LMKhiOP9dUqAbEt31bNdV0cbCIPAYOAkoAJWvK4Xq+MKZpBorI
	WQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4geshp08yk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 15:28:21 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fc1e88189so27271981cf.1
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 12:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377301; x=1788982101; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPhTKwWu0ZC070eRJGAvJA7RPQcJokjsS4EySLq6rA0=;
        b=Qsz37Yp5V6dMaGsZLeNsEmP90BOqLitK7WYbpmO1ZK70ymdleIhc56ikVuDn8o5i3r
         TfMPBwaKf+Utv/+arbC/s2KPLDGHK7fooc0Js8bAzA9JvtJpm4g0IYM5B430G2X4SKHl
         nKBd32KmcLhDKqx6rgxLlc8jDjtWM1TyIp4GWqmQq5qQLo59T3/GEKs0g3xqjriSQ4bR
         xgQ+Ej3KVh4DSn170n9tPkkoZUTjbIgbPEyymVKykUGpWIBN+IW6d7KVTt9UsERpFlet
         Nqr4nFzCAcvJWBL/azuQpwDyRr0iJ/FoBdt8m/DhSUD/dpmzej53lExcXXh5q6FPs/eJ
         CIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377301; x=1788982101;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XPhTKwWu0ZC070eRJGAvJA7RPQcJokjsS4EySLq6rA0=;
        b=pBBKuwCYH4TpkVV1yIF3yK0qw70ujguAj8mnmXfgnxi/KfQrSo3Hhz3RbqtGT50gP5
         8HUUsKreZXn4UmAhA+FenL1geaWQM+PnnIyX8DYWs3N+LUEMaY+EdzeNE+HCp2/e3NJ9
         ZXJANUSLWrI2/EIPqOloT8v3u1PK2OOFAUcOjcoAqSsB4DM+b/E8Arv2508Oghp1W3uS
         FAsMyq4qYjb1+LWHqLvgoOxxoNpliQ3riDFc6zQxh1pOemtOzULGHr91mYdP19VV7pSR
         wagpFGoYpJr8vxBlHq9p+XWJ6x9x9Ci1mpRvPz4cZTi5ha+PeXh4tO/acOonpblUD/5r
         OjHw==
X-Gm-Message-State: AFuF++kOzr45s2lEc8+Y8CC//L8ce2akCb+HBH/g4IREvYIGQBF3alvh
	AGpPEStckaoi++YbMZ09qbYlxZpG4yf/vihXPznWmWT3BVMsWz5TtkWZGLOuQE7eOnnAnaDioP7
	Y0y/Reaa4v/1mfxp0L+d37jWDgs0kx3ehEWVEagbgZZCFkJ8+wMUoJnA=
X-Gm-Gg: AYBFou3YKq+VARXPF7dGEv7qZuaklNratuwEXQvFzyf3xkYoJdPo1fLpxhOErgfWM/K
	biLr3jEozEs34PDK3IpNTjSCIpjgYFRp2YnCtAfA8FwRpx1P0L+R+ETENjMS8OiL7NbFNcj9MZX
	7uBMaUwPfCJQMyYZGUZkUykyEgeUEVZUTxxE3RFLnuTDrw9sCXt8CdMLsw6k5hhHtxmV5KkNvpr
	MMbWfho/r3Q+tIa+s7YHOL0+LxN5HtX7jTbxOEUiA31N2t8ox2x07C3VW/lKihS5qs2XiSpGLWy
	ld+LwHzc95O2pEJCHz7H8hAMrGpWo0Mz4IVGzlbawTGm9Dwg3Vt9i6y8h1WoOQGbPb73AIw2OQG
	cITXwRHXVx9Au3A56mzFFhNkFJ8joRwzfm1pBTS/tgdyAH9Wawf/VnQ==
X-Received: by 2002:a05:622a:1906:b0:52d:918b:92e1 with SMTP id d75a77b69052e-53036b93351mr82217141cf.5.1788377300527;
        Wed, 02 Sep 2026 12:28:20 -0700 (PDT)
X-Received: by 2002:a05:622a:1906:b0:52d:918b:92e1 with SMTP id d75a77b69052e-53036b93351mr82216511cf.5.1788377300021;
        Wed, 02 Sep 2026 12:28:20 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:19 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:48 -0400
Subject: [PATCH 02/11] mm: memcontrol: constify obj_cgroup_memcg() and
 friends
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-2-e2c1da22246d@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=1873;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=32H1t1WqS50OuWNOahh2XKuh80JbjBLzpk9HxQSJAR8=;
 b=LYEgMgFYhn+Wku6NCeEdHf4ev23GptfScBM0FZS17DRElY3nFhOjx7LrmufmMei8aKlnIoLdP
 PVtuZrXpv0XAT4Snz1hQZnXyChRYU0Yp4h2nI9ex4KXJVsx49m+SSKe
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: gru1118NE9JCefjy6W8itqta4XQoHftE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX3fnm9VmnQfj0
 rzo4GXap25grG8VVTD5X6r/8KK+Tm516JJDcbPd/+0jTtXO3YiHvlODDbsX/sl2+6T80WqSPqp/
 +G8d6x1RI1GCB98g954Pp1uMLc63C7P/k5K6gVf9HOTTAebk8l8inptJAk3L9sfaqAPxCP1yBfD
 jpU7iPFom2C4+yXcVRAEh5+U14sHWECgCb7XR0YPYbuKWGc1P2bcLgWKYb9c8fceIgZdfae0x/G
 3dBdi5TBOvQYgPUP56ZIRfS10E9T4sZ9iHnduuqIjCQr32UmNHd8jHvohSheihw9wwbNZ1VdvWH
 vQzsyLBi5Rx0ZuzqbLi2+1sTr5YZa7tC9e3wMu0CtmDz8evGr50NhPsqe+dOX56o+ZljO0iSJA3
 WUS7Wy/dtuGGmTzK01TPegT48Hldyun/7NA+YMLJR5EdSgjI7/Nk4LJW6QF4PtF2yQVabYPgcqz
 uGkURFWRg4mk7tPPTMA==
X-Proofpoint-ORIG-GUID: gru1118NE9JCefjy6W8itqta4XQoHftE
X-Authority-Analysis: v=2.4 cv=J96aKgnS c=1 sm=1 tr=0 ts=6a9878d5 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=HbpFEVrQSsppjrtFf58A:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX0MaQ2TmkN2Ox
 RCwIBfsg6PxuMYJFXHMp1O4/MQuyCwP7JzUDvh2tQDFmpqEqeKMGFt1Dav8h6b0+3Da8QuKm6oP
 iQveiCuDRk74rkK86r5G0856z2BWQ/tZ1QlSdfgKPikDTJtXme6N
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 bulkscore=10 adultscore=0 spamscore=0 suspectscore=0
 clxscore=1011 priorityscore=1501 phishscore=0 malwarescore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172

obj_cgroup_memcg() and get_mem_cgroup_from_objcg() only read from the
objcg. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 91ca94667d44..2b3b62e84ab2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -363,7 +363,7 @@ enum objext_flags {
  *
  * The caller must ensure that the returned memcg won't be released.
  */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	lockdep_assert_once(rcu_read_lock_held() || lockdep_is_held(&cgroup_mutex));
 	return objcg ? READ_ONCE(objcg->memcg) : NULL;
@@ -472,7 +472,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return folio_memcg_check((const struct folio *)page);
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	struct mem_cgroup *memcg;
 
@@ -1036,7 +1036,7 @@ void mem_cgroup_flush_workqueue(void);
 extern int mem_cgroup_init(void);
 #else /* CONFIG_MEMCG */
 
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *obj_cgroup_memcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }
@@ -1065,7 +1065,7 @@ static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+static inline struct mem_cgroup *get_mem_cgroup_from_objcg(const struct obj_cgroup *objcg)
 {
 	return NULL;
 }

-- 
2.39.5

