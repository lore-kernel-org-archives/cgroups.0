Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793708636;
	b=4grY8XwO2r/I5zZzuyfCGsU+p3Y+IQxuj0EX6ml/FFO2ITAVlps3lJOCJ3CQ5t0jvC6S
	 qsmE+YFo9JUH6pyo2CymY29zB+qCS84nlR7bnrwSPZ0bYmW+UhwI6mgP/Kd2XBhxbVWnN
	 Jpo4/S6aRxiuFKGYWcnQunKj6HQhfciB9TNKph2/e1GcRyJHos/D4HxXf8HJwYidCGFID
	 oMWhwhRkd3vYxiyDBbc7NTGYJoTeNY7+ZJ6iwqJp7JuXxtoOPlxuSsQnFkBwXCDxlr5wv
	 YOd4QCnPpC4VAROIw2eJ0nvji9p/7qdirJwa3RrkJVvQmKJJV4SCE7pPzmucbGkIcZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793708636;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=5+giExnZG9PbIRprmj3rcwLAC4uTyxxBQab4OXS7D6o=;
	b=DNT994N7sBJeXAsDbwDkTq5A4FGWjQ2XZo5hQWiakYbFSwi0c9aDeaigMdI+L3RziHAZ
	 pcA6tE+oktDx+PP9XtVt1H18d7i1kjADVzlN8pO09E4+e6eNGZAy51Azr94x/UR7hfLbo
	 gYsnzWKXCUc09rXwis3vpQXWi1OTvGQmlnnXsx1wZyxh8n8wr8FOl9aJxnwYTNhFbPCP6
	 ec9HUABh1bkd3CtbsZAGXbHhVosb/bgZMSFBlLp449dE9m9LpAw7owm0++gSTs1qrxQEp
	 MpJoEdjePYugCFOrJ9+vGiZBrStSWPuesCuTzc5Sf6ktNKyl7GuJWhULgc/C9M77CDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dbTCJdF2;
	arc=none smtp.remote-ip=91.218.175.143
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30AF606A324
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 12:23:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E30AF606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dbTCJdF2
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZCZPLAdU2GP8PtTvn35MB7p7rMmvQ15GA72KpLOK3eo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793708632; v=1; x=1794313432;
 b=dbTCJdF2uGcqzh37oFPtMCzkhAalFFRRJDdXJ3PFE5wouyD0ejuykduxUhTOFCxnMbQqANKp
 nlP4F/PNQVafFAM1T3CV9vFtgoIYVeJCBEZZiwrQe0Xfppf5goqSZKwXRYoVzz477MXUSzNJH49
 rlmPhYYvxKH+9ZumpGmTeFfs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e671a108ae62cf5d;
	Tue, 03 Nov 2026 12:23:52 +0000
X-Mizu-Trace-ID: e671a108ae62cf5d
X-Migadu-Flow: FLOW_OUT
Message-ID: <f5137dbb-b0ed-44ea-a23f-5c848315a68a@linux.dev>
Date: Tue, 3 Nov 2026 20:23:37 +0800
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
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev>
 <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
 <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
 <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/3/2026 6:00 PM, Barry Song wrote:
