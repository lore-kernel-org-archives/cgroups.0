Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42052E7162
	for <cgroups@vger.kernel.org>; Wed, 21 Jan 2026 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768994775; cv=none; b=iwl27krBzxh+zz1r/imZceNFu0g5AfguomukX1O3SRdT58j80zS3uP3OFtsOYZXKfIeir6h8ldrNp5bCBrNe+OIUQ6NJ8Yheh6TIHlZ6GvzPVCHJHAZzPMO0YWoS4KdyABsbB161eKvDrhQL14qHVMpChWHaEUp+isspRD6UhTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768994775; c=relaxed/simple;
	bh=XJuFQG6tROVPxmopmKhhnYJFcbZUPiSyMXwpEqQ5REA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YCwGRxaQmLkL9ZQawbRRNvKdscP502OMJcfKFA7zvPb2jt54I5Z8fRmNaSbGNB/9b+T2EtbggW0IUlIuX0KsycV/Wwgd7ITgALCRvpFX3nOJL3EJosoN6I+QyZKXMA6KOJQlEyR6oLwHPdP4oyWR0LU5thv/B2XgvYZnDH0FRko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bTZV01Al; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bTZV01Al"
Message-ID: <7c49e382-9f67-4a49-a884-47c96ab348d5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768994771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EI3PnO2ne3zU35Poebf9UA7r2AUkoJbbfNXfGukOLUk=;
	b=bTZV01Ali7NQ0Pn3QESP2LOgMVmYpkdVmP4rBR66PxR0itj/VUlFqvpJ/itCWXVTp/Yjly
	hYcwvqrg6rdDvmyZPbRY5TWkftQgGasc9tH1Qb4lQUX49dDOldHGUpXA0Me9bIi2XY0TRB
	lcUlt1qpotSi4uKtUn0n4jB/d1Kw/5o=
Date: Wed, 21 Jan 2026 19:25:39 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
 <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
 <5a18658e-2076-4cbf-bc53-5b6e99c1035f@linux.dev>
 <A13923AA-8200-4863-8080-EC4B254BA3AA@linux.dev>
 <moupi2ch2cpuyrurthk66igh275ks62pltjk2zfngxozj52oxs@64lxvcgh3ays>
 <37734a82-1544-4015-b4dc-30583441a7ba@linux.dev> <aXCIsLQMSdQ2GNc4@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aXCIsLQMSdQ2GNc4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 1/21/26 4:20 PM, Shakeel Butt wrote:
> On Wed, Jan 21, 2026 at 11:43:50AM +0800, Qi Zheng wrote:
>>
>>
>> On 1/21/26 2:47 AM, Shakeel Butt wrote:
>>> On Tue, Jan 20, 2026 at 03:19:00PM +0800, Muchun Song wrote:
>>>>
>>>>
>>>>>> No reparenting local stats for v2.
>>>>>
>>>>> It seems that lruvec_stats->state_local (non-hierarchical) needs to be
>>>>> relocated in both v1 and v2.
>>>>
>>>> Here we might need to elaborate a bit. Specifically, in the function
>>>> `count_shadow_nodes`, the use of `lruvec_page_state_local` to obtain
>>>> LRU and SLAB pages seems to also require these logics to work correctly.
>>>> For SLAB, it appears that the statistics here have already been
>>>> problematic for a while since SLAB pages have been reparented, right?
>>>>
>>>
>>> Thanks a lot, now it is clear and yes it seems like SLAB is problematic
>>> but now I am wondering if it is really worth fixing. For LRU pages, how
>>> about using lruvec_lru_size() defined in vmscan.c. That would at least
>>> keep count_shadow_nodes() working irrespective of LRU reparenting.
>>
>> Do you mean calling lruvec_lru_size() in count_shadow_nodes()?
> 
> Yes but I am mainly brainstorming. We can keep the reparenting local

OK, I will take a closer look.

> stats for both v1 and v2 for now as it is not a performance critical
> path. I am more worried about the stats update path where upward
> traversal of memcg for CSS_DYING can be costly and I don't want that in
> v2.
> 
>> But
>> numa_stat interface also reads lruvec_stats->state and make it visible
>> to the user.
>>
> 
> Not sure how this is relevant.

My mistake, please ignore it.

Thanks!


