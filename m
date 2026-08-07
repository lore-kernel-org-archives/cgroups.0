Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9734746D1
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 15:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117770; cv=none; b=fpxmp1ZG05MOJHgt1OXtrD/QPieOfz7p1UfTGjPC4cBzvf9GznW9TT0KwseHZUI0rExlgKwLLznS393j7bNm1JjyzBlFSs4/VlXiJdvPznxJcZXdao6C7a/HzghJuQOMVVemo2nUnhvPls0I0W09/sX3Frd1z2Ouz0Z1NzTl/k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117770; c=relaxed/simple;
	bh=yp1hs+SwwFUDahLN4JScNiWQyiGFo5VleKvlH38FXIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItIhQTFwDrFDHFnQ0b5Ulym628D5hBWLEz/eThtacPy9POqt5i2alUJRpj8JAqFQB6cG6nrtlCpPE6hFX8AcaXgdi9sRLaA8fzmQgBw4I4EavftrkJ83UDqleC11Urgj0pmY8PT3u113n+8b4zqAHCIE8jxuaGY8aGvzqVHiOGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=U6ahlEey; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="U6ahlEey"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-902e4af2d9dso16772336d6.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 08:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786117766; x=1786722566; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CEn2KGn5WZDKTdyZCzrkPMcKy/ABJR6AC0QsaSC3OWk=;
        b=U6ahlEeyF2MnVY8m39vPbNNBnICbh/f241swDAZID7b72hcArcVJZqwXAwMbfgQFJg
         rJ9AIYLxV8hNNcWewi1KR9FA4GiKnm9BG9ObTh7eIkVgxbcjTxUQrdKF7labVAgCx3Qd
         9U/hCipVyVQiyGb5DvtOshXjVht1UibJkLHJtr3cNUIE2DrDkYNfvBD9lSML1384su6/
         pq7zOh4WqUfKk1u/86Td2e/kA4fKrU2ggQ2rzo4aZRe15qvLl5YR/gAVlFazKInK/Qn9
         d5Z9178HSMDMq1ggjaA+p3+KopCkhgzevnpnOvpqA1ck+gfKaBEyoVVJ4/45KouSXQyo
         ilnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786117766; x=1786722566;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CEn2KGn5WZDKTdyZCzrkPMcKy/ABJR6AC0QsaSC3OWk=;
        b=Ym6a28D+8/hA2jph2YBUErkIbtMdKls/accTxf3DqFwXg8dCaCjsDG0vy+gjsvemul
         Lh59LvwZgMMn4Y1KDbs8zr5etSaKoUMIIYR33wlF4MyW10MX9AfWDPNRTrijl1Jjqxve
         SNRIwrSwYn/TtGnYcOrEo7D/JV1dut+UEczuHYXpV3/wNOV374MI7UTg75cUmld/hhSv
         0FwnpPJiF3EWd+ENkblhO+d+DPb6KoT4QrEUEF3OOeuhcehLv5yMC0e0m4HwQik9dPXi
         gNYX7nojOYb8XrOK8ZmmsSEgmnb/1bnLyNEMPhEyQ7Ovk9tpy2Q2JLBknqRHbJmRTe8x
         D7ng==
X-Forwarded-Encrypted: i=1; AHgh+RpPW4/1tIExy3huD2rVUlvIqlK+C6G5m8tDVxyS0fmOS3aBhPIg/aALUByi23ovh6T+EqsC5yQq@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5+B3UTyeVWUHUVOp9E56GtoFxOoH9oYKs4VlploGrmhKZgccL
	NF0Csn/ldyE6057ecL8jjCDmOTxcDfTm4S+SMuKGcjF601RwkpwxSEk+XubizY1c364=
