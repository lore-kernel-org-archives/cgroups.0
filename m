Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53DD422E17;
	Thu, 16 Jul 2026 13:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784207501; cv=none; b=AyqqHrTc7emx56cv0qFHaWL9iFa2Zw2f0/I5xDgtFzCUN+kzj31Eg0rB8Xlej50BFjcj3B3tGnK+KZx8nV89pytEUnFRgUCz3Ya7sgla7OEkgQlBwUa9fAXsrZMZMjoKnEtnChr9znH6tHi1o1H1xdbEqVFa/K5wLEEIEh4DqVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784207501; c=relaxed/simple;
	bh=/VJ6X00vFsaKag60wTG5vOGDGXTzmB6+S5iXmjYd6IM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mN4mjGtdNHflryFooCA6JtL1jDasqRpMrxwXKfViuB2tXSWQuBu2noGoB8tP6ajkfRMZpwYp2EH4axbiz+OOwh2FTOfRF7Lgx5C3cl6kfL2a2MrBkvZcoC5eqXDOpaFfCBIxcJPJJV+xJl5gV/xR0pd5N56SYy+JQ3StCyWndDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D3lXAqmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D3lXAqmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869CA1F00A3A;
	Thu, 16 Jul 2026 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784207498;
	bh=Q12vl0zIPR6g9EKa3dbl/yhaJDA5a/mc7l/eMs+Jp4g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D3lXAqmkm9LZxqBEnAgaj/gtbAEP1YT9alV5H6p8v8KmeHneN63CTsqP9tzy8NQ2J
	 7K41AHKV9sZjCu5hYwNYrjxhegpeu+gjcvNSl1DlIlDyVC6AL5qnQi7YfM7i7hPQ2A
	 ZkH0YRmbYtEx5WGrU0J5OSBRYxBcyHL290F5+g32Mvia7QeE2muBXQtNVaCNx1cOsG
	 9It/Jo+88aaShrPMaSUdgsyhcnhaBGJ8XuiYoZLIghCCf/JgNFWr7NJMUswB7pzyFz
	 TlBdJc9kVpuRyVQpLqveNzD/DDF19NswZJj+XSSyOvn/hPfUi0/VB2L6F5XGiwWVW5
	 AkVxe/qBDepww==
Message-ID: <a8a0e540-414b-4174-a9f9-2c501fb46130@kernel.org>
Date: Thu, 16 Jul 2026 15:11:30 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9 v2] mm/memcontrol: Make memory cgroup limits
 tier-aware
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
 David Rientjes <rientjes@google.com>,
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
 <3ff8b23a-479d-46e8-b820-a23697587f01@kernel.org>
 <CAN+CAwPK4cW6k6LazZsbuvewswOwzM8VJgPvcg0jef7FwfF1qg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAN+CAwPK4cW6k6LazZsbuvewswOwzM8VJgPvcg0jef7FwfF1qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/11/26 22:03, Joshua Hahn wrote:
> On Mon, May 11, 2026 at 5:56 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/23/26 22:34, Joshua Hahn wrote:
>>> INTRODUCTION
>>> ============
>>> Memory cgroups provide an interface that allow multiple works on a host to
>>> co-exist via weak and strong memory isolation guarantees. This works, because
>>> for the most part, all memory has equal utility. Isolating a cgroup’s memory
>>> footprint restricts how much it can hurt other workloads competing for memory,
>>> or protects it from other cgroups looking for more memory.
>>>
>>> However, on systems with tiered memory (e.g. CXL), memory utility is no longer
>>> homogeneous; toptier and lowtier memory provide different performance
>>> characteristics and have different scarcity, meaning memory footprint no longer
>>> serves as an accurate representation of a cgroup’s consumption of the system’s
>>> limited resources. As an extreme example, a cgroup with 10G of toptier
>>> (e.g. DRAM) memory and a cgroup with 10G of lowtier (e.g. CXL) memory both
>>> appear to be consuming the same amount of system resources from memcg’s
>>> perspective, despite the performance asymmetry between the two workloads.
>>>
>>> Therefore on tiered systems, memory isolation cannot currently happen, as
>>> workloads that are well-behaved within their memcg limits may still hurt the
>>> performance of other well-behaving workloads by hogging more than its
>>> “fair share” of toptier memory.
>>>
>>> Introduce tier-aware memcg limits, which establish independent toptier limits
>>> that scale with the memory limits and the ratio of toptier:total memory
>>> available on the system.
>>>
>>> INTERFACE
>>> =========
>>> This series introduces only one adjustable knob to userspace; a new cgroup mount
>>> option “memory_tiered_limits” which toggles whether the cgroup mount will scale
>>> toptier limits. It also introduces 4 new read-only sysfs entries per-cgroup:
>>> memory.toptier_{min, low, high, max}.
>>>
>>> The new toptier memory limits are scaled according to the amount of toptier
>>> memory and total memory available on the system as such:
>>>
>>> memory.toptier_high = (toptier_mem / total_mem) * memory.high
>>>
>>> For instance, on a host with 100GB memory, with 75G toptier and 25G CXL, the
>>> “toptier ratio” would be 75 / 100 = 0.75. A cgroup with the following memcg
>>> limits {min: 8G, low: 12G, high: 20G, max: 24G} might see toptier limits scaled
>>> at {min: 6G, low: 9G, high: 15G, max: 18G}.
> 
> Hi David!!
> 
> It was great seeing you at LSFMMBPF. I didn't get a chance to have a
> conversation with you at Zagreb but hopefully I will be less shy and say
> hello next conference : -)

