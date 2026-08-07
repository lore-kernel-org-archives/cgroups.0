Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82F645D5D0
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786120311; cv=none; b=ctyKx6qGVvuUDRn5oAWyW1JcRHiLD38AGzdMOdycUAFRIPWmZP9hO/pz+NA8dO1nDRQCY8mo9s64e/QO4Vx9sNW5XzY8f8TGpOEX5lx6wJ/J7La2Br5hb/ZwkV3tSzlNUKZzfZwOMhht7i0SGBtWv8xxGlw4ypSsTmX9+qdP2bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786120311; c=relaxed/simple;
	bh=i2PqP9GN1rc1C/aHcpmeJ7dfbh11hyBtG/3G8aAPeQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2YfLFSvu6Irzvru1LEA/ptILROhVx14O+LERdgSlKB9b1P7U2Pdcxaz3pRompcvzxzTBTQAHTPexz/6m+6PcY8V/jeiZvGOYbsogTekjFErkwWVzJ9vIWe20b+cDzRscHDYzA+yq0aj6fyiMIbV85dpzLiQBnYoP5srWY6PFoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=Ajqh+gc4; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="Ajqh+gc4"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso15834536d6.1
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 09:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786120307; x=1786725107; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dYO5gL84ZfhgoOGOa76MHQFHtbyAJJVUdQQDYUbGmIY=;
        b=Ajqh+gc4UNQMOcqMryzAgygqBtj4Pgh30RDj2x84hSdFOZ7xQq6t0y7EhxWVcE/J7F
         hnI+oNVoUuHqMOI/UIAzG6vVlkCzKNYYyWwB3iMiW8WF8THEUjTnLCuo5Gk15IJG8wOd
         0yMLxPpRgu7AuQUhv3p0OzqHYwcQA9ddGKtlDhEbkExc8nhWqMbffwWx6kCXa63dXwqq
         Dd5VEOTHGqaBgdx40v9XhwohJxaEtQ3kd6S4ZCRDkeUCJ4Ou487M6ezQL8BdtB+t0LcM
         HfIGm082R8imCORrVr5ujmDt+Qf1jKKAlF9vcBoGCRkg8LAuxEgwMV3+2H+czlPVqxlB
         QolQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786120307; x=1786725107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dYO5gL84ZfhgoOGOa76MHQFHtbyAJJVUdQQDYUbGmIY=;
        b=N/EHnpYVjIw1JmffMr9emDhjQ7qNvU58oxJyrAb3UErYvrsvmGDyl56cXyBt5XFjxl
         HdkeHAbsnLGLqQYwBZcCVzlFCKermMx7lTyxvNrxBKnalmn+50eNSDtt1iV09TVZIBpI
         YawRLXcDDzFBETGgRSJOv8bvJNLrP06R9eRBqWK2rk+7uKCejzwqM4n94a+QJKI9Vtk7
         lZgowdIA3hysSdegrLiU3ODGwoUC/OokeVg4y8yH34F7MWNsjt9EvJDUSTMF8XYtk/tx
         v+nRUysDAoMp3j9VjRAN54wBVwJSCcWtlxMiG6BjX4flmoiCbl+BtyP56AktB/HI6DkE
         5BUQ==
X-Forwarded-Encrypted: i=1; AHgh+RolokxkyZSWpHqmVvfxLYPyrWY3tx8c/XfeKJhpufLHnH+714cDonLJd1mQ/yhwLcleVTmngWAv@vger.kernel.org
X-Gm-Message-State: AOJu0YxoRzvGE+UiMdCjVlRFsJX3qzoOPh2iCc+Vadi38zELX29ErmN3
	QaSwJIjgaV3VPuAc+QYWSRGW1jDvFMLSmGeFvOwXDvDaY0sEIwGM0gYCSoz7fNCRKk0=
