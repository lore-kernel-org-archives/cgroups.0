Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B7D3FCC;
	Thu, 10 Sep 2026 07:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789026032; cv=none; b=qCUffAIzg8FPaqzZ7iYTb6m4gwTVUdvDw+/1Grka7xFVHaaqwKks+n63uOIjL1NJKjPD5x3f+T9g1mYQwuc/Bb2l3DTbNbJJw226xwmzDXFf3r7PKeIZNWQ44135Pwx9aooMv4lDoK03IiboH5cO8/j0Ds1UgQrv6RdaqEzKON0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789026032; c=relaxed/simple;
	bh=hPUuSM2Gydow0HPwDDJUKrw5P9qOJFNqgBy8vTF2rqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G8JIZiLkDhfq4WA/Y0hYfN5hrju8b6Jx9aL28CaGJtuXCYG/bn2i2RJxC9E+Qy1i98pU5Jpxz2BktG0/P092dp5SRaEe4FRfxVNRJfyCEP7ZZa4QVyLQRiFMdIfBcEaU0iAl51JaeQOTILBdSb7MTuYMm7Mhkf6oYzLyroQdS5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hObn2qOa; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hObn2qOa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789026019; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nO/KQnopE23Wizv8xSIWVHEQPNqM2xv6VOHjFuXQ9M0=;
	b=hObn2qOaq0A3X+0I/izOXtHdCNfRASbw87T3QgCGYi/yv0rN3eSrFnWlHLyezIN5IwoEcadQzCazc6zLqKLCAChfDQWtc7zcupV36M6SD9i9XAHWHzFGFyFT0PuKhz1TCKJZKb9Q3rnGA1C9ZDxtYdilA/PtlNmrvgt0M1uS/0I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XAgyQpm_1789026012;
Received: from 30.178.84.157(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAgyQpm_1789026012 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 15:40:17 +0800
Message-ID: <de74c87c-b52f-4310-b3f7-9a64b1b01eb1@linux.alibaba.com>
Date: Thu, 10 Sep 2026 15:40:12 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg
 ID for list_lru indexing
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
 <aqGjkGA7XeYEHA2T@cmpxchg.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <aqGjkGA7XeYEHA2T@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/26 2:21 AM, Johannes Weiner wrote:
> On Mon, Sep 07, 2026 at 07:01:08PM +0800, Qinyun Tan wrote:
> 
> This is a private ID with lifetime only guaranteed for online
> groups. Reparenting happens right before it dies at offlining right
> now, but this is not a great dependency to have.
> 
> Use mem_cgroup_id() instead and just get rid of that helper.
> 

Hi Johannes,

Thanks for the review.

Right, the copy of the private ID carried exactly that ordering
dependency, and the cgroup ID removes it cleanly. mem_cgroup_id()
it is.
> Both of these functions do very little now and the asymmetry you're
> adding on the mem_cgroup_kmem_disabled() check looks odd. Please just
> inline them into mem_cgroup_css_online()/offline():
> 
> onlining:
> 	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root()))
> 		static_branch_enable(&memcg_kmem_online_key);
> 
> offlining:
> 	memcg_reparent_list_lrus(memcg, parent);
> 
> The root check is unnecessary because roots are not destroyed. But if
> you'd rather not make that change here, keep the root check, and leave
> its removal to a separate cleanup patch, that's fine too.
> 
That makes sense. I'll send a v3 with these changes.


Thanks again,
Qinyun Tan
