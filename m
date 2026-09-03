Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089634FDE5B
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458141; cv=none; b=g1SGXyPmS9rJrgPzeurnXpn5mNeJXyMycKld/bPKGnOop4g/GErUYxIUN1XxrIobnKIvMaKJucelV868o8OF2GJnFKz/M+nRA0HjQapNV/Y03PiguksxOBA+3bY2pKkp531tJDnLDS2bltH0XMjIXFkmuIphOf8C7U337q0EZiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458141; c=relaxed/simple;
	bh=3cWqPp22IraIGu0JvB3xQlMqoKb4a/YFuTmuVC27eeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khPf+qlpNZIO+GA2VxITfeJDO7b3plvTiyDjyo/n5Mpz3sQxFkdBMefh3w+ZuG7mB898eiLX7gp7MSVmqCnoRBSD0sJq9Le8+palpwU0FcFxH0l3uSGY79C1dxF+LSX4ycfcGfXiuhjcfhXgXTD2x21hCb6GP0jUnbH3xvBEjBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BBlpvUw2; arc=none smtp.client-ip=95.215.58.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BBlpvUw2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3cWqPp22IraIGu0JvB3xQlMqoKb4a/YFuTmuVC27eeM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788458136; v=1; x=1789062936;
 b=BBlpvUw2RgIZusVVoCMvSFjY8j+K2JhYbj2ZiLegxvSijKM+7Yrxs7T65SJop68DOXNd7sF1
 xabXaJ/UkbONF6THFkJXWzm1d8OlTVBXTVaaksqChOvPoPU0CEifrGd/U/8/Landsnq+1p9Lb70
 3rfXu1uEvFld/ci6ifFeHRns=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 82f448d9f30fec5e;
	Thu, 03 Sep 2026 17:55:33 +0000
X-Mizu-Trace-ID: 82f448d9f30fec5e
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:55:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: workingset: use lruvec_page_state_local() to
 count lru pages
Message-ID: <apm0b7mioZwXWE1Z@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e16dc5e411c1c5d95c4c4db6ffc789756362b867.1788169145.git.zhuhui@kylinos.cn>

On Mon, Aug 31, 2026 at 05:46:09PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budget
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as they
> are created, losing thrashing protection.
> 
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the follow-up patch that
> redirects dying-memcg stat updates for all hierarchies.
> 
> Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Reorder this after 2nd and with that

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

