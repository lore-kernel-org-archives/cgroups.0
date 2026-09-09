Received: from mail-qv2-f5.google.com (mail-qv2-f5.google.com [74.125.230.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE353397E80
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 18:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788978593; cv=none; b=CsOHK4jIJOR5RakDS7IPcW0oLrWgext51DSx58zQQlFW5s+Vlmnf1fL6UU6dD4BgBT8jNvsTUtIXavf0tTvyv9LQit+jbDA7gtedB6X0j+4l1ev6hXDkAEhKVs6YFJp5R1AL87666Fmr0weYs8B9gigMl5jHe3FAi7UO/9172vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788978593; c=relaxed/simple;
	bh=+CPMrFl/jUrszvFkBjRpPbN5cZST8GT3Y7StztkkvVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/+16bKe46U2SST/PAGOjIqonYKemRIVDf4xFEWent88FiompTOAbZGtrz71786lVv+wEIoyNjaTeoNmpNjqscOYCljcmSRRIqtTKUhpigVE6prbXpX4DcFRz61+IWoXreSVypVroDbPqjTU2iTrHvYfR2rlXR1UJbOo4bnYSyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=Xll4H6KA; arc=none smtp.client-ip=74.125.230.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="Xll4H6KA"
Received: by mail-qv2-f5.google.com with SMTP id 6a1803df08f44-90cd1be1f12so23070576d6.1
        for <cgroups@vger.kernel.org>; Wed, 09 Sep 2026 11:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788978590; x=1789583390; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pIvedYIS2AeKXYBcXZE100tskW8WcxbKQFbzxJ/h4TY=;
        b=Xll4H6KAcn3iLNlRB4cwpdXfVHSm2UTw4bqRcfqAkG1pYbZrRwXeWzQ9a3SyoUdk3P
         ZWLB4WJzzjdZiVYrGuw09AsmiSzd/MJDyxEPfN2b+tDRj+ajrfvy5GaUoqtoJkRH3vj+
         7TDQbAv3zxE9PuEiMu1XCmBQLT3NGEheHy2lSbz3ADlRUrk9jr6cru2AmbhLdz1PuLs9
         kt2X48OEc8XD1e90TBbv1AAD+WijbqUdMlJxFMgLqyAMi3ME5BIFXUjmTegUwNLV3F9h
         WQu+o6HQaxbOuT3Y1qpY3Y6qnxxL5ZHYTgcpPWFBs+jTiOkDHUf759edJnj1kcRN2tBL
         GToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978590; x=1789583390;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pIvedYIS2AeKXYBcXZE100tskW8WcxbKQFbzxJ/h4TY=;
        b=rk2yHneVLxaeKGkns1daTkGJOfl6jKOFr7OoIZNW6yxtdVuZwh/eJCakjNCQ4RuVwT
         qognfYsJ+MP4L0GiQND9X54YLPq3dQ06skeWB0J0QAgCUkCblTCQMYsUVw6m8ap3Xlf9
         5LKfY3Uph9wXAhtfhW/r4HDSUJbpab+BxR1LChsvynJ76ueQjWhElbDvT4qgBeDFpAjQ
         asHi3bcswL/6fkxqnT4KISVvGF3na0z1dnvVlCGITX+/V5UmhDgXRiOS5we1inEXOEGs
         /r7KCXf2/ACYb02u+nbABluGnRZCddpSOUbvbHYjKDW7BD5wzAaeSBykGxrbeDihesxN
         F1rQ==
X-Forwarded-Encrypted: i=1; AKwUvBz+7fApCcfdfQmAgLne0RZZ76prc995tkSCeJZ3U9DH/UMvUWxeVQf3qVGi+bG4JJ1oZRajbbz+@vger.kernel.org
X-Gm-Message-State: AFuF++lzy2Ln5SHJEKGPY2Bj5HTycBiqQ92iCzcnxAqWcCPokocY77+X
	ZpgYMc2oUzFyY4ntBXg97o8iXfVJM9gKVVeh++koKY7TckyAQi8RpGNJQczl0OzzOHM=
X-Gm-Gg: AYBFou0NO+xzaFoppbFkJkENQCsc9/mQUOLZLu826Wi/dPemRDsHTnargOdXot+kFio
	yI0G4cTI+ILLGFL99xsJdjMLwLLIGI+E16CDONWUJNNsoXu4FZG/mfZb3hcSD94aAb4gW7B9JLc
	cxJ9gl30lrKznxJpGkxYGK66WJEsDigGeoHy3E2KdVJkGnFRs+5fESe27TPEUhpUfme1AO9n6hf
	TkURBdEww/3hZwRHTkKsYDJX7hXUzJj5L7MQXQBKYyFS/4tVeUYt1zUA7kWanfSDYEbbHDun9O3
	tC6A16H3tzpse/sXw3ga/xqFpownnFwA9Z7kcPdiD8daIdnff/D/L8AWi0zxZyXbNmGVqpmLHPN
	eW9tfkegbgd2A30c6jsuOKSvNJIiBMn0/9IlvR406sGvGIbzrsCKaMuNo3ViUPR4VG/7bF7vJZM
	Tjv3bn8o9GQ4d8eJZ6cZlDR4Y6pugBZCzZXtYvdwBkzat/pyzMpoWyE/iPSRungM/kz3aqqg==
X-Received: by 2002:a05:6214:2f8c:b0:910:3451:341 with SMTP id 6a1803df08f44-9103efb48afmr505437276d6.32.1788978590647;
        Wed, 09 Sep 2026 11:29:50 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910490a3a58sm119183276d6.44.2026.09.09.11.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:29:49 -0700 (PDT)
Date: Wed, 9 Sep 2026 14:29:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: zswap: mark the zswap shrinker
 SHRINKER_NONSLAB
Message-ID: <aqGlnALaf-Cvq4kj@cmpxchg.org>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>

On Mon, Sep 07, 2026 at 07:01:11PM +0800, Qinyun Tan wrote:
> With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim
> never invokes the zswap shrinker: a cgroup under memory pressure does
> not write back its own zswapped pages to make room; they are only
> written back by global reclaim or once the global pool limit kicks in.
> 
> The zswap shrinker is registered memcg-aware but without
> SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
> before commit 03375203e1da ("mm: do not allocate shrinker info with
> cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online()
> check in shrink_slab_memcg(); since that commit it is demoted to
> non-memcg-aware at registration.  But the zswap shrinker is not a slab
> shrinker: it tracks zswap entries and resolves the owning memcg from
> the folio's objcg, independent of kmem accounting.
> 
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
> 
> Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
> under memcg reclaim with nokmem.
> 
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
