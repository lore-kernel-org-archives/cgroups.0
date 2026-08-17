Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AD541F5CD;
	Mon, 17 Aug 2026 12:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786971578; cv=none; b=AVcoDi+w15vyaCcFXQ/obUhZS/qEEfhp38qNWhv8xkbpA9GtUnB4YJxIs7M1sabImiJdzaCrjFjtGWXlrH722YoCypFpT17PSCiGl+KiIqGiQ2sUyCNmZXTATOGsYJlheqEXUVXgc/cR1xVdmBHyysulW9460jNLadPwWnuUURs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786971578; c=relaxed/simple;
	bh=Yo1Z0JZli7rF4OUHnYRLbA2ODQbbCNCUVli+mHdLH68=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZbOo6/75JEfdXuCBkaTOslqyTjWLkuyMqZlPoG5l5lpX24p3unWDoBHoBrVprmrzxbWuZEMOzKYcP800BgiJXpq9OfEIFxnX/10HV+f1C23gI0tLHzyjR1MnKMbrcY+BB/zvxoxBaYV3ads67+QKsP9efVkd0ko7Tm0au0uTdnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 78d2afd29a3b11f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:20c77bfc-890c-454f-b469-44eaec05df7f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION
	:release,TS:18
X-CID-INFO: VERSION:1.3.19,REQID:20c77bfc-890c-454f-b469-44eaec05df7f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION:r
	elease,TS:18
X-CID-META: VersionHash:7db8b62,CLOUDID:9d44d1eae9543b53943c25c0b960a562,BulkI
	D:260817111225XMIBG1F7,BulkQuantity:6,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:40|20,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FCD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 78d2afd29a3b11f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1916834942; Mon, 17 Aug 2026 20:59:24 +0800
Message-ID: <64e6f737-292f-4678-a1c2-aca95cfb672f@kylinos.cn>
Date: Mon, 17 Aug 2026 20:59:17 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, akpm@linux-foundation.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, zhuhui@kylinos.cn, joshua.hahnjy@gmail.com,
 audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
To: Matthew Wilcox <willy@infradead.org>
References: <20260817025917.66233-1-husong@kylinos.cn>
 <aoJ83tk7R1x3Jul-@casper.infradead.org>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <aoJ83tk7R1x3Jul-@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

在 2026/8/17 11:15, Matthew Wilcox 写道:
> On Mon, Aug 17, 2026 at 10:59:17AM +0800, Song Hu wrote:
>> refill_stock() takes a css reference for each cached memcg slot and
>> mem_cgroup_css_offline() relies on drain_all_stock() to release those
>> references before the cgroup can finish dying.
>>
>> consume_stock() can drive a slot's nr_pages to zero while its cached[]
>> pointer stays set.  is_memcg_drain_needed() skips such empty slots, so
>> the offlining drain is a no-op for them: the pinned css reference is
>> released only if the slot happens to be evicted by later unrelated
>> charges on the same CPU, or by CPU hotplug.  The memcg then lingers
>> in the dying state indefinitely.  On a CPU with container churn, a
>> per-cpu stock can pin up to NR_MEMCG_STOCK (7) zombie memcgs.
>>
>> The sibling obj_stock_flush_required() has no such gate: a cached
>> objcgs slot is flushed regardless of its byte count.  Drop the
>> nr_pages gate from is_memcg_drain_needed() accordingly.  Draining an
>> empty slot is a single css_put() and a NULL store, and it happens at
>> most once per slot per drain, so the extra work is negligible.
>>
>> This is easily reproduced with short-lived cgroups pinned to one CPU:
>> 12 charge/exit/rmdir cycles leave nr_dying_subsys_memory at +2, stable
>> across later slot displacement.
>>
>> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  mm/memcontrol.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 17da1f43b7d3..b931ec16bb82 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2291,8 +2291,12 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>>  		if (!memcg)
>>  			continue;
>>  
>> -		if (READ_ONCE(stock->nr_pages[i]) &&
>> -		    mem_cgroup_is_descendant(memcg, root_memcg)) {
>> +		/*
>> +		 * An empty slot still pins a css reference which
>> +		 * mem_cgroup_css_offline() relies on drain_all_stock()
>> +		 * to release.
>> +		 */
> 
> I don't think the comment adds any value.  It explains why something
> _isn't_ there which makes no sense to someone reading the code.
> 
Fair enough, will drop it in v2.

Thanks,
Song>> +		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
>>  			flush = true;
>>  			break;
>>  		}
>> -- 
>> 2.43.0
>>
>>

