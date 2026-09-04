Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAF8395ADE
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788557741; cv=none; b=OeNpSCQlBiGoAhVRLj+8gTZzD8gtaDreOXZndnMg4s79nJ6FgjUcaiUPULQwMRPiJmLw16tPHIhwaNAFwRp9x6bEE71RDZ1ZI37+gLRnouGbWVsRwnrfc+fkQ5Q38ui6MGPEtNDxgfU4qxbnVc40CpB4SW86xgvA7FL1Bwpd/cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788557741; c=relaxed/simple;
	bh=TE6/7pMNgS1nsvSVNi8RHdC8GwfOgzuZWlAq9IXHFLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WODw5tnvMrdmdMqprUm8ylZNahFT+Gt3tPTrhKPpmpxiPm8LUQysbjOQY8iHklLUTCKfEgT3qsnvBHs4Lf3Vd31R8JSKE7HBn+/KS8EsHWQjdo1QbNI+8AZl7MD1C7fhGJJITyHrTS6WrlcZeACevylSsmrfpQT1uSrpviucZbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=h36vtbVJ; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=YbWIczaH; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="h36vtbVJ";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="YbWIczaH"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684KZRYI2721222
	for <cgroups@vger.kernel.org>; Fri, 4 Sep 2026 17:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=L/aP
	YyT1Jy/RmfEhEFasDwbK2r6Vj3z/rQBklaXlzNI=; b=h36vtbVJnPBr/57FHUct
	EG1vzQhWbPpsp50Ww0DPKKHUacejmfX4tEXDe9AHJaRXF1UWzQa6CMYBXiIAHgG8
	aMUQTSUTg9jbDTdZVJzcdg+s2p6vfajitccHwSiIa9PmEq6WrpJNAae3d9IhAL/x
	8/KHRVFMEokYsmCh3QcB9/0BYko51C/snMoPCyxaKS4q+5V6a+YX4YBdiPNThh/y
	FCZeFTmEUXFM/5/t9qqpVsS7iouwFlpSXXnbmtGcq//5sh45WZuUCs+YvJ8UIswG
	xf+ZwoXDkRxAlxgKrrgdHlcQkpAg5bEKOvMr++z4CsB1xHSSPilo/EaA0ahkxiKU
	GQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gg0ac36u8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 17:35:37 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90e7de22fddso30664576d6.3
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 14:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788557737; x=1789162537; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L/aPYyT1Jy/RmfEhEFasDwbK2r6Vj3z/rQBklaXlzNI=;
        b=YbWIczaHE/F3NWncSU+Bc4amYDd+OK0EMLo/5I6gL0mQPc5mqXlMt08AhKXE0ZfKpR
         GocvfhGUUUzhbTbf+oc0R6g3wc04R04ZkCEWt0sUBjMAXUbaHJfGlYO7kXdBnjO9Fyrc
         ucIlPvwf8kayQW0HqVJjd3jbTxL+kmpJswe18hA9tNu+FvdeGik3KmBa13KpI8irxkCz
         wDuCS4fnpymMM8Ip+Sq15I5+hgnBVcS9/IVy/Jwauz4TlfZ+5dHn6+dyp9W1tOOYNq6E
         PvGX1VfEwILCrbUlXGpsorwBObvqCYXT4EZgen1riUetKO4G3SbfiE9njuZMZnCX4P1M
         K4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788557737; x=1789162537;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L/aPYyT1Jy/RmfEhEFasDwbK2r6Vj3z/rQBklaXlzNI=;
        b=I1N4AEQun8Ek1pMONNtnmFRDj5bcvBN6KSAkIeL1/jdYYtqNO7HMkebZ9nH6mcKPDs
         p3D47v66aXnufuw3bCfoYXyYKts3LSMIxD09dbpLD3JIlmQfAfJ+Z2rgFLQogVXzq4o4
         bmPI/7PIwhOIO1EP7svp0TZwrLlHWaLgN0PiGf4KFj0pGIm3lUlh9ydNGUjIfDbFMNHf
         vZwsUagums05XVl/LoX+W6EIqckfdeXdsB58XfY2LxzXWz8oBB75CTdYfmB1tM59pKoR
         VL3WtBvXKplIStSUYy7g8mzKlzdsK4bC8XikxTHbYjM3UIUeHDWLDL5w40MIJpF29HQq
         XbYw==
