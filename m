Received: from mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CFC4B1B5E
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 09:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790069944; cv=none; b=PoKeDN2plOckYpR8bqGPcrQywEcwGGpJWsFyHKCgr5Ow0GiWSkTaB7M6FOfPM/jJIHNiHFm6hm41ea1kAW1gMxiYjx+2Iq/AFTKxWaf+CC2HHn08aeKfBX0gC1oDT51NHgyIyFfwsCW2u73TKSjTELk/0KaGQLrW+Qq8fMVKEOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790069944; c=relaxed/simple;
	bh=hi1vDGEifONMUPQI29D6K7Rz4VLkNWGHmR08F4W6XWs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qQOOgfS0flGk0ayCMGn1lJff9RA6YTbBi4puEg9cnF95Rgq71XKHDL+PsvnflnUK2yN6vaViKRDqw3n7bHskBWfwZe7uGk/ugR5UeYA51vHIbqe3DLhgUo5YimVmyn3Oz73sz34jQLWdUFp/6gcb7Dy/jfwqWJrtQToz1kvGQ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cASNak4y; arc=none smtp.client-ip=95.215.58.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cASNak4y"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hi1vDGEifONMUPQI29D6K7Rz4VLkNWGHmR08F4W6XWs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790069939; v=1; x=1790674739;
 b=cASNak4ysuWjNi33n5bSDcBdcWis2zVS9qvdGrVjHVup11L/H4Fy2JLJIERrGeYANXz8CszW
 oLautxEeyd2Gjpi4VrSY37vqwZe2ZMcT5H+QQ91vdpC6IbVWed6Etmxj5X9apohdoXYrE+Gj8TE
 q0+yoU3mYLQ4aBgDeLCnyNpw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9d2428c7de0bd619;
	Tue, 22 Sep 2026 09:38:59 +0000
X-Mizu-Trace-ID: 9d2428c7de0bd619
X-Migadu-Flow: FLOW_OUT
Message-ID: <d9c97d83-f29b-440c-9385-47d13afc38f3@linux.dev>
Date: Tue, 22 Sep 2026 17:38:51 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
To: Muchun Song <muchun.song@linux.dev>
References: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
 <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
 <B710AD66-B826-4138-B1D4-2DB3E00FDC1D@linux.dev>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <B710AD66-B826-4138-B1D4-2DB3E00FDC1D@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/22/26 2:18 PM, Muchun Song wrote:
>
>> On Sep 21, 2026, at 17:12, Hongfu Li <hongfu.li@linux.dev> wrote:
>>
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
>> stats. These stats are accounted against folio_nid(): incremented on
>> the folio's node when handed to a user, decremented when the folio is
>> returned to the pool.
>>
>> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
>> to the new folio and drops the memcg data of the old one, so the free
>> of the old folio right after the migration skips the memcg per-node
>> lruvec decrement. The hugetlb count stays attributed to the old node
>> for the rest of the life of the charge, while the target folio gets no
>> increment on the new node; its later free decrements a counter that
>> was never incremented.
>>
>> Migrate the per-node lruvec accounting alongside migration. Global
>> memcg totals remain balanced because they track resource consumption,
>> not node placement.
>>
>> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> ---
>> mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
>> 1 file changed, 31 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1460cba53588..9c96ebd5436f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5598,6 +5598,34 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>> rcu_read_unlock();
>> }
>>
>> +#ifdef CONFIG_HUGETLB_PAGE
>> +static void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
> Actually, we don't need this objcg parameter since we could get it from folio.
> And I'd like to move this function to hugetlb.c.
>
>> +     				struct folio *old, struct folio *new)
>> +{
>> + 	long nr_pages = folio_nr_pages(old);
>> + 	struct mem_cgroup *memcg;
>> + 	int old_nid = folio_nid(old);
>> + 	int new_nid = folio_nid(new);
>> +
>> + 	if (old_nid == new_nid)
>> + 		return;
>> +
>> + 	rcu_read_lock();
> Please use guard(rcu)() to simplify the code a little.

Hi Muchun,

Thanks a lot for your suggestions. I will drop the objcg parameter of
move_hugetlb_lruvec_stat(), move the function to mm/hugetlb.c, and use
guard(rcu)() in it.  I will post a v2 for review shortly.

>> + 	memcg = obj_cgroup_memcg(objcg);
>> + 	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
>> +       		NR_HUGETLB, -nr_pages);
>> + 	mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
>> +       		NR_HUGETLB, nr_pages);
>> + 	rcu_read_unlock();
>> +}
>> +#else /* CONFIG_HUGETLB_PAGE */
>> +static inline void move_hugetlb_lruvec_stat(struct obj_cgroup *objcg,
>> +    					struct folio *old,
>> +    					struct folio *new)
>> +{
>> +}
>> +#endif /* CONFIG_HUGETLB_PAGE */
>> +
>> /**
>>   * mem_cgroup_migrate - Transfer the memcg data from the old to the new folio.
>>   * @old: Currently circulating folio.
>> @@ -5635,6 +5663,9 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
>>
>> 	new_objcg = get_migration_objcg(old, new);
>>
>> + 	if (folio_test_hugetlb(old))
>> + 		move_hugetlb_lruvec_stat(new_objcg, old, new);
>> +
>> /*
>> * @old was charged through a non-root objcg, so its charge is in the
>> * page counters. If the re-derivation walked up to the root objcg -
>>
>> -- 
>> 2.54.0
>>
-- 
Best regards,
Hongfu

