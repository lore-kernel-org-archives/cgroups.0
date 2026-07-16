Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3033A379EEF
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 03:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784174342; cv=none; b=SRYxqfs20QMD8DRM832e8VjC6DhuMz48PJANiGMmwCIzwVo5wrqOHdUDeyIA8GUD0nQ48hIS+wxvcmxOpV1eE6NkeV/u1ehl+iomutz9ptrS02PRoeDNs/goHSQyrzueqAfqLcN2hqVKRcIDnY/5Hpp8e7e5ZlrE98U+jRNGnQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784174342; c=relaxed/simple;
	bh=zyCm0QK4BCMch1rnvE4tLgyccRo/yRLYbVBtxwh/bNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJOK0u5jhErzOa1Sdk8l6s+wUCvgdolpZ0ojGOj9ommKG9RTZwNi02pig7Y2+9PNCy3TAJyv/UBAZo4I5Vt432oqPwwgrML6D8fUtEUto/jpawPuyw9a8HlTNeSJTDwokjj4Co/5C6fJohXeAxX+upa2EF3jqVEjnsoXo/ZXW/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j/33hv/2; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j/33hv/2"
Message-ID: <7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784174329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0AnN8e1EWqqeefGMv/bid+J5xVgBNkpn/GD6NfmL8Ms=;
	b=j/33hv/23oaQQSAejzxu8OIEdjmzkl12BiowWWlgn26wVQRMjzYs439/J9IDkjKukuMLsX
	53VgUfAUpxv31jx++lcI1MJVRKqsxEYpkptZDceICJrWs33g0AzVm4G13AuMlubGJ00hUY
	kLDej4Qt+xXRWPGtDkJzH2n+pprSi0w=
Date: Thu, 16 Jul 2026 11:58:33 +0800
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

Hi Ridong,

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

By the way, in get_scan_count(), it seems we still reclaim file pages
without swap space, even if swappiness=max (SWAPPINESS_ANON_ONLY) is
set.

This behavior appears to contradict the semantics of
SWAPPINESS_ANON_ONLY, which probably needs a fix as well.

Thanks,
Qi

