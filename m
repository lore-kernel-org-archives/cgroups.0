Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF9939D3D0
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 11:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976868; cv=none; b=qCxCl3hcK+4skfdM+8TeIfhmGbJkn4L+tijmP55disE8okmF919KeyLZE4g2PGa+EuBPb5ZFWOsBIWKWiMRD+oxYPkMsyFRhnn4BuEAzr8kuUpQnJT9XSdKPu8hbK19BAbx7lG4GDbPU+yRwgrjBD9leApxT4FGEAdrY4qw8RhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976868; c=relaxed/simple;
	bh=Ch0k37ZwRXyF+QmHQJEjZjn8meEqwJrUMR+Eu0Lv7aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ff9UWn+kduMal3TXAfDLFB7OnBJyEgwXgYjsc9J0rKTH+DxW0KNBRPblbHC4z/t9X10ir8E4Io9HsI2+q72mrpjYqbLBdPXMHW3kRFueieVC75zijyj2MoHilXuq1+B+Zs4K8qoSiXWofJpnl/DDz6XanKFMvmZhpNBKnaY/BXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UMLG9yr4; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UMLG9yr4"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1682bff3cso3754605e9.1
        for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 04:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791976865; x=1792581665; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KDrnC41SrQnoIWB3x7VgCSDF/VPgZxWskPROOodTSN8=;
        b=UMLG9yr4APlXj2SYfzoNLTD4OigNxm43sP9VjcxtEuj4gsw85SSEroiR1qv/1CBHAh
         FfNYygywHcMLgAnEfF0AHSE/YceWgB9/EUchVejwC/xN++SdLcDkm7uAPjZP4eZqXDDN
         5UHCu3ShcLE6hPiozgiGWoeZmQ3gUz1ccpfByWvMn9+4mLETlEZNrCi7athv5jjJ7Oq9
         CZt0rl7dqWIJmcpOADSTjiX5cSKa7gyFBXDDJ0iJu+HjOyOpf+EExSzV0xN/N56rmgWe
         37jVEYQ/I7lQzqmgIPWVDzfGmqoVDT4mM7geP1Yxlc4MqGPwE/XFS2y4hXaLfQ5y6GsO
         PaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791976865; x=1792581665;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KDrnC41SrQnoIWB3x7VgCSDF/VPgZxWskPROOodTSN8=;
        b=i1cq2B6uD9RobVWuUcXhpwFO8TZso8W2q1sjdg5uwXK5Cnvm9yON+IqfXfo9R2smGR
         dQ3Nv0CrXJB6XPDEjei6d8CPjatKXXmLuFguxNXUtLYliL3+m8m3dceBIT/1JDfzBkli
         izkdHj97gumnkMklhVMnF+RH8NC/Wjzam9LJHGF/HTOIJ79/B3zi3+g9usRqygXKNKdI
         g8liWN7S8dyZEMFDES47UY1vuRf0O/gqRJCxCOJgDqBqc/Xps3qf9ZEnS58bXzxNzmTU
         7ryW5y7FOmtbaCC1IrBDjsW9KZby3sQHY+k1lIxKtO/oIEiLSj83T4UzUi1up0LlkAMk
         FkjQ==
X-Forwarded-Encrypted: i=1; AKwUvBxnVr6uNMz6/n01MwKN8Tu1brpUVZrvl5cDImj5ZnMCXaOPuE6y1CWOMEYuVdk7jlhAC4CsZRU0@vger.kernel.org
X-Gm-Message-State: AFq9FYJUoVWUWmAUZWlFtDNqUwedelKL4FBhwyTvtC+Clx3dJs+ZBHpB
	63FEqQXhcnkUbwOAA1IqA9dHC0W8h5JYL0N1gOW54XS9gVjZYtF3H3UexVTNY0+jymk=
