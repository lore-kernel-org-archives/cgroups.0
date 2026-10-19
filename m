Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3671B526091;
	Mon, 19 Oct 2026 14:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421516; cv=none; b=CzdV9/U58oH8WDwqEeYr/EHJPVWwmJiEHprD1+2bBUOP8xodfMjNQKPlr2JCfmG5T/FM/2skUkpCF8b1Smlma0OBuy8JFRssmltx0MEiidLHDBYlGJ7xxmv+u2tVtI7I/N0E5YhGmZ8qaw29Z/50d2Rk/DmyXtJRjqvarQOxqLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421516; c=relaxed/simple;
	bh=37GBfxW7rIi3gZiGCH4WjT6DBFJ0nkuvHw/+TdxjWNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l5vfDVyiGW/2167iHv6y4AwyYOOdHiMZFeOev0h8HANrHSmg0f0EBD2ZeQtvKxdwWHdf5MmZtYujZCKCfhXdL4bG3SYGTXf2cItX36iDkIFWHGnjDl0eVXay95EtKpYfzhNM/Y6PT/D+LkNLxiqhY4+M/v9lCr3vXDh8uv/IEvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CytbvJKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CytbvJKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98C11F000C4;
	Mon, 19 Oct 2026 14:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792421514;
	bh=IEuKHXnppdYbcLdn+ZpMOWRZpyj22L+OaDWKsVYJBU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CytbvJKgpdduswBwk1KzlfJSnpKOX7ypQXzLh7ah9RHTacFvwlL0K9eu+Xt5w8eS9
	 5yEze4BmXOXsrukOsydZtO2HZK+HD9K8r6f34WpmEAColF8mZQR4TAQ7pisWqDLakM
	 jCx7a6dbOPMec+ZyLbiAkRvRtkMhdP8kQaJpvOVBDrwmi9ff4npyXzVToSZ9r6OX5a
	 mDmwePbsqtTbIX8Pykf7QvN48xBhV51ByiKkLXgWGOz8ZOYGaqTlPdUnB9WfjqqZ4i
	 mysUbn+eqHr6lc2ERj3DgEyYW1UfLSsZVon1Ht0CKOH4rTDb1G4RTgePzgSDmbu4cV
	 +jA1W37dt0AsQ==
Date: Mon, 19 Oct 2026 15:51:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
	ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, mhocko@suse.com, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC 1/2] mm: add source selector to memory.reclaim
Message-ID: <atYsvc9gIejcuwew@gremlin>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
 <20261019141401.11927-2-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019141401.11927-2-lizhe.67@bytedance.com>

On Mon, Oct 19, 2026 at 10:14:00PM +0800, Li Zhe wrote:
> memory.reclaim was added as a generic proactive reclaim
> interface for memcgs, but memory tiering makes its practical
...
> The source= key is intentionally typed so future selectors can be
> added without reinterpreting the nodes form. For example, later
> patches may add source=tier:<selector> or other source types while
> keeping source=nodes:<nodelist> as the NUMA-node source selector.

Similar comment for the commit message as below re: simplicity.

>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 23 ++++++++++++
>  mm/internal.h                           |  3 +-
>  mm/memcontrol-v1.c                      |  6 ++--
>  mm/memcontrol.c                         | 11 +++---
>  mm/vmscan.c                             | 48 +++++++++++++++++++++++--
>  5 files changed, 81 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 86a2a0099178..a016575010ba 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1454,6 +1454,7 @@ The following nested keys are defined.
>
>  	  ==========            ================================
>  	  swappiness            Swappiness value to reclaim with
> +	  source                Source to apply reclaim pressure to
>  	  ==========            ================================
>
>  	Specifying a swappiness value instructs the kernel to perform
> @@ -1464,6 +1465,28 @@ The following nested keys are defined.
>  	The valid range for swappiness is [0-200, max], setting
>  	swappiness=max exclusively reclaims anonymous memory.
>
> +	The source key declares where the normal reclaim aging pipeline is
> +	applied. It is a typed selector in the form source=<type>:<selector>.
> +	Currently only source=nodes:<nodelist> is supported. For example::
> +
> +	  echo "1G source=nodes:0-1" > memory.reclaim
> +
> +	This instructs the kernel to apply reclaim pressure to memory of target
> +	cgroup that are currently resident on nodes 0 and 1. Reclaim then
> +	follows the normal reclaim path for selected folios. The source
> +	selector does not choose a demotion or eviction policy. On tiered
> +	memory systems, a source node in a non-terminal tier will usually make
> +	progress through demotion when an allowed demotion target exists. A
> +	source node in the terminal tier has no demotion target, so successful
> +	reclaim progress from that source is eviction.
> +
> +	The source selector is a source constraint only. It does not select or
> +	limit demotion targets; those are still chosen by the kernel's memory
> +	tier demotion policy. Specifying source does not change reclaim
> +	completion accounting. On tiered memory systems, completion may include
> +	demotion progress that moves folios away from the selected source nodes
> +	without reducing memory.current.
> +

I'm no cgroup expert so I can't really comment on the concept overall, but can I
ask please that you try to make this documentation FAR simpler and clearer?

I have no idea what an 'aging pipeline' is, then the paragraphs dive into
significant detail and I don't see why you would want this or what it's useful
for?

You should lead with that, and keep things simple, only introducing detail
later.

Right now it's 'types:selector' (only 1 trivial example given) -> reclaim
follows 'normal' path (what is 'normal'?) -> for selected folios (who selects
them? How is it relevant to _an admin_?) -> source selector (what?) does NOT
choose a demotion/eviction policy (neither defined in document) -> source node
in non-terminal etc. etc.

It's very typical of LLM-generated text - it treats the reader as a computer
with a large mental 'stack' for storing this information.

Humans don't work that way.

The document targets _admins_ and this text strikes me as very very confusing
for kernel developers, let alone admins.

It also seems to assume a lot of knowledge.

--
Cheers, Lorenzo
