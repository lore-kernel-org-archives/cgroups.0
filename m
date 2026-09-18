Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFCE36B918;
	Fri, 18 Sep 2026 03:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789702609; cv=none; b=lDd70LhDEahvh2ss8/JABkfzFyzcdxjThwo8VTDYCiU8x+IbtECBTTnNh60dcJ/U9Q0Tb2nEZjv+em3gpDpT1r8myLMz6y7xiEhIuQLKfBB0Ej2JL5WwrXg/rGirej+u5LhUY+6KDp56gJ53m6QIm/cAupNNuuG0h5D1qHWM2eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789702609; c=relaxed/simple;
	bh=7SRUDjHVlFq/XtjwKeAdhlDkeFdcP/gVV2vWBIupXu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=naxf7o/MuQCOKQuQp7b+MdMNJeFkXNxUiIFN0IPArEZ3brN+9+sSzlSSoo2XhcYpksJcEp5ashWRvbh8p+XK7QHLPxr+WK6lXS3NJDiz11FBIFoHMgi3BD0wzKDaxu+vDZe7Jy4CTrIqM3AwU6Ss3wktNaUP8Enzqia3gCnWSHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xzdmggnj; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xzdmggnj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789702601; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=c5IgYQhJIaLET5VUZswXngb8vhELaOWEAGHyCwS5Ja8=;
	b=xzdmggnjpDGFP1hhDpwq5MKvzMjFIVUOQNKq6u7r/Dldn2xKYRCC2NxXj7Pn3Qep0AlqEQA7EGjHqnzblapwKRBd62VBQxPa8dSnCsEPtAH1cfW7l29tw9MIu4/UXFYrIwe3uxTsO8flSAz/NO7/rVRJE9pv2P3owMNYbXETSVQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XB9qv0d_1789702593;
Received: from 30.178.69.151(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XB9qv0d_1789702593 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:36:39 +0800
Message-ID: <c875638e-d14d-4237-9824-57d6c0f4a2ef@linux.alibaba.com>
Date: Fri, 18 Sep 2026 11:36:33 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: memcg: don't hand out large folios above
 memory.high
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 xlpang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, chris@chrisdown.name,
 kasong@tencent.com, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
 <20260915042546.279410-2-qinyuntan@linux.alibaba.com>
 <aqx5kcqRrbkuay4i@linux.dev>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <aqx5kcqRrbkuay4i@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/18/26 9:26 AM, Shakeel Butt wrote:
> On Tue, Sep 15, 2026 at 12:25:46PM +0800, Qinyun Tan wrote:
>> memory.high is enforced on return to userspace, and synchronously in
> 
> Over time I feel like this sync throttle for memory.high was a bad decision but
> that is an orthogonal discussion.
> 
>> try_charge_memcg() for large overcharges, but only when the charge gfp
>> allows blocking.  A populate loop - mlock(), MADV_POPULATE_*, any
>> GUP-driven population - never returns to userspace, and large folios are
>> charged with the THP allocation gfp, which does not allow blocking under
>> the default defrag=madvise without MADV_HUGEPAGE, nor under defrag=defer.
>> So neither runs: usage grows from memory.high straight up to memory.max
>> with no reclaim and no penalty sleep.
>>
>> mlock(200M) in a cgroup with memory.high=30M and memory.max=140M.  Of the
>> 110M between high and max, the burst consumed:
>>
>>   4K pages                       3M in 5s, then still throttled
>>   THP, defrag=always             6M in 5s, then still throttled
>>   THP, defrag=madvise          110M in 13ms, then OOM killed at 16ms
>>   THP, defrag=madvise, patched   3M in 5s, then still throttled
> 
> I don't really like polluting non-memcg MM code with memcg internal details.
> Let's first discuss the semantics we want here. Please tell why getting
> oom-killed by kernel in the scenario you have described (mlock() larger than
> memory.max) is wrong. How does throttling it will help? What can the external
> observer (userspace oom-killer) do other than killing it? Or you are thinking
> that the workload itself is observing itself and change the behavior (though
> the big mlock one can't do anything).
> 
> What I am looking for is the real use-case you have for this case. Not
> mlock()ing big chunk or creating a lot of unreclaimable memory and going over
> memory.high. For example the reason I added the sync throttle in memory.high was
> to implement a feature Google has in their internal kernel where a workload hits
> its memory.max limit, kernel delays the kill for couple of seconds and during
> that time, the node controller may decide to increase the limit based on the
> memory situation of the memory. However even with sync throttle, we couldn't
> reliably implement the alternative because applications there have thousands of
> threads and there is threading library which keeps cloning more threads if it
> observes threads getting throttled.
> 
> So, let's talk about some real use-case and then we can decide if throttling
> makes sense here. If we decide to allow throttling in such cases, I would rather
> do it in memcg code i.e. somehow inform memcg code that this is THP allocation
> and can be throttled.

Hi Shakeel,

Thanks for the detailed review.

Honestly I don't have a real use-case. I ran into this while testing THP
under memory.high, so it's a semantic inconsistency I noticed rather than
a workload I'm fixing. 

The thing that seemed off is just that memory.high enforcement depends on
the folio order the workload happens to fault in - order-0 gets
throttled, THP under the default THP settings doesn't - which the user
has no control over. 

I don't have a firm view on the right semantics here either, and I think
you're right that that's the thing to pin down first. Whether the
order-dependence above is worth doing something about, or whether it's
acceptable for large folios to skip memory.high, I don't have a strong
opinion on - I'm happy to go with whatever the discussion settles on, and
if it's working as intended, that's just as useful to know.

And if it does turn out to be worth throttling, I'd be happy to rework it.

Thanks,
Qinyun Tan
