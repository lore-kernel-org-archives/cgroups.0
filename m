Received: from mta1.migadu.com (out-150.mta1.migadu.com [95.215.58.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF9E3839A0
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 10:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788087440; cv=none; b=NDMzLKj0WW9q/CG9zTQpbipGPMBtEzjjkrWo02LCEd9zcct/Yb/kbnX8XgVLJ6KJcmR3DDXhvJRezcvQVcawVb4yuwaECZBntFqaXbdHN70glg8omBgtrAq5jzGWJCfZMmjfm60uJVbWrMVFpDmg15oKMzsO0aDy5D5Gv+zaBCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788087440; c=relaxed/simple;
	bh=yzCS2uJ6tHwcB7fqOOQe9/2KmZ3F1ciT33gbDIVkuaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPMxmWHFonLfCCcTeGxIjlXw1sBCcMcHI4tiiMBVojUXl0n+yCs2zg/wMLyfbZ9zD96/K1iOkSwFPh0e7+kTbXrxy9nuNctPo5ZqL/SsZKPvfunqTfiDNe5XZECxIwCbdlrW/MaqPo3Gb5uyxHh5D4Mjy1nMhM3ynptJNWIBinY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TeCLhTro; arc=none smtp.client-ip=95.215.58.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TeCLhTro"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yzCS2uJ6tHwcB7fqOOQe9/2KmZ3F1ciT33gbDIVkuaI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788087436; v=1; x=1788692236;
 b=TeCLhTroa41J58XGdLShIZaU9Qmd75n7b/gevcF+hfbpeIjxZlIXVXxKe18Sv/9GLVgHfvE8
 8WSQT5VT1Ewup6F19wi2JckVfI4rmsjRPnh7zX71H/mCvsa7yQf5RO7LSMUQVg6E3MQ1++4j1nz
 0K/WTuvwEvVVxNS6+fWx0CVk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a1b9075004b6ac5b;
	Sun, 30 Aug 2026 10:57:06 +0000
X-Mizu-Trace-ID: a1b9075004b6ac5b
X-Migadu-Flow: FLOW_OUT
Message-ID: <b9494f20-9ec0-45fc-830a-1bc2f92ecff2@linux.dev>
Date: Sun, 30 Aug 2026 18:56:53 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Barry Song <baohua@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>,
 Yu Zhao <yuzhao@google.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
 <20260828110919.1324028-3-ridong.chen@linux.dev>
 <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
 <c0a32c3c-bff8-433c-8552-f0723e3a07b7@linux.dev>
 <CAGsJ_4wvYNV2UMaFW0a3Fb9U09v6bPfXyg4Rzw4B27xo-NVYbw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wvYNV2UMaFW0a3Fb9U09v6bPfXyg4Rzw4B27xo-NVYbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/30/2026 6:40 PM, Barry Song wrote:
> On Sun, Aug 30, 2026 at 6:13 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 8/30/2026 3:53 PM, Barry Song wrote:
>>> On Fri, Aug 28, 2026 at 7:10 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>
>>>> memory.min/low is silently bypassed for MGLRU during global proactive
>>>> reclaim (writing to the root memory.reclaim) and global direct reclaim.
>>>
>>> I guess nobody is silently bypassing anything. It's just that the
>>> effective min is stale data. If kswapd has run at least once, should
>>> the protection have been updated already?
>>> I guess we need to update the changelog a bit?
>>>
>>
>> The children's emin/elow are derived from the parent's min/low settings and
>> children_min_usage, both of which can change over time. As a result, emin/elow
>> may become stale, even if kswapd has already run once.
> 
> right, let's just say this in changelog, we are *not* bypassing we are
> just checking
> against stable data. The current changelog seems to be misleading.
> 

Thanks, Will update.

> [...]
>>>> +void mem_cgroup_protection_path(struct mem_cgroup *root,
>>>> +                               struct mem_cgroup *memcg)
>>>
>>> Can we rename it to `mem_cgroup_calculate_protection_path()`?
>>>
>>> BTW, I see that the only caller is in vmscan and it passes NULL as
>>> `root`. Do we need to keep the `root` argument if the new helper is
>>> only used for global reclaim?
>>>
>> I'd suggest keeping it as is. This function updates protection along the path
>> from root to memcg, and could be reused later. Note that
>> mem_cgroup_calculate_protection() assumes the caller has already performed the
>> top-down walk, each level's calculation depends on its parent being updated first.
>>
>> For mem_cgroup_calculate_protection_path(), it can be called in any context
>> without such a precondition.
> 
> I am fine with this -  keeping the root there. but I guess rename is worth it.
> 

Yeah, I will rename in the next version.

-- 
Best regards
Ridong

