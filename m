Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDDD35C69C
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 02:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789007373; cv=none; b=a0l/16fe+S2WopYSjiv4LlV5Tc+MPwonjI5YRqBnsLJUZ+Va3ZWm4R44B9G/Efy8Z3hPW6m/a3KTXF4V5YNR4RyQ/oLsFuTKGcm2CQ3eAhdEGSwyi4e9EFBKC901Go8Vt8P42Hwx8PBj94bnVUsqpMLxELURpmLD37FwyBxZWR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789007373; c=relaxed/simple;
	bh=Y/blbjutIcIhh1FZMIlhTaz3G2b1cjP6+5HZLeL4Xxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cyXQb6L94pbApbhoyhvUy1L/bZD1tdJWgzcz8jA1OdiuQNjXBB3JvpMl208Wloid5QQ7R1eZEdM5kNqFn9CuBc0+JSWh+WI74aqM5pU7pficL3T+VkqwCfU49mswHl9wZZKiHifZLtYPxN7A//P4wMBzIgYAClecNzbSSfJKKh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pssyfs5u; arc=none smtp.client-ip=95.215.58.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pssyfs5u"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Y/blbjutIcIhh1FZMIlhTaz3G2b1cjP6+5HZLeL4Xxc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789007368; v=1; x=1789612168;
 b=pssyfs5u/ge2qtdtQ5UewIqqERFFt2qdNLPX4iCPo7bLsQGuPr+wI4v9UkamJDRPt2BGgNHR
 dNzEfXty5Fm54+/jDJnRAbTch1eGYK9gsbA56rlixHczHruRctTYo1P9iJ5QlspfI65Aeb8t79h
 crxzbr3DgL5yWdnGb1ccxmJE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cbde5c5200df5b9a;
	Thu, 10 Sep 2026 02:29:28 +0000
X-Mizu-Trace-ID: cbde5c5200df5b9a
X-Migadu-Flow: FLOW_OUT
Message-ID: <bc8d46f4-4bdd-45b6-8c68-09a8b7556dc3@linux.dev>
Date: Thu, 10 Sep 2026 10:29:19 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v4 0/4] mm: workingset: fix the shadow node budget under
 MGLRU
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
 <20260908183733.ea115c9f8e6f88220d1b9b5b@linux-foundation.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20260908183733.ea115c9f8e6f88220d1b9b5b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


> On Tue,  8 Sep 2026 11:41:10 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
>> number of lru pages") broke the workingset shadow node budget under
>> MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
>> maintains, so count_shadow_nodes() sees the evictable LRU lists as
>> empty and the shadow shrinker reclaims eviction tokens almost as fast
>> as they are created, losing thrashing protection.
>>
>> ...
>>
>> Performance testing
>> ===================
>>
>> The test script and the raw results are available at [1].
>>
>> Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
>> configuration, medians reported.  Workloads:
>>
>>    w1-anon-churn: single-threaded anon fault/charge loop in a memcg
>>                   (MADV_DONTNEED + re-fault, no reclaim).  Every touch
>>                   is a real fault with charge and memcg stat updates,
>>                   so it stresses exactly the fast path patch 1 changes.
>>    w2-file-churn: file read loop under memory.high pressure
>>                   (reclaim-bound, noisier).
>>    w3-reparent:   reparent accounting sanity check.
>>
>> w1-anon-churn (pages/s):
>>
>>                   classic LRU          MGLRU
>> base             4393028              4377122
>> patches 1-2      4385996   (-0.2%)    4352887   (-0.6%)
>> patches 1-3      4381832   (-0.3%)    4377053   (+0.0%)
>>
>> w2-file-churn (MB/s):
>>
>>                   classic LRU          MGLRU
>> base             8277                 8226
>> patches 1-2      8226      (-0.6%)    8123      (-1.3%)
>> patches 1-3      8157      (-1.4%)    8294      (+0.8%)
> Am I misinterpreting this?  This difference is probably within
> inter-run variability?
>
You are reading it correctly.
The w2-file-churn differences are within run-to-run noise: it is a
reclaim-bound workload dominated by reclaim and I/O, which is too noisy
to expose the small fast-path overhead.
That is what the "within run-to-run noise" note in the cover letter
refers to.

The meaningful signal is in w1-anon-churn, which is designed to hit
exactly the fast path patch 1 changes: every iteration is a real fault
with charge and memcg stat updates, no reclaim involved.
There patches 1-2 show a consistent small overhead (-0.2%/-0.6%), and
patch 3 brings both LRU configurations back to the base level.

I can reword the cover letter in the next version to make this clearer
if you think it would help.

Best,
Hui

