Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E39F175A69;
	Thu, 30 Apr 2026 00:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777509913; cv=none; b=NVzYHokPIaP5UL44vBrnGcVLQPn6e3yX/t8Po0wbf568tAtEWXzQxJQ6Lux3+WjZY8dO4CAuAtF43x1+CnBGcNSf44jYxoQUKACMEmyFjczg7rBv1kJES0TakulX5EUk1I44DrsosUNi6I/wCZKbgRJAUnKekiHJ+tJy4dHqAa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777509913; c=relaxed/simple;
	bh=1NgfA3n3epDy0q1UITsRHjNEHHtTt81kvm0NYuIzMtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWe/3NAldRA0BPV4Kmcbi7HzmDNW9x8xCzYgoN9toVa+O14qqd38plllfzBzDRqnSvsiiq7rz11QW8CgRLKPZMdl5XXwA7H6A1PDyTumot5y9tU8ESHH8gMfD2+ddVZZmXPJ/3shDlLMgo3oPudfSokpXPsx1YyMSUYzXZQ7qtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFwGVGJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFwGVGJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AFCC19425;
	Thu, 30 Apr 2026 00:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777509912;
	bh=1NgfA3n3epDy0q1UITsRHjNEHHtTt81kvm0NYuIzMtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFwGVGJfkaIy5KBpg96SC/rKobcnOYBnzagj5OPEvKfrKBihzUHUnX6IZ/CEQnC8A
	 GisE6n6TM1ZbJzxzrC+jDcAgerA1xpww1xwWxrFgMbGNquTa0zc5JpP0gvF7fJx3em
	 EeDTV/+QKI4nwYVaU7ZybGyhUKxS9xBc0aCjcYEgSzKjqeg+8u1+/RlYErk2q8Yfgd
	 iSJ+fz15N+R3dhUGHIt9GfU1PABW+e49jYJM3F0lrFS0ePeRSuXgN5aOPUd5SOxOkF
	 fMwm+rH0HnOvRvvZ/CTd/2xbNNd4EX1Pdlu6jDt1Ph7Ms8n79wXywt/BNfYIIbD2m5
	 ozp8+0YxligEg==
From: SeongJae Park <sj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
Date: Wed, 29 Apr 2026 17:45:04 -0700
Message-ID: <20260430004504.113550-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429084216.186238-1-hui.zhu@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 29 Apr 2026 16:42:16 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

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

Makes sense and looks good to me.

> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]
