Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B5E21A453
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 12:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787832258; cv=none; b=POXXfEjoAw9IsIluFSQaeDxKRZYdV7QyW7Zjo5gstw34ozyXyogkdiebi/wtp8OLdDz54DLKppiB5Riy6bAODISU9wFTq9V0kDy/dhhk8d60On2w0seiRvKrdLCyaFufPWrpl7/brV6lqj+pVxEQ8WyTzMmIcYcRmI4bEIHJjTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787832258; c=relaxed/simple;
	bh=sisPV8gzEpPlKpghtjt/eOx5vsk5qM8t0MCPsEmqUhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Za8FB6GbRfiC771m767JULMt7VWMS0k5Y12ouY0U2SkbhdphjusdSNZIqZvoxwW5V8w7BvHaB1HIUdUZxDlobl9JlXbwgsBmsFUR0wz/mbyco8mIEwxH2mYuWIjcQBLMTgd+fI/L3vkZL0FfU1SWuA4fGRdMkO5pnJ9YiR45MMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ptc/ttcQ; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ptc/ttcQ"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso7185605e9.3
        for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 05:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787832256; x=1788437056; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GP97XYSOxAd4mwkEh8pXHynZ3Zgb6dcRm0VHZ16u2ys=;
        b=Ptc/ttcQykigA1DF/F2r5O7S/7kxd/H7gnsic9BADBJlWlM586l+y2xqLMgdmDrX5K
         PBiqR8ZwsqEw+bO6z8YcpN6FUapN7EwSaCm2XM9IQAobM5HzN/cuwwTQMgS0Hk8+snhI
         ebUt7Ir1LW9S53JZKPADNbanBCOI+gGWiAMsiRbB9b+CCFZLtQYzSteFGKDk1iCjLc94
         8vPKBd+WhxfgYoRInnOMnAnn+kUIoQzxbjxxwoRQ4Ef0rcK5xA+ltPNIxLtX8f+5EP35
         v9Kprc5fIIVlYhLAL78L1/vSBFQgTHXlhi65jIcKhK/ZVJVvy/WqZlvEtdtAcCKEa/d4
         DMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787832256; x=1788437056;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GP97XYSOxAd4mwkEh8pXHynZ3Zgb6dcRm0VHZ16u2ys=;
        b=gDOihMWtf1WUwGTjeaieUszN39F+HnP4c3pzU63wAFM/4HCCzAIQhTjPxzqDJN/CHI
         lE9RSnwn+BsZwkh5VRC0ERE+2xUj3OrIyC3jKiQEfLjHVkk+XdZOeb63TXFWpvHWE9z0
         m/DmNwx6ZMaWq4tCJMyvXnwCggnuvqSgP9vTWf/pl6uuKmSyFZzfabQ06YJASfLN279A
         AgUsouPtOsUv8Zwqb1BhN66SRWXpQHtIdMNX/nKKeft19bvEW+8DOp+DoO9oCkCMFsDA
         V43/8+8pZhKj1MuP0autpPdTK7S9u0ImkClYsPPA34TDBrMkyL6oRiS7XeoJQlVykuvn
         L3Aw==
X-Forwarded-Encrypted: i=1; AHgh+Rrn+Yy+WLXRZzH2pvxPJUQU/0ROzoumt6YAMZZ2wsv5pPQ4UR8b6L0rgU8SnORFuWMZnUcI16M+@vger.kernel.org
X-Gm-Message-State: AFuF++nrOA8egFJh80HhAyoxRRE70niNA9bCKyePW3R1cFZKOUidJ3/z
	TEhghzBk9kfYoAGNRH6yhjQYcdAZrE+VoOZL0UWXJjxYdlyhJEAhS1OH9+uRzQAxaOY=
X-Gm-Gg: AR+sD13mwSH4mXdzRachN6F//IppJkbU/jXh0YYWWJ2+kA+lyd5kVozHDd/YUMCITlw
	PiDaBYORx3WgYD1jTiQCYFcT1HVzZOPuw65cMFC6iujXDs5+nWcboINXbLqGajq7n48E54JbEaz
	8OJgRKS2N4y94v1dIfP47M0PMQhNn81w7GOS/B/GesgiXtiIQJsXDOWpPThsj8BaH+Yo5LlQ+ej
	GEGbqAs3EKW+4ghbGsiOAeHA4B+3SEr+qkvH8vh4bN6MYiTBb8PRzf+7CHJoy/H7eASyQr1rXJM
	/3vvALFp0IPr2E2i/kfrH0HyE0X0EIsSF+VdTn9nNKAtOVdnrujJFnut75PIZl+8Ygat59oB96k
	p69ItI6QwANExcSXx9b0XGY5IpzfYOEZMOLyfh0uqpqJlC2XB7oIMz8gjMG06W0x67DRqYrZsYV
	igZtvm8i7JkHdwAubTZchNYuCSD2nTzhIgBCEqo9EvKc/jtd/7ffA5OrwwmVlHfI97+P4N1yJkv
	ZnkjRVbpUWA
X-Received: by 2002:a05:600c:3513:b0:496:bbce:fc with SMTP id 5b1f17b1804b1-499dc82c0d7mr166799585e9.12.1787832255539;
        Thu, 27 Aug 2026 05:04:15 -0700 (PDT)
Received: from localhost (109-81-32-216.rct.o2.cz. [109.81.32.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e28dc134sm8549762f8f.20.2026.08.27.05.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 05:04:15 -0700 (PDT)
Date: Thu, 27 Aug 2026 14:04:13 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hao Li <hao.li@linux.dev>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: treat disabled memcg as kmem accounting
 disabled
Message-ID: <apAnveXHmeQlKJnU@tiehlicka>
References: <20260827091813.22327-1-hao.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827091813.22327-1-hao.li@linux.dev>

On Thu 27-08-26 17:17:50, Hao Li wrote:
> mem_cgroup_kmem_disabled() currently only checks whether the
> "cgroup.memory=nokmem" option is specified. However, kmem accounting is
> also unavailable when memcg itself is disabled.
> 
> Check both conditions to ensure the function accurately reflects the
> kmem accounting state.

It would be really great if you could describe how we could end up with
the inconsistent memcg enabled but kmem enabled and what kind of effect
does this have.

AFAICS the inconsistency is possible and it would lead some wastage but
no functional problems but the changelog should be more descriptive.

> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1ebceade4021..b28f6165c354 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -132,7 +132,7 @@ static DEFINE_SPINLOCK(objcg_lock);
>  
>  bool mem_cgroup_kmem_disabled(void)
>  {
> -	return cgroup_memory_nokmem;
> +	return cgroup_memory_nokmem || mem_cgroup_disabled();
>  }
>  
>  static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
> -- 
> 2.54.0

-- 
Michal Hocko
SUSE Labs
