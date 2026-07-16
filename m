Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3093D7A16
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190240; cv=none; b=ArZiJ8OZvU/HEbV6ydUXMO8y3CBBP7pfWgkbaBpLbLg3d8kPZkeTL46BXZpFuu6CA8GF0v6g/3wfmIKshTTHShpYX7kfublzHfLpIhu31QFaSutNVrT0cf9T/mEaz/9fqfgcLxI1bc2BH/T9cxykWWAQjG/pT4Pfx0ASwkHmuMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190240; c=relaxed/simple;
	bh=OqI4WMNgYIsd+7+h1pcgjDmt8GV93rtfpTA8yRBccbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U+CkkMyPIX1089eIsiW2jes/xpppfQe3s3lj6ifXMnhiCVtQJMcswKicpY6cFRsJxbJ0da//PAvzoPZUPeq1Ss8eBrAmFNiyLK5Yx2iWjggyvnO7XgcfP+JC1rvYNiA1++NJ5SK14gCVjeuURRVza1a7j9+po+7Gsvr0LVIyiDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Op6V0AuF; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Op6V0AuF"
Message-ID: <e1cb2692-166d-47d9-9296-d49f208f7290@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784190223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UIaszBeUoTnjcZ9764rp1WBJk9UH/ENIc9gpm/gy/NI=;
	b=Op6V0AuF4XlLT+MZsRSab/NCi9drrN/5EZf8hapHnyZ1epDk8IaaOQyWMrbrxKL+xLYono
	yq00msQf8VHcQcEQPS6YRrcrRYPsD/i4EuCqgsqHAjoY4PIc9kUs7LeWkqKnOHwaqGRtKn
	gZ8AagocXhquwlAfqxnYYiLFPsELhFA=
Date: Thu, 16 Jul 2026 16:23:31 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Tao Cui <cui.tao@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-3-ridong.chen@linux.dev>
 <c5efad07-7188-4f18-bdc3-fceb8aedc9b8@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <c5efad07-7188-4f18-bdc3-fceb8aedc9b8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/16/2026 2:06 PM, Tao Cui wrote:
> Hi Ridong,
> 
> Reproduced the bug and verified the fix in a QEMU x86_64 guest with
> CONFIG_MEMCG disabled. Global vm.swappiness pinned to 1, then:
> 
>      echo "64M swappiness=<x>" > /sys/devices/system/node/node0/reclaim
> 
>    swappiness= | buggy (anon/file)   | patched (anon/file)
>    ----------- | -------------------- | --------------------
>    max         |      0  /  16385     |  16292  /  0
>    200         |      2  /  16384     |  16837  /  0
>    1           |      0  /  16386     |      0  /  16467
> 
> Unpatched ignores the swappiness arg (always file); patched honors it.
> Matches the commit message.
> 
> Tested-by: Song Hu <husong@kylinos.cn>
> Reviewed-by: Song Hu <husong@kylinos.cn>
> 
Thanks.

-- 
Best regards
Ridong

