Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115D438C426
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 03:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787108418; cv=none; b=JQnFe64vg4Uz8ctoabCLogVc8bVylDDr6U4vR9JHslZ2Dz9TZkL7f6DUWMJh4bHqGUB4y8NaKgcvcPGj74vUiPYdYCUubQxdO+miU1vp3kNe2Qck9Oi/0MREFFxOzcW4UjqOFeLf4OF3wNz7JQN5V409GId35GYOucbpNmNKUyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787108418; c=relaxed/simple;
	bh=xPmnBPJ28zrY6uvYpdGY3wel6+VuX1OFUcFOxEaeTdU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=c7Ci3pRwz+OyZ2eyIldFK6JcV2W+KNvmQKj6Eti+aWkPaSBxYQyqWuOt07TdkX780UZe2W9zn0shn92FwErEFOJdqn1zGBR1ZxHIUQW279iwGYY8v1mgSDxYQKGjOpJvMC3c8RGdo7sFf4dyy0EU1mRV9g+JLIdWnkawWY6yzmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F8MdRUmZ; arc=none smtp.client-ip=95.215.58.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F8MdRUmZ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xPmnBPJ28zrY6uvYpdGY3wel6+VuX1OFUcFOxEaeTdU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787108413; v=1; x=1787713213;
 b=F8MdRUmZC8v4mx9zU/ExpMgxZWjgn/2JB4G+w534apYpqubjDJ9+M200HPU64H/iC5sgqUsr
 aVK4Jhk2S9GAl9y5XJlg8KPKXU/Csckd2S2M7fSVyv5Nmaa8sdznULH0N5Xo+++UhzvjJEtvy3y
 oAH+Hw3136hvXtK1uayD+uhY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.110.173] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id a0a07108882060cb;
	Wed, 19 Aug 2026 03:00:13 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>
Date: Wed, 19 Aug 2026 11:00:09 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
To: Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev> <aoQNtIRvqXRh-x4u@tiehlicka>
 <aoRz72_zdMai_RNV@linux.dev> <aoSLxSBUPbEqimJq@tiehlicka>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <aoSLxSBUPbEqimJq@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, Michal, Shakeel

在 2026/8/19 00:43, Michal Hocko 写道:
> On Tue 18-08-26 08:06:22, Shakeel Butt wrote:
>> On Tue, Aug 18, 2026 at 09:45:56AM +0200, Michal Hocko wrote:
>>> On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
>>>> On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
>>>>> From: Tao Cui <cuitao@kylinos.cn>
>>>>>
>>>>> memparse() consumes no characters on an empty input and leaves the
>>>>> end pointer at the terminating NUL.  The only validation in
>>>>> page_counter_memparse() checks for trailing characters, so an empty
>>>>> input slips through and the limit becomes 0.
>>>>>
>>>>> All limit write callbacks of the memory controller strstrip() the
>>>>> input before calling this helper, so a script that writes an unset
>>>>> variable hits this path:
>>>>>
>>>>>   LIMIT=
>>>>>   echo "$LIMIT" > $CG/memory.max
>>>>>   echo $?
>>>>>   0
>>>>>   cat $CG/memory.max
>>>>>   0
>>>>>
>>>>> Nothing reports the mistake: the limit is now 0 and the OOM killer
>>>>> goes after every task in the cgroup.  The same happens for
>>>>> memory.min, memory.low, memory.high, memory.swap.high,
>>>>> memory.swap.max and memory.zswap.max, where 0 silently removes the
>>>>> protection or disables swap and zswap.
>>>>>
>>>>> Reject the input when no characters were consumed, which is the one
>>>>> case the trailing-character check cannot catch.
>>>>>
>>>>> Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
>>>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>>>>> ---
>>>>>  mm/page_counter.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/page_counter.c b/mm/page_counter.c
>>>>> index 661e0f2a5127..d14db705b04f 100644
>>>>> --- a/mm/page_counter.c
>>>>> +++ b/mm/page_counter.c
>>>>> @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
>>>>>  	}
>>>>>  
>>>>>  	bytes = memparse(buf, &end);
>>>>> -	if (*end != '\0')
>>>>> +	if (*end != '\0' || end == buf)
>>>>>  		return -EINVAL;
>>>>
>>>> I wonder if someone started depending on this behavior. In that case it is
>>>> better to return error instead of silently ignore, so we will hear complains
>>>> loudly. This looks good to me.
>>>
>>> This is backward incompatible change and I am wondering why should we
>>> even risk regression.
>>
>> Mainly I was wondering if this is intentional or unintentional. If this us
>> unintentional, can we fix it without anyone noticing?
> 
> My guess would be this was just omission. Those happen and over years we
> have learned that userspace is quite creative at using those.
> 
>> However if we are ok with this then let's make is formal and make this a
>> documented behavior. I don't have any strong opinion either way but I think you
>> are saying it safer to just assume this is intentional. Fine with me.
> 
> My main question is why should we even bother to change this in the
> first place? Is that reason stronger than a theoretical breakage of
> userspace that we might learn much later?

Since you asked "why bother", here's how I ran into it.

The patch actually came from a production incident rather than a code
audit.

A maintenance script on a cluster accidentally wrote an unset variable
into memory.max of a workload cgroup. The write succeeded, and the
workload in the cgroup was subsequently OOM-killed. There was no
indication that the successful write had caused it, so it took quite
some time to trace the OOMs back to that script.

When I checked the documentation, I noticed that the cpuset controller
explicitly documents the semantics of empty writes ("An empty value
indicates that the cgroup is using the same setting as the nearest
cgroup ancestor..."), while the memory controller documentation says
nothing about empty input.

I reproduced the same behavior in isolation on a Kubernetes cluster
(v1.29, cgroup v2, two-container pod, 384M pod limit):

  # LIMIT=
  # echo "$LIMIT" > $CG/memory.max
  # echo $?
  0

  m6demo   0/2     OOMKilled   0

  oom-kill: constraint=CONSTRAINT_MEMCG,
            oom_memcg=/kubepods.slice/.../kubepods-burstable-pod....slice
  Memory cgroup out of memory: Killed process 339529 (sleep) ...
            anon-rss:32kB, file-rss:452kB

The process selected by the OOM killer had less than 1 MB resident
under a 384M pod limit, but the empty write was accepted as 0,
immediately triggering a memcg OOM. From the caller's perspective, the
write simply succeeded.

One caveat is that kubelet reconciles the pod-level memory.max within
seconds, so the window is short there, although container-level files
are not reconciled.

So the patch came out of that incident and the documentation gap it
exposed. My thinking was that rejecting an empty input would make such
mistakes fail immediately instead of silently changing the limit to 0.

Whether that benefit outweighs the compatibility risk is not mine to
decide. If it doesn't, then documenting the current empty-write
behavior, similar to cpuset, would also address the ambiguity that led
me to investigate this in the first place.

Thanks,
Tao
