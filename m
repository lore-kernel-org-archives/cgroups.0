Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3041F435539;
	Fri, 24 Jul 2026 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784908400; cv=none; b=NVfVNj/T4mWHwzdECG/v+jqRpGO49sGvvLixzQIhKpKWmFlwQh3Mqu2lneV3biKiS/J6pg+13+oMdnTyOBAE2JpKGe5NHJnUinBrC/eGmXPvYWLw+Trf2FKqw9bDCD1ldMIN6BSDsr8C7ceuDLgPpm682Ss6dWyl389jm9woT/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784908400; c=relaxed/simple;
	bh=pvCEZGYyl+wMPhmvDrOLi6RgpLytfqvsOIkCMq+82+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zpu7Ycu49EYK4vHl42Ua5Sb6O0BrH9df3+kdGg+QVpO+CUwLXCS+lmeZW7eFThVMHtWLxgurMILTfABV+dr0VSX3Se+eOYeAAs/Ewi89GoFZLxU5WbhyaMUJ9hsMPMya/E3zOczJEPDuYcOvaqXB27+cjJEZHITvAlUDl7HODgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PCpg4SE7; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PCpg4SE7"
Date: Fri, 24 Jul 2026 08:53:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784908396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=06uCIXsveTpkvDVkD9nXslULujIABwBfAiluqsvUQbg=;
	b=PCpg4SE7KPs5gD4m8VAbzQQyvn+j9kFS8RF04pCPP14S8Aj6j8jhN19WHt+nEZqTgsK93m
	bkVm9wC9xdo4U4FGGGLIJ0THEQZSQYbg+2yoZOKvwJPg6c50FzmXsqhkoc9Wszyl+qZNtS
	kicIpxgWjnJm4AElvDP1xik7717SOyY=
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
	linux-kernel@vger.kernel.org, Song Hu <husong@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH -v4 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
Message-ID: <amOKS3Ze3SgmgWMY@linux.dev>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
 <20260723032434.2016749-3-ridong.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723032434.2016749-3-ridong.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 23, 2026 at 11:24:34AM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> sc_swappiness() had two separate definitions depending on
> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
> vm_swappiness, ignoring the proactive_swappiness value passed
> through scan_control. This caused the swappiness parameter
> written to /sys/devices/system/node/nodeX/reclaim to have no
> effect when CONFIG_MEMCG is disabled.
> 
> Fix this by consolidating sc_swappiness() into a single definition
> that checks sc->proactive_swappiness first, then falls back to
> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
> and !CONFIG_MEMCG.
> 
> Before fix (swappiness=max ignored, mostly file pages reclaimed):
> 
>     # cat /proc/sys/vm/swappiness
>     60
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 1840
>     pgsteal_anon 25
>     pgsteal_file 1815
>     # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 18013
>     pgsteal_anon 337
>     pgsteal_file 17676
> 
> After fix (swappiness=max honored, anon pages reclaimed as expected):
> 
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 0
>     pgsteal_anon 0
>     pgsteal_file 0
>     # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 16283
>     pgsteal_anon 16283
>     pgsteal_file 0
> 
> Cc: stable@vger.kernel.org # 6.17+
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Tested-by: Song Hu <husong@kylinos.cn>
> Reviewed-by: Song Hu <husong@kylinos.cn>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