X-Gm-Gg: AR+sD12a7gY8UTR4HBYdyYO9DfHmTTOEo2diJ1Lg7uufyD6oDHfO+QgUps17j77/FjU
	G7moQPHhrOZTrLDHtG3A+vRC2nwWjCTyvLHNeesNdkpox8FGZPc+VQIoBs9IyQ3M0eT55S22Uuz
	HmT/YCdsZqbHTAz6FiSzO7s1/X3Geq2mD+8OTYVMqgk6nqsQ3y3QGRLM2+vCaPs24JC8KD12V2O
	6sp3xcXVm8HN3TefpgLw1nlMN8Jlu9eboc8Uj47jd/Px36Z6EGE+W0+6GaSgw9egj49t19uBdi5
	RlmFLZKh7u/xPyi7TZxSmZoR/0cte2oRBvALN8Rr/3bmyMGMv/+0u0ulZ7+8bz2QT1QKHEhf0HK
	vSvpu7cbE320YeK1MuOZLSBCAZx7M6JC43McKrG99+bxhBBhOKpaCC5qxwuKJ3+hs0OFI89Yq5K
	GkZQWrQlsyy/EAQRde7hFCo94iORyBcqhqE0CYPiwNPB4qS7nhyZ1ELZASa5I=
X-Received: by 2002:a05:6214:450e:b0:907:bf1e:f888 with SMTP id 6a1803df08f44-9088f9ec72amr206847166d6.17.1786117766300;
        Fri, 07 Aug 2026 08:49:26 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a92ff8c6sm11404806d6.28.2026.08.07.08.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 08:49:24 -0700 (PDT)
Date: Fri, 7 Aug 2026 11:49:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, riel@surriel.com,
	gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
Message-ID: <anX-ga41DMNWF6-2@cmpxchg.org>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
 <20260806184254.3790858-2-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806184254.3790858-2-nphamcs@gmail.com>

Hello Nhat,

This looks pretty clean to me overall. Nice. A few comments inline:

On Thu, Aug 06, 2026 at 11:42:44AM -0700, Nhat Pham wrote:
> @@ -276,8 +277,21 @@ struct swap_info_struct {
>  	struct list_head discard_clusters; /* discard clusters list */
>  	struct plist_node avail_list;   /* entry in swap_avail_head */
>  	const struct swap_ops *ops;
> +	struct xarray cluster_info_pool; /* Xarray for vswap dynamic cluster info */
>  };
>  
> +#ifdef CONFIG_VSWAP
> +static inline bool swap_is_vswap(struct swap_info_struct *si)
> +{
> +	return si->flags & SWP_VSWAP;
> +}
> +#else

I think what could make sense is have

- CONFIG_VSWAP
- CONFIG_VSWAP_DEFAULT_ENABLED
- a boot flag that's = CONFIG_VSWAP_DEFAULT_ENABLED

Then you can use jump labels to cut runtime overhead to 0 if it isn't
enabled at boot.

This way distributions can ship it with no overhead out of the box,
while allowing users to opt in for early testing.

IMO this is more valuable than a runtime toggle.

It should be part of this patch if you add it.