Sorry for the late reply :) Yes, hopefully talk to you in person next time!

> 
>> Assume you have a bigger hierarchy (HBP, DRAM, CXL), or assume you have multiple
>> NUMA nodes with a hierarchy each.
>>
>> Your proposal doesn't really seem to be very versatile, or am I wrong?
> 
> Let me address these comments separately!
> 
> First, for the multi-numa-per-tier case, I think this is already pretty well
> handled by my series. Once we realize that a memcg is consuming too much memory
> from a tier, we trigger reclaim from that memcg via
> try_to_free_mem_cgroup_pages,
> which as far as I can tell already handles the multi-numa per memcg case.
> Other than restricting the scan_control's nodemask to target the nodes
> from that tier, I don't think there's anything else to be done.

I am not really sure about the "toptier" notion, in particular if your memory
hierarchy is not static.

Imagine that you have only DRAM in your system. Then you hotplug some slow CXL
memory. The you hotplug some HBM CXL memory.

The meanting of "toptier" changes, which is rather confusing to me.

> 
> Next for the 3+ tier case, I think this is a lot more scalable than it seems
> at first. This series depends on another RFC that I sent out [1],
> which pushes the concept of "stock" from memcg to page_counter, which means
> that it is more scalable to just add more page counters to each memcg.
> This means that each tier would just need another page_counter to track its
> memory usage, and we trigger selective reclaim on the tier that is being
> targeted via the scan control nodemask we introduce in this series.
> 
> At my talk in LSFMMBPF, Usama noted that the user-visible API should probably
> remain the same, no matter what. The way I have currently established the
> memcg files aren't really scalable, so Usama suggested turning the
> "memory.toptier_XXX" sysfs files to "memory.tiered_XXX", which would include
> a newline-separated / space-separated list of per-tier limits. Something like:
> 
> $ cat memory.tiered_max
> tier_0 20971520
> tier_1 31457280
> ...

memcgs are currently not NUMA aware, so this could be one possible direction.

But is "tier" the right abstraction? I really don't know.

Are tier numbers really what we want? I don't know.

We'd really need some feedback from memcg folks.

> 
> So we have a way to make both the user-facing side stable, and the internals
> also more scalable.
> 
> With that said, I've opted to leave the internals to 2 tiers for now -- I think
> it is not too late to add the generalization series when we start seeing
> 3+ tier systems out there in the wild. My goal was to introduce tieredness,
> and we can work towards generalization in a future work.
> 
> On that note, it seems like in general mm is aware of 3+ tiers, but most of the
> existing work revolves around distinguishing between toptier/everything else.
> I got this impression from reading mm/memory-tiers.c -- but please feel free
> to correct me if you feel like I have the wrong idea here : -)

I assume you're right, but it's something different if we end up providing a
proper memcg API towards the users.

> 
> So perhaps the generalization work would benefit from first introducing more
> general tier awareness (not just toptier vs. rest) in memory-tiers.c.
> 
> What do you think? Does this approach of introducing toptier restriction for
> now, and then generalizing in future work make sense to you?

I'd suspect that we'd want to support multiple tiers from day one -- especially
get the interfaces right.

-- 
Cheers,

David
