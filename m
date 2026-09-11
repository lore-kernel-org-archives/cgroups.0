Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211F0235BE2;
	Fri, 11 Sep 2026 03:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789096773; cv=none; b=kuWkr0wBLWD2nZfr73pCQEKd2hdWD4/5ssbfbgu6JcozQ07vnaAQLiqNS/Vonc6w4gB9rBLog3FIEMZkwou0uiV1DVcTEmRg4TEKi0JrFxnxcjb0fRkx1SdV8OZgxqfpmcuKMS1qkugkixl6Thrbsa3EUi1c58Gr2yXwaX84uJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789096773; c=relaxed/simple;
	bh=dzgN+X5DGPRIiE/+fRHu+sZLC7g+kAlktEOlXZPYDRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dQI458YO84hUWC8ohNTcCkkDxOOfqgOV6Spi6STuKLBkQUs/uIHh0a1aiiS3BO2LdTW128egd9VhBB+Vcb+SSmh6YvW4Bsydh48XTXxGDun3TmFKd5PqlZcb0sSecuzPBxW2nkRVAnuCuwDPWtau20Cx4ypUYRuZCbZe0m9az+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TsOzOO6g; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TsOzOO6g"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789096761; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lHye6fXV6O0BwmOSmMkNW8tisA69YmRVUOPP9SEpvNM=;
	b=TsOzOO6g1o3cbXVRFCH+nDpNjrJT9fzsKuQ0xzluO8j4DTuF1G/62LLdX4GcIGfStujdoWmElrDwqvL1PoYFYCJ483zAMAjPDAQ7ApdC2BiF4dboo5xUfN5bQ5Efti2TAJOKqYGmcZQ9aVJ0wgckC8q1yokqZPZQQ1w6kW4L6QM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XAj1PlA_1789096757;
Received: from 30.178.68.86(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAj1PlA_1789096757 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Sep 2026 11:19:19 +0800
Message-ID: <0b1ddfea-4c1b-4726-8a63-abe44edbea66@linux.alibaba.com>
Date: Fri, 11 Sep 2026 11:19:16 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: memcg: settle memory.high debt after THP faults
 with non-blocking gfp
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Xunlei Pang <xlpang@linux.alibaba.com>, "Liam R . Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Chris Down <chris@chrisdown.name>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
 <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
 <6B46E8DF-679B-4254-A4AF-7B992B0F6460@nvidia.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <6B46E8DF-679B-4254-A4AF-7B992B0F6460@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/26 11:10 PM, Zi Yan wrote:
> On 3 Sep 2026, at 23:54, Qinyun Tan wrote:
> 
>> Anonymous THP faults happening in a kernel loop that does not return
>> to userspace -- the populate loop of a single mlock() call, or any
>> GUP-driven population -- can drive a memcg's usage from memory.high
>> all the way up to memory.max with zero reclaim and zero penalty
>> sleep.
>>
>> This defeats the containment memory.high is supposed to provide:
>> above high, the documented promise is that "the processes of the
>> cgroup are throttled and put under heavy reclaim pressure", and
>> userspace OOM handlers (oomd, Kubernetes) rely on the high..max
>> buffer as their reaction window.  Only after hitting memory.max does
>> the non-blocking charge fail, THP fall back to 4K, and
> 
> Why not force THP to fall back to 4KB when memory.high is reached?
> If reaching memory.high means the processes are under heavy reclaim
> pressure, I do not think it is reasonable to give any more THP.
> 

Hi Zi Yan,

Thanks for the review.

I think you're right that this is a policy question. Falling back
to 4K at memory.high is also workable -- it would even be simpler,
and the existing fallback machinery would take care of the rest.
I picked settling the debt mainly to keep memory.high a soft limit
for all folio sizes, but I don't feel strongly about it. 

I'd be curious to hear what others think here -- happy to rework the
series either way.
