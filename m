Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F89A25B098
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 02:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792378098; cv=none; b=OZoZ2TmXH98eagmu8RqmYsO5VT9evsjxvwoXgoFNraAjhPablFZ3N3vNh6YXCa8JIP/zChAXq8j0pG3RAZ9l2o4umv/uT3Lt/REYJzsQfTmzBpeL7R8PedlPltbzc0bchn9+sPDYh04l4hjgm0UjF8TrY4WhxJxMX3TzlO5sCzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792378098; c=relaxed/simple;
	bh=uJd85rqKa3hx2YcUCQnwN6zrGg8MtC8mCup4hf7dmx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pnkhPoYlYbd3Zuvk+uyGw7rS4LVdtQKYk4iT6n5A9/Olt5z4LTtIXj026QAjixP9amCT5lx7jfcq9ZoD5WhMdznxS8KS8BKg/2l2ZVP1Sg6xG3xBOQlgZFoe0bhZAuICYDMQi5KmMcGOjO4t+e/Kmot6zrynfQ97juxbEEL8GoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DpsqdlHq; arc=none smtp.client-ip=95.215.58.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DpsqdlHq"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uJd85rqKa3hx2YcUCQnwN6zrGg8MtC8mCup4hf7dmx0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792378094; v=1; x=1792982894;
 b=DpsqdlHqh57TOQVudIzSXAdrXDkcT/txgvanrBVID2zfgCU4OWXnyxk1y3aNrelR/Wrvmsrt
 YXipXfJW1yjA6HnuJrTeFY2F7ODIBeX51BsDaXpt3frFu7HM+oF+FZzA6AN6MubNUJSCjtHNVXG
 hSnaGDRs5SLRcBpOu+0R2tH0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b000c8b95270aa37;
	Mon, 19 Oct 2026 02:48:13 +0000
X-Mizu-Trace-ID: b000c8b95270aa37
X-Migadu-Flow: FLOW_OUT
Message-ID: <ff8c13d1-371d-4da6-95fc-9fd13adddb56@linux.dev>
Date: Mon, 19 Oct 2026 10:48:05 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/7] mm/vmscan: move vmscan tracepoints to a local
 header
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>,
 "open list:BPF [MISC] :Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
 <20261013131309.2790253-3-ridong.chen@linux.dev>
 <20261014124914.21c21559@gandalf.local.home>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261014124914.21c21559@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/15/2026 12:49 AM, Steven Rostedt wrote:
> On Tue, 13 Oct 2026 21:13:04 +0800
> Ridong Chen <ridong.chen@linux.dev> wrote:
> 
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
>> tracepoints can be extended to reference vmscan-internal structures such
>> as struct scan_control, which is not visible outside mm/.  This mirrors
>> what several other subsystems already do with their trace headers (e.g.
>> arch/x86/kvm/trace.h, drivers/gpu/drm/drm_trace.h, net/xfrm/trace_iptfs.h).
>> As they do, use a relative TRACE_INCLUDE_PATH so that no Makefile change
>> is needed.
>>
>> No functional change.
>>
>> Assisted-by: LLM
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   MAINTAINERS                                        | 2 ++
>>   mm/shrinker.c                                      | 2 +-
>>   include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
>>   mm/vmscan.c                                        | 2 +-
>>   4 files changed, 8 insertions(+), 2 deletions(-)
>>   rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index c5519d67b6f4..80d2a9dd0525 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17575,6 +17575,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>>   F:	Documentation/mm/multigen_lru.rst
>>   F:	include/linux/mm_inline.h
>>   F:	include/linux/mmzone.h
>> +F:	mm/trace_vmscan.h
>>   F:	mm/vmscan.c
>>   F:	mm/workingset.c
>>   
>> @@ -17722,6 +17723,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>>   R:	Lorenzo Stoakes <ljs@kernel.org>
>>   L:	linux-mm@kvack.org
>>   S:	Maintained
>> +F:	mm/trace_vmscan.h
>>   F:	mm/vmscan.c
>>   F:	mm/workingset.c
>>   
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 7ec2a9704f6f..3c3e87c4b61c 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -3,7 +3,7 @@
>>   #include <linux/rwsem.h>
>>   #include <linux/shrinker.h>
>>   #include <linux/rculist.h>
>> -#include <trace/events/vmscan.h>
>> +#include "trace_vmscan.h"
>>   
>>   #include "internal.h"
>>   
>> diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
>> similarity index 99%
>> rename from include/trace/events/vmscan.h
>> rename to mm/trace_vmscan.h
>> index 8a872990b4be..c5d824fef554 100644
>> --- a/include/trace/events/vmscan.h
>> +++ b/mm/trace_vmscan.h
>> @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>>   #endif /* _TRACE_VMSCAN_H */
>>   
>>   /* This part must be outside protection */
>> +#undef TRACE_INCLUDE_FILE
>> +#undef TRACE_INCLUDE_PATH
>> +#define TRACE_INCLUDE_PATH ../../mm
> 
> The proper way to do this is to have:
> 
> #define TRACE_INCLUDE_PATH .
> 
> And update the Makefile with:
> 
> CFLAGS_vmscan.o := -I$(src)
> 
> -- Steve
> 

Thank you. Will update.

> 
> 
>> +#define TRACE_INCLUDE_FILE trace_vmscan
>>   #include <trace/define_trace.h>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 29b31446fc11..6207dad9e644 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -71,7 +71,7 @@
>>   #include "swap.h"
>>   
>>   #define CREATE_TRACE_POINTS
>> -#include <trace/events/vmscan.h>
>> +#include "trace_vmscan.h"
>>   
>>   struct scan_control {
>>   	/* How many pages shrink_list() should reclaim */
> 

-- 
Best regards
Ridong