X-Gm-Gg: AR+sD136NQ8pPCczPR5L0d4LuSylflrXmESuU9HSJV7/PwrETnkuUN2HxxUaV40qCJ4
	vIcGlYOB6Q/bydTVC8D8PEbKHXb+Rdl9f+sHSzopPc6/yGXLgixSciZZgpoXkMkj/tHEyWhYexR
	L0eRCr59p1kaCTm2fRuso4XsBu8hynCkcobMW733FbE17UvZUj95dyzNNbhWGBq5nAmBwkC9A1e
	XijcOsEcP5eQMECfGpYxeDF1zEk6fChBEcLqPBoScJx6Up8zAQ8JYwIu2h8MvvwHmXodUb9+3IC
	C5bBoPsSjGaP7Lskv08RnbPzQYwW97kY4zJz7W18bqCnzuKVrvZsgW4QZhG/uCdvLqoMacfnHYs
	1d9+c7l5ElOV+2e5DX9Jpgta93EWYWOJrmjW70DIfPKT76FSrZmNRx3L6bO12kowzeCwxqAekDb
	GBoJjaE5Fm7J9duG4PWalz8+/K/P5WhUDPmMPruO2rHX1Xj+rd/f5JZKNKe+E=
X-Received: by 2002:ad4:5c8f:0:b0:907:6f9c:3b43 with SMTP id 6a1803df08f44-90a34c86e42mr12128346d6.2.1786120307299;
        Fri, 07 Aug 2026 09:31:47 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908a932ce88sm12048886d6.38.2026.08.07.09.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 09:31:46 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:31:42 -0400
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
Subject: Re: [PATCH v3 08/11] mm, swap: only charge physical swap entries
Message-ID: <anYIboHEUZb4fhHv@cmpxchg.org>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
 <20260806184254.3790858-9-nphamcs@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806184254.3790858-9-nphamcs@gmail.com>

On Thu, Aug 06, 2026 at 11:42:51AM -0700, Nhat Pham wrote:
> Charge memcg->swap when a vswap entry acquires physical backing rather
> than when it is allocated, so memory.swap.current tracks on-disk swap
> usage. Zswap-backed and zero-filled pages occupy no swap space but were
> charged as though they did.
> 
> memory.swap.current therefore no longer counts them, and a cgroup whose
> pages all land in zswap can now reclaim anon memory with memory.swap.max
> set to 0.
> 
> Direct-mapped physical swap charging is unchanged.
> 
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>

To head off any uncertainty about this: this is exactly what needs to
happen in terms of cgroup semantics.

memory.swap.* are about physical swap space. They track, control, and
enforce fairness for a finite resource that is separate from memory.

When a user switches on vswsap and a bunch of empty pages are stored
inside the zeromap without consuming swapfile space, these counters
must be 0.

When a user switches on vswap to use zswap without a backing file,
these counters must be 0.

When a user switches on vswap to use zswap with writeback, only the
pages that get written to the swapfile must be tracked and controlled
by these counters.

A few inline comments on the implementation:

> @@ -5701,6 +5702,116 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>  	return 0;
>  }
>  
> +/**
> + * __mem_cgroup_record_swap - record memcg for swap without charging
> + * @folio: folio being added to swap
> + *
> + * Pin the memcg private ID ref and record it in the swap cgroup table
> + * without charging memcg->swap; the charge is deferred to physical-backing
> + * allocation (vswap).
> + */
> +void __mem_cgroup_record_swap(struct folio *folio)
> +{
> +	unsigned int nr_pages = folio_nr_pages(folio);
> +	struct swap_cluster_info *ci;
> +	struct mem_cgroup *memcg;
> +	struct obj_cgroup *objcg;
> +
> +	if (do_memsw_account())
> +		return;
> +
> +	objcg = folio_objcg(folio);
> +	VM_WARN_ON_ONCE_FOLIO(!objcg, folio);
> +	if (!objcg)
> +		return;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	if (!folio_test_swapcache(folio)) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> +	rcu_read_unlock();
> +
> +	ci = swap_cluster_get_and_lock(folio);
> +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> +			  mem_cgroup_private_id(memcg));
> +	swap_cluster_unlock(ci);
> +}
> +
> +/**
> + * __mem_cgroup_charge_backing_phys_swap - charge memcg->swap
> + * @memcg: the mem_cgroup to charge (may be NULL)
> + * @nr_pages: number of physical swap pages to charge
> + *
> + * Charge the swap counter when a vswap entry gains physical backing. The
> + * private ID ref is already held (pinned by __mem_cgroup_record_swap() at
> + * vswap allocation), so this only moves the counter.
> + *
> + * Return: 0 on success, -ENOMEM on failure.
> + */
> +int __mem_cgroup_charge_backing_phys_swap(struct mem_cgroup *memcg,
> +					  unsigned int nr_pages)
> +{
> +	struct page_counter *counter;
> +
> +	if (do_memsw_account())
> +		return 0;
> +	if (!memcg)
> +		return 0;
> +
> +	if (!mem_cgroup_is_root(memcg) &&
> +	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> +		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
> +		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> +		return -ENOMEM;
> +	}
> +	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> +	return 0;
> +}

