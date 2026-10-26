Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006983;
	b=sQekpIvJcDdEz0esHd+wRzWRGdt1NGA8ZAS9x5WBdCQyhpNmjpgSi9JazGAItoGW9scH
	 0dRvaaIHbL18keFd0UdwVC382eFZv+aC8zEZh+pKaKqoQvf1G9qiyq+X+vRwgNcG6i389
	 THgcyISyW5aCd5sG7tyaPdDtJTJsPIfeC/peBkap9tU53yeJUDrke3kNfKGHe+CIwlpux
	 1b4GWDV8nW3nqyRsuzF5z4OtfH9lJcq/OEmQCKWioY29S4Yy9YORKJ8/R64TXgqwgtBcI
	 UWXvg59ehhZRPnKpOiqOfebKJiSR1647deEledPERBQ8HlKHMbXzS2HtXYHOalHiS/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006983;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=RsawiG6L+7MbIfpDDEJd12nG5n3sYWkrFkopCA9f4hQ=;
	b=25vKhB9jXVyz6gZSC/kyWKG7AgffHkqfFEYstjJttj/oRbGZAhRqTKrj1KBDKTxaw1qa
	 ggXVOsCR4vNcXJtpkPEf7SgoOcQexcuLjwDaAlInVnLKtvYdRjF8kC6jfweOO0S2cWGv7
	 TsKgmjjDdhaaAPEKDayACPHl/QyUOZ//KYq5O8xhHs6NgrkFf7pWoqtX+6pETISIb2KIM
	 ZIJV3ot6axUdhg4vsJ60x52xUwExE2na6BtGbI4vbTyhzQkHUR3uze+Lw8VCuS+Mt/eCl
	 oAtYfJvnV52675QGT5DinicpqwwJ5B8F771bpjCglLw8wRW+MR3fZXynEpqUJdJsVfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=EAmtIXhn;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43B3606A31B
	for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 09:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E43B3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=EAmtIXhn
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so19328575e9.1
        for <cgroups@vger.kernel.org>; Mon, 26 Oct 2026 02:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793006981; x=1793611781; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RsawiG6L+7MbIfpDDEJd12nG5n3sYWkrFkopCA9f4hQ=;
        b=EAmtIXhnMKfe0Py3pITI8nUlo8i/ug6wmWJNMvB4OaBokrE5lP+aySzPAftmVkX6pQ
         9ztk9Cs1T9q8jOhY8cwBmZuLlWknsr0Z64F5crACBJ+tC2LLj4c2gGdqmvzZxXah2dxl
         51G1e424tq8mM6k5DZKBuw/eP1pPqE/M51V43crq+GqhhX46QNPNTTyR8gG3MeRQE5Pd
         G7juPRw4Qd5kgDO45XbmfMJBH3P5N7gyqnx5WIuhP3vJjNiN80/yPyxdxhhNpI6uYw6y
         cwZ0CX1SQIijgmpzcjKi2m6VUCrd6q/ueLQXN8T3I6pPB+/aPrJhXD5ROVZOw8Rcys8D
         tXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793006981; x=1793611781;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RsawiG6L+7MbIfpDDEJd12nG5n3sYWkrFkopCA9f4hQ=;
        b=ooOoQMwWK7eYE+c9HVHzUhFTc1E2tZOEgz3wccTlDfYG93b62qQR5hxonWePUK6Znu
         uuP1QShe5pwPmmstA55ZGICZeQgDHhdm7BnLSMZyLT/nsUToNtSsFYRBDoYSj5OlA4us
         kKDBkXx1RNvy016aM1d0KaVUQFdZwnLDFhmNIvZ//YEIx5TtZQqTgiKuLKduJ8yMiV1P
         TXS6kd9VPvwbU4p61MRodKh9w/X99KwKDSdB/iOZp3uJhv0zapIwZJ0NNrl196Z/JUXR
         vIlgNbAy/mTh/0a7qA1vDQXqZ7+s2YCvY+CwrK/EjloU/Z57ucQyWcCAtlzzaICmSRVf
         8XYQ==
X-Forwarded-Encrypted: i=1; AKwUvByhFe6pJdYcmm7qO1gpEzB+1q8E096ASToIl/WIloM4kwBV0EvulIISzVBIhTbw19c5GBNraIXK@vger.kernel.org
X-Gm-Message-State: AFq9FYKM/d7VjKIW9b8X1+NN1wdB5Fk07gHmNTDzmvDdtmrVdnFZHMhQ
	Rib2onv5ZV4EtlpX+PXm/E+oXSnw5H/iLIkN+1ruPiEa7w7ExjoPBMEYG2jAuYRq7Sc=
X-Gm-Gg: AYBFou0GlTBi7IiHHVQ2Q+botl6z8ZqTOD//Z6gwPXFvZrMj/RRcabIk/tCcJH+Af/W
	ICveUSJBQWte3LQqw5/V6rK8r7NhzXpUpH5Fy1+5ygk+qFv4wXBiWLz7Rq/vzhpVnTYdNkD5b+J
	/GBt2ieJ3OQxKECtwWH770GjkmfO94TOHiMH0dASCicQ9MKs65UqOX/TQj5lN96Nc9yT8TvSgzc
	5CMW20ReaJP/KyDGjknsUs5mcVPxpE+BV8duoQFmZ5XI/jwodf5S0vDYQtdTYwqt3Ah9r6/Lyk2
	cinsuwtd/wwMFSXLwSeY0wY1MnfrnnZ1UP4mBygabjszfDZbVGJGE3iTizFcRMsGozO9IpQmfVU
	w6wVKexY3QXzH2pxlEv5nic5qPOyaLFWbrCsvksCjNE96j0feyJB/P5aK4Fkfm46aSHmhzNj2VY
	vK8++fpW3k4ITgxz33FXdLqqYDKMBKoeqB1Qd38ot47tbHIHg2hldN1QZRBgcbD6a6QKk1hNiQi
	4zqKHzoKqyGtrTSmK+9isgQv1+v4Zdul1sUiPRtxfkVx3sMvGjur7jj4zfZyzuUsPsQwg==
