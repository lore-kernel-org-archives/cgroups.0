Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624600;
	b=iixImQaJ3mGWM3aqL6aXqy/azy6yNmms5CWb4oGgdQXf5t2qwMuBR+sZ1VyJlb2wM+lY
	 OK5gyOxboe+Bh9K8p35i+r1H0M1o/homS0MNo6hRj6T0PIItOcx/ZElshQ8/+SuNTsalX
	 4DrGq79BjDp6If07yEIQOsgyOCoCe/HBXZde42znEf7pSTxOi//Dsj5tpHjhE/FD0sX4V
	 P5hGENcl3srMiIROAqGRyQJsGtJUoQmf0/t8E8P1tbgGu0Q9a+/OMY4Bba77AhI5EtOq6
	 x5n9souL8Etynl+D+okd56z4dNoQmxr1TjJrGMUeZ8jBUB/Qbet7vc7WkGqmpaVKrpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624600;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FXUqkUNHxYE2NGpJQs5al5RvPwIjMfRnSOyTuQqz9ps=;
	b=RezTW8gFX8MIb7GCFCycDq5b9OIktCGfipvPGhJd3k6Qye0Q3SHI9TTBticLQ8EK5qRW
	 nnNbiEXabLZjL00RRv03fimboqUhHdFtiA2cZlwntUPWmWyEZjaLX9X1MCsZL44qQm1tc
	 nLSxOBMHk/UbtjD0vVjTkqubKnF8a7CQKVJNrhjVRjBJf3YK8V+coMQdchTxGkkU2KtmN
	 xrlJinUSArgs4f/hf586bbM5ArRFBhqSzTJGWR3B6j0H0DRFKrN8mIffZtI9NVdu2TRs2
	 TIXUG/dfHhaS7bWOBe0BbBNOxgLerBxXG5s6rEfvbM6DPFZzQ4wFQZ4URrdJkivr7wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GqIPqxUf;
	arc=none smtp.remote-ip=91.218.175.62
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A64F60A261E
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 13:03:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A64F60A261E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GqIPqxUf
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ReST3cWLqWrD/t1sA1J8bJ67KuQOqTddHpAzRisO018=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624592; v=1; x=1794229392;
 b=GqIPqxUfLfW7mSUNjHodoC2JNe5t6hFUMQgYL22fCM2tZQyOnaGgGP3RC6UReR655Qj/SKsD
 BzAoJI75o5CvVAA+tJBk0Lsb5rKxw5yZXAmUpWosbPLWvracM6vQOrbqjbAh8DiGzvDD6gHZxRS
 ZS2fMbo2RVsmx5OnsnjK8eNA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2247600f0cc60053;
	Mon, 02 Nov 2026 13:03:12 +0000
X-Mizu-Trace-ID: 2247600f0cc60053
X-Migadu-Flow: FLOW_OUT
Message-ID: <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
Date: Mon, 2 Nov 2026 21:03:05 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
To: Roman Gushchin <roman.gushchin@linux.dev>
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
 <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Roman,

在 2026/10/30 14:05, Roman Gushchin 写道:
> I believe we want to delete this code sooner than later, why would we rewrite it before that?
> 

My assumption was that v1 would still be maintained for some time
before its eventual removal, and the goal was to reduce the coupling
between the remaining v1 code and the shared core structures during
that period, rather than to rewrite the implementation for its own
sake.

If the expectation is that the remaining v1 implementation will be
removed in the near future, then I agree this work becomes much harder
to justify.

Am I being too optimistic about how long the remaining v1 code is
expected to stay around?

Thanks,
Tao

>> On Oct 29, 2026, at 10:40 PM, Tao Cui <cui.tao@linux.dev> wrote:
>>
>> ﻿Hi Johannes, Shakeel, Michal,
>>
>>> 在 2026/9/19 00:24, Johannes Weiner 写道:
>>>> On Fri, Sep 18, 2026 at 11:41:09AM +0200, Michal Hocko wrote:
>>>> On Thu 17-09-26 13:26:40, Shakeel Butt wrote:
>>>>> On Wed, Sep 16, 2026 at 08:57:34PM +0800, Tao Cui wrote:
>>>>>> From: Tao Cui <cuitao@kylinos.cn>
>>>>>>
>>>>>> The legacy cgroup v1 memory controller has already been moved out of
>>>>>> the shared implementation at the file level (mm/memcontrol-v1.c) and at
>>>>>> the Kconfig level (CONFIG_MEMCG_V1, default n since 6.11).  Its
>>>>>> per-cgroup state, however, still sits as individual members inside
>>>>>> struct mem_cgroup, guarded by #ifdefs.
>>>>>>
>>>>>> This series isolates the deprecated implementation from the shared hot
>>>>>> structure: all v1-only members are grouped into a dedicated
>>>>>> struct mem_cgroup_v1, and every access goes through memcg->v1.X.
>>>>>>
>>>>>> With this in place the v1 implementation is self-contained: its
>>>>>> interface in mm/memcontrol-v1.c, its state in struct mem_cgroup_v1, and
>>>>>> its eventual removal becomes a localized deletion of this struct
>>>>>> together with mm/memcontrol-v1.c, instead of unwinding
>>>>>> ifdef-scattered members across the shared header.
>>>>>
>>>>> Sorry I don't see any benefit of this code churn. The code is already behind
>>>>> config. What exactly this code churn is giving us?
>>>>
>>>> The only arguable upside is that this would make it ever so slightly
>>>> easier to track v1 specific stuff (once that s@v1@memcg1@ or similar).
>>>
>>> I had the same thought. It's kiiind of nice to see which members are
>>> completely specific to memcg1.
>>>
>>>> I am not convinced this is sufficient to justify the churn either.
>>>
>>> IMO it helps that it's mostly in memcontrol-v1.c where the chances of
>>> interfering with other work are pretty slim.
>>>
>>> The patch 1 + patch 2 split is a bit bothersome: indenting everything
>>> into a union, only to then move it out in the next patch.
>>>
>>> Tao, if you folded these two patches to make it one clean extraction
>>> and changed over the sites at the same time, I would probably lean
>>> supportive on this.
>>
>> Sorry for the late reply.
>>
>> Thanks for the feedback.  Looking back, I think Johannes' point about
>> the patch split is fair.  I split the first two patches to keep the
>> initial step semantically neutral, but it also made the series look
>> like churn for the sake of churn.
>>
>> I'll fold the first two patches into a single extraction in the next
>> revision.  That should present the change more directly and hopefully
>> make it easier to judge whether the resulting boundary is worthwhile.
>>
>> Thanks,
>> Tao
>>
>>