X-Gm-Message-State: AFuF++mWwB5b6bMWi1mTRzcAUPbUh4Z7J5pIIi55yLo8ipREV9llfryG
	2X6R4+sAziNbCEn7eJxeB4gSV8FZO+W4tbTWJ1F6e9JMcbxsDnCvp6ykuGYvo9FdXMbMKXM6Cvg
	RBmV+UN8rwR2P1QNiey36aciFNDumaziGXcZJ9UsiQyJdHcWLzqDLWZw=
X-Gm-Gg: AYBFou3yfdqj5K4t6FBDECtoJo9cB9dOo/Gj/yb+rjmTwKZPnlPuS4ERKfcLzrNvUTc
	TpiQhT8D3VKT/yCa1jse+B08aP18184Yw7SFe1dOmw5y0d0x3W31QTe/oAlmeRHbB2Hjx77NxVI
	d7isoChMqzKKsb3VRabhflFxhlRh75Nw0+JpI4v6Xh7vUuaEi7hjyY8RWvuCG3hFYB34jhc9vaM
	MUcC/ZrSL4C9aKGoXmIEhz3cuNIHIHV2tKwu0umX05xhNRV6C/uF7lVMMJN42bKoTuMq6VOgAaL
	4L6d94Ny8LRASmQC5eJd05yLlu75bVE/gZ/ndV66n/RFBRHpi9/gttTggKHyZIq8BMcNMWEKTjB
	VyvYLfU/gLcodYXt+vGTnIBTckscqEjmdtmrP6lsKaTg4yLbA8DBa
X-Received: by 2002:a05:622a:130c:b0:52f:e60e:70c3 with SMTP id d75a77b69052e-53054961fddmr94379861cf.24.1788557736750;
        Fri, 04 Sep 2026 14:35:36 -0700 (PDT)
X-Received: by 2002:a05:622a:130c:b0:52f:e60e:70c3 with SMTP id d75a77b69052e-53054961fddmr94378971cf.24.1788557736018;
        Fri, 04 Sep 2026 14:35:36 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-177-158.net.columbia.edu. [128.59.177.158])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305418950fsm29599931cf.20.2026.09.04.14.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 14:35:35 -0700 (PDT)
Message-ID: <5ac3eb40-2c40-45cf-a5ce-d7dc3a10c491@columbia.edu>
Date: Fri, 4 Sep 2026 17:35:34 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] mm: memcontrol: constify the lruvec helpers
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
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
 <20260902-folio_memcg-const-v1-3-e2c1da22246d@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-3-e2c1da22246d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDIwMCBTYWx0ZWRfX9DTD/QlricWj
 AZ71QdNZmXvHPfmnh39AHUBN7hsf7xihBhJPxhvviaDN3EBWYzrE/M28KjTrYSvHa2/GeQ30PjJ
 n/gt+lnrK2SydT2NABRvJVhS/iS8Tja1XQHZNNqG9ndbBlWQjSIJFtEbAhTxJn8Og5l03BdhQRx
 QPceGs3oo4JNaWC+dA5Cr3AFvOQyYAyfhpHNi7PQwEpNWqgByLB+a6B7Kb74u7c+XSw5BeLJGyH
 izjW+y5K+GoDQMCi6EYZ7woGH+3KgnsR0HXNWGL8yLXM6Gev27ScZXySYHSC3D4gORQEFT797A2
 12O3FjuE3vy22lUNHhX+4Vy1PBhxqvJ5iQudEqVZJr2eaGXbQHUgN7qx27/GlQ9hwQN9QWClUZN
 5mpU3ivXxZQjbsSkimsjUoPzaxAUfajoC1JmbHba+fqITZtZJLxo9yB4UMHfHFKACR4PzKSzupD
 hDs//kuDmBuEuDoHMiA==
