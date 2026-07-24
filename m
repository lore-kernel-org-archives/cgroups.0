Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5AB353EE0
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 04:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784866730; cv=none; b=mor+xRm+gePbV8HmqE1buz9kCSsAByNWSER1vf6u3BV3ytkJYgOPivEALkytQoq2xy/dvMGs3cnAVIj7wpo+zghJjsaeqS8vyz3rJ7QW7hw8q8TthSOSeWGbmV7ExzBgZawn61MB5/lny6qttEuT4+Nc/nDjNVD66tW9TiP5fk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784866730; c=relaxed/simple;
	bh=UE+25WkddRSp3wEZS2XqD1LRwn4D1Otx2lFlMryBESc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCrmyXJbLkebZ5eVGV4WuTPkGu5j/MgS8iWFJFVrOOD2NtYpS4N/T9K2636opkogiGJ5RxhBKFZPMXZncu+V37PBDLk2wV9Oqv+vZUSNAiF2YVYqkDJxHglg8D7XHR/3KjwSiwO36blP/FO0YeLQt8qS1MrLGPoIWbsVYbZeq4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dk9VntJM; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dk9VntJM"
Date: Thu, 23 Jul 2026 21:18:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784866724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iEgGWeL+yTrVdbZEiIfi87cvm6YPXdswgArk5B9kdpk=;
	b=dk9VntJMllXGY/FMdSbMLmOHXGaJ5tdm5EZ6K5s2gXFTlUptT+TtQM8NCnJuG4DjvlTSB3
	wfRJY+VFZySmpCnZ0LEe8WF26TsE3TCd2b3Op79O2Bm0Qu5RkpdD1ju4uvl7/nCrklqV6F
	myak+3FNHqp8vyohdJnxiCmZ+rUxG4k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Song Hu <husong@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -v4 1/2] memcg: move mem_cgroup_swappiness and
 vm_swappiness to mm/swap.h
Message-ID: <amLniSIh-6Bc9mld@linux.dev>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
 <20260723032434.2016749-2-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723032434.2016749-2-ridong.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 23, 2026 at 11:24:33AM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The per-memcg swappiness knob is v1-only; v2 always uses global
> vm_swappiness and ignores the per-cgroup field.
> 
> Both mem_cgroup_swappiness() and vm_swappiness are only used within
> mm/ (memcontrol.c, memcontrol-v1.c, vmscan.c), so move them out of the
> public include/linux/swap.h into the mm-private mm/swap.h. This keeps
> unrelated declarations out of include/linux/swap.h.
> 
> Guard memcg->swappiness with CONFIG_MEMCG_V1 as well, so v2-only
> kernels drop the unused field.
> 
> No functional change for v1; v2-only kernels drop the unused field.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Song Hu <husong@kylinos.cn>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
