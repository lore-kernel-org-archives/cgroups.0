Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF80D3644CA
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 08:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786609382; cv=none; b=kZ4TixWwQ3IK8TcEXQGK9WAbHEwhdo0TUUEE23HNSHOahcoARZhoBpxQ75mwcXLDVpu+dLOjdPkGsVzFDPtZjrxcp2oB4D6MVpzSU2ScInsjKGIXj7glIW4sSAGGN32Ep/yy8gtH6Qq9PoPj2u/zjw54O/sJCnB/iJE0e92jUE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786609382; c=relaxed/simple;
	bh=oZzXzorDBfVYIoQLhCsLyR4CdgepGNwaUW+q8EUzLAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h7E+7zLDnvhtZ7iszOXmRTMJX4B76EXwBN02Sac98RvTr8G5s9riHYa7tY/l0p6te1BzwN8MSuxr6aeji1YQE4Bk9D2Ya/bCilOzUHnUx7iAtJF8OEhbFuZQpntI4+UaC8IN8u+n8n9gHS4EKDmBnrhqwbRb/5uF2a94bHbPsPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Mc9f7Sgg; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Mc9f7Sgg"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49558ce01afso14397845e9.1
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609379; x=1787214179; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ADGYe9gSWNwrnz5xQxNpg6LlRco8vJEKHwyfHThFbis=;
        b=Mc9f7SggLyY7H2AKfXSWyYGHSMxxuptdzNtq4imwyvZal5Fj5dBNgi+MC0G+/yIiuS
         /XuhU4SX/ejQsQnW2Hda4t2W55p8O1PeD3amRRZDdBZY5lqCsn8pdQVTcZeix03aIJRI
         JS5RoljLPHD5MGsxhBFl+GY+nW+Fr/SgJ/h7526AvFYTesXmubRmBF9X3agg91l1Fy5z
         wWm5BCQn2CN4iMZh24bp/MvsgS2ozmpNrDKoskONgvJy1Ud+4ygcqLfG/eqg1vFdWIKm
         EfQo0b+m9PrzrCOF3+SosacamCZFPDXny0E7UqrlKN51otKvQ38iGXIzjWRyBZ1x/SgD
         tgFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609379; x=1787214179;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ADGYe9gSWNwrnz5xQxNpg6LlRco8vJEKHwyfHThFbis=;
        b=Zp3CU8XjyoPUemHsmUuPK8jC7lILhB2CR7ShvG2J0snpXMU5RoRJp+lPMPvHgcJQ/L
         gHmBn20EBREKxuvVPoyC1+eEu7FCkRd1j2R/cANaXYKbPfIjDD7SJ/z/D/L+G5nF5Q6I
         9LAyiMqYiLYSeph7vTuWDFxSzLY0kn23/RPhn4R5Qz3hJcHNZY8TpcBKPPVPuPpXXuJW
         vadGq8U+8j60kLdeO5lUCO6CmxndUQciZ90O0vnwbMGlNRmnYDBN3luEwF4ihHfcxYbm
         jgZVYfOPPeGaBR4lQC1lWMq3MCRmX54HGzY9OlT0xq6GUqXEca500Zjyg6gsy/P+wNVJ
         QFSA==
X-Forwarded-Encrypted: i=1; AHgh+Rq05q4cHoKft6WsiMlgssuatUR+42mmMkeEAhq12Va9oOG/g0NJ16UVIST9J+0kN6yQum5rSzIT@vger.kernel.org
X-Gm-Message-State: AOJu0YyTXAeP1eccie6g54sUhTnWFCu+rwuO/Hoxw+N6sPisMrpJbQQq
	tvWQK80vIAr+sgDeenb2ViqXFDpnD6cG7/bgUEIaAIol7WRDiCPQ7HAL9xHC8YzD4zw=