These functions are just __mem_cgroup_try_charge_swap() in two acts :-)

Please refactor this properly:

__mem_cgroup_swap_record()
__mem_cgroup_swap_charge()

> + * __mem_cgroup_uncharge_backing_phys_swap - uncharge memcg->swap counter
> + * @memcg: the mem_cgroup to uncharge (may be NULL)
> + * @nr_pages: number of physical swap pages to uncharge
> + *
> + * Uncharge the swap counter on physical backing release for a vswap entry.
> + * The private ID ref is dropped separately via __mem_cgroup_id_put_swap() when
> + * the vswap entry is freed.
> + */
> +void __mem_cgroup_uncharge_backing_phys_swap(struct mem_cgroup *memcg,
> +					     unsigned int nr_pages)

Same on the uncharge side...

__mem_cgroup_swap_uncharge()

> +{
> +	if (!memcg)
> +		return;
> +
> +	if (!mem_cgroup_is_root(memcg)) {
> +		if (do_memsw_account())
> +			page_counter_uncharge(&memcg->memsw, nr_pages);
> +		else
> +			page_counter_uncharge(&memcg->swap, nr_pages);
> +	}
> +	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> +}
> +
> +/**
> + * __mem_cgroup_id_put_swap - drop memcg private ID ref without uncharging
> + * @id: cgroup private id
> + * @nr_pages: number of refs to drop
> + */
> +void __mem_cgroup_id_put_swap(unsigned short id, unsigned int nr_pages)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_private_id(id);
> +	if (memcg)
> +		mem_cgroup_private_id_put(memcg, nr_pages);
> +	rcu_read_unlock();
> +}

__mem_cgroup_swap_put()

and then remove __mem_cgroup_uncharge_swap(). Handle this split the
same way as on the charge path.

> @@ -2116,8 +2117,16 @@ int folio_alloc_swap(struct folio *folio)
>  			goto again;
>  	}
>  
> -	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> -	if (unlikely(mem_cgroup_try_charge_swap(folio)))
> +	/*
> +	 * A vswap entry has no physical swap yet, so only record the memcg;
> +	 * folio_realloc_swap() charges once backing is allocated.
> +	 *
> +	 * Need to call this even if allocation failed, for MEMCG_SWAP_FAIL.
> +	 */
> +	if (folio_test_swapcache(folio) &&
> +	    is_vswap_entry(folio->swap))
> +		mem_cgroup_record_swap(folio);
> +	else if (unlikely(mem_cgroup_try_charge_swap(folio)))
>  		swap_cache_del_folio(folio);

This becomes:

	if (!vswap && mem_cgroup_swap_try_charge())
		abort
	mem_cgroup_swap_record()

> @@ -2614,18 +2685,28 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
>  		/*
>  		 * Uncharge swap slots by memcg in batches. Consecutive
>  		 * slots with the same cgroup id are uncharged together.
> +		 * For vswap, only drop the ID ref - physical swap was
> +		 * already uncharged in __vswap_release_backing above.
>  		 */
>  		id_cur = __swap_cgroup_clear(ci, ci_off, 1);
>  		if (batch_id != id_cur) {
> -			if (batch_id)
> -				mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
> +			if (batch_id) {
> +				if (is_vswap)
> +					mem_cgroup_id_put_swap(batch_id, ci_off - batch_off);
> +				else
> +					mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
> +			}

And this becomes:

	if (!vswap)
		mem_cgroup_swap_uncharge()
	mem_cgroup_swap_put()
