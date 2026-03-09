Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EE538F627
	for <cgroups@vger.kernel.org>; Mon,  9 Mar 2026 23:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773099828; cv=none; b=VsWbsn9cFPTbaHMx5rP/R8WPaXZTyMgs4w4Sg3fC+nJ9LE6oQ7zDzdEz4/sNMsQ5MDf5M2r2veiIYL97NfiN5H9UM1F39WVffbK4CLRPRiOrEcEWD7DMNVOhyHFi/colNuHCx6O0kWMEbZAxLTzHEjpwpRWFQBxm/yOior991FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773099828; c=relaxed/simple;
	bh=3MHOsSOC8s2umrtXNLmRUJoH3s6oflpR1jzzDK7EsA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aVXWBwByWZmmaCRkZBHBiC8YWr2K4hqx6NiOz5w/AVKic5WdH0hOXxg8pjTzDs3zeyYXxZjBiuOgNu6a+QfRa3DK79nZdvOlyQL6dKLWJUsr/KkRF1QCV60wewwiZpEox+f0CCYUJU7VHzOut/E9uPIMlhhT8RqhGd4TwYN7JHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nlLDsKr2; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nlLDsKr2"
Date: Mon, 9 Mar 2026 16:43:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773099815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/iFELzGhWdH/eNtU4E6wcj10oGbw7AuRjfLOotw9uPs=;
	b=nlLDsKr23aZgU6oEj+eh7RNxKM/IBMFZieSL0bHjkbDfQ1ibcGB5RsexzpkRRgx0zyPbH3
	TjvFim1kvYAq+v1OB8H3VD7aPn1YRCwHyIo8HbS1X/Ua8oML4fUNu61irhyDVhfkurqZey
	fYpzyx+nDJrHQsJPCkWxBlj95E2LwCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com, 
	vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com, gourry@gourry.net, 
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com, 
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org, muchun.song@linux.dev, 
	zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev, surenb@google.com, 
	virtualization@lists.linux.dev, weixugc@google.com, xuanzhuo@linux.alibaba.com, 
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aa9aDGwk8YteaEob@linux.dev>
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307045520.247998-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 06, 2026 at 08:55:20PM -0800, JP Kobryn (Meta) wrote:
> When investigating pressure on a NUMA node, there is no straightforward way
> to determine which policies are driving allocations to it.
> 
> Add per-policy page allocation counters as new node stat items. These
> counters track allocations to nodes and also whether the allocations were
> intentional or fallbacks.
> 
> The new stats follow the existing numa hit/miss/foreign style and have the
> following meanings:
> 
>   hit
>     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>     - for other policies, allocation succeeded on intended node
>     - counted on the node of the allocation
>   miss
>     - allocation intended for other node, but happened on this one
>     - counted on other node
>   foreign
>     - allocation intended on this node, but happened on other node
>     - counted on this node
> 
> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
> in /proc/vmstat.
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

[...]

> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(current);
> +
> +	if (is_hit) {
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
> +		mod_lruvec_state(lruvec, hit_idx, nr_pages);
> +	} else {
> +		/* account for miss on the fallback node */
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
> +		mod_lruvec_state(lruvec, hit_idx + 1, nr_pages);
> +
> +		/* account for foreign on the intended node */
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(intended_nid));
> +		mod_lruvec_state(lruvec, hit_idx + 2, nr_pages);
> +	}

This seems like monotonic increasing metrics and I think you don't care about
their absolute value but rather rate of change. Any reason this can not be
achieved through tracepoints and BPF combination?
