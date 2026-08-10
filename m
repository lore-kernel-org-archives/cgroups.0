Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E20437128
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 19:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388970; cv=none; b=CSQ6YL8gNidcWFkMowGrQnJY8N8M1MyBlFWSKMpCq23aAQXr/P8pjSBWnYL1DPerJAccrqjYiPlaqW9b5OJT4JEovyEfecRv1efBrpVTXbi4pLMCx2xX4BfpDlYUi4UdN1Z/uMNXoSEVxRKE/MiD99mf6pE+3LhBWBvJVrAELmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388970; c=relaxed/simple;
	bh=3/Gmcwwe0rohIADH+j1TmPfA4KMjsHDLTtqre4mK218=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHsQnFu5dtwi7xRmklrwWvxv+/wvPPS85R5qs/hERlRQsgSnU95419O73iBdZGQ/wEzFkFr5BO4PxVrKJGuSYEw0TRN/ZFFVOaNAqswS6KY4dDVEVdQj0Ba0yoHKSPHAWYvGbdq6LQOfzbY7oStdFY2RNX/ZYXvv3RVyb1tkSiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=JrsJp9F9; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="JrsJp9F9"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c05dcdf49so22314881cf.0
        for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 12:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786388965; x=1786993765; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=85QqMALH7INEGXTtVF1giRIfVxPtGVRsSvUojxcJqt0=;
        b=JrsJp9F9dG+0mjO1pS8LzqHMGiK1+iKnFg38PX3ioqPqUb4BtKhbBxdOs4oDwEbtWI
         MoJtF2QLZ+kgTOaPjeF8Ilu7HtAXuYznYy/HP3UrmM/w+BODUb148btjYaw+RZGWTL1R
         CtYsddNTeuw5TAM97sg4ljfxbeDfrnx/Az4qqpgkrrWeK26U9b9PNZT6jiSpfO8FiLbP
         wmZn+HUmW4O4WZmMlT0L3KDY8pe/ve22CJKBQkUaTtlH0nVJFeNgHTLwT4exrjktxqa2
         lhs9cRYsj1vJ4KLpNgkKJsXEv2lCxJWCY5Hh31xJDceISBI/QiUXBxb6SEkGyzuzQqz/
         0Zjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786388965; x=1786993765;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=85QqMALH7INEGXTtVF1giRIfVxPtGVRsSvUojxcJqt0=;
        b=mMHTgBW9qgyGT+s/Of8BBywWBobsGp3k/EYgmg85EoDpC0AQQA7k2g4VGkf/E0ZC3D
         V2Zy2aOvF8ll6sa2sRpsI4nLPxppnE7ruDJpmi7TwDEgECJ4yTkv7HFkvk91xxr9Rl5u
         BhOoXLMp4+YMFo+R57a35LQkHsOTy+tq3YUWErq59sVNS3e70deM/+WgxVT+1K4NdpHw
         xwo6yAMcK82S+vJMpBaC73Q9DKMos5z1oTGFYk7PRuP44pYKNVOA2VpUN3jA6Hvzpoca
         oYpbxRgtBDXlFDoeve054E0jXiZ4kWAQel1syseUFwVMTqUcOuQGHrsF2EuX6a7UTvf/
         iEiw==
X-Forwarded-Encrypted: i=1; AHgh+RrsYzvVqIONuVitINtWu/V6YYD0LV/zwpXGztO27CpHzOdclHzMWkJFpIPyaikGow54XF390Qlv@vger.kernel.org
X-Gm-Message-State: AOJu0YySmxTq2tFM0ekwrSmkPt42EvQte9Og/NNEhFhIkxFq52XFgvb5
	Z39e45eM2Sf1vuKSp1WHIXww8AVmOeX4h9OY4/IIwPrrMQhRFu4rQHbMJdYLWIMvu6g=
X-Gm-Gg: AR+sD12hQrN62eOO80gMIDberBp9Q+TXXZlb+/VMhdGzKNawiLJ35MZu47edMwtZE2w
	25zZfNMJ83o8Way5q6+qgSBpzQql2u9k6oZVfb6qz97fmIf1EDd6lJT4nf3qtvVoDw+mvbi9b/H
	IFh104NWzrV6LSQSNojoUaapEOBcxIxYu/gjHzqy1KFZLw6Kl4lFBa3wepmc24Gr29yylTe+3GT
	cqnASA3++IWopGgav8K51zucUDuAgRipuhnLPzFgWq7rBdyHIfnlEcOJYlx2+kaVTAHp+XXhc1P
	/L0hgX/uD3bd4W3RtTZP3cjSRhnYNvV5QHXv86VgdPR/tIsltv2jLWwNLcxKjAqO/K8x6qwLrk1
	8vZ96pI+jQoUyGPhAXw7GdF1R/cEgMxI0Y3tEas+dLomRPh92gqBs9/VUuqHE4JgkA2ZYvxQUbB
	8odmTvG4/FAd71XC4YF7jHthVNLd7IDOBM4rClkcMf6N8M/rwH8AS9110nxujV72AOBoC81VxKq
	2TtZ1iVUQ==
X-Received: by 2002:a05:622a:4811:b0:52d:3352:f7ac with SMTP id d75a77b69052e-52d4bc69744mr47975431cf.28.1786388965496;
        Mon, 10 Aug 2026 12:09:25 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d16337589sm78043431cf.6.2026.08.10.12.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 12:09:24 -0700 (PDT)
Date: Mon, 10 Aug 2026 15:09:24 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: shakeel.butt@linux.dev, akpm@linux-foundation.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
Message-ID: <anoh5K01Qcn2t1Xh@cmpxchg.org>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810074247.52747-1-guopeng.zhang@linux.dev>

On Mon, Aug 10, 2026 at 03:42:47PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
> cgroups") made failcnt accounting conditional on track_failcnt. It
> enabled the flag for memcg->memory, but not for memcg->memsw.
> 
> Consequently, memory.memsw.failcnt remains zero when the memory+swap
> limit is hit. Enable failcnt accounting for the v1 memsw counter.
> 
> Reproducer:
> 
>     CG=/sys/fs/cgroup/memory/memsw-test
>     LIMIT=33554432
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
> 
> Start a child process in the cgroup and make it allocate and touch 96 MiB
> of memory, causing a memcg OOM.
> 
>     cat "$CG/memory.memsw.failcnt"
> 
> Without the patch, memory.memsw.failcnt is 0. With the patch,
> memory.memsw.failcnt is greater than 0.
> 
> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Sashiko raises a valid point. kmem.tcp.limit_in_bytes is deprecated
and will warn if set, but the functionality is still there for the
time being. No need to leave it broken until it's removed.

Could you add

		memcg->tcpmem.track_failcnt = !memcg_on_dfl;

as well?

> ---
>  mm/memcontrol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6939a4fbb991..4ffe5b3733d9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4235,6 +4235,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  #ifdef CONFIG_MEMCG_V1
>  		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
>  		memcg->memory.track_failcnt = !memcg_on_dfl;
> +		memcg->memsw.track_failcnt = !memcg_on_dfl;
>  		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
>  		page_counter_init(&memcg->kmem, &parent->kmem, false);
>  		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
