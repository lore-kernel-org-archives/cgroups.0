Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3F81482E8
	for <cgroups@vger.kernel.org>; Thu, 30 Apr 2026 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777554224; cv=none; b=Orim1d1qYzY/Oy8WgIckvYpjvCzupkrHFqJdKxU7G6iOqPvole3rQpH82SGkAkFFJdbarelX40ymgUBiahWWA3Ysu7TgsN3vZfEcI5cEL2Aki6nZrNyk63DmqUlJd0pxHFszd09ZXTRlAfeh+tauda2h7dOYrSsON9jpjzW9E/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777554224; c=relaxed/simple;
	bh=SP7g56WfTYGbNHX/Ba/fvguS2wTsCsIUzDC74LX7oSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVlU40B2DCJVu7PmwKgl0eg0FkoVem0fDhXntBjXE1oOArtcRIDHssfmGDAImxPjnfYEnL3JbFyZ3BsvNHXCzDvvk0D7I9RCW6ppuwR0pZZJV0EB4AYcMY6qbqLvBJFEvhvl8Lx7scT9cRf06WJktP0FJKhjhSiuRy52vdJV5pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d4Y47WcK; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d4Y47WcK"
Date: Thu, 30 Apr 2026 06:03:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777554206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=48UFhuUrS/5CKzCRf6cET806F55RZ+asmMEzp5H3pjE=;
	b=d4Y47WcK8SMHjZKcK3wFwqSykiALyGWunDOn09eKb4GbUzLB16aNBXWrZMhduas8+OIEU+
	ZnxP+j7MHVjXm/IM3DX9xWvDzVivMWgdLOawhDgFj8pFGL576eU+SVq1uyB3h5hxe83qnl
	/uHiv5pWfjQT0+cVFvR/jK/XVLcZU10=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: hoist pstatc_pcpu assignment out of CPU
 loop
Message-ID: <afNS6UJjUl_zQIHS@linux.dev>
References: <20260429084216.186238-1-hui.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429084216.186238-1-hui.zhu@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 29, 2026 at 04:42:16PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> In mem_cgroup_alloc(), the assignment of pstatc_pcpu is invariant
> with respect to the for_each_possible_cpu() loop: both the 'parent'
> pointer and 'parent->vmstats_percpu' remain constant throughout all
> iterations.
> 
> The original code redundantly re-evaluated the 'if (parent)'
> condition and reassigned pstatc_pcpu on every CPU iteration, then
> repeated the same ternary check 'parent ? pstatc_pcpu : NULL' when
> storing into statc->parent_pcpu.
> 
> Move the single conditional assignment of pstatc_pcpu to before the
> loop, resolving both the loop-invariant placement issue and the
> duplicated null check. On systems with a large number of possible
> CPUs, this eliminates repeated branch evaluation with no functional
> change.
> 
> No functional change intended.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
