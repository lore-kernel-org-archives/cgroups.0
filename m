Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537BD31714A
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 03:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784172392; cv=none; b=beLklgEPmEhoOo+OuECXUSS5M+mc8K3jVW2E5ubFkyeQonwicPe1FycSuFN6dXZsxL9SxnARioeTvfFPBajpazzD35MMf/GnVpTKYB37wC1x8FgPtAzfFmzEo5oGqkep3/mqVp+jkg2yIYFNz30r0A3yQs+C1MSso/CEKr1z+dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784172392; c=relaxed/simple;
	bh=WA917DKAKOwQI8iWYO+lgG3B+zDmXKZrt1gj1VohUHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FFUiTUgYVUNFy0UHgie3ZDhR1Ij13CI4/zMR5U1890O2zbNAK1aaQxoywBZrgC/5YLf8DSpjKSeZkrcf1CslDBgZsqJ3XESCmRCXOP0lK+Z+QGmP3GvHQB3fKoSewi0OFUydxVUVC2e+Y/oWJ+ELLgu9YonGqkWskjImEM+mtdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kzs63WiC; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kzs63WiC"
Message-ID: <688a39f3-4539-4916-80f7-67456a514169@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784172378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NnyjyDapX7AyGQm2q6tRWBOCLxlc24/i4a9N09iebLA=;
	b=Kzs63WiC192zhPydLmoGCNFB5idBm5wsZX6Yu30ywryMazQ5LAAcUpixyDemD8ow/Dz580
	GT8Uhnk07l0TiaOF3IiOBWY8H1b6CE0TRhhwxhXUAY054weucbAwW1g7z7pz+3kkkokWnh
	pm3kdP5i5fgXXSZAJ/KYmvM3jEKx/qU=
Date: Thu, 16 Jul 2026 11:25:58 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Ridong <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-3-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260716031729.1064007-3-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/16/26 11:17 AM, Ridong wrote:
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
>      # cat /proc/sys/vm/swappiness
>      60
>      # cat /proc/vmstat | grep pgsteal
>      pgsteal_kswapd 0
>      pgsteal_direct 0
>      pgsteal_khugepaged 0
>      pgsteal_proactive 1840
>      pgsteal_anon 25
>      pgsteal_file 1815
>      # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>      # cat /proc/vmstat | grep pgsteal
>      pgsteal_kswapd 0
>      pgsteal_direct 0
>      pgsteal_khugepaged 0
>      pgsteal_proactive 18013
>      pgsteal_anon 337
>      pgsteal_file 17676
> 
> After fix (swappiness=max honored, anon pages reclaimed as expected):
> 
>      # cat /proc/vmstat | grep pgsteal
>      pgsteal_kswapd 0
>      pgsteal_direct 0
>      pgsteal_khugepaged 0
>      pgsteal_proactive 0
>      pgsteal_anon 0
>      pgsteal_file 0
>      # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>      # cat /proc/vmstat | grep pgsteal
>      pgsteal_kswapd 0
>      pgsteal_direct 0
>      pgsteal_khugepaged 0
>      pgsteal_proactive 16283
>      pgsteal_anon 16283
>      pgsteal_file 0
> 
> Cc: stable@vger.kernel.org # 6.17+
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>   mm/vmscan.c | 19 +++++++------------
>   1 file changed, 7 insertions(+), 12 deletions(-)

Thanks for fixing this!

Acked-by: Qi Zheng <qi.zheng@linux.dev>


