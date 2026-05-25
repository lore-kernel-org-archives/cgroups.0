Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D259D26AC3
	for <cgroups@vger.kernel.org>; Mon, 25 May 2026 21:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779745772; cv=none; b=dejmtUuOSf0qnE+SrA/79B92s3gfX2oRahW1GWn98K5f/pdrfl5KUmYFXjnviOpczYQKCejA0SOV/7a1hOfDD30RgsFgN1y7VR32DerGJwttHyf1p63Q/s4YMsax7S7FhQM4Tx+pwxBZBZLP5h8yxN3WDzPdIieX6UalpmFcXcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779745772; c=relaxed/simple;
	bh=CycOweSSK5fYJQkC7YggQl6CXEds6kZc2+6Ew6i9a50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ut8e41ZK/0T8HSHxztaPrPxGZpCnv684i7Jp0XoToiU+tArVmmThr7qe4cHGpkdN9YTgR/Md0yxVCwfzsVn+CZ6XIhZT0kDdxFnUZTy8C7Qkv4629ZShGDDhEKfMAh9Kb/B8GQKsaCFrCJQD6V3K1R3sfvYbWNFz/nh2zSUFTG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e+fHqF0X; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e+fHqF0X"
Date: Tue, 26 May 2026 05:49:15 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779745767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cJhBbkkg9PzZDnnqjTJHB8wsc4R5SikbJ0jWD5EeS2M=;
	b=e+fHqF0XD/2ukH7jaNcc49iWmkLqXOyXDPERSKjViWt9hzNi/4hkjKU/8yJbS4/dnG6K+s
	FsGVz1//2ivLRyemGIQ2qB13gI9xqp8ao3RFpGx6ISu2mR0n9HgXkJYQEtbc4cFi6oqu6X
	3uk6bAdkolNSekPOBXbjMdUUvkJIX9A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahTD24kOr9WoluRT@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-2-youngjun.park@lge.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-2-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT

On 04/21/26 at 02:53pm, Youngjun Park wrote:
> This patch introduces the "Swap tier" concept, which serves as an
> abstraction layer for managing swap devices based on their performance
> characteristics (e.g., NVMe, HDD, Network swap).
> 
> Swap tiers are user-named groups representing priority ranges.
> Tier names must consist of alphanumeric characters and underscores.
> These tiers collectively cover the entire priority space from -1
> (`DEF_SWAP_PRIO`) to `SHRT_MAX`.
> 
> To configure tiers, a new sysfs interface is exposed at
> /sys/kernel/mm/swap/tiers. The input parser evaluates commands from
> left to right and supports batch input, allowing users to add or remove
> multiple tiers in a single write operation.
> 
> Tier management enforces continuous priority ranges anchored by start
> priorities. Operations trigger range splitting or merging, but overwriting
> start priorities is forbidden. Merging expands lower tiers upwards to
> preserve configured start priorities, except when removing `DEF_SWAP_PRIO`,
> which merges downwards.
> 
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>

This looks good to me.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

While there's only one tiny concern, please see the inline comment.

> diff --git a/mm/swap_tier.c b/mm/swap_tier.c
> new file mode 100644
> index 000000000000..9490e891c5fe
> --- /dev/null
> +++ b/mm/swap_tier.c
> @@ -0,0 +1,302 @@
......
> +/*
> + * Naming Convention:
> + *   swap_tiers_*() - Public/exported functions
> + *   swap_tier_*()  - Private/internal functions
> + */
> +
> +static bool swap_tier_is_active(void)
> +{
> +	return !list_empty(&swap_tier_active_list) ? true : false;

The above line seems like generated by AI. Whatever else I have seen is
"return !list_empty(&swap_tier_active_list);" which is enough.

> +}
> +
...snip...
