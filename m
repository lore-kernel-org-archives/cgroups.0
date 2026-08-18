Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082CB377558;
	Tue, 18 Aug 2026 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787018018; cv=none; b=mKK2d4xbpZVWN0CAJa9XoQFbmN2ZR644A0EmF8a5JVoJF5LcHkC1ZYaA9i9ZgeCIG6eUO2S9/mytkdhRfAjfG6lWDYd3EautkkvtSWiZJnPiD+LIB2a8C1yMv63T/v9TncoeDrdlK7dSbYsdQ6aS4gOKchMnWUEqGYbuEm99sK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787018018; c=relaxed/simple;
	bh=0UYXK6BymdpKknPrzkNn0UNxNmcL/J3raMI16/7b+og=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RS2V+MJjyzB540+8Pi3IM3Kf7axVT1e7Ssl5nZSMbmePatXvq6nQf8FcHNBzP8YffVudkTApuwS5gdG61UQt74Qz3LGDwZaAlzkKby5Rub2bIqpADiwQ3XHpX5yQIMs4I1D3RmIpTWgj6SnOuecQBpTaxQJXDIuMxymiB6UrnFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 98f26d409aa711f19a56ed5b684f684d-20260818
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
X-CID-O-INFO: VERSION:1.3.19,REQID:3467a7b8-6acd-4bba-98ca-171a139c49ab,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:3467a7b8-6acd-4bba-98ca-171a139c49ab,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:82d02ce816d1a340e5eda7bf45feaeec,BulkI
	D:260817213154BZG2GML9,BulkQuantity:2,SF:17|19|64|66|78|80|81|82|83|101|10
	2|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 98f26d409aa711f19a56ed5b684f684d-20260818
X-User: husong@kylinos.cn
Received: from [192.168.110.173] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 839497270; Tue, 18 Aug 2026 09:53:24 +0800
Message-ID: <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn>
Date: Tue, 18 Aug 2026 09:53:10 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: husong@kylinos.cn, akpm@linux-foundation.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
 nphamcs@gmail.com, yosry@kernel.org, chengming.zhou@linux.dev,
 yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in
 obj_cgroup_may_zswap()
To: Shakeel Butt <shakeel.butt@linux.dev>
References: <20260817131843.45121-1-husong@kylinos.cn>
 <1787017182353556.21.seg@mailgw.kylinos.cn>
From: Song Hu <husong@kylinos.cn>
In-Reply-To: <1787017182353556.21.seg@mailgw.kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/18 00:04, Shakeel Butt 写道:
> On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
>> obj_cgroup_may_zswap() runs on every folio swapped out through
>> zswap.  For each ancestor with a non-max zswap.max, it flushes the
>> cgroup rstat hierarchy synchronously with force=true, which skips
>> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
>> with zswap.max configured, a container takes the global rstat lock
>> on every swapped-out folio.
> 
> Any reason you are limiting zswap through zswap.max?
> 

Mostly fairness on a shared pool: zswap.max_pool_percent is global
only, so on a multi-tenant host one cgroup's cold anonymous memory
can soak the pool and crowd out the others.  zswap.max is the only
per-cgroup control over that share; memory.max bounds the total
footprint, not the share of the pool.

>>
>> zswap_shrinker_count() had the same pattern and switched to
>> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
>> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
>> where the same flush on the shrinker side showed up at 2.88% of
>> kernel cycles under osq_lock on a 96-core machine.
>>
>> Measured on a KVM guest with a swap storm under a cgroup with
>> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
>> before the patch and 198,968 times after, while
>> __mem_cgroup_flush_stats() was entered 281,017 times before and
>> 80,445 times after.  The removed 200,572 flushes match the store
>> attempt count almost exactly; the remainder comes from other stats
>> readers in the swap path.
> 
> This is a known issue. Using ratelimited interface also comes with a drawback
> that the kernel may react on stale information and the consequences might be
> unneeded oom-kills.
> 
> There was orthogonal discussion on moving zswap limit enforcement away from
> rstat. Yosry, any updates on that?
> 

Fair point.  The direction I had considered is the benign one -
stale low after a burst of stores overshoots admission for a cycle.
But after a burst of writebacks the folded value can be stale high
too, and premature rejection with zswap.writeback off or swap.max
tight ends in a memcg OOM kill that accurate stats would have
avoided.  may_zswap() is admission control rather than a hint, so
the guarantee matters more here than for the shrinker side
of ea80da363a1f.

If moving the limit enforcement off rstat is happening, that
supersedes this patch and I am happy to drop it.  Otherwise it can
serve as a stopgap for the per-folio lock cost - your call, and
curious where Yosry's discussion stands.

Thanks,
Song

>>
>> The stats can now be up to one flusher cycle stale, so zswap.max
>> admission can overshoot for one cycle in a storm; the overshoot is
>> corrected as soon as the next flush lands and later stores see it,
>> the same tradeoff the shrinker side made.
>>
>> Fixes: f4840ccfca25 ("zswap: memcg accounting")
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>  mm/memcontrol.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 17da1f43b7d3..7a8f689055c6 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -6000,8 +6000,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
>>  			break;
>>  		}
>>  
>> -		/* Force flush to get accurate stats for charging */
>> -		__mem_cgroup_flush_stats(memcg, true);
>> +		mem_cgroup_flush_stats_ratelimited(memcg);
>>  		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
>>  		if (pages < max)
>>  			continue;
>> -- 
>> 2.43.0
>>

