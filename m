Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794493836;
	b=xiBPBsRsS+fCAOec5izASjlfGbMycIsBfg+HA0J7GKIY0gINvHk/j6/x248KKlRDAS1R
	 5PBnj7nwEx63rwhiVxV7kRboyXX8yENPISSbsdBRjdfaQaaDHyAaKakShE/lAldd1jMQM
	 iWnkI9N/NuKTbAkVvgE7lRuuyZ03OdeYr4Z2K83AV7NeLPQfof+iDKHNUAuT3zaImD5NE
	 CqjCqWSalzBS5FMZepjFUo9Mnrig5zX2WhCk9qkcAgDuPES+fnx9hlQV329rlMV5OwRa7
	 fdLFpB4E7yTvKEDidkFmpZWyXU/KGkzoe4YY+Rt/mpiBYJeSlPZMGvKTliBlN4HrS0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794493836;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gsmy0r2PiQc6pLBgGT2iVgxiMmcutgitiTqzWpJ1o5Q=;
	b=qFupWTgsGUUiQvtTCj9N0K90fEOHLxsAn3acrddOZ7ij04Jz13RAU8XmCnDmDxEmdEvi
	 j414yU6g6rx/MIuAfj5LlsmqALS6IvqWrcX0JLVTyHRmm8RcUhmWzVUySzxels69s9aqI
	 LeHPpXy30o/m525briUfr96tz0tJIgG8d8C7d+uIxcVSYG9DF8Am3yRkE+7MrezLGus6D
	 RErGR4TtBq8WscUVqC2z3lK5fw7Vt9yQS3D/zbQkzzejbB4GKcqLXy+uEmlrV1Cn+yerm
	 U5REweACQ3Unj7gEnT6BoN+tI2F5p02QsGNGL+OhZM9UC6Xm//PyQ/tMGIwDVmn1pwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iKXpz5BQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6583B606A337;
	Thu, 12 Nov 2026 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iKXpz5BQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF411F00A05;
	Thu, 12 Nov 2026 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794493836;
	bh=gsmy0r2PiQc6pLBgGT2iVgxiMmcutgitiTqzWpJ1o5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iKXpz5BQspSTB/yVdyil9C8T9ubHWY8dy7Fu6HvyNLXCWgAFgZHlou8L1dRh1Zs75
	 www38WX9HcC1KcjqWybnFDKl7yzmVBKK6cUPmp8Em6U8Ui/7b/3EPj8H1BV+l+kBGY
	 vrhmK64tjy1wZk6jq1l7MtzWiGJvZLg6rtA3+mhY45dfu0YFjMfSHXp0Q6cum6PX5T
	 yduq9ExJuohOhP8GXdZXpwItvJCZ44kgZcBnejO6MgeVYRY3gdF/g5wAxccms0lITo
	 5Ld9jDkL6I+Hbfusrq/seuR5n0AT+URmssp/mgtRG7vGAz9wtH/ZacSq0i1OJu3inY
	 A/ZYRCXukx7bQ==
Date: Thu, 12 Nov 2026 14:30:34 +0000
From: Harry Yoo <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: flush nr_charged_bytes when the obj stock trylock
 fails
Message-ID: <avXL3ZGyyiQpv4vG@thinkstation>
References: <20261112013220.4064478-1-shakeel.butt@linux.dev>
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
In-Reply-To: <20261112013220.4064478-1-shakeel.butt@linux.dev>

On Wed, Nov 11, 2026 at 05:32:20PM -0800, Shakeel Butt wrote:
> When interrupt code, such as an RCU callback in softirq, runs on top of
> a task that holds the obj stock lock, its trylock fails and the bytes go
> to objcg->nr_charged_bytes. Nothing empties that counter while every CPU
> using the objcg keeps it in its stock, so it can grow without limit.
> 
> Users see memory.current and the "kernel" field of memory.stat keep
> growing while the cgroup's real usage does not. With memory.high or
> memory.max set, the cgroup is reclaimed, throttled or even OOM-killed
> for memory it does not use. The counter is 32-bit, so after 4 GiB it
> wraps, and those 4 GiB stay charged to the cgroup and its ancestors
> until reboot, even after the cgroup is removed.
> 
> Fix it by uncharging the whole pages in nr_charged_bytes whenever the
> trylock fails.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: stable@vger.kernel.org
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f5f567f7d4a9..091401cecf39 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3553,6 +3553,8 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>  	int i, slot = -1, empty_slot = -1;
>  
>  	if (!stock) {
> +		nr_bytes += atomic_read(&objcg->nr_charged_bytes)
> +			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
>  		nr_pages = nr_bytes >> PAGE_SHIFT;
>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
> -- 
> 2.53.0-Meta

-- 
Cheers,
Harry / Hyeonggon