X-Received: by 2002:a05:600c:3e14:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-4a35ae8806amr117990415e9.8.1793006981265;
        Mon, 26 Oct 2026 02:29:41 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a08dcbfsm122433365e9.2.2026.10.26.02.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:29:40 -0700 (PDT)
Date: Mon, 26 Oct 2026 10:29:39 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] memcg: reduce cacheline contention between lruvec
 stat updates and LRU lists
Message-ID: <at8dg75u4qmQKZ9M@tiehlicka>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
 <20261023195417.1391216-2-joannelkoong@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023195417.1391216-2-joannelkoong@gmail.com>

On Fri 23-10-26 12:54:16, Joanne Koong wrote:
> Every memcg lruvec (per-node) stat update reads the memcg and
> lruvec_stats_percpu pointers in the first 64 bytes of struct
> mem_cgroup_per_node. These updates are extremely frequent (eg these
> updates happen several times for every page that's faulted in, freed,
> dirtied, or written back).
> 
> The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
> on a different cacheline from the lruvec, but Intel CPUs do spatial
> prefetching [1] and fetch cachelines in 128-byte aligned pairs.
> Depending on where struct mem_cgroup_per_node lands in its slab, that
> cacheline can be paired with the cacheline holding the LRU list heads.
> 
> When this happens, every stat update also pulls in a copy of the LRU
> list heads cacheline, which is written to constantly by other CPUs under
> the lru_lock. The stat update has to fetch it from another CPU, which is
> unnecessary overhead since the stat update doesn't use the LRU list
> heads at all. But even worse, the lru_lock holder then has to invalidate
> those copies and wait for the acknowledgements to come back before it
> can do its next write, which makes the lru_lock critical section longer
> for everyone waiting on the lock.
> 
> This was found when analyzing the output of perf c2c for a benchmark
> where many threads fault in pages in one memcg. It showed the first 64
> bytes of mem_cgroup_per_node as the most contended cacheline (over a
> third of all HITMs and 5x more than the lru_lock cacheline) even though
> there are no writes to it. A quick experiment adding extra padding so
> that the cacheline no longer shared a pairing with the LRU list heads
> showed that this removed most of the contention, which confirmed the
> cause.
> 
> Fix this by moving the memcg_pn_cold group, which is only touched when
> the memcg is reparented or freed, right after memcg_pn_read_mostly, so
> that the read-mostly cacheline is paired with the cold cacheline
> instead of the LRU list heads.
> 
> Results from a multi-threaded fault/free benchmark in a single memcg,
> run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
> pinned to CPUs showed average pages faulted in (and freed) per second
> across all threads, over 7 freshly created memcgs per run:
> 
>                      before    after
>   shmem, 20 threads  4.74M     5.59M   (+18%)
>   shmem, 80 threads  7.94M     8.66M   (+9%)
>   anon,  20 threads  3.04M     3.08M   (+1%)
> 
> [1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
> (bottom of page 62/800)
> 
> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69e1bcc67c58..6139195b7fa4 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -95,6 +95,24 @@ struct mem_cgroup_per_node {
>  
>  	__cacheline_group_end_aligned(memcg_pn_read_mostly);
>  
> +	/*
> +	 * Touched only when the memcg is reparented or freed. Placed right
> +	 * after memcg_pn_read_mostly because CPUs with spatial prefetching
> +	 * (eg most Intel CPUs) fetch cachelines in 128-byte aligned pairs.
> +	 * This keeps the read-mostly line, which every lruvec stat update
> +	 * reads, from being paired with the LRU list heads, which are written
> +	 * constantly under lru_lock.
> +	 */
> +	__cacheline_group_begin_aligned(memcg_pn_cold);
> +	/*
> +	 * orig_objcg preserves a pointer (and a reference) to the original
> +	 * objcg until the end of life of memcg.
> +	 */
> +	struct obj_cgroup	*orig_objcg;
> +	/* list of inherited objcgs, protected by objcg_lock */
> +	struct list_head objcg_list;
> +	__cacheline_group_end_aligned(memcg_pn_cold);
> +
>  	/*
>  	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
>  	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
> @@ -114,17 +132,6 @@ struct mem_cgroup_per_node {
>  	atomic_t		slab_unreclaimable;
>  #endif
>  	__cacheline_group_end_aligned(memcg_pn_write_hot);
> -
> -	/* Touched only when the memcg is reparented or freed. */
> -	__cacheline_group_begin_aligned(memcg_pn_cold);
> -	/*
> -	 * orig_objcg preserves a pointer (and a reference) to the original
> -	 * objcg until the end of life of memcg.
> -	 */
> -	struct obj_cgroup	*orig_objcg;
> -	/* list of inherited objcgs, protected by objcg_lock */
> -	struct list_head objcg_list;
> -	__cacheline_group_end_aligned(memcg_pn_cold);
>  };
>  
>  struct mem_cgroup_threshold {
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs
