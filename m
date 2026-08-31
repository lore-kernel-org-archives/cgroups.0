Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D57139FCB4
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 07:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788161357; cv=none; b=F9xUWIGILlI7P/FnszI06FmPE/+AXcZupDhCl9ZmBycz117HhkuW+QXqpH0mJdK6LsNfebcavcPn00Jw8GD/B62yWLDDx4E+1WZYMdIThF4E6jlYSDhBpLtLwW8ceFlXFac6uFqYIyBsC7QVuPWusWfqrGaVw4dbiW8L4bMWPMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788161357; c=relaxed/simple;
	bh=jKunFJbRTXAVT8eYRevg418PMfhaJ+T7AZJAXrgxsuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rt1BnJJfq3oreLi0DXb5OK/5AekbBYXRgXoTSMYvBD0NA4cRNeqQmcZiPhqbmzBkfKNwk+ru2iESltj41PlbFPKxWE0UQwlVpVH0gcotlllnUJcfnEHs+Hwy+eI01tuR+DNdfSCSPslvIOUokpcJk6vEsUsqOlTrTKBib7KaY80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H+m0godM; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H+m0godM"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso30682215e9.0
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 00:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788161353; x=1788766153; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lObPyH6kdWwL+DlBFF/s5fn9Kq4aH8qpCjM9SPcedhs=;
        b=H+m0godMWIxYAt3S1k75WjJZGl8IGb8sX2SHr/VUhc/qsGMciGRBUb8V2tx0gAxT5o
         dlOijgBoem9SLAdb/8OWsKUN6QnvKn4dtnmoDzK9WmgKESXK11WjAV0E9MCyU4OWtKDf
         Df23jTtLKL0ccw7J7tKuLhZQwSt/igQG1pe3gCiO1MUxKk4mbAG5B7zfylYdt76Y89WN
         fmo0r8UJzVhfZp11zi8lWuu83TbeA2sFN4HDozNsqrZesT5K0Nfxw2hzFTAbSafHF4va
         j82f9uPGAYrGk1sj2sbZn+U4ot5TIsxgTuBqE2y39bMnttgnT+hvKq3slGyiO/7wYvSd
         oR2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788161353; x=1788766153;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lObPyH6kdWwL+DlBFF/s5fn9Kq4aH8qpCjM9SPcedhs=;
        b=CQ8F7Nudhr3AROUawkSAfAZhztKNIKW8bkSYS/DnFovbYl5MnyPjM0gtT1rlzW/lLm
         PFr60ihOObULSJDSNCml3j3lVg2G/of6C/OfkuVIJfb/bAUv0ydihGMoM73DOx8MBycj
         IWtJcE4ec/sPlVAPNj/Tlja+DNHLUt2vSCzE1EmUAD0AAGMYis7R6WEdjIVcQN54MNqa
         Xu2TLvMTPYyIYfNdjNR/1PntOQMPJ0c8I3KrlsiVD5WjqeRBN0g28TO5dpRGz4oGH8zN
         918f5H5Nt5Vj0/sL1sPXnIGrwHzmnr/xG+y1OwNv9++VvAZD0jOd0F7mRAXsEdY0nRLV
         xSow==
X-Forwarded-Encrypted: i=1; AHgh+Ro7xLksQ6dC17/I72OCZh0CONuZ0szGoib/E+J7JsnSFmhE6kYbT1q9fZWE6Qu2KKyM7emSL8tk@vger.kernel.org
X-Gm-Message-State: AFuF++mLN6vj8VIpaWAuXgVQim1IDxVL5nR8ZKfWkaj4ApOycSnBWQi1
	cO0t7b7IbGsWBUJ7Aepy1XrWKbM65yqcc0iJJvcko+WumV85C27dDjhxR4yW3RMDnSw=
