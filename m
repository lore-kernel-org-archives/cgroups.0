Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24CC3859EF
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182011; cv=none; b=RZw9rQbNm9n705jIYWW3wpanjkSz81jfOHcLd1/5kmAkf2yBHGkUanQKpgcVLaCMy+u3dXgKxuU8GlO2PWg7VNuQuXTiXLOy2V7R7QgMck03TI5fTHwWSXRVY0gWRiQqkrVST2CtVfiCr8zFGIg5dY5EA/zsiPa2b9pcI9hrby8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182011; c=relaxed/simple;
	bh=dbXVOSGpG+ytP577TTz2cjwlzWO5l0LZk965xEyoSUw=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VSaPZDpwlMQmbZevoatdHVsE/XpxeD3sdiC+ua8jnfN7P2IffBzOAeBndFqi6LR/6BI1hjKsgPMTRPc6lTLtDfSEsmf12NOrVXWAqBDUgM17ApsJ9JFqcNZ6SW3cdi94YxKo771Mua10TLe4Pwma9JD/fQgFBo6QaD1aWuN/JuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CPd0apMa; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CPd0apMa"
Message-ID: <c5efad07-7188-4f18-bdc3-fceb8aedc9b8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784181995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7uhHNMGoknzcpdCX17NI7sXI5Sy8+5TFbMqGXleEpE4=;
	b=CPd0apMauILsa0blk2Zc4Px4Ow25bSesO0rzdBGHpTKJ4yZpjwqUAkpX7TFVcZKhK6fxaR
	AG2mg6BU/X6qqv1UFv01iPxLiwxms33oA/l21mXJ2trnE4zIM1IwnFkC2VE9oBVmK4V8YZ
	8Oyr8gGKFp4RFowyOqGoGApS8ieFzXY=
Date: Thu, 16 Jul 2026 14:06:27 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Ridong <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-3-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260716031729.1064007-3-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Ridong,

Reproduced the bug and verified the fix in a QEMU x86_64 guest with
CONFIG_MEMCG disabled. Global vm.swappiness pinned to 1, then:

    echo "64M swappiness=<x>" > /sys/devices/system/node/node0/reclaim

  swappiness= | buggy (anon/file)   | patched (anon/file)
  ----------- | -------------------- | --------------------
  max         |      0  /  16385     |  16292  /  0
  200         |      2  /  16384     |  16837  /  0
  1           |      0  /  16386     |      0  /  16467

Unpatched ignores the swappiness arg (always file); patched honors it.
Matches the commit message.

Tested-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Song Hu <husong@kylinos.cn>

在 2026/7/16 11:17, Ridong 写道:
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
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
>  mm/vmscan.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 986dde8e7429..bd71595c8b2b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -199,6 +199,13 @@ struct scan_control {
>   */
>  int vm_swappiness = 60;
>  
> +static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
> +{
> +	if (sc->proactive && sc->proactive_swappiness)
> +		return *sc->proactive_swappiness;
> +	return mem_cgroup_swappiness(memcg);
> +}
> +
>  #ifdef CONFIG_MEMCG
>  
>  /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
> @@ -239,13 +246,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
>  #endif
>  	return false;
>  }
> -
> -static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
> -{
> -	if (sc->proactive && sc->proactive_swappiness)
> -		return *sc->proactive_swappiness;
> -	return mem_cgroup_swappiness(memcg);
> -}
>  #else
>  static bool cgroup_reclaim(struct scan_control *sc)
>  {
> @@ -261,11 +261,6 @@ static bool writeback_throttling_sane(struct scan_control *sc)
>  {
>  	return true;
>  }
> -
> -static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
> -{
> -	return READ_ONCE(vm_swappiness);
> -}
>  #endif
>  
>  static void set_task_reclaim_state(struct task_struct *task,

