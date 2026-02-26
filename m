Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6252E287510
	for <cgroups@vger.kernel.org>; Thu, 26 Feb 2026 06:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772088450; cv=none; b=X6CA6GCV4OM27ilyC0VuycoPjcvf0NOK49yMfAbAmX4U3p0e0v8I215t9u3QboGB7LCgy2qmKpmA/IavVQqpp+8p+F93vS4JJfWhqXGeWJfWqyeqQdWAn+9icfYlS7UUBNn0gJAf9sHAOYxJMgRnBRZn2ILPSNSzfll2zrpNNjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772088450; c=relaxed/simple;
	bh=DmGR01XygYwoda02GDK2aMgMZbHrZRSbhGPuqmsMP48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CnfHQNLBERxojS74LGbVtlf03X8H7bigVhwkyDimc/GeRc7qDocu+1MEpfAL9BTAtrbCYzWfq0MWk1ISXG4FMP51/CUIx2h5FvZ437b0PldOmenaqvUO1ENtwSebGokwOCCu7RehHcUMRgJVFaeopNlYpZCNW9dDrZwoWQuSwAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S12TlyhM; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S12TlyhM"
Message-ID: <6effce05-9a13-4991-8183-5e8187914c54@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772088447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fvIzD9WJtipjYeMRrpj/AGOaEvkByWxGuVy0TYOYU04=;
	b=S12TlyhMe1GbrxdO2P/PjyBRAFPl/RgOxwCuDYl2PXTlPFQ/8xaB2vjNd1UtgtDQB8H91e
	vSMGImE53Ms+r26I3v3k92+U7qfWwQo1UVhnCtIg3v3Mhqs7tyRqBPqe2SyE3nxYBHfthb
	mmA0HTmtZ4vyRIpigAqXpt8/fCaLK7w=
Date: Thu, 26 Feb 2026 14:47:14 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 30/32] mm: memcontrol: convert objcg to be
 per-memcg per-node type
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <0f915487ffc653cf6ea19335c21c01aa06004641.1772005110.git.zhengqi.arch@bytedance.com>
 <20260225094456.74145-1-qi.zheng@linux.dev> <aZ-uNV1biPYLhJ48@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aZ-uNV1biPYLhJ48@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2/26/26 10:27 AM, Shakeel Butt wrote:
> On Wed, Feb 25, 2026 at 05:44:56PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Convert objcg to be per-memcg per-node type, so that when reparent LRU
>> folios later, we can hold the lru lock at the node level, thus avoiding
>> holding too many lru locks at once.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> changlog:
>>   - fix a missing root_obj_cgroup conversion and completely delete
>>     root_obj_cgroup.
>>
>>   include/linux/memcontrol.h | 23 +++++------
>>   include/linux/sched.h      |  2 +-
>>   mm/memcontrol.c            | 79 +++++++++++++++++++++++---------------
>>   3 files changed, 62 insertions(+), 42 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 45d911dd903e7..6e11552a90618 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -116,6 +116,16 @@ struct mem_cgroup_per_node {
>>   	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>>   	struct mem_cgroup_reclaim_iter	iter;
>>   
>> +	/*
>> +	 * objcg is wiped out as a part of the objcg repaprenting process.
>> +	 * orig_objcg preserves a pointer (and a reference) to the original
>> +	 * objcg until the end of live of memcg.
>> +	 */
>> +	struct obj_cgroup __rcu	*objcg;
>> +	struct obj_cgroup	*orig_objcg;
> 
> The layout of struct mem_cgroup_per_node is very performance sensitive. Please
> couple of performance benchmarks after rearranging the fields particularly the
> above two pointers together at the start of the struct.

Got it, will try to do it. Additionally, it would be even better if
there were existing test cases available. ;)

> 
> Otherwise:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!


