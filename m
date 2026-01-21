Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF3636212B
	for <cgroups@vger.kernel.org>; Wed, 21 Jan 2026 11:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768994533; cv=none; b=VtypZ2haK8CcU8baLDKYi0E0/IDIGSURPoVe2siJTXosUt/xbjXORlkSbM5xEDHFWpo7GqC4XKMcJx9QD7BdjwlWDy3qo1D9bnPMzzhoGnpKf10GW4uiA1a43NWOPLnHpzxPQfj5nd9ns/advetT2JSxIQNrJ6Tst5bFvP/odNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768994533; c=relaxed/simple;
	bh=BWNqOce4wTpeTKGf7ZweojFhIY6rcNn7K0lNiuDUTXc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UKRvjnsN8g6pw2hq3xPkas3PktUAfCUWmnDGyCaymUoJTtowLhA677/1+TqkjWXyw5s52EeDk2kEgoSdinkQKh8CJjkm241EHZAf9P0XH+FYIgOOu+Duqfm0huyjyJvVWA226wFGOjXd3LJz+LZRj8ed3AX7DLq/u09sqDz+VC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NEErvpnf; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NEErvpnf"
Message-ID: <b7ae0bf1-2a37-4848-80b3-7affa25cbde0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768994526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqhAFzJjI/DgbR47XPHmTUNDQmb22woy0wLaS+F3G48=;
	b=NEErvpnf+3SVo2420D1iw9gprXB3BTqiAM33r/uRjkK0hi0Y/fuIwdNJfhWFkwkYDC+c4G
	qTkD02heYrDr8N0t/aJQS1SfgYz0ybVwc2YeKOLhsTkwZAc/x/QdpTcbg8qW3O3J0I73vO
	Ce0rkbMrWZhoouAnbTdHwgoRcCkUAvo=
Date: Wed, 21 Jan 2026 19:21:49 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 26/30 fix] mm: mglru: do not call update_lru_size()
 during reparenting
To: Harry Yoo <harry.yoo@oracle.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
 <20260115104444.85986-1-qi.zheng@linux.dev> <aXBNuLDtUmDVyXTv@hyeyoo>
 <aXBT0R42Xuzwr3Ns@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aXBT0R42Xuzwr3Ns@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 1/21/26 12:19 PM, Harry Yoo wrote:
> On Wed, Jan 21, 2026 at 12:53:28PM +0900, Harry Yoo wrote:
>> On Thu, Jan 15, 2026 at 06:44:44PM +0800, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Only non-hierarchical lruvec_stats->state_local needs to be reparented,
>>> so handle it in reparent_state_local(), and remove the unreasonable
>>> update_lru_size() call in __lru_gen_reparent_memcg().
>>
>> Hmm well, how are the hierarchical statistics consistent when pages are
>> reparented from an "active" gen to an "inactive" gen, or the other way around?

Oh, I completely forgot about that. If update_lru_size() is not called
during the rreparenting, this issue should be considered separately.

>>
>> They'll become inconsistent when those pages are reclaimed or
>> moved between generations?
> 
> FYI we've observed this while testing downstream implementation
> as it led to MemAvailable being unreasonably high due to inconsistent
> statistics.
> 
> The solution was, if lru_gen_is_active(child, gen) and
> lru_gen_is_active(parent, gen) do not match, # of pages being
> reparented must be subtracted from the child's statistics
> (and up to the root, as it's hierarchical), and added to the parent's
> statistics for the generation.

Make sense, will fix it in v4.

Thanks!

> 