X-Gm-Gg: AYBFou2wQx5Z13BTt+bNBSVJCtbCijfdQN1QPExoXFJ/SbVYvvFUba7zyAy6gvhUekb
	D1hp1TCAHheLbeEbCpsdGF/uU4m37k2+/k0OSxzwHcfmO/sA9Y6zkL34c5O1qcbQjyEf7t41Dwi
	0UUrh7NT68UM2xqlRO9+w+HHUG/FNFyyWrLMuzZ4kZS4dnNDE1MXCh4ktVkKIfn4eKyk2est2jQ
	RKZCnDkijSg8YvUHyGgkxusNZhI+hun87nkdC3/88FSqP/WKjm67ylph3VxaujZFttEQswmdKyM
	i+/8n3iYJvu8Q+uz7P7lSSEBM8QG8ahSLDpxX90j/Q/0QF+fuSYPNbLzpRk4kvf/8f/rRFAlMKs
	eiTpgmpmlRDxzTtR5mH9kQoLAs8AlCiMD3YiHsdXzTr/ApvOxac2j+Uh2tqKcMWY7zU3Kd+UElC
	jHW1xvOXuJb78JcqMHx3MUsmEv20vU7T/3ZutBeFnoWLdT6GUnw/8kdML2Xn4XdjveU2hfnpaIR
	m7vcqxASiCk
X-Received: by 2002:a05:600c:3f0c:b0:4a1:6517:ccf1 with SMTP id 5b1f17b1804b1-4a18e47a844mr324249785e9.9.1791976864761;
        Wed, 14 Oct 2026 04:21:04 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ab6361sm9561760f8f.32.2026.10.14.04.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:21:03 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:21:01 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 2/5] memcg: use high_work for kernel threads
Message-ID: <as9lnTYY0NCAp-c5@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-3-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-3-shakeel.butt@linux.dev>

On Sat 10-10-26 14:09:54, Shakeel Butt wrote:
> Kernel threads never return to userspace, so deferred memory.high
> reclaim does not run. Reclaim and throttling during a charge can also
> delay work they do for other tasks.
> 
> Treat kernel threads like interrupts. Queue high_work for the first
> cgroup over memory.high and skip reclaim and throttling in the charging
> thread.
> 
> User workers created by create_io_thread() and vhost_task_create() keep
> their current behavior. Vhost kernel threads use the new path, even when
> they borrow the owner's mm.
> 
> The worker requests a fixed batch of pages each time. A fast allocator
> can keep usage well above memory.high. Kernel threads also skip
> memory.swap.high throttling and its high-event reporting. The memory.max
> and memory.swap.max checks stay the same.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

yes this makes sense as a general improvemnt.

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
> ---
>  mm/memcontrol.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 20c5dfe1a894..8116fce6ab96 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2705,6 +2705,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  			       gfp_t gfp_mask)
>  {
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> +	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
>  
>  	/*
>  	 * If the hierarchy is above the normal consumption range, schedule
> @@ -2723,8 +2724,12 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  		swap_high = page_counter_read(&memcg->swap) >
>  			READ_ONCE(memcg->swap.high);
>  
> -		/* Don't bother a random interrupted task */
> -		if (!in_task()) {
> +		/*
> +		 * Don't make an unrelated interrupted task handle this charge.
> +		 * Kernel threads may be working for other tasks, so let a worker
> +		 * reclaim instead.
> +		 */
> +		if (use_worker) {
>  			if (mem_high) {
>  				if (allow_spinning)
>  					schedule_work(&memcg->high_work);
> @@ -2751,6 +2756,10 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
>  		}
>  	} while ((memcg = parent_mem_cgroup(memcg)));
>  
> +	/* Interrupts and kernel threads stop here. */
> +	if (use_worker)
> +		return;
> +
>  	/*
>  	 * Reclaim is set up above to be called from the userland
>  	 * return path. But also attempt synchronous reclaim to avoid
> -- 
> 2.53.0-Meta
> 

-- 
Michal Hocko
SUSE Labs
