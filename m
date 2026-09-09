Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2333337AA86
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788978146; cv=none; b=XgEnjHknLEcj6bKFtQw8SZCH5BFCQvkxQC9IV/VvEKThBJyl7ARHdPFlw/KzIourC+INoaIIGObHShj4IjQ0/MzXk5bXWNmlHO/1fd6ZsOmJURXynM+SHbL/TkUJjxkh/7wUv/aivMWt3AZx210tV6JTflNB3N/uwbaDKrDirzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788978146; c=relaxed/simple;
	bh=CMSbUmjBNeTqwH+XPZOLWom9obZHzYZEqa0mzswbC08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qhv6678pzeJnTZTIsHUYU4uAc3Ytdip0gxAAIehLTk99ddZRSCXoepnlG00KuMjzZYlfRGe8Htv9k8ZP1w9wuRSp8A3BE33hKy38i1tisfeAVKXn3T0tBkplWKnpnk9UKFgnDlGDKKBr6DYoG9E9AW/9vpxdMiaOj7RDv8aH5/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=Ew6ow3XV; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="Ew6ow3XV"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66bd7857841so6769949d50.3
        for <cgroups@vger.kernel.org>; Wed, 09 Sep 2026 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788978143; x=1789582943; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mdfhQUoai9I947DZmJ0Mq2HjjU3s4/4qoMH6601twbc=;
        b=Ew6ow3XVoyCFrGeO0WHjGuioN49MFRg8TrCEZhOmWvtpV+kKAXJkmXBPexGnocl8xo
         VwWuElbJ+l0NgJanqchz5C7+/+6y/rfSFvlEBvyOEbkXjMGZWvB/ylNe5A3HGZJ1JHdr
         cmIGWVYl6vZsdXrLiG+ILf6eHEvZvWz2sAdg2NtTU+sqkiFLA+LYfrXHSIl0ZLH1sHQy
         LG5748LdhiXtbN/fIMZccQRiG8niRLo560WisX8qtDr9MNP5L/aISpvTkzi6xOn8+Ayp
         B5yQhHGzxquhZ2CSkgi1HJMNARjFk+5L5EguzfBvMLQAPWgfKG4UOPRLc11rmZNSjJu8
         XsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978143; x=1789582943;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mdfhQUoai9I947DZmJ0Mq2HjjU3s4/4qoMH6601twbc=;
        b=p+9EK4bANeyeo8en3dUMTqYtu/lM9gCbX85x2aCr3TVeFd3ZV6voRY3UQWch9d53wm
         R2kyzlEE2JrL3gdFRrNtX1HtQV1ZPfP0FOO3wSS9T4S+YWMllXUtIV+rkLKkvpIp/Mgi
         vC1KatSa7C5zuP/tbT/i00difM+09ZDBxEBOUruaXmDudX3S2/P0W9hDfQcAb/FoB2Qj
         KFPcZbziY0WAyaM0uuPbPrSY261o3aAK8JnBrdn5bHfjM3MdXqH9cw/rY2FzzMS84Lcp
         PWKFlONJqB/5PL+4+1/QHsQ/IlcnBAtomFyhFMrY6aXHQjE/51+inpcGJtorjDCQM4GX
         gDQQ==
X-Forwarded-Encrypted: i=1; AKwUvBx4c+d9PTU2FdBGLz/GiC6UIAspB1wTPajDtNFU9x+jteVF1aG/IPY5N00n0zTPjUJzrfB1l9RL@vger.kernel.org
X-Gm-Message-State: AFuF++kG8LVFgagmedLfORE/BZFSjZroBk0/5viM++GByzCId+wbjb79
	XUP8UOx+GY+LcuxhJ2EGoq4bWO7MEpqpsLRoxio6N6LvctSLq04NVKYV3OYhq9NX6HM=
X-Gm-Gg: AYBFou3FUNChkFqx4dCI9IYrYBFKgNQ6QpB+4DZxyaaph01PHtP45eiDyPVZzUrzYmV
	2T5Telqr1OS+gmYknb+DHrCmeybPLoOq9hHPegwk2Uw9mcVIyi2FQ2DwmQqmH/7QDsyGmXiNVKC
	hFp2pYcxZHlgvydGyCoyQgDCwxa1o9S4Qo3Jy2QYWiugB4VehDmgTD4DZPBQXOVuPXa89aqnEgl
	B34VZMaJq6yE3xdTl9yNuwDgxXlXUomwBKuFf1s/eGzPoCfsPktCognvS8qbuTh7yr3N33XhPDG
	QYRK+z+m0narHoEHronhqeUU1u1xPyfIvUtphIW9qwliyHJUoU7f2JD5dapvJUKjk5TEhZZxJrc
	oPtvuVhC+h3TG7AdcmJs7YEAWPNG+Hhjt9zx6TCwxvvnbGAKb4hIxTV6MoqAZadK8ASEcoX7ZzQ
	sIAAHcX3drbet/3tXn/u0/Ojf6nGDplfvXCGfI4tAQpIFrklJzpp8nhOA6zwdywfRWiWqk5g==
X-Received: by 2002:a05:690e:108a:20b0:66d:28d7:c33b with SMTP id 956f58d0204a3-66fb5ad93b6mr9645565d50.40.1788978143182;
        Wed, 09 Sep 2026 11:22:23 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694c35sm149647686d6.36.2026.09.09.11.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:22:21 -0700 (PDT)
Date: Wed, 9 Sep 2026 14:22:20 -0400
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
Subject: Re: [PATCH v2 2/4] mm: list_lru: keep per-memcg lists with nokmem
 for NONSLAB-backed lrus
Message-ID: <aqGj3I87H6MnAZRQ@cmpxchg.org>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-3-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907110111.2286932-3-qinyuntan@linux.alibaba.com>

On Mon, Sep 07, 2026 at 07:01:09PM +0800, Qinyun Tan wrote:
> With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru
> into per-node lists.  That is fine for slab objects, which are not
> charged per memcg without kmem accounting.  But a lru backed by a
> SHRINKER_NONSLAB shrinker, e.g. the THP deferred split queue or the
> zswap entries, holds user memory, which is charged regardless of
> nokmem.  Collapsing such an lru loses the per-memcg view of its
> objects.  Reclaim can no longer target just the cgroup under pressure.
> 
> Keep such lrus memcg aware under nokmem when their backing shrinker is
> registered SHRINKER_NONSLAB.
> 
> This leaves the savings of nokmem intact: slab-backed lrus (e.g. the
> superblock dentry/inode lrus) still fall back to the per-node lists,
> and the per-memcg lists are allocated only when a memcg actually holds
> such objects.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
