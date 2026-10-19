Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792432698;
	b=Msk0gdX/A69wWgApEujh9gw947xxCwgnJvpEfW9PRuLXtkNKjef5C1TP0WwKthoYyrkn
	 GrHUXjkKdYwtJTy2FIvzN7T/0GodgMKrS1DBfvyQL1eFB64Gae00PlPUOa9yM0n7GzLxJ
	 r3xGbFx1RXs4CxQNyq6TbD3sUQ7gChIz3K4jRSMikOvAXwG3Gkjl/C4Z1cuVi6AXABA13
	 +oCtRwqlqpDiZx8GmbC0Tpss43a4y3WhMxRuKxFFDHXF4tR4UyMaHTQz7RAuYUZU7nmif
	 gK285YtqNL2opKklPf2S5p/WXoRgBtlvbF8hh4iVqIwFtiAFwK7oGiCA+1i5NG9Ue5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792432698;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=AO7xqUXlLM1TA2n8fcNeWS06aNBQVTSeH4oKun/bjtc=;
	b=mq3AqC4Db+irsiMyOIw0OEIw4IROVTmDcmSR/FWn50xCDoichZPfO0cWpF2fmx80Oc9I
	 ljn4JyG4jClUUV1SbbzyHHjJ09LVns4s9Q6Wo/Gf4kBi3zZ71Rl4Mw9n/zMXdrpKqXn7G
	 cZfgJPJB6Ivo8Y/6e+HFvXApTVkuLHwxX13iG1DBBMxq41S+uaA3a2IAPqpZlVtKpIChl
	 NDwKjgu4Ho2MNeucLvbhMmvs19SGDIwrpd/zEwKQOvKt7hnAR1v/MV+SF3lQnXA2GSP5Y
	 1H9vsp0/k68DdcaNOFRqXp2pZV1E1pqcB63FdGUE8VXylMfYAE45RP06YozAXS26q3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYMDLAPI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395E5606A319;
	Mon, 19 Oct 2026 17:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYMDLAPI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A551F000C4;
	Mon, 19 Oct 2026 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792432697;
	bh=AO7xqUXlLM1TA2n8fcNeWS06aNBQVTSeH4oKun/bjtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JYMDLAPIlnGDCSLBNWLAx73Dyjpl3FQ1FyElE4UAZCi0GlccwDiBVINdBVS3Bs5OY
	 F/6z6VGnNuxR94PeS40d0KDlddWiw/hiCFcxGuON3usR/zxnwpoQ8TdmjJJN4Q2QXu
	 HMoBSAbw+qFYO+eQhoRGGbPgDToer86yFVpeWaBJHBvA6CIFRa1+WSgPA4iTN6mayx
	 AsylWJ6DNUJcKiztzWcNL7Nbcp6g4QLG7yj5aUCqxovYzyvxfhjcHPq+Nmr+2Yvc93
	 af91GIxf+ZohcO+uyeLIaa7NHL9V7Txzzd34rWzNxEbGCwCyvgYrnzGZOeKS/GjXJ+
	 UeiVKqOzarHfA==
Date: Mon, 19 Oct 2026 18:58:15 +0100
From: Harry Yoo <harry@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/shrinker: allocate shrinker_info_unit from a
 dedicated kmem_cache
Message-ID: <atZZkIFH1wrX4w4w@thinkstation>
References: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
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
In-Reply-To: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>

On Mon, Oct 19, 2026 at 06:11:44PM +0200, Konstantin Khorenko wrote:
> shrinker_info_unit holds BITS_PER_LONG atomic_long_t of deferred work
> plus a one-word bitmap, 520 bytes on 64-bit. kzalloc_node() takes it
> from kmalloc-1k, so almost half of every unit is padding.
> 
> Allocate the units from a cache of their own, sized to the unit. The
> cache is not cache-line aligned: the counters of a unit already share
> cache lines between shrinkers, and aligning the unit would only keep
> neighbouring units off each other's boundary line, at the cost of part
> of the saving.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