X-Proofpoint-GUID: aKhdOqGMBhJJQsmDJkoqNeCNaBlEqXFV
X-Proofpoint-ORIG-GUID: aKhdOqGMBhJJQsmDJkoqNeCNaBlEqXFV
X-Authority-Analysis: v=2.4 cv=MotiLWae c=1 sm=1 tr=0 ts=6a9b39a9 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=tLges04aSNaZGVAfhBIy2A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=chcUDXjQMmrNteCdNfIA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDIwMCBTYWx0ZWRfX8FuwHAPKsKEe
 pq8f7luZJqOQF4GoSnVeErLpZfNXWJslQmBiLl9hYq1poK8U3qvYUODtk23NOp2NpP0SwAFyScZ
 pKk4tgo0GPUswCGaPtvEuoVdPgLiMkkkvJxbOzKS2jmQ411GQZY9
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11896
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 priorityscore=1501 clxscore=1015 phishscore=0
 suspectscore=0 bulkscore=10 spamscore=0 impostorscore=10 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609040200

On 9/2/26 10:27 PM, Tal Zussman wrote:
> The lruvec lookup helpers only read from the memcg, folio, or lruvec
> they are given. Constify them, along with lruvec_pgdat().
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/memcontrol.h | 34 +++++++++++++++++-----------------
>  include/linux/mmzone.h     |  2 +-
>  mm/memcontrol.c            |  6 +++---
>  3 files changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 2b3b62e84ab2..4b7cc97e45b2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -688,7 +688,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new);
>   * @pgdat combination. This can be the node lruvec, if the memory
>   * controller is disabled.
>   */
> -static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
> +static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
>  					       struct pglist_data *pgdat)
>  {
>  	struct mem_cgroup_per_node *mz;

From Sashiko:

[Severity: Medium]
Does this function actually just read from the memcg?

Looking at the rest of mem_cgroup_lruvec() not shown in this diff, it
contains:

     if (unlikely(lruvec->pgdat != pgdat))
         lruvec->pgdat = pgdat;

This mutates the lruvec which is logically part of the memcg's per-node
state.

Since the commit message states these helpers "only read from the memcg",
is it safe to constify this when it can modify the structure on newly
onlined nodes?

Answer:

The write goes to lruvec->pgdat, which is stored in the per-node
structure reached through memcg->nodeinfo[], not in the memcg itself,
so const is fine. I'll clarify the commit message.

> @@ -1528,8 +1528,8 @@ static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec, unsigned long
>  }
>  
>  /* Test requires a stable folio->memcg binding, see folio_memcg() */
> -static inline bool folio_matches_lruvec(struct folio *folio,
> -		struct lruvec *lruvec)
> +static inline bool folio_matches_lruvec(const struct folio *folio,
> +		const struct lruvec *lruvec)
>  {
>  	return lruvec_pgdat(lruvec) == folio_pgdat(folio) &&
>  	       lruvec_memcg(lruvec) == folio_memcg(folio);

From Sashiko:

[Severity: Low]
Were folio_lruvec_relock_irq() and folio_lruvec_relock_irqsave()
intentionally omitted from the constification?

Just below this hunk in include/linux/memcontrol.h, both functions
still take a non-const struct folio pointer:

static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
         struct lruvec *locked_lruvec)

static inline void folio_lruvec_relock_irqsave(struct folio *folio,
         struct lruvec **lruvecp, unsigned long *flags)

Since they only pass the folio along to other now-constified helpers,
should they be updated to maintain API consistency?

Answer:

Will constify their folio as well.

