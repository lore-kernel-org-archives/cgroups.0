Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE4B1A304A
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 01:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784855502; cv=none; b=uFOdz0NhsbvHLMHXKzEv5fed/0yQhC4wTr2Klw6W6o8stofhOXGswhYMER4I3Bs2ZLj0GwldgFWTI+ykj7Ovu3WmipDRZcGOtDJKnHp/Sv33pYHHwASCnS9N8X80rYVwWaCrxynZhHNVLQ6J07F8x4B3+/kLyRjyB7yNIAJsRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784855502; c=relaxed/simple;
	bh=dNwvlX0cBvSu5YtbbAxXlaFnjZdSS/GyFzTZbXOArvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j5ljl6bVKp5VkkNOVRIzznC8DdCqbijTvCzXW6+m5MqXjwZeEnoonj+vp9eVp2uGZr8hu+83sz76PWgOi3lnSq6QcQrouWJCbfOgsEEpNdX8jel+oI4MpSnbfwFwTWhWVZA3RstCd9wYOlmhUiKoyyDFTwrNyeeS3k1AsuXlRgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Yakm3+hH; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Yakm3+hH"
Message-ID: <5e8d124b-c96f-466d-8947-68cde3014a17@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784855488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sRSJBzhHabeY3v8/MCt6zskXys5KcGp37U7Whb22Mjg=;
	b=Yakm3+hHVWosoKkIcbUWUVD0bxF53ix1pmcMT+x6uqW2PIiszrBGMV7Xtpxg3rrlMbvLuZ
	dHiedtkB5Ia35jz7DP36wg64XbLQi5ZvAuLhCiA7tY3NkSIJRuoiZxG2M7ZU3aZ/i8NA0p
	+jApLnlffCMhcMdPjHOj+dyomlNsxu4=
Date: Fri, 24 Jul 2026 09:11:18 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH -v4 0/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Song Hu <husong@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
 <20260723173418.010e38f655f83850d92c2c8e@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260723173418.010e38f655f83850d92c2c8e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/24/2026 8:34 AM, Andrew Morton wrote:
> On Thu, 23 Jul 2026 11:24:32 +0800 Ridong <ridong.chen@linux.dev> wrote:
> 
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> The per-node proactive reclaim interface
>> (/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
>> but it is silently ignored when CONFIG_MEMCG is disabled. The root cause
>> is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
>> !CONFIG_MEMCG, and the latter never checks proactive_swappiness.
>>
>> Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
>> include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
>> handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function.
>> This is a prerequisite for unifying sc_swappiness().
>>
>> Patch 2 consolidates sc_swappiness() into a single definition that works
>> regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.
> 
> Thanks, I updated mm.git to this version.
> 
Thanks.

-- 
Best regards
Ridong

