Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473BD3DDB03
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 13:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786367069; cv=none; b=EkSDsvzsc9fFZ4bQ3i9DkWZYcM3ZC528LfNox4t+/eqVVHGpf3BpvxwWTOUVCjKWG6zC7xHp6IeNOk4ZiywfZ7zKgSf8W3rtxjJFzq0J51WpEYOQKU48d6APDAIfIegbo+d7tb2LIn5SCF16l2qhCIdESPOX98g4zG+b9Ev+hRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786367069; c=relaxed/simple;
	bh=V3VZrT1lvjCXWQZFbzklyiBEG9bwtxwrehV1UYNaEsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJKxe7iBSkEdd8W6yMrucLqOKXvKHtenb7bch96pq/YVy6AMO9G0t3vfCKl4e54WkSs8vsqRnbH7XQA3LkE+o6z67zFM/byh6oOfEUyxcunCml1sxGJQ3t1lAIbJLQiUeEBhe+L2TvoyZDc3AL6exLAsxob2xU0ZpZn+3yQXhkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P2jDIVBV; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P2jDIVBV"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f6609c657so968231f8f.2
        for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 06:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786367065; x=1786971865; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wmWCD/D7PFkQWTWKXm0x5gIDV1EYLJG81k7aS8klGqA=;
        b=P2jDIVBV7jUBENE+eqTJm2GuLtdOsfLwwu/8E0VF73S0GeCKONxL2crV+O309U5IW4
         ikjGXI+RmeY2GUmhOYMly+iyYbY+YJjZC79dj6aCYh0dWXiKgNoDdc+L511c5d4P/W2O
         kFQwOHaBoaFLMJYVT2BJFX3Z/J7EWtIgNED1lJjlQxSs/6T7jE5NQx2fvv2qSgnFjNuT
         AlV16vUYeVpJt2A1KCxFIOwTzILqXa2iNJ6mRNbrCHkOUNoB19NmCdHxdQSI3ulZHS2t
         IkQTnIEESQocgke+BbyjkzRo3ZgWqOxCWPId5kSxMLM/MCJzeax4LbJl16A7S/Kt3xoA
         6S2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786367065; x=1786971865;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wmWCD/D7PFkQWTWKXm0x5gIDV1EYLJG81k7aS8klGqA=;
        b=SRn1kdiYUpaPECzgBsRubEBgxqglRKqWZFpFQ3w9yg5uvhD8fNdDntKLcKHeC9or+7
         gAPNakpMzZ8J6ZI3ToTq5ScgAsf0YvOttnVcWM1TJ/XqFICLMovTGP5quRcr6CMot7Xu
         RhW+hzl6eOe82NoEkB/X6C9INy7fZ8CYtuYD+cKjgTPpoIc52HeGozsq0n2fDd+3cv+2
         /OPbUJMlZLLw1syy7aMCf9Rdg5i/wl3wusuo7ynNu1YqiEIQQLocFNF5tXcPoo8CJL2q
         yPJx2jWo6gYrY8vm6aI1a8rq2DgDmxd8qSk0NHghn4eWo3ap4Oqvf49WBsoBLGNERruM
         4AWw==
X-Forwarded-Encrypted: i=1; AHgh+RoS0bjChy79F4g4i+0oxx9MYhQcHQ2OD0SkRbrroHBng8t4oBfU9hC6uDv3wtgfLZDcAzg7jNz9@vger.kernel.org
X-Gm-Message-State: AOJu0YwDISwjy1h6zLeepmkDVt21l1o2IGVnKDU8nt7GBByV6e4kAGGz
	3FSBpdkaZqy6HN0OkISjbJ06QxY0Lnyod0lDaAuSGKerFczOIs/mIrxB8C+RsOFsJeo=
X-Gm-Gg: AR+sD11+ECu6eD8pn6fggbt218ohcgZexrJGxnInN0cYe/peE+r7yEDr7+K7BOpoDPT
	ffZZAn/BmKuxtPFhO3z7vvBu1INTkEkj9Bje3T7Ns0ifQAh/FcU82y8F0PyylHFujfHAAPnyzcE
	iECoMQtkvtoj0n3e1RFpiqsBKxgSPt4an3sjsPxYLq0mNiQZJ2SxHvYDTI4cleuJEJuyoRBuKHJ
	co3sFAm+01jOpNrBivvnt5Og8Cvq7ogFh+PRODB8YSUkB3Ud/qzLBE18qRbr+G5X2daIGwK9Pey
	aw8MjWpNn5wtAwuOH+qryg7TqRStZ9Pp/zreJ8neUMBBsZx0RxYVLJTtRpuBZsRplur7f6kzhlq
	HSfaGi0MIMgKO1j2q1g4/z+dXgGAax8YSiMj+97BGjbr1Ddf3qXSKBffkvQV95wg7+ymw5Q0ruf
	u4xXot779E8GKvNCYDa/l5Cfc74fQeHRxzEmSbUSafvS+4m5t/ivf2UohwF2yVauneghRXNhSNZ
	A==
X-Received: by 2002:a5d:5d86:0:b0:47f:8fc8:a8b1 with SMTP id ffacd0b85a97d-480026c89d2mr26784095f8f.14.1786367064903;
        Mon, 10 Aug 2026 06:04:24 -0700 (PDT)
Received: from localhost (109-81-83-166.rct.o2.cz. [109.81.83.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f8f33sm40375893f8f.27.2026.08.10.06.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 06:04:24 -0700 (PDT)
Date: Mon, 10 Aug 2026 15:04:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: shakeel.butt@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
Message-ID: <annMVxXm4tZ4h4FZ@tiehlicka>
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

On Mon 10-08-26 15:42:47, Guopeng Zhang wrote:
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

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

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
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs
