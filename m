Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C311D207DE2
	for <cgroups@vger.kernel.org>; Mon,  2 Feb 2026 04:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770005725; cv=none; b=sqlv1eYE8KE+11hul45iqG3WMzZJgLuqbtoxziuBX8Q+D4aoJbVJhZzj6SrIigj90LdY7az9kvt1y5NhtSVXSW1P7B158p60ELiqzBVb9l+/1fH5uFrGnVHNYlR66W+wL3odnDcsM+QezaeSq57q/tZkyoAdIpTJx0/x0Rfdfmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770005725; c=relaxed/simple;
	bh=162Sxo64rjJ2ogW/PNj9/2Lzz+0NYp83xBG45gYPE2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mo2m2SylwEPbQnYsj88JgdshgFIrFocMbiAFjuiNafEy+phsU/W8NirKMLJlfm5U+wtRe9s7esXWcfKipAuufTaeugCbNW1L3Rl3oFmGmwx1/1MgYlaXKZkZ5xwZxlXCXOUZkTtw3gOXrNoqoDyzxppHgjQn5TO4TuADC5L0PIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bZlNb6GN; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bZlNb6GN"
Date: Sun, 1 Feb 2026 20:15:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770005711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zvtlAMLtgHm63VCI0lv5mAl1ZFv8A9Ibz2DahGIKhtQ=;
	b=bZlNb6GNNV/QTypPFLHskbMbyUuYpJXjrBAvd2OIlM6KKtLhufwy08CcTMwVumVlTqlXXW
	3Upk6ZTmHjt1ZYCw2nmoz+AELoMAyW4BA49n1b8r+sohZns5a0EcBeyDXA5gE4DLCJUybx
	AFIVdhd4xYJ2m7dyU/j1rhBqRW1GPaI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Bing Jiao <bingjiao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, tj@kernel.org, longman@redhat.com, chenridong@huaweicloud.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 1/2] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aYAkqsItdd1x0jEE@linux.dev>
References: <20260114070053.2446770-1-bingjiao@google.com>
 <20260114205305.2869796-1-bingjiao@google.com>
 <20260114205305.2869796-2-bingjiao@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114205305.2869796-2-bingjiao@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 14, 2026 at 08:53:02PM +0000, Bing Jiao wrote:
> Fix two bugs in demote_folio_list() and can_demote() due to incorrect
> demotion target checks against cpuset.mems_effective in reclaim/demotion.
> 
> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to can_demote().
> However:
> 
>   1. It does not apply this check in demote_folio_list(), which leads
>      to situations where pages are demoted to nodes that are
>      explicitly excluded from the task's cpuset.mems.
> 
>   2. It checks only the nodes in the immediate next demotion hierarchy
>      and does not check all allowed demotion targets in can_demote().
>      This can cause pages to never be demoted if the nodes in the next
>      demotion hierarchy are not set in mems_effective.
> 
> These bugs break resource isolation provided by cpuset.mems.  This is
> visible from userspace because pages can either fail to be demoted
> entirely or are demoted to nodes that are not allowed in multi-tier memory
> systems.
> 
> To address these bugs, update cpuset_node_allowed() and
> mem_cgroup_node_allowed() to return effective_mems, allowing directly
> logic-and operation against demotion targets.  Also update can_demote()
> and demote_folio_list() accordingly.
> 
> Bug 1 reproduction:
>   Assume a system with 4 nodes, where nodes 0-1 are top-tier and
>   nodes 2-3 are far-tier memory. All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Should respect node 0-2 limit.
>     # Observation: Node 3 shows significant allocation (MemFree drops)
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1
> 
> Bug 2 reproduction:
>   Assume a system with 6 nodes, where nodes 0-2 are top-tier,
>   node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
>   All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Pages are demoted to Nodes 4-5
>     # Observation: No pages are demoted before oom.
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2
> 
> Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> Signed-off-by: Bing Jiao <bingjiao@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
