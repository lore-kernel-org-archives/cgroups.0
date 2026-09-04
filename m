Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95553955FE
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 21:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788558151; cv=none; b=eDAoMKKc9Lrl1LbAO1Dj31qQ6d0x2WD+nGIhrpeNFvBpDYOZqCCDxQX091olClQ1+7h9qIGfiSI8VK1pdnzj7P8a/nkYpy8yAaMsLAyeJ/DfoabVq3yy2SF1PENbUYSUaCN2Eti3rpEEcpbekhKwXpymvoSbd/CUa3Fk/RyVl3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788558151; c=relaxed/simple;
	bh=IfTURNHlwjtaRepVD5dByQ+90DxxWiZBB2cnPzFTSSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P3Aj41zz8ICMzciyL3usFyBoyRsEbuGcb2KpjDT4X85tQZZs0s6x9paq7f/lOECfVKmUjwOpPnxb6EZutiWCEMP1MW8KgfjWRNdUl3IAvZH91G8c4V6juzvNf0NlDiyMpxVOnB3uMpAO6NluVW9t00iKubSI/1ddq2znnUND5Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=nvpYHaWp; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=WV01+LBO; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="nvpYHaWp";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="WV01+LBO"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684KZ1NS4168451
	for <cgroups@vger.kernel.org>; Fri, 4 Sep 2026 17:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=9sBs
	rXDWsA6mIM6eTb+x+9JskBQgNRQ7PhCpi14v3SQ=; b=nvpYHaWpJagUrv72UkPu
	pSyLtzsV1MZZi57QENoYRlenxKN2V2EsKHyhZ9o5kJZaa2q3s3LGsw6nDLsiobU5
	wEQFRPDAoD0D541yZ8U1Y+BjiW9KFG6uT79JPlnRHXhEi5zNEzNRiMP+EuEnqdfs
	OrHHhY/585JZoZ7zWL8I6RT5o1wOEPg5htyWEDiU4Qd9pEcl0Zp2xARNJ8J5/9WM
	w7S9cP3TRSGxIJSjWIwNi7TV88gioy34fkCUxBgxdbyML0goMreNY2ygjzWl83AT
	iXDilJMAvs8KbeChfGBTJaCPT1NK6iCXdUUkQ4xSk8w0kW6pSQl/iCr7gZDkNlkF
	GA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gg0acb8re-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 17:42:28 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90cea0b5522so27414076d6.1
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 14:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788558148; x=1789162948; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9sBsrXDWsA6mIM6eTb+x+9JskBQgNRQ7PhCpi14v3SQ=;
        b=WV01+LBOnOkMCPt09DlKn3sEFtbEFUrO2mjNUipos8CQ7R4bmaY1qoEgSpJy8erngB
         K+QazoaoiX1dllF1iUnHpxEWmnWHMqAGFZXAAnWgviDuMngYBBdjB+D3j0qDya1S5Mcx
         CmrUVKU2r7LDm+rylGfSlMOOiw6FkieF0X8nLNr08nqZzD+3ALTqoST1WFmnLsDEiP23
         U9qowCI530qEIIJ+k4+ZXSdVG7Qv1Y5qI+fmqXenoVVfReNcnMNxbXNlfQKzsQgtroWE
         KiY90lbtw6Vy2934NCHfcUo1xEEwd6Gq1roSJBWE9UUgdM/U//SoonSPsxT1meGQMhtC
         /BmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788558148; x=1789162948;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9sBsrXDWsA6mIM6eTb+x+9JskBQgNRQ7PhCpi14v3SQ=;
        b=mIzUv9bi5MlTAm3CqmKwu7KEr+L+oF35ra2WF9xalnf3mNH2qsEwj9sDcINJsf1GZJ
         BNeHa4pLEF6dupOhH4BYtOko08OrUeEfvlKtLdikeQbOTOp+ocKAGrdncHBcd0iwSOYc
         XrwvqMUMNV/c1Du4+2nAyNv9Z3El0n/p26zmHB0CBMJdmEk/2H5ZvTdWjQmHmuBlld0W
         mIjiOMK5FQ3+eeyu+O1FSg0dawzWuxY5J35NZqK0WUkwL1n8JosOCgRfptEn2qyLZ97a
         k6siAMftU1BnztESByjt48CH4VWyEKvXT5QihWO/ojhSdYnr/KyFHPrvRWFb6zqowqrC
         Rn9w==
