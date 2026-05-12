Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C45333D4FD
	for <cgroups@vger.kernel.org>; Tue, 12 May 2026 16:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778602125; cv=none; b=cyzqfY43Q25yZ32ar0RqkUAWFa/7D6QWpUvqRMCCjseg+FUopsiFaUaww8yMsvZ6QQlIjf3+qyDWlgy91m6HEflnSZfMxRr701scBPgb3oVWp96zmqvB8sEVeIojXFUUaIJ+QNk77J8qe0pHevu/KoCiol9MEcJAxtTHgd73gGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778602125; c=relaxed/simple;
	bh=FfA31veIK14by6jLWYDU+NO2Kv59cKt9QSL74jZIC40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joN+wp1cU8z4rNwe1G2ucnY+BgwkTAd3Qlom32/p5tStQakk9lnqZtj4MfRzK6b8pTNLSUn44+ddH1boJjSWk888/Q09J0RWUoV/sP+/0Cu4CJC1zhIM3mUEReKQlRE6qhVXr6c1RGXUKLhpwJTZZfA5hSEeTcpdALw2x/vin00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WMotxzTT; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WMotxzTT"
Date: Tue, 12 May 2026 09:08:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778602111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JQEQQ/VVs9AhGm+qtGkVypTgVgwVlaVm605jGnsgvX4=;
	b=WMotxzTT7Gex56zTN2EDTCuUXloYSEoO/TNSMbbi7q6VIR1JIsjOfRhrvH/Ah77igTjH48
	wuVjVT3Ah5ANBizD0PmSEvUx6EAonupa7wSKrYFhqQd4aTaD2gTmQ7GocT6XIBDOhtthe1
	4JTKBYtHiCUCb1tilGFeczME/KueIA0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: memcontrol: propagate NMI slab stats to memcg
 vmstats
Message-ID: <agNQNMl6TySHF4_8@linux.dev>
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-2-alex@ghiti.fr>
 <agJYrraKk_wbHe07@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agJYrraKk_wbHe07@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, May 11, 2026 at 03:49:36PM -0700, Shakeel Butt wrote:
> On Mon, May 11, 2026 at 10:20:36PM +0200, Alexandre Ghiti wrote:
> > flush_nmi_stats() drains per-node NMI slab atomics into the per-node
> > lruvec_stats, but does not propagate them to the memcg-level vmstats.
> > 
> > This is inconsistent with account_slab_nmi_safe() which updates both,
> 
[...]
> 
> > so fix this by propagating the NMI slab stats to the memcg-level vmstats.
> > 
> > Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Please resend this patch as independent patch and CC stable.