X-Gm-Gg: AR+sD12NAT82vniu6WyDIAylARcqgv2YT+131l/wbtj7HqQoeWgsHatzwwp8fL/IkbL
	dKSNuX02bdd+IjKvR6YhoLX1DWmLGyjI9tqWhfV+BO/VhEMRzFdJ2hQwYM3gZS53j6aSBGLk/xr
	gPIw+nPUIm9DPJgqDflICr1haNNRe70EZq8/RhgOS9Uq8yiEaTUoYjO568hkLLkDXnO+6y+2CCV
	FpPtq4+Le7/GfhwM7wJj1yEAVjtzQgk9pqJwmQsUIFHvQ27NdlCjs0Pi1fOjYB2xuOdoAD0UmsM
	k8ZZhfSed/g/oCWvjhVvqO1b4R5+/HbE58j9hpb63zDXVg1G2OB9xLZElJdlcPlzu4lhgB/Z+iT
	pwqY2toN+bMkCSvafZDuI2RZCfomebgBS4nLnN7H57/213lBsjLTK2i3MkoYRCPRCUZiVJenHmO
	Ku/NL5zyXv3VqvlT59lBbdtA64L3H2U2wPbEPBc3aY7D0Nr4DV+tRrcAtleWCFhP3EXxgmIB4=
X-Received: by 2002:a05:600c:4fc5:b0:499:7f38:d77 with SMTP id 5b1f17b1804b1-49982183d4amr40750515e9.6.1786609378615;
        Thu, 13 Aug 2026 01:22:58 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981de6a05sm70856685e9.1.2026.08.13.01.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:22:58 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:22:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Message-ID: <an1-4Rgwlsfd9Hjt@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-2-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-2-shakeel.butt@linux.dev>

On Tue 11-08-26 13:31:55, Shakeel Butt wrote:
> The v1 soft limit has been deprecated since v6.12 and nobody has
> reported depending on it. Start the removal by decoupling the interface
> from the implementation: keep memory.soft_limit_in_bytes, but ignore
> writes to it and always report the maximum value on read similar to
> what memory.kmem.limit_in_bytes already does.
> 
> Writes are still parsed, so malformed input keeps returning -EINVAL.
> The knob now also behaves the same everywhere: it used to return
> -EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
> disabled.

Is there any specific reason to not return EOPNOTSUPP for everybody now?