X-Gm-Message-State: AFuF++n99KTCjLKgzUNOJwaCFFbewexLnHRgUZrSx1+B63xtulhrZEXN
	gcuUsHmcyXvU9knrWXhA2VZ+6SToL//jpCTQKzbvIzgOlcrlRegB6IPSVGWVfFRi8SdmheVVs2p
	aikdIwSsIBnyVE0r0h6SkFxxxnWiNTQbXN9tYgJg5j1/FZ61Wj+ReMvE=
X-Gm-Gg: AYBFou29atpBfF/VdT2fV06FhbjZg3vrhEooIWYqxH/3rsneizWo1kVgdXcGf+dGEVO
	adnbcUQhJ6o35rzLfGnZtm2rvHv89O+tR+UaULJ6UM31GjzppFlYh9L/XeshQI2G0/GgxQI5Ki9
	CPQQuhfaUwUvGNc9XXrXfjOFwS5L4vOv+nGhsqEH6/sBQ6mf1utXchhcOmJgvSTBpEVrwVrkNPZ
	q16+mlGC3mzGdIpT4UlJN3+Hq+PJjZ9T+V4S5L0saGE9LY0A5ys82kO3x59ei9PUjOm92T5MDlC
	dnvxUjKdDK1HoXUSskSynb1MtQ9gvCnXz9s8/BGQKPX+lNNibZ4e13qJXbRZvNX6ZBTdw5Uz2eN
	SvmW7eLJq8mQxg1CRm20RixhftX8dv51tDynFeDAJIy2pfZ9WlSHs
X-Received: by 2002:a05:6214:f25:b0:910:44f2:5ce3 with SMTP id 6a1803df08f44-91044f25d21mr48209936d6.8.1788558147685;
        Fri, 04 Sep 2026 14:42:27 -0700 (PDT)
X-Received: by 2002:a05:6214:f25:b0:910:44f2:5ce3 with SMTP id 6a1803df08f44-91044f25d21mr48209456d6.8.1788558147144;
        Fri, 04 Sep 2026 14:42:27 -0700 (PDT)
Received: from [10.207.49.22] (nat-128-59-177-158.net.columbia.edu. [128.59.177.158])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91043b54cd6sm18880636d6.34.2026.09.04.14.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 14:42:26 -0700 (PDT)
Message-ID: <7f70b59e-b1b5-452a-8a2b-d51392737a53@columbia.edu>
Date: Fri, 4 Sep 2026 17:42:25 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] mm: memcontrol: constify the memcg and lruvec stat
 readers
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
 <20260902-folio_memcg-const-v1-8-e2c1da22246d@columbia.edu>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-8-e2c1da22246d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: o41VUMBP0NyXCwOASBLltSHGT0jItu4k
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDIwMSBTYWx0ZWRfX3TUnn8kXJeqc
 NEPiW5997DHJprzQm401lAG96B82dknQ8Bl54JdM+rD6NRmKRnrqoU8YB7wYA2kUgsHBEnhm3qi
 b+/YQ88+8ufkrL/7SowBtywWHYnxMJeVUhWGBvCEPaWpWDx8UipY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDIwMSBTYWx0ZWRfX3wrfEqU4EAbg
 BBBa6FgtXFgeMo7j+TYqDvPOCUFnID3rxubHjfAzaT7ghsmqkmbjFz5BZhZ5jtcYpzCvwvdmR6k
 lvOsuaT71je1bgcPga0KdsJeTXApKiIRPY2wcBtvWIXwpVl2L4ie+jgOGChAz0zJEZ4kWJc6T2t
 j5iTQ/FmlYlwTI3jKeOpcRs3Uh0EyjWYvn1sbdTYF/B1YspFjcKVXkC445FKOpK6GznwiCi1Rwk
 BydPaL92Q0J9udZqk7+QVBw520cCN8bvaHeDeExwuzwEkKoyRkVPE9EwqSmNZSmb+jjzvbxr7Nx
 DBpRNWrH8Qw+LXCsM/aWud4nQCoryb8gZasMlGvyHD/wNJAKgrEg4twQBKR+xpEstXhCYLPW0u9
 tA27DEFGhhYgjZrVS992FVV+EoycHTgGsbBV7NIbP8qK7qVZQpI4VyTqsA70h3ptVxISlNFq1pu
 9nlyWmtWTcAWp4cXE+w==