> +static inline bool swap_is_vswap(struct swap_info_struct *si)
> +{
> +	return false;
> +}
> +#endif
> +
>  static inline swp_entry_t page_swap_entry(struct page *page)
>  {
>  	struct folio *folio = page_folio(page);
> @@ -402,6 +416,8 @@ void swap_free_hibernation_slot(swp_entry_t entry);
>  
>  static inline void put_swap_device(struct swap_info_struct *si)
>  {
> +	if (swap_is_vswap(si))
> +		return;
>  	percpu_ref_put(&si->users);
>  }
>  
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 331daf7fcfab..32d38b552845 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -19,6 +19,16 @@ menuconfig SWAP
>  	  used to provide more virtual memory than the actual RAM present
>  	  in your computer.  If unsure say Y.
>  
> +config VSWAP
> +	bool "Virtual swap device"
> +	depends on SWAP && 64BIT
> +	help
> +	  Adds a virtual swap layer that decouples swap entries in page
> +	  tables from physical backing storage. Swap entries are allocated
> +	  from a virtual swap device and can be backed by zswap, a physical
> +	  swapfile, or kept in memory - with the backing changeable at
> +	  runtime without invalidating page table entries.

IMO this is difficult for a user to decide.

If we want to make this as a config, then IMO the help text should be
about not requiring a swapfile to use zswap, zerofill pages etc.

From where I'm standing, though, this code is no longer a separate
vswap.c feature like it used to be. It's pretty integrated into the
swapcode, and it looks like a good chunk of the core datastructures
aren't conditional either.

At that point, the usefulness of the config option is limited. If you
go with the jump label and there is no runtime overhead, it might make
sense to just keep the option on what the JL should default to.

> @@ -143,9 +150,19 @@ static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
>  static inline struct swap_cluster_info *__swap_offset_to_cluster(
>  		struct swap_info_struct *si, pgoff_t offset)
>  {
> +	unsigned int cluster_idx = offset / SWAPFILE_CLUSTER;
> +
>  	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
>  	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
> -	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> +
> +	if (swap_is_vswap(si)) {
> +		struct swap_cluster_info_dynamic *ci_dyn;
> +
> +		ci_dyn = xa_load(&si->cluster_info_pool, cluster_idx);
> +		return ci_dyn ? &ci_dyn->ci : NULL;
> +	}
> +
> +	return &si->cluster_info[cluster_idx];
>  }

This now requires rcu. IMO a kdoc explaining that would be good.

> @@ -733,6 +765,11 @@ static void free_cluster(struct swap_info_struct *si, struct swap_cluster_info *
>  		return;
>  	}
>  
> +	if (swap_is_vswap(si)) {
> +		vswap_free_cluster(si, ci);
> +		return;
> +	}
> +
>  	__free_cluster(si, ci);

Should this be part of __free_cluster() instead?

- swap_cluster_assert_empty() seems useful.
- move_cluster() handles the list linkage and could do the list_del().
- swap_cluster_free_table() is the same.

The other caller is the discard path. That one isn't relevant, but it
shouldn't hurt. The layering would still be a bit cleaner this way.

> @@ -835,14 +872,21 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
>   * stolen by a lower order). @usable will be set to false if that happens.
>   */
>  static bool cluster_reclaim_range(struct swap_info_struct *si,
> -				  struct swap_cluster_info *ci,
> +				  struct swap_cluster_info **pcip,
>  				  unsigned long start, unsigned int order,
>  				  bool *usable)
>  {
> +	struct swap_cluster_info *ci = *pcip;
>  	unsigned int nr_pages = 1 << order;
>  	unsigned long offset = start, end = start + nr_pages;
>  	unsigned long swp_tb;
>  
> +	/*
> +	 * Take RCU read lock before releasing the cluster lock to keep ci
> +	 * alive - for vswap dynamic clusters, ci is freed via kfree_rcu
> +	 * and the grace period could otherwise elapse in the window.
> +	 */
> +	rcu_read_lock();
>  	spin_unlock(&ci->lock);

Since you replace the naked spin_lock() below with
swap_cluster_lock(), change this to swap_cluster_unlock() as well?

>  	do {
>  		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
> @@ -852,7 +896,15 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
>  			if (__try_to_reclaim_swap(si, offset, TTRS_ANYWAY) < 0)
>  				break;
>  	} while (++offset < end);
> -	spin_lock(&ci->lock);
> +	rcu_read_unlock();
> +
> +	/* Re-lookup: dynamic cluster may have been freed while lock was dropped */
> +	ci = swap_cluster_lock(si, start);
> +	*pcip = ci;
> +	if (!ci) {
> +		*usable = false;
> +		return false;
> +	}
>  
>  	/*
>  	 * We just dropped ci->lock so cluster could be used by another

> @@ -1146,6 +1239,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
>  			goto done;
>  	}
>  
> +	if (swap_is_vswap(si)) {
> +		found = alloc_swap_scan_dynamic(si, folio);
> +		if (found)
> +			goto done;
> +	}

The name and the composability look off to me.

Can you make this a pure allocation function - vswap_alloc_cluster()
or something - that links it to &si->free_clusters, then jump back and
use the existing alloc_swap_scan_list() sites?

There is a new_cluster: label upstream you could use for the retry.

> +
>  	if (!(si->flags & SWP_PAGE_DISCARD)) {
>  		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
>  		if (found)
> @@ -1264,6 +1363,13 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
>  			goto skip;
>  	}
>  
> +	/*
> +	 * Keep vswap off the avail list - it is not allocated from by
> +	 * the physical swap allocator (swap_alloc_fast/slow).
> +	 */
> +	if (swap_is_vswap(si))
> +		goto skip;

This is describing what the code does, followed by a why not.

Describe the why: Vswap space is only allocated through [...], not [...]

> @@ -3528,10 +3668,43 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  				    unsigned long maxpages)
>  {
>  	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> -	struct swap_cluster_info *cluster_info;
> +	struct swap_cluster_info *cluster_info = NULL;
> +	struct swap_cluster_info_dynamic *ci_dyn;
>  	int err = -ENOMEM;
>  	unsigned long i;
>  
> +	/* For SWP_VSWAP files, initialize Xarray pool instead of static array */
> +	if (swap_is_vswap(si)) {
> +		/*
> +		 * Pre-allocate cluster 0 and mark slot 0 (header page)
> +		 * as bad so the allocator never hands out page offset 0.
> +		 */
> +		ci_dyn = kzalloc_obj(*ci_dyn, GFP_KERNEL);
> +		if (!ci_dyn)
> +			goto err;
> +		spin_lock_init(&ci_dyn->ci.lock);
> +		INIT_LIST_HEAD(&ci_dyn->ci.list);
> +
> +		nr_clusters = 0;

But it's one, not zero. And only the first slot is bad. Why is the
rest not usable and the cluster on the nonfull_clusters list?

I think you can make the integration a bit more organic in general:

Don't do the DIV_ROUND_UP per default only to overwrite it here again
e.g.

If you come out of this branch with cluster_info == &ci_dyn->ci, you
should be able to reuse the existing swap_cluster_setup_bad_slot(0).

swap_header && i < swap_header->info.nr_badpages should skip that loop
as well.

Your maxpages is SWAPFILE_CLUSTER aligned, so that

	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {

loop is skipped as well.

> +		xa_init_flags(&si->cluster_info_pool, XA_FLAGS_ALLOC);
> +		err = xa_insert(&si->cluster_info_pool, 0, ci_dyn, GFP_KERNEL);
> +		if (err) {
> +			kfree(ci_dyn);
> +			goto err;
> +		}
> +
> +		err = swap_cluster_setup_bad_slot(si, &ci_dyn->ci, 0, false);
> +		if (err) {
> +			xa_erase(&si->cluster_info_pool, 0);
> +			swap_cluster_free_table(&ci_dyn->ci);
> +			kfree(ci_dyn);

IMO it would be nicer to make this part of free_swap_cluster_info()
instead of duplicating it.

> +			xa_destroy(&si->cluster_info_pool);

That one probably doesn't matter. If these allocations fail at boot,
the system is in trouble.

> +			goto err;
> +		}
> +
> +		goto setup_cluster_info;
> +	}
> +
>  	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
>  	if (!cluster_info)
>  		goto err;
> @@ -3556,6 +3729,10 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
>  	if (err)
>  		goto err;
> +
> +	if (!swap_header)
> +		goto setup_cluster_info;

Is this reachable?

> @@ -3949,3 +4127,51 @@ static int __init swapfile_init(void)
>  	return 0;
>  }
>  subsys_initcall(swapfile_init);
> +
> +#ifdef CONFIG_VSWAP
> +struct swap_info_struct *vswap_si;
> +
> +/* vswap does no IO on its own. */
> +static const struct swap_ops vswap_ops = { };
> +
> +static int __init vswap_init(void)
> +{
> +	struct swap_info_struct *si;
> +	unsigned long maxpages;
> +	int err;
> +
> +	si = alloc_swap_info();
> +	if (IS_ERR(si))
> +		return PTR_ERR(si);
> +
> +	maxpages = min(swapfile_maximum_size,
> +		       ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUSTER));
> +	si->flags |= SWP_VSWAP | SWP_SOLIDSTATE | SWP_WRITEOK;

Please add a comment on the flag choices besides SWP_VSWAP.
