Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935D6234984
	for <cgroups@vger.kernel.org>; Fri, 20 Feb 2026 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771625945; cv=none; b=D/8mHdTzrvvh77lBrP3wduNnjehI/hFxuAuPPaUVAJSIWKUpazzIS57mZGScOHBn6IhCTIiiqXOHltrQkceklZ5plThiDlJ3NjPTx2NybUeHj1M9D/zZlfDypoZdRE5M5t8Wtyo64weMsY9iS2ogfkUjodSZrMo2egB38goHfzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771625945; c=relaxed/simple;
	bh=zy6UpB/HHY7Q28p6VFNkuhAD1MwwDysX7RWMQ9t4nr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6RtZddPkqscsWjFU9sSxCSfE/LQKyebGTSpZ9TQSi/SI65tzY/Pl3dFySifKchd/TJvfwY23nhrYCJMtGZTMPrF0dyauJzNtsu6IXWdpY26d5c1bKbqlBHclwDmcsFKsovUVRcfDd1l/XvEubOeyZgwZMj9E00NJqbaLYX4SaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fNrlUOzZ; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fNrlUOzZ"
Date: Fri, 20 Feb 2026 14:18:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771625941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XfObkIhOT0Ua1/RMBtrT9Uid8uwfbK9pIchG0yozPAo=;
	b=fNrlUOzZf8XHzHoiMAE7mfXGUjLekaDwrSQDCDbWFxlptq8b9gy3v41LnM/pUY8SonBkuW
	t+4GkA2socG0NHU/j7lfAandXGjH+RrzghxlmLtMiGyHlLxr3a5SU8j9AX4dS1edcUm6w5
	TJUbfA2LxA6RdiC0qYQiox3K0XH8vC8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mst@redhat.com, mhocko@suse.com, vbabka@suse.cz, 
	apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com, 
	gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com, 
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev, 
	zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev, surenb@google.com, 
	virtualization@lists.linux.dev, weixugc@google.com, xuanzhuo@linux.alibaba.com, 
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH v5] mm: move pgscan, pgsteal, pgrefill to node stats
Message-ID: <aZjdZv1eJc4HanML@linux.dev>
References: <20260219235846.161910-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219235846.161910-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 19, 2026 at 03:58:46PM -0800, JP Kobryn (Meta) wrote:
> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
> node_stat_item to provide per-node reclaim visibility. With these counters
> as node stats, the values are now displayed in the per-node section of
> /proc/zoneinfo, which allows for quick identification of the affected
> nodes.
> 
> /proc/vmstat continues to report the same counters, aggregated across all
> nodes. But the ordering of these items within the readout changes as they
> move from the vm events section to the node stats section.
> 
> Memcg accounting of these counters is preserved. The relocated counters
> remain visible in memory.stat alongside the existing aggregate pgscan and
> pgsteal counters.
> 
> However, this change affects how the global counters are accumulated.
> Previously, the global event count update was gated on !cgroup_reclaim(),
> excluding memcg-based reclaim from /proc/vmstat. Now that
> mod_lruvec_state() is being used to update the counters, the global
> counters will include all reclaim. This is consistent with how pgdemote
> counters are already tracked.

Yeah this difference always confused me.

> 
> Finally, the virtio_balloon driver is updated to use
> global_node_page_state() to fetch the counters, as they are no longer
> accessible through the vm_events array.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
