Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793662175;
	b=oVMIvqNwRzMwizijJWSAYd8UT9bK9bZKBCkNoQz1R4xaMXlZ7yRppyjNk5kLMPSqUdg9
	 SVl2C1EtbvvScUaaHP+sAKTq33XSMChem5X0Ny0PxJmNI23PsB88GoUw5pED8xE2pi0fS
	 QW0yRbR7KbFAPx1dMT6LR5+fp2AQM8iogVcHHnULJx/cY91D597kMns8zCXwQy66qQXoH
	 cGY3Jt3/ad3ItpVHCG9XH+anUFdXQRMP9U8HIbJNSYKbWqaPeWC8vi9fweeY2RfNS6NNZ
	 VPskLMGJxlqxVehmhrQmf2lGs+w/9p/odfi31fnkJ8+wEzMVE5z/yMQlkkE18KbcaVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793662175;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=YTKi2ZfuXtkzbJQerS/R1oO64J2LCdQqFsgYxGf3I7A=;
	b=wzEN1/pCXN4q3dtBdVlyBb/KtF2PrJWYr0Py58AtGwfpJ5QG8HXGomMNexmJTkm9HRQX
	 1BSoGntqBDzFfsP2ZLk2od5ZENqiPa5anLy4YGibm8rOrLttuHrRLtkFbCGGmVZay6+05
	 ctGcUV0dMbQj5UJOPw6T1ZUDsOiH8GpYRPmCs3fHiLi3h/W9swJQx2LhgPusOH8/HAZA/
	 kpJr2iBNyMVb6eluloYvsOfn/YqPJX0+68HOT40U9jUoTDFKpvX85t+KaTSdbK97be1LV
	 RjnkCbmsEkCrqyINAJ5Wzly+UpSHjll0BXLq1g7QkLuJCgwpIA3/0eXUs6/+8GjaMRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLmxYpKB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6476C606A327
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iLmxYpKB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F294B1F00A18
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 23:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793662175;
	bh=YTKi2ZfuXtkzbJQerS/R1oO64J2LCdQqFsgYxGf3I7A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iLmxYpKBtb2Sdv0r01qtXOVlpvgwAWru+Ok8vsOsBX4TUWT/L3zIPpIEZIEWF7vdx
	 t8NntwM9tD/+nK96mxlr/NPIwELo4bF3H2n8XE4d7C30PFnO7jgAaL3NP9oyq9X9S2
	 jt9BkWKOGgp4pkADIcBhBIQoH+shB2mgdM/3dG8K+bbkCvX7qXWQRS1cPGnpTaW9S1
	 C61TAVnooyiRHepDeFGV5dEKolSdlaasXHuN2HJgLpJ9+EhlSck7XqnFX9DcGYVTpp
	 yLdxyMXJ8SIqh9bdjs2XFDFX6j07xSXenmV6L/tkuUrInI1EigN+A9+RaXbiuTHgg7
	 E2GiFdzlDl74g==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so4949256a12.3
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 15:29:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByT7dOlZ8XuCquMLrEVis4vhUvvuu82rgNk5WB3E/R3fVVtKbZk3DG3B/lj5ZpewT0NXOJJDYKn@vger.kernel.org
X-Gm-Message-State: APuU4Z+XjXDF2fHoM+ioWVh0UgHEBiThOQbUSbwpUI30Nu9/n7RWM872
	zQ2ZmYIenDosMOIJn0hQa7zCno14TtWWs30K3izqJON4sp4Lche4IYyBA8QhK9PUdKpqlkCOX7H
	SI+BeXkmabF1uWdFi+7SNM5HnEgeRS0Y=
X-Received: by 2002:a17:907:6ea6:b0:c2e:378c:8ce3 with SMTP id
 a640c23a62f3a-c4ca7aa72b9mr897146466b.32.1793662173962; Mon, 02 Nov 2026
 15:29:33 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com> <20261102225030.2743129-3-joannelkoong@gmail.com>
In-Reply-To: <20261102225030.2743129-3-joannelkoong@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Nov 2026 15:29:22 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
X-Gm-Features: AclHuK-4t4jepCmFSgrDiHYFCB2QMcYxAclyDHxOZQ_Fy5-IrgHz_mEoVtmdPJI
Message-ID: <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ac6c43ea8c5a..938843346571 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>         return x;
>  }
>
> +static bool lruvec_is_root(const struct lruvec *lruvec)
> +{
> +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_memcg(lruvec));
> +}
> +
> +/**
> + * lruvec_lru_page_state - read an LRU stat of an lruvec
> + * @lruvec: the LRU vector to read from
> + * @idx: the node_stat_item to read
> + *
> + * Like lruvec_page_state(), but for the root memcg the node counter is read
> + * instead. For stats that only track memory charged to a memcg (LRU sizes,
> + * workingset, rotation and reclaim writeback counts), the root memcg's
> + * hierarchical value equals the node counter. The root memcg can just read the
> + * node counter directly instead of going through rstat, which requires
> + * flushing. Flushing the root memcg flushes every cgroup in the system.
> + *
> + * Use lruvec_page_state() for other stats (eg slab).
> + */
> +unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
> +                                   enum node_stat_item idx)
> +{
> +       if (lruvec_is_root(lruvec))
> +               return node_page_state(lruvec_pgdat(lruvec), idx);
> +
> +       return lruvec_page_state(lruvec, idx);
> +}
> +
> +/**
> + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for delta sampling
> + * @lruvec: the LRU vector to read from
> + * @idx: the node_stat_item to read
> + *
> + * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
> + */
> +unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lruvec,
> +                                             enum node_stat_item idx)
> +{
> +       if (lruvec_is_root(lruvec))
> +               return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
> +
> +       return lruvec_page_state_monotonic(lruvec, idx);
> +}

Why not do this directly in lruvec_page_state() and
lruvec_page_state_monotonic()? They already fallback to node stats if
memcg is disabled, why not do the same for the root? Are there cases
where the node stats are not the right thing to do?