X-Gm-Gg: AR+sD11CnJ28Hro0W01+3KRExwW7/bWMvl0RVtCiEP11j2V7nPbFx0220GIqCkai4hX
	ayFh3KIaoThuTNSe2wKFr4ACO5MzcsqrRiMtrrVU655KTixNjjHwqcmSy/Zh6epaIBQ+JKhxTsV
	StA5HLSgQxLjC8/EsdpPUIXG6vHEgNra5JK/rPnIhRPEQT0YezZz/RdauRlCpBAvXZPa2klG90b
	Chzt+mTDuwlsZZAV0XckP0akTeUvlzqmCCvLcjHslogrxnmodnQjX3IWPADcFUKsTLeUZWiZbeX
	FMObic5HwCj3TV/8H7YJiaWgw/CqXeLqb9Mp5yPNLRF1uhHFic8dL8T0qNs2XF+pqT+idi065CF
	KgARVnLB55sLrZw+eHBbQHOcFMkwxaOL/+ND2hlV4hiALgjH/h9Ddm9mfUDNQ73uS21Q0ZX9zkn
	qNkOWJ55iGWGENZ1VslxdaedCYESmb7zErGHsQdCoSccbAvAjCS5nddSK8EZct7eFRsfv9lTHGy
	Q==
X-Received: by 2002:a05:600c:b85:b0:49c:c96a:d36b with SMTP id 5b1f17b1804b1-49cc96ad411mr275821535e9.12.1788161353524;
        Mon, 31 Aug 2026 00:29:13 -0700 (PDT)
Received: from localhost (109-81-17-247.rct.o2.cz. [109.81.17.247])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b94dd2517sm269889955e9.7.2026.08.31.00.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 00:29:13 -0700 (PDT)
Date: Mon, 31 Aug 2026 09:29:11 +0200
From: Michal Hocko <mhocko@suse.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-ID: <apUtRwonTCUF07u5@tiehlicka>
References: <20260828135036.7d44361f@fangorn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828135036.7d44361f@fangorn>

On Fri 28-08-26 13:50:36, Rik van Riel wrote:
> When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> isolation, schedule_drain_work() can drop the work in a separate RCU
> critical section, and housekeeping_update()'s synchronize_rcu() can race
> that second check, leaving the flag set.
> 
> drain_local_stock() only clears the bit for work that ran, so the flag
> remains set and the stock is never drained again.
> 
> Have schedule_drain_work() return whether the work was queued, and clear
> FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> isolated, so future drains can retry.
> 
> Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> Cc: stable@vger.kernel.org
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Rik van Riel <riel@surriel.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks

> ---
> v2: use the approach suggested by Michal and Shakeel
> 
> Link: https://lore.kernel.org/all/cover.1787890328.git.riel@surriel.com/
> 
>  mm/memcontrol.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..309398e943ca 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2306,7 +2306,7 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  	return flush;
>  }
>  
> -static void schedule_drain_work(int cpu, struct work_struct *work)
> +static bool schedule_drain_work(int cpu, struct work_struct *work)
>  {
>  	/*
>  	 * Protect housekeeping cpumask read and work enqueue together
> @@ -2315,8 +2315,11 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>  	 * pending work on newly isolated CPUs.
>  	 */
>  	guard(rcu)();
> -	if (!cpu_is_isolated(cpu))
> -		queue_work_on(cpu, memcg_wq, work);
> +	if (cpu_is_isolated(cpu))
> +		return false;
> +
> +	queue_work_on(cpu, memcg_wq, work);
> +	return true;
>  }
>  
>  /*
> @@ -2348,8 +2351,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  				      &memcg_st->flags)) {
>  			if (cpu == curcpu)
>  				drain_local_memcg_stock(&memcg_st->work);
> -			else
> -				schedule_drain_work(cpu, &memcg_st->work);
> +			else if (!schedule_drain_work(cpu, &memcg_st->work))
> +				clear_bit(FLUSHING_CACHED_CHARGE,
> +					  &memcg_st->flags);
>  		}
>  
>  		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
> @@ -2358,8 +2362,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  				      &obj_st->flags)) {
>  			if (cpu == curcpu)
>  				drain_local_obj_stock(&obj_st->work);
> -			else
> -				schedule_drain_work(cpu, &obj_st->work);
> +			else if (!schedule_drain_work(cpu, &obj_st->work))
> +				clear_bit(FLUSHING_CACHED_CHARGE,
> +					  &obj_st->flags);
>  		}
>  	}
>  	migrate_enable();
> -- 
> 2.55.0
> 
> 

-- 
Michal Hocko
SUSE Labs