> On Tue, Nov 3, 2026 at 4:39 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 11/3/2026 2:48 PM, Barry Song wrote:
>>> On Tue, Nov 3, 2026 at 10:58 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>
>>>> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
>>>> youngest generation. There is currently no tracepoint on this path, so
>>>> the moment a new generation is created, and how the min_seq of each type
>>>> trails behind it, cannot be observed as it happens.
>>>
>>> We might be more interested in why aging is triggered rather
>>> than the exact moment when max_seq is advanced.
>>>
>>> With your patch, we get:
>>>
>>> ~ # cat /sys/kernel/tracing/trace | grep mglru_inc_max_seq
>>>              a.out-93      [001] d..1.   278.276539:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=4 anon_min_seq=2
>>> file_min_seq=1 nr_anon={0x0,0xf016,0x12,0x0}
>>> nr_file={0x1886,0xb,0x4c,0x0}
>>>            kswapd0-50      [000] d..1.   278.422400:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=5 anon_min_seq=2
>>> file_min_seq=2 nr_anon={0x5,0xccb6,0x3439,0x0}
>>> nr_file={0x4ae,0x4f,0x55,0x0}
>>>            kswapd0-50      [000] d..1.   278.508003:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=6 anon_min_seq=3
>>> file_min_seq=4 nr_anon={0xccb6,0x3d29,0x1,0x0}
>>> nr_file={0x0,0x59,0x7,0x0}
>>>            kswapd0-50      [000] d..1.   280.046056:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=7 anon_min_seq=4
>>> file_min_seq=5 nr_anon={0x3bf3,0xcbbd,0x23e,0x0}
>>> nr_file={0x0,0xb,0x1,0x0}
>>>            kswapd0-50      [000] d..1.   280.124876:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=8 anon_min_seq=5
>>> file_min_seq=6 nr_anon={0xcafd,0x3e31,0x0,0x0}
>>> nr_file={0x0,0x5,0x7,0x0}
>>>              a.out-96      [001] d..1.   290.629014:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=9 anon_min_seq=7
>>> file_min_seq=6 nr_anon={0x0,0x10615,0xb,0x0}
>>> nr_file={0x331,0xb,0x9a,0x0}
>>>            kswapd0-50      [000] d..1.   290.653098:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=10 anon_min_seq=7
>>> file_min_seq=7 nr_anon={0x15,0xef23,0x18c4,0x0}
>>> nr_file={0xb,0xb8,0x55,0x0}
>>>              a.out-96      [001] d..1.   290.684875:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=11 anon_min_seq=8
>>> file_min_seq=9 nr_anon={0xeee3,0x1afb,0x2,0x0}
>>> nr_file={0x0,0x76,0x4,0x0}
>>>
>>> You can see that the youngest generation is always zero,
>>> because you're just getting the newly added youngest
>>> generation :-)
>>>
>>
>> Hi Barry,
>>
>> Thank you very much for testing and reviewing.
>>
>>> This somehow suggests that the information is redundant, as
>>> there is always a zero there.
>>>
>>> I suspect we'll need an additional tracepoint to show why
>>> aging is triggered and at what sc->priority it happens.
>>>
>>> But do you know why you trace the moment just after aging
>>> is completed, rather than the reason why aging is needed?
>>>
>> My original goal was to pair it with mm_mglru_scan_folios, to see how
>> the aging window of each memcg moves. The per-generation anon/file
>> nr_pages were added following your suggestion on v1. I put it at the
>> end of inc_max_seq() because of the restart there, as max_seq and
>> min_seq are only final after that.
> 
> The per-generation anon/file nr_pages are perfectly good, as
> they can also help explain why aging is needed, especially
> now that we're introducing new code for imbalance-based
> aging.
> 
>>
>> You make a very good point that the reason for aging is also
>> important. So I'd like to discuss which way is better:
>>
>> 1) Keep mm_mglru_inc_max_seq, and add another tracepoint at the aging
>>    decision in try_to_shrink_lruvec(), reporting why aging is needed
>>    and at what sc->priority.
>>
>> 2) Replace mm_mglru_inc_max_seq with a single tracepoint in
>>    try_to_shrink_lruvec(), right before try_to_inc_max_seq(), reporting
>>    the reason, sc->priority, swappiness, max_seq/min_seq and the
>>    per-generation nr_pages before aging. The youngest generation is
>>    not empty at that point, and the new window after aging can still
>>    be seen from the following mm_mglru_scan_folios.
>>
>> Which one do you prefer?
> 
> Maybe we should keep option 2 for now. Understanding why
> we are aging and at what priority is much more important,
> especially since we're still introducing some
> imbalance-based aging code.
> 
> It should be quite simple, just a matter of moving the code
> around a little.
> 
> If we later find a good reason to have option 1, we can
> always add it, right?
> 

Hi Barry,

Agreed, I'll go with option 2. Two things I'd like to confirm first:

1) To report the reason, should_run_aging() would need to return it
  instead of a bool, e.g. an enum like:

   enum lru_gen_aging_reason {
	AGING_NONE,
	AGING_NO_EVICTABLE,     /* eviction is not possible anymore */
	AGING_MIN_GENS,		/* better to age, eviction still possible */
   };
	
Or just report sc->priority, swappiness, max_seq/min_seq and the
per-generation nr_pages, and let users derive the reason from them?
The former is more direct, the latter keeps should_run_aging()
unchanged.

2) try_to_shrink_lruvec() has changed quite a lot recently, e.g.
Kairui's reclaim loop rework, and your swappiness series also touches it, 
including the aging part. Is it stable enough now to carry a tracepoint there?

-- 
Best regards
Ridong

