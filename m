Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B6D40962C
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 12:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783946095; cv=none; b=R6vFB6xgX7ZQI02LFldXhFKhq/fkETunJprSbU3sjFqpdVpyHZssGm8QZY+7uLrVwmolNG6RlykKsLVguJXVBKP6bMxR1g6WuVFf9eBQDc5YX6V5PGhAjQKCuw8YOrCAhMiAVjwuS1y92WKrrYen+2E7yhrjsDrSXfbajmWATTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783946095; c=relaxed/simple;
	bh=3noOyco9YFZQY8GONL6s4RS3Jtn7BplwFjDiVSwHAnk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HTqGjFmgy/pUfro1WTVfNtW6qCVg0nUjpo3HLOosy91sTGSfukBjrtmRLXxssF0qi6wszmk8QfguXZJNM8aAw5k8b8URWBeyAKkCzBeb5kCDSQDwVmhnHuz5rvYUvJCzgLaXFJvdyr28XQu8Nkx4K+o46VTU7k4PhMuuOWenY10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=upOGX7wO; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="upOGX7wO"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783946091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lHypyUNn2HVnK1SWBb4ieypi03fXxl2jL6EyCeQIuUw=;
	b=upOGX7wOzhWGgpudj11Mxbp9JfS5C7idfCct/CWgItwz6yiESe7f9bF5/CPTKMjaIboxnr
	ogsLMVm068Qh/mKIhWwKZ7c3Eet0iUNESFG1ywQqF+pR0XHDKuGOVxwew6PraN4Q3T7XNf
	LwbgzJX/8jCWTvzN96/xBOBpvEcM0Pw=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
Date: Mon, 13 Jul 2026 20:34:14 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <F7C69746-C0A3-41AC-95EB-BCE6D73C2FF1@linux.dev>
References: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT



> On Jul 13, 2026, at 17:37, Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
> mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
> for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
> int return type required by the old callback interface.
> 
> The function now has a single direct caller and no failure path. Make it
> return void.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>