> This also fixes the syzbot report linked below. Soft limit reclaim is
> the only caller that runs shrink_lruvec() from kswapd against a
> specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
> and in turn set_mm_walk(), which warns when called from kswapd.
> 
> Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Anyway
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  .../admin-guide/cgroup-v1/memory.rst          | 49 +++----------------
>  mm/memcontrol-v1.c                            | 43 +++++++++-------
>  2 files changed, 32 insertions(+), 60 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
> index 7db63c002922..7d2a44af52c9 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -47,7 +47,6 @@ Features:
>   - pages are linked to per-memcg LRU exclusively, and there is no global LRU.
>   - optionally, memory+swap usage can be accounted and limited.
>   - hierarchical accounting
> - - soft limit
>   - moving (recharging) account at moving a task is selectable.
>   - usage threshold notifier
>   - memory pressure notifier
> @@ -76,10 +75,9 @@ Brief summary of control files.
>   memory.memsw.failcnt		     show the number of memory+Swap hits limits
>   memory.max_usage_in_bytes	     show max memory usage recorded
>   memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
> - memory.soft_limit_in_bytes	     set/show soft limit of memory usage
> -				     This knob is not available on CONFIG_PREEMPT_RT systems.
> -                                     This knob is deprecated and shouldn't be
> -                                     used.
> + memory.soft_limit_in_bytes	     This knob is deprecated and has no effect.
> +                                     Writes are ignored and reads always
> +                                     return the maximum value.
>   memory.stat			     show various statistics
>   memory.use_hierarchy		     set/show hierarchical account enabled
>                                       This knob is deprecated and shouldn't be
> @@ -340,9 +338,6 @@ memory.kmem.usage_in_bytes, or in a separate counter when it makes sense.
>  The main "kmem" counter is fed into the main counter, so kmem charges will
>  also be visible from the user counter.
>  
> -Currently no soft limit is implemented for kernel memory. It is future work
> -to trigger slab reclaim when those limits are reached.
> -
>  2.7.1 Current Kernel Memory resources accounted
>  -----------------------------------------------
>  
> @@ -710,42 +705,10 @@ For compatibility reasons writing 1 to memory.use_hierarchy will always pass::
>  
>  THIS IS DEPRECATED!
>  
> -Soft limits allow for greater sharing of memory. The idea behind soft limits
> -is to allow control groups to use as much of the memory as needed, provided
> -
> -a. There is no memory contention
> -b. They do not exceed their hard limit
> -
> -When the system detects memory contention or low memory, control groups
> -are pushed back to their soft limits. If the soft limit of each control
> -group is very high, they are pushed back as much as possible to make
> -sure that one control group does not starve the others of memory.
> -
> -Please note that soft limits is a best-effort feature; it comes with
> -no guarantees, but it does its best to make sure that when memory is
> -heavily contended for, memory is allocated based on the soft limit
> -hints/setup. Currently soft limit based reclaim is set up such that
> -it gets invoked from balance_pgdat (kswapd).
> -
> -7.1 Interface
> --------------
> -
> -Soft limits can be setup by using the following commands (in this example we
> -assume a soft limit of 256 MiB)::
> -
> -	# echo 256M > memory.soft_limit_in_bytes
> -
> -If we want to change this to 1G, we can at any time use::
> +Writing to memory.soft_limit_in_bytes has no effect and reading it will
> +always return the maximum value.
>  
> -	# echo 1G > memory.soft_limit_in_bytes
> -
> -.. note::
> -       Soft limits take effect over a long period of time, since they involve
> -       reclaiming memory for balancing between memory cgroups
> -
> -.. note::
> -       It is recommended to set the soft limit always below the hard limit,
> -       otherwise the hard limit will take precedence.
> +Use memory.low and memory.min in cgroup v2 instead.
>  
>  .. _cgroup-v1-memory-move-charges:
>  
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 835fc8e51184..05ef55cae4dc 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -96,7 +96,6 @@ enum {
>  	RES_LIMIT,
>  	RES_MAX_USAGE,
>  	RES_FAILCNT,
> -	RES_SOFT_LIMIT,
>  };
>  
>  #ifdef CONFIG_LOCKDEP
> @@ -1888,6 +1887,30 @@ static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
>  	return -EINVAL;
>  }
>  
> +static u64 mem_cgroup_soft_limit_read(struct cgroup_subsys_state *css,
> +				      struct cftype *cft)
> +{
> +	return (u64)PAGE_COUNTER_MAX * PAGE_SIZE;
> +}
> +
> +static ssize_t mem_cgroup_soft_limit_write(struct kernfs_open_file *of,
> +					   char *buf, size_t nbytes, loff_t off)
> +{
> +	unsigned long nr_pages;
> +	int ret;
> +
> +	ret = page_counter_memparse(strstrip(buf), "-1", &nr_pages);
> +	if (ret)
> +		return ret;
> +
> +	pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
> +		     "Writing any value to this file has no effect. "
> +		     "Please report your usecase to linux-mm@kvack.org if you "
> +		     "depend on this functionality.\n");
> +
> +	return nbytes;
> +}
> +
>  static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
>  			       struct cftype *cft)
>  {
> @@ -1924,8 +1947,6 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
>  		return (u64)counter->watermark * PAGE_SIZE;
>  	case RES_FAILCNT:
>  		return counter->failcnt;
> -	case RES_SOFT_LIMIT:
> -		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
>  	default:
>  		BUG();
>  	}
> @@ -2020,17 +2041,6 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
>  			break;
>  		}
>  		break;
> -	case RES_SOFT_LIMIT:
> -		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
> -			ret = -EOPNOTSUPP;
> -		} else {
> -			pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
> -				     "Please report your usecase to linux-mm@kvack.org if you "
> -				     "depend on this functionality.\n");
> -			WRITE_ONCE(memcg->soft_limit, nr_pages);
> -			ret = 0;
> -		}
> -		break;
>  	}
>  	return ret ?: nbytes;
>  }
> @@ -2384,9 +2394,8 @@ struct cftype mem_cgroup_legacy_files[] = {
>  	},
>  	{
>  		.name = "soft_limit_in_bytes",
> -		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
> -		.write = mem_cgroup_write,
> -		.read_u64 = mem_cgroup_read_u64,
> +		.write = mem_cgroup_soft_limit_write,
> +		.read_u64 = mem_cgroup_soft_limit_read,
>  	},
>  	{
>  		.name = "failcnt",
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs
