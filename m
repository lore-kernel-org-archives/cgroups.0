Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BDD41F342
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755557; cv=none; b=eep5t38cXSnW20ZJyviomvFQde1lRfwAjZRFjTIZkcCes24RkrKVKz3EQCG1vuRVApFHnu3WsOmUo6xfX1sARQl3NMvUGsoYdk2IFZDJlpOmPX4ZwUTc8R8vVuhZPtQ6Zu2rzGUMi9wGepae3RrhwPN2nV5vrhaVGdH+Qke8g4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755557; c=relaxed/simple;
	bh=iHCQilQ4x8FlNnS2IkgCh0INwKZKlX5mZWBCxqEI+cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5Dvy1jTJrvMYImk2sPqldPadFuPSW/NICPLzCXuZ2CPYsd5TSaW8onYu5WcD4FGwu2aqk3ZxZYOgWdjDEG4U0oJwdh2Ad0I+Rpkd+NMUKZUTRX+VhYYBqd8Jm8RAw0bhjiP9fgKZta9JrksvOxPUe/5fIl+EIn8rtINQ0gQIJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LiSjmj38; arc=none smtp.client-ip=91.218.175.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LiSjmj38"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iHCQilQ4x8FlNnS2IkgCh0INwKZKlX5mZWBCxqEI+cs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789755554; v=1; x=1790360354;
 b=LiSjmj3811D0sEQOkFqhqCslxtDax7X1LstUpScy0vbMDuBGjoX52NzwJM61BtguLCzlpZIO
 BPxpEGi6Qi3facgpZxEptn53a2H32/9PBQnF10xG20NBJhNu/QhIe/8PFFUC+8JiySfgRfASJVK
 mVQRrX4GuIeYOOgNpxkVkEQE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8db66427678445f3;
	Fri, 18 Sep 2026 18:19:13 +0000
X-Mizu-Trace-ID: 8db66427678445f3
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 11:19:08 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: bingfangguo@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Bingfang Guo <bfguo@icloud.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: move memcg private ID refcount to objcg
Message-ID: <aq2AUmRISe3Nmfft@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>

On Fri, Sep 18, 2026 at 05:18:43PM +0800, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
> 
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 8412f4840ae35..7e4fbc5a786d6 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -281,6 +281,9 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
>  	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
>  
>  	memcg = mem_cgroup_from_private_id(memcg_id);
> +	if (!memcg)
> +		return false;

You can not return here without initializing *lruvec as it might be used in the
caller. Also mem_cgroup_lruvec() can handle null memcg and will substitute with
root_mem_cgroup.

> +
>  	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
>  
>  	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
> @@ -470,7 +473,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
>  	 * configurations instead.
>  	 */
>  	eviction_memcg = mem_cgroup_from_private_id(memcgid);
> -	if (!mem_cgroup_tryget(eviction_memcg))
> +	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
>  		eviction_memcg = NULL;
>  	rcu_read_unlock();
>  
> 
> -- 
> 2.43.7
> 
> 
