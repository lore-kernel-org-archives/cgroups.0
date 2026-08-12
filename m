Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C859147012F
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786553323; cv=none; b=neer6UDIv6UnQiSe46G619yZRtVg/ECveSSWl5tPn8lvxHIbWtLUdfUgL10L4vH7CLhWnsNMj3PCyfRTBNJ/fUZGH+LesocBDiV93mRskniNV3lMUu90oD76Qb8MClOXnmRuEvxmh5wgy+LE2nkn529TqMjyRe3fFJZPZZwjbqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786553323; c=relaxed/simple;
	bh=ehGxUwHNzBc2FQxNXfwVF1AexYOK+Dgj6vQjPhOYxwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVEd9I6f7yAreIyRh2icTO6ar6wb2YKGiqA7MiTgT3lFXQ8BOfgaYTqZNe7zQ6nzIfEXrRGMM9OBA743ISAkoV9euc/kqLtzqxVQHVw87deyEuh6MiIWUQNr5+wFD+aS2qmOY1Qpq5BjVzxV56V1CjW6V6S0TQonbZVeTme0FEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=g81A9IU1; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="g81A9IU1"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-90a60a3ee0cso7930486d6.2
        for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 09:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786553313; x=1787158113; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eJWnk/M4buJ0YbJEsu331nsW/cLwTebx/mZLjvLX5Ns=;
        b=g81A9IU17G7xAJVLr4s2osC5jMl7n2WqsnZ/KQvlWfiH9x9leW0e8jn6i6NzEhViiK
         rYqb7bhLd7CTuWsqiyGNSvT0pBl1gecvfVe5m53pUDHAD87guUnZlHVqv92EoCx+vrRr
         gw+D+uSxzFVgc5fUyWYcE/cdhJTr3GBbaLFRWTca0rTj//lM9nFQLJ//PpaoLxJIogkK
         /ODWQuI/2ZGY5tTljsHSnp3/UkWn4nK9xdDfNl3aY2cEFQMo/2fLa5gIHu88sBghc1HK
         b8ZN/TbGr5Z1QQfCErts+6PjehGiapjYz+UttbePuEdu9Qz74p/+gZ0+Zx5LWpolEc7x
         wv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786553313; x=1787158113;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eJWnk/M4buJ0YbJEsu331nsW/cLwTebx/mZLjvLX5Ns=;
        b=Y6MOL5YSaT5VuEesJc/BOsdqYj2VBznmA5VDlnrIzVmNbStky+tBT70kwWxkRSg6ME
         A870YhBYeHdUnsyAfTEn6+wK4bNfKTBxX43gRTLz8ABvOR8i7MmfdD20oelUTGMIKKmK
         LnxZXKltzPWa5rn0GiEMDfYxuf6lyYUxxosmUaWDre3Jz4wUcGdbfw+91xNJ+Eo4Kago
         RCYnvsgtIbw3exH3M243/X0aFTGcvQOw9vZJZlwWynoxoSPgwPFlIxqtX+c0OwoXqjPi
         tsEzwnNCQK9w1fm62MzgKEoN39Lqhxe3cQBva1SOzry4VYiWGgi5QOH03ZD0ZdMD0aIY
         VrHA==
X-Forwarded-Encrypted: i=1; AHgh+RpIuyxo+3aSlxdo+S3CRP/jX9awOD9HhwRNSmrZ1VBU9wCZML3jgfNVb/uJOYhwkPtB3C3J74gq@vger.kernel.org
X-Gm-Message-State: AOJu0YxiHCCqkIy+mtTAssPRdsKQSlegiubzHc1J77IvlvuwCRXoRorM
	Jesn7vTLgPHddsOE7m+KkQgzmAz7Kzc3fAlnTL1jhis690ILk4fRlCmam8FKFcYwRkc=
X-Gm-Gg: AR+sD10XGwkbWN+KRisScDa2vO7knYUaSfEZLp//Dn5Zz0U6lTKpimZGIExSy3bmI4s
	v+w3nHGdNo58/xHTZlTT3BuXQsvLxoK4zyeZO8wdwJmyOLbOU7fZ5Pq6wsNYpcFhOvQrBmwmuCk
	nbr43jQaE/yx1NDMqoxT36ifcJljsF84vaR79gzrbzrSeLhAF+4ujE5mNFLNke7wdmhNnevSM0e
	CTjTGswhAnnIrPqEVpkyXIW8ZDST9Vf50IFjf0NpwFL/ma9AIGH9kg+E2t7LMZIbYJWnl7nofIg
	RZWuuDq3RFrq6sCl/ZYr3+V/iPFUKrpJumzjxmp9WG9Zecl3fhXBMqkcoeVUURQ+l3Z7dlvzPjP
	b5oFkuxpAmyYKocU5yMFfmsmVJ8RMFbyf/tDQKVMzVO16GB5w32oTVw6AK9f5uDVhvSg28IaIk/
	T64ytV2GAzn0NZ2NsTFco0pfiS149Yk2UDCPyaykPJbnvB1dwtOIz8ny1+eGewFJ5XrrQ9NA==
X-Received: by 2002:a05:6214:492:b0:8f0:a849:f392 with SMTP id 6a1803df08f44-90a6ff45bdcmr55143356d6.14.1786553313548;
        Wed, 12 Aug 2026 09:48:33 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c2cdcebsm24786266d6.21.2026.08.12.09.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 09:48:32 -0700 (PDT)
Date: Wed, 12 Aug 2026 12:48:32 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cui.tao@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 2/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
Message-ID: <anyj4GGPnuU-q2AP@cmpxchg.org>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807090000.1532495-3-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807090000.1532495-3-ridong.chen@linux.dev>

On Fri, Aug 07, 2026 at 05:00:00PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Writing to memory.peak resets the peak for that fd only. Each fd is a
> watcher and reads back max(its own value, the shared local_watermark).
> 
> peak_write() resets by lowering local_watermark to the current usage.
> To keep the other watchers' peaks it then walks the watcher list, but it
> stores the current usage into them instead of the old watermark. So once
> usage has dropped from a peak, a reset on one fd wrongly drags every
> other fd's peak down too, even fds that never reset.
> 
> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
> collapses to 1060 KB although B never reset. With this patch B keeps
> reading 410624 KB.
> 
> Fix: save the old watermark before lowering it and use that to floor the
> other watchers, so a reset only affects the fd that issued it.
> 
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/memcontrol.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2da55b778ae3..28577beeb3d0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4746,7 +4746,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  			  loff_t off, struct page_counter *pc,
>  			  struct list_head *watchers)
>  {
> -	unsigned long usage;
> +	unsigned long usage, peer_watermark;
>  	struct cgroup_of_peak *peer_ctx;
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>  	struct cgroup_of_peak *ofp = of_peak(of);
> @@ -4754,11 +4754,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  	spin_lock(&memcg->peaks_lock);
>  
>  	usage = page_counter_read(pc);
> +	peer_watermark = max(usage, READ_ONCE(pc->local_watermark));
>  	WRITE_ONCE(pc->local_watermark, usage);
>  
>  	list_for_each_entry(peer_ctx, watchers, list)
> -		if (usage > peer_ctx->value)
> -			WRITE_ONCE(peer_ctx->value, usage);
> +		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
> +			WRITE_ONCE(peer_ctx->value, peer_watermark);

Sorry for letting your previous reply sit unanswered. You made a good
point on the peer_watermark = max(usage, local_watermark) being
pointless because that's how local_watermark moves to begin with.

So what you had before was indeed better. It was just me missing that
detail. Could you please go back to your original? Feel free to
include:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
