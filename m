Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329D82989B0
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 12:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659985; cv=none; b=aUbeei0X+pzwO/oC60tWhHLZBzJx5rz7HTXITORskb1cF5anly2UkLBJ8V9PQ2mOEw6sN/KfsV1JubeWQwma14sRCVBzJcBYCTi5AlX+RScvK8x/5sGt7CIMlH077h6/+sGtk6QGCaZ/rq5x2LpLHibFS4OjzoOxxXHpBisX+Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659985; c=relaxed/simple;
	bh=trNVA5gVReYdkFue47keFlPvHc1/Gh0KXZaU+Bnrfug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DH2Ip1y3bFUa7/xCrbjsEoHBMxAaOP7OOW71bK3pi+FZajuBchBM6fj6SwlpBdijWReGprcloGcI7v6pu4HJlghAx991GR6KebJuigQYQng2TT8Y4/y5/xU29reTyg/amgbvcJL9fhCSS9QjjswIr4OyExd8MkmLGv6cbZNmzBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QnxojTs7; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QnxojTs7"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso1220958a12.0
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 05:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787659980; x=1788264780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MBJ/vcOaP1xG+Rh/R0z//WBNgvz+tz7qG49hmmpRSwg=;
        b=QnxojTs715vQVImJaZZa8CJDtKYbf5Tfyem3O4FAAzZk543Q58Ax8LoIMVUrS7twtT
         z+Dq/wKNZte+ePvhA0WpfKLwu+hnJHthXLRiE2tC6knEjjLUPv02CVkc5HbkPeLYznEq
         ItTn3VfF5DlAJtbdcnTuw4ArP5ka4nDU1duxIQOzu0NTIhBFLHoryE9XqTiMLADn6Sr4
         c5M8XJ/iZEs2MPkGJFMhVV1hI1SJ8KcSMzh7Cmyp3IXTMbXQ1URTN8ENetPZIoinbiQ7
         BlWBBCXKxW3U7gJhnQUzJMk/HmiIqsu0ONKhOiP8JxKMaJLHik6HscbBtkrpGnTeeNkt
         y67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787659980; x=1788264780;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MBJ/vcOaP1xG+Rh/R0z//WBNgvz+tz7qG49hmmpRSwg=;
        b=SL7oRKnDwBGfHYQWhxIpeffcfkIg4Idf9jcDZf+4Mt+EfUJaFFZWhBK6cUBiHaHBzF
         kz0YLNXqVEdaoDjs+aimbF5KzWc/tWIA5/AIllYDSYOBTNjeDvQmzj9SCCSEw5caU2au
         aTQmxLzboYZsLp6k6vbORlWAsuRl8cKwYwYBw4v0XLsV+UfLUUbIAjx5n8h4Nm8nNOvX
         PO+jxVrYw1IfmZzJWnaHJ2gz95agQHjpn3LaMXUTVOb7hRNkMgmvCsy7eVznYsHQEFNu
         eeiN1VLEPfgX7Dbj/CjyJzPXfF67GRHt5eIiGU/znqbYk6TdLh1+Qcb3SYeHYx5PMcRX
         hYNA==
X-Forwarded-Encrypted: i=1; AHgh+Rr6vL+NGCbyWqrrQVKHHhLwwcHDus/K1OSP/LjaHJR7dPTAfoB9XoZEqCbvaT7nJ/7pM11ay3zk@vger.kernel.org
X-Gm-Message-State: AFuF++lsNGIqJAzPj3hQKS/y5R9ETcZnumAHgptfip9Z0gFs4fsiG2dt
	uRlhIzjanfs4n74WD+9MVQNzk7OPmARK8Ix5C0cMXYznwYrUoc5OZ7Mn74wpNcqsib8=
X-Gm-Gg: AR+sD12BZiUyeQu38oDvXVrpT+x/krSLASiqkjQ057qbqMHmAgDbDkRbBPdV6aY5IdY
	XQOIgvOtE3taC9yiR5mJ1GERdJZBIxyReu/ebmH0i75BhCGz/VEfZnzZwJIv88bwUAKwuNgEITg
	WCEdYFtayBLKvIydkrOInIjBobZSXEdvpol3kzUcgG79lh7dpLVc58OfY78qnNmF+Ajyxz3wY0c
	mWmkuR68vMQ/jW5uF6qGe0C2MHkdDyI59a9INwYCH2JPsTOJRaYZm8t5CG1OeMTPtPFs6vvmvup
	Az3aqjtWUjiqM4GQlpWmH/x+6ALBblA1leoeRJ6shQO47Jjr/a74kQZKMgOuT62rpGYQd9aV12N
	ZfuHqgVRyJF2wR28MLMC9oX3xUIND5BZBc7zo58o4TZvG0pZV6Gy/nQtLs8YeXCfKEg0pkQ90lm
	2hDx2FMoUuq1LrtXDZp60qW4BQTxL+6yMXJcUB1b9mYhg+S1BAa9pQ2Ri2bZ1IwjYcthhcWhHgk
	g==
X-Received: by 2002:a17:906:eecd:b0:c24:6382:2648 with SMTP id a640c23a62f3a-c24e2cdaa43mr742664866b.5.1787659980407;
        Tue, 25 Aug 2026 05:13:00 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24966f9c9fsm1859755666b.39.2026.08.25.05.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 05:12:59 -0700 (PDT)
Date: Tue, 25 Aug 2026 14:12:58 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: remove unused memcg parameter in
 calculate_high_delay()
Message-ID: <ao2Gyjq7VvqCGnZD@tiehlicka>
References: <20260825120153.1405-1-hongfu.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825120153.1405-1-hongfu.li@linux.dev>

On Tue 25-08-26 20:01:53, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The memcg argument of calculate_high_delay() is never referenced in
> its function body. The delay calculation only depends on nr_pages
> and max_overage, and both callers have already obtained max_overage
> from the same memcg.
> 
> Drop this unused parameter and update the two call sites inside
> __mem_cgroup_handle_over_high().
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  mm/memcontrol.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 11b85f4b6828..8bdb6988e7f0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2515,8 +2515,7 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
>   * Get the number of jiffies that we should penalise a mischievous cgroup which
>   * is exceeding its memory.high by checking both it and its ancestors.
>   */
> -static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
> -					  unsigned int nr_pages,
> +static unsigned long calculate_high_delay(unsigned int nr_pages,
>  					  u64 max_overage)
>  {
>  	unsigned long penalty_jiffies;
> @@ -2594,10 +2593,10 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
>  	 * memory.high is breached and reclaim is unable to keep up. Throttle
>  	 * allocators proactively to slow down excessive growth.
>  	 */
> -	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
> +	penalty_jiffies = calculate_high_delay(nr_pages,
>  					       mem_find_max_overage(memcg));
>  
> -	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
> +	penalty_jiffies += calculate_high_delay(nr_pages,
>  						swap_find_max_overage(memcg));
>  
>  	/*
> -- 
> 2.54.0

-- 
Michal Hocko
SUSE Labs
