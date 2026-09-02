Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344DB4AEBC2;
	Wed,  2 Sep 2026 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788378037; cv=none; b=DkGmhj/wzQCLZdnopoTN65vbMwBME6TV6ks5QxBzZQ8SCz04tn2jGXEtTzSyCmvxSENqlHfpRrLchoN4FXamN1v/8SDfLSIm0VibWZtm4hDSuLz2T3exA0aRgW9cePaSWeyWvvu2iZzdrVQ3JsO0I+OoMDFaBYYf8L3u5GtNO+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788378037; c=relaxed/simple;
	bh=MHnCUQLkQy45ruT2Cs9eA8nc4/NzAKl+VPEMB2vc2iU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=k3xN4SyY+GEo1ME4fXDXkEzmdB/gNfpmCqpxLeeNonxUeQb0vW2WrpbbhEA28cqStKYRHp/rPi2OvfZr5+gxyo7e46aBfZey3zELtBBqUAwjzPPvBfxLzgMutMYfB05ldzuBgsl+MhoqyzULb8ZagXVeuroHSunmH0uFEP2qQRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2hmEHzbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2hmEHzbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E9A1F00A3E;
	Wed,  2 Sep 2026 19:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788378016;
	bh=LgInFhPoAEPM/8+81aICGdqQBdcuVnYwUlt3bosDlig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2hmEHzbAOvrPbWny4gsMa4pFCXw2fu7NnwHYKSeo8vYE1AmVgwZcRVEUdhbnP5woy
	 V851HqJHR1v6PxgVUXWG2gV44zFL/XJ+yDG2CXOFYsTpvaLemczlnxDYMoMB6ofE5Y
	 BG89Zuk5GkudzQCP/LHSB/o+qw3tH3IATSXj9knc=
Date: Wed, 2 Sep 2026 12:40:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, tjmercier@google.com, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] memcg: remove the v1 soft limit
Message-Id: <20260902124015.ec0e73154b93b69b62873e26@linux-foundation.org>
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  2 Sep 2026 10:43:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The v1 soft limit was deprecated in v6.12 by commit 569c4f62d84a ("memcg:
> initiate deprecation of v1 soft limit") and nobody has reported depending
> on it in the ~21 months since. memory.low and memory.min in v2 have
> covered the same ground for far longer.
> 
> The knob has since been made inert by "memcg: make the v1 soft limit knob
> inert", already queued in mm-hotfixes as a backportable fix for a syzbot
> report [1]. Nothing can enter the soft limit rbtree anymore, so this
> series just deletes the machinery that is now dead: the reclaim pass in
> kswapd and direct reclaim, mem_cgroup_shrink_node() and its tracepoints,
> the per-node rbtree, lru_gen_soft_reclaim() and the MEMCG_LRU_HEAD op, the
> per-node tree fields, mem_cgroup->soft_limit, and finally the v1 event
> ratelimiting which is now down to a single target.
> 
> memory.soft_limit_in_bytes itself is untouched: writes stay ignored and
> reads keep returning the maximum value.

Thanks, I updated mm-unstable.

> Changes since v1 [2]:
> - Dropped "memcg: make the v1 soft limit knob inert" (1/9 in v1), which is
>   already queued in mm-hotfixes, making this an 8-patch series.
> - Collected the acks and review tags. No code changes.

I've confirmed that v2 made no alterations to mm.git.
