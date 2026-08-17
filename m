Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B08411A18;
	Mon, 17 Aug 2026 13:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786971740; cv=none; b=FAkGAwB7J++17Ro+RsddAVwdzl+Sg08mcHkLTPf30nlYEV+p5np+KniaMW1a3bxnjhqgT5c2hJMndwKBteObPY0PleyIQg9i17NTDdPXxC4zcdmCMLGiiaBviPveCFnO2Ovf2eIwALRgjgGlIImvAshb43GdhW/l2J/mQyep5sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786971740; c=relaxed/simple;
	bh=rDwDzaH9ga9h6VMJLEs3CaeZ1KA2QyWTuyuASeON+7E=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ExpEzXKq7ZwPo7f2aYYivYXj5AZJsJYx4JQ503LBDeiDkDVHUzikyRPil7UiEmqkF+Uz/OJE1h7gQRwJr3lBl7YrFqY96crOtFJ9FcrzFxwm/fW4IwdysebLw2uQmTi9wwH5ZLyh+pyaEcKNk0bESwVKwE0sLhU6lEXbebo8bFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: daa4eee69a3b11f19a56ed5b684f684d-20260817
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
X-CID-O-INFO: VERSION:1.3.19,REQID:1e554df8-a0d1-463f-a140-bac16303b300,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION
	:release,TS:18
X-CID-INFO: VERSION:1.3.19,REQID:1e554df8-a0d1-463f-a140-bac16303b300,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION:r
	elease,TS:18
X-CID-META: VersionHash:7db8b62,CLOUDID:51fdd7f7051a8035206c84856aaa31a4,BulkI
	D:260817111225XMIBG1F7,BulkQuantity:7,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:40|20,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FCD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: daa4eee69a3b11f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 500632610; Mon, 17 Aug 2026 21:02:08 +0800
Message-ID: <ab77cf2c-0549-4e93-87c6-863a4bebf0e5@kylinos.cn>
Date: Mon, 17 Aug 2026 21:02:03 +0800
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
 muchun.song@linux.dev, zhuhui@kylinos.cn, audra@redhat.com,
 bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
To: Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20260817043047.1553572-1-joshua.hahnjy@gmail.com>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <20260817043047.1553572-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, 

在 2026/8/17 12:30, Joshua Hahn 写道:
> On Mon, 17 Aug 2026 10:59:17 +0800 Song Hu <husong@kylinos.cn> wrote:
> 
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
> 
> Hi Song,
> 
> I feel that this above statement is quite misleading.
> Scheduling a drain on a memcg that doesn't have stock eventually
> performs a drain operation on every memcg cached in that CPU.
> 
Right, I missed that drain_local_memcg_stock() flushes the whole
stock, so an unrelated charge below a dying memcg would throw away the
other slots on that CPU.  Will drop that claim and the objcg
comparison from the changelog; the objcg side has no reference to
release from the stock, so there is no symmetry to argue from.

> drain_local_memcg_stock
>   drain_stock_fully
>   {
>     for (i = 0; i < NR_MEMCG_STOCK; ++i)
>       drain_stock(stock, i);
>   {
> 
> Sure, for any empty stock during this iteration drain_stock is trivial,
> but for nonempty stock that happen to co-exist on the CPU, it's forcing
> a cache miss on the next charge.
> 
> The problem that you note does seem quite real though. I think a less
> invasive solution could be something like
> 
> if (mem_cgroup_is_descendant(memcg, root_memct) &&
>     (READ_ONCE(stock->nr_pages[i]) || css_is_dying(&memcg->css))
> 
Will do.  The ordering works out: kill_css_sync() sets CSS_DYING
before css_offline is queued, so css_is_dying() is already true when
mem_cgroup_css_offline() calls drain_all_stock().
> By the way, I think the argument that "obj_stock_flush_required has no
> such gate so is_memcg_drain_needed doesn't need one too" is also not
> really correct since a dying objcg doesn't flush anyways. 
> 
Thanks,
Song> I hope you have a great day,
> Joshua
> 
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
>> +		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
>>  			flush = true;
>>  			break;
>>  		}
>> -- 
>> 2.43.0