X-Proofpoint-ORIG-GUID: o41VUMBP0NyXCwOASBLltSHGT0jItu4k
X-Authority-Analysis: v=2.4 cv=a4EAM0SF c=1 sm=1 tr=0 ts=6a9b3b44 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=tLges04aSNaZGVAfhBIy2A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=H57HtBtNAyM616LuGCcA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11896
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 adultscore=0 spamscore=0 phishscore=0 priorityscore=1501
 bulkscore=10 lowpriorityscore=10 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609040201

Responses to Sashiko below.

On 9/2/26 10:27 PM, Tal Zussman wrote:
> memcg_page_state(), memcg_events(), and the lruvec_page_state() family
> only read counters. Constify them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/memcontrol.h | 23 ++++++++++++-----------
>  mm/memcontrol.c            | 12 ++++++------
>  2 files changed, 18 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index bd82628d0d72e..10a197886f316 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
[ ... ]
> @@ -1392,19 +1393,19 @@ static inline bool memcg_vm_event_item_valid(enum vm_event_item idx)
>  	return false;
>  }
>  
> -static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
> +static inline unsigned long lruvec_page_state(const struct lruvec *lruvec,
>  					      enum node_stat_item idx)
>  {
>  	return node_page_state(lruvec_pgdat(lruvec), idx);
>  }

[Severity: Low]
Does passing the newly constified lruvec pointer to lruvec_pgdat() discard
the const qualifier?

Looking at lruvec_pgdat() in include/linux/mmzone.h, it does this:

	return container_of(lruvec, struct pglist_data, __lruvec);

This returns a mutable container from a const pointer, circumventing the
internal const-correctness the patch intends to provide. Should
container_of_const() be used here instead?

Answer:

lruvec_pgdat() purposefully returns a non-const pgdat, as some callers
still need one at the moment (node_page_state()).

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 35f924c9f2a31..3d3eadddc1307 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -489,7 +489,7 @@ struct lruvec_stats {
>  	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
>  };
>  
> -unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
> +unsigned long lruvec_page_state(const struct lruvec *lruvec, enum node_stat_item idx)
>  {
>  	struct mem_cgroup_per_node *pn;
>  	long x;

[Severity: Low]
Does the use of container_of() later in this function silently cast away the
const qualifier added to the lruvec parameter?

In lruvec_page_state():

	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);

This macro expansion discards the const qualifier, undermining the compiler's
ability to enforce const-correctness. Could container_of_const() be used here
instead, with pn declared as a const struct mem_cgroup_per_node *?

Answer:

Yes, this can use container_of_const(). Will change.

[ ... ]
> @@ -530,7 +530,7 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
>   * monotonically-incremented event counters are stored in
>   * enum node_stat_item.
>   */
> -unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
> +unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
>  					  enum node_stat_item idx)
>  {
>  	struct mem_cgroup_per_node *pn;

[Severity: Low]
Does this function also silently lose the const qualifier through
container_of(), similar to lruvec_page_state()?

In lruvec_page_state_monotonic():

	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);

Would it be better to use container_of_const() and a const pointer for pn
to preserve the safety guarantees of this patch?

Answer:

Yes, this can use container_of_const(). Will change.

> @@ -547,7 +547,7 @@ unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
>  	return (unsigned long)READ_ONCE(pn->lruvec_stats->state[i]);
>  }
>  
> -unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> +unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>  				      enum node_stat_item idx)
>  {
>  	struct mem_cgroup_per_node *pn;

[Severity: Low]
Like the other functions above, does container_of() discard the const
qualifier here?

In lruvec_page_state_local():

	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);

Could this be updated to use container_of_const() as well to maintain strict
const-correctness?

Answer:

Yes, this can use container_of_const(). Will change.
