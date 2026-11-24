Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795481693;
	b=GMClE7Jk7DaeBhFaUO6TyeKH/wPQadViiVwnttjN+0sFC4Dh0F4if7QXz2vsKYyHHsHR
	 MB3coPUOTMsDTlLCsPSdjdI2QOR+sLuSEr1jzT5RstSFKOYPzwbqdCuvUq8GWMv/vMa3g
	 /KqwFhtrE/xGKu7yVcmuHRolE1W2BrmR/1QfRxh4t6iwNYfMSzPdrMtukzrqnS859J6An
	 JBdnU+xPLh/egL0LAe9fpWiO+xpOagU88tN3Aj2toY6ZKWSnnOcOdDi7OBDsZPf531ije
	 6sPoEG/1njkVVhb8V2wvrbKARw+LF8WLDKjcE+2UvwkPg+qpch/GLkSeM4z6R6btzTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795481693;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7ViN0eIHvL0Nbs3ZKsf4/7g5sSxQBxyYI76K+CVQYXQ=;
	b=wZY8g0HS+cBZMEAPWKPKm5JmvyvIaC9K4HUjZgqietzTUhWtv1w82I+0Se1w8HPgNqvv
	 dejFccODG1wKMeG9mO3XQdUG/scyYduDeVqvk17glT2K8REIyGFKh7S9KgfHa1HQrSR6p
	 ovp1f6tcqa9+AGy0NhxJB+49/FmO8xrqMKTkMPweDiUkhlymRwWAL20JHQXaEt65ey/EA
	 MitAI1S+CeU6BiZiGS0sNwBN5GzOKD2r6c5uLB+h8inycoelyGjoFMZ8CTd0nlp/O1tae
	 zK5FKsNo44oUTflXvnxeR8GDAyxe8NPKWNufa5xunyG+20kIARW8RYUZXCEqK1qxlAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wxtmXz91;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF0E606A32E;
	Tue, 24 Nov 2026 00:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wxtmXz91
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052871F000C4;
	Tue, 24 Nov 2026 00:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795481692;
	bh=7ViN0eIHvL0Nbs3ZKsf4/7g5sSxQBxyYI76K+CVQYXQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wxtmXz91k/hp5vtf2YQn9xalSkOczmFrqpABLN4i4Q3Gi9PQpFSuF1/+2vfingqVP
	 mhcfj4CwpU/NSHMIifdFjYGR7yhN1HdYKoejPXpDmTPTU80nx7nlRWYyJUmxu0Pr98
	 UnIl8Bmc7ZZyjA+avslw/J69aEnmuWliDoYBULdo=
Date: Mon, 23 Nov 2026 16:54:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Koutny <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Meta
 kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-Id: <20261123165451.8c30df036f95995316e15047@linux-foundation.org>
In-Reply-To: <20261124000439.967403-1-shakeel.butt@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 23 Nov 2026 16:04:39 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> allocated. The ID is erased when the last reference to it is put, and
> that reference is first taken in mem_cgroup_css_online(). The failure
> paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> themselves.
> 
> But css_create() can also fail after css_alloc() and before
> online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
> without ever coming online, and nothing erases its ID. The reserved
> entry stays in mem_cgroup_private_ids for good, and each such failure
> takes one of the 65,535 IDs away. With failslab failing radix tree node
> allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.
> 
> Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> only set when an fully onlined memcg is released.
>
> Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
> Cc: stable@vger.kernel.org

hm.  These allocations are all small and they're GFP_KERNEL so
cc:stable seems a stretch?   But whatever - stable people have bigger problems
than this ;)

> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -449,6 +449,11 @@ static inline bool css_is_online(struct cgroup_subsys_state *css)
>  	return css->flags & CSS_ONLINE;
>  }
>  
> +static inline bool css_is_released(struct cgroup_subsys_state *css)
> +{
> +	return css->flags & CSS_RELEASED;
> +}

todo: switch css_next_child() to use this new helper.


