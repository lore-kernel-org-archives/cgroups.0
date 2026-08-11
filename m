Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344E0380FD3
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 06:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786429585; cv=none; b=CQnE7P+YetiHtBRWle79jALJjdUYFgj09or7IGh2UBG41muZ6PWaXDTVheAVyrC0nsMcW5MBXTX5rnszN/AiEiVP9SJE+0pYLWqzKefUUZbwhRGTuwzDY3ZVwrbyzKrrRDk4SoThIjUCca8KZwHfm+Lq3jyyefACFM+zJ3N++0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786429585; c=relaxed/simple;
	bh=R+WW+TRJ0w8DNpdT7WLuo3OznUsOKynfOD/erVqa/0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bt7mDzQovyIbbd8Db8uoDv5CmsBX+Sza4YB3OSdzGgbBbd1mJqOnfOPnSjRLEKQ6guEBXpN/OenJoYsVO9H06F3k8FdZOgD8fb9jcROgYy2hR80C+KdmsNCqbXX8K8a6eH2aQoOfb01v8mhl7mKtXQHLXbMRrVvlQyesDjXtpxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZMSFg7rO; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZMSFg7rO"
Message-ID: <c2e8b6d5-e444-4fdc-909a-a928e0e8f45a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786429579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrvIDI4l3ibJO+y9A4q6yHaI4leghzx/mVJIb4ZQWF0=;
	b=ZMSFg7rODBkJTKpJce/kKymt/vvKd4Si1DCFMJdlSBmYZBWa5h2iXhozUCctMzolwmOoHZ
	Yy8BPbkRSTT04rnxaf/kAAoWWUk7aqPtScK21NWYnDADO6FijO9fVdDoyRjbu4OpauPfUj
	i0zD/9SLnH+8r7/xeyzinBz4Mbf5PP0=
Date: Tue, 11 Aug 2026 14:25:59 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3] memcg: keep folio's objcg same as its node
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
 stable@vger.kernel.org
References: <20260807142406.443516-1-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260807142406.443516-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 8/7/26 10:24 PM, Shakeel Butt wrote:
> memcg_reparent_objcgs() has an inherent assumption that a folio's objcg
> is the objcg of the folio's node.  Folio migration across nodes breaks
> that assumption: the new folio simply inherits the old folio's objcg
> while living on a different node.
> 
> Once the assumption is broken, the reparenting of the folio's objcg and
> the reparenting of the folio's LRU list are no longer atomic.
> memcg_reparent_objcgs() handles one node per iteration and drops all the
> locks in between, so the objcg gets reparented in the iteration for the
> objcg's node while the LRU list gets spliced in the iteration for the
> folio's node.  Any LRU operation on that folio in between resolves its
> lruvec through the objcg, and thus takes the lru_lock of the wrong
> memcg, not the lru_lock of the list the folio is actually on.
> 
> Fix this by selecting the objcg by folio_nid() at charge time, and by
> re-deriving it for the destination node in mem_cgroup_migrate() and
> mem_cgroup_replace_folio().
> 
> Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
> Cc: stable@vger.kernel.org
> Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
> 
> Changes since v2:
> http://lore.kernel.org/20260806165813.2526415-1-shakeel.butt@linux.dev
> 
> - Refactor common code between mem_cgroup_replace_folio and mem_cgroup_migrate
>    (Johannes)
> - Always commit the destination node's objcg. (Johannes)
> - In mem_cgroup_replace_folio, force charge based on committed objcg (Johannes)
> - In mem_cgroup_migrate, if destination node's objcg is root, uncharge the
>    source node's objcg. (Johannes)
> 
> 
> Changes since v1:
> http://lore.kernel.org/20260806061830.3294679-1-shakeel.butt@linux.dev
> 
> - In mem_cgroup_migrate, do obj_cgroup_put at the end (Sashiko)
> - Handle scenario where destination node has been reparented to the root but the
>    source node's objcg has not yet (Sashiko)
> - Add comment explaining the race between migration and reparenting (Johannes)
> 
>   mm/memcontrol.c | 100 ++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 83 insertions(+), 17 deletions(-)
> 

Thanks for the fix!

Acked-by: Qi Zheng <qi.zheng@linux.dev>

