Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792644737;
	b=TUrG7Asks46hrrJRMaBfVBo3tmXI8doeWHTbdWboW6eYkRu/G5z2Z1DYgYYSdy58v2Pr
	 z7MR4EHGBO/3p/B0DfqajlRp2VvklkNQWjgnGxdh0aHXUhSb1n6pkUK1iBTXgTUJ+bRYt
	 OQg5r66tWJnMP6ldZNxW5CaKu2BCMRVd+6FhMO/cgFXpohpxXN1kRU1jBY3+lDXRRYfz7
	 5BN0OEecYRONtFjKfYNI3k0FgGHyWAAT/7RBt60ov3+WeWAIredWFeCGwxlq7eoqQcOAJ
	 9aIUsz/ZS7yrmBMnH05anYXWr8FBTS8eJlYuPO9VDvtfVatLD77kVGPY+nab8ffre/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792644737;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=aKmRIxZbD0nMDMPI/mEiihjsp8gY8MgQFkQF67TPGtQ=;
	b=JNOtWmsupwJl4ZjgseWkG2rlN1T8QVlFzRC8leH8gsNW3YLPFXDMsHPKTadccC8Iaroe
	 XLczfLhAdVSj3BiisJ/YhuRzxVTA7NlrEEwdFOsTF0m5KPgrzWZds7Xp3gPn/vkCeCZ+L
	 5YzsQt+gKzyeqBajrOXILbObC/ZRrAS5acOxdzhkUP2SEORzYyc+GFzah5YwasPpsp17j
	 vg23gjXXnZPjjKywSxRB4cNiTLW2MogEI/B1c52JYyrKkGZAbDoYjfjcDzcf2D6orslCX
	 1QdslUX5JZvefSvmhuJIYfNr7nSaD+mCMYWfHYtYMMZpiE65VZt4WXTZKQAOym/Ihdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=PhKWZl+l;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFC5606A319;
	Thu, 22 Oct 2026 04:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FFC5606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=PhKWZl+l
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3669215A1;
	Wed, 21 Oct 2026 21:52:11 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8A763F673;
	Wed, 21 Oct 2026 21:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792644734; bh=44sAahlGBWki3CLzttdyPd9BArWJwv9oFthryRDKXxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PhKWZl+lITNgn2s18xxBwN4IQraWSJ3Cly36ez4WrldNA0izm/ZvQ/eT/q/NtTu2O
	 4PgjE7ydajX26F5KF1L4HW9UCok/SYdFTfGDRxwnyEZHfcRCJdbgY0fzXDcLsdWysU
	 B8KvEu2vSg01HkJZwbIe1Sxh4H0+haQQcOBzWu9A=
Date: Thu, 22 Oct 2026 10:22:10 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Down <chris@chrisdown.name>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/page_counter: use WRITE_ONCE() for emin/elow when
 parent is the root
Message-ID: <ckukoxkv5cgvk5yywqe7fzxyo43cu7jh7ys5d6qs4rbasxutev@ixfqdcpsppmm>
References: <20261021204818.3431099-1-shakeel.butt@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021204818.3431099-1-shakeel.butt@linux.dev>

On Wed, Oct 21, 2026 at 01:48:18PM -0700, Shakeel Butt wrote:
> page_counter_calculate_protection() runs without locks. Several
> reclaimers can update the same counter's emin and elow at the same
> time, and readers such as mem_cgroup_below_min(), mem_cgroup_protection()
> and the dmem eviction code load them with READ_ONCE().
> 
> Commit b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store
> tearing") made the main path store emin and elow with WRITE_ONCE(), but
> it missed the early return for a counter whose parent is the reclaim
> root. Those two stores are the only plain accesses to emin and elow
> left.
> 
> With CONFIG_KCSAN_STRICT=y, a few tasks writing to the same cgroup's
> memory.reclaim trigger reports like this within seconds:
> 
>   BUG: KCSAN: data-race in page_counter_calculate_protection / shrink_node
> 
>   read (marked) to 0xff1f91b146d40e40 of 8 bytes by task 163 on cpu 4:
>    shrink_node+0x57a/0x1210
>    do_try_to_free_pages+0x194/0x930
>    try_to_free_mem_cgroup_pages+0x204/0x3f0
>    user_proactive_reclaim+0x28a/0x4d0
>    memory_reclaim+0x35/0x50
>    ...
> 
>   write to 0xff1f91b146d40e40 of 8 bytes by task 167 on cpu 6:
>    page_counter_calculate_protection+0x1fa/0x360
>    mem_cgroup_calculate_protection+0x4e/0x70
>    shrink_node+0x53e/0x1210
>    ...
> 
> The default KCSAN config does not report it, because it treats aligned
> word-sized plain writes as atomic.
> 
> Use WRITE_ONCE() for these two stores as well.
> 
> There is no functional change. Readers already accept stale values, and
> compilers emit a single word-sized store either way: with GCC 14 the
> x86-64 object code is the same before and after this change.
> 
> Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/page_counter.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 9167ffd1380c..5293460831f8 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -472,8 +472,8 @@ void page_counter_calculate_protection(struct page_counter *root,
>  		return;
>  
>  	if (parent == root) {
> -		counter->emin = READ_ONCE(counter->min);
> -		counter->elow = READ_ONCE(counter->low);
> +		WRITE_ONCE(counter->emin, READ_ONCE(counter->min));
> +		WRITE_ONCE(counter->elow, READ_ONCE(counter->low));
>  		return;
>  	}
>  
> -- 
> 2.53.0-Meta
> 
