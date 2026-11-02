Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793616376;
	b=TLrTVW4zvF81ha9mi8AVgz2H7Ym0a97dJihlRaQKL1jDXtOOUnVNYJA0h61IczINssIR
	 mlwq30gdsYoAZx7Q6OI3POT51HGJ+YWHEzF0w3P/JjoZr1IgjGu+DLLhJ2E5a87YXQLZC
	 hJmiPiugHLgWE63e2RQlbbX8ann567HmPkiVvdTzDnjqHhjt/EndfowyoEyB4p1pE5fm7
	 BhlIJ/TYlMAXIDnn+SWMTKQRIrlzB/xmQdCzk5HzVE/gDs0pJNipWrjxGQP89goDqazSc
	 70CzXAz1352Pk/UJVYO46uDQtILi2cszvsMNlepSlG5silzhXkoiC7CGMjSXavzhuAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793616376;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=lxWH9yX4Vl4mKtXKvGkvQaa05rH5ZKTvpkSa847Tggg=;
	b=qv6il/gVqCldsg/yVbQ+IoJ3+uBqW8qnb2bm6d/qY/gPPruL0Yg0wyI4cipsLgirgKyi
	 JrHdAN2mhdyVc9bry7U215uOUZAguQUJ2JF0lJEJq1oRmbl+xscs8G+s3j02ChT62RcFP
	 DFqQZsOnvvNN5ux+U9jDCzv4CZv+EMjEpsglnDxCaTcv/CQO1XtkmU84cmaOZmWTMnL8P
	 lKf4zSLSQUHQznstPxSbo50m8Z20pSapse/VyCXmxo76ucqE8+eeMPpokdhkRV83e4IA7
	 n3irrmglGO1lQJWbicmLMArrZO5s/VF2OM2pt/q0qIbBPiYtAuwjRCto1lavaImU+7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QYtjFkK8;
	arc=none smtp.remote-ip=91.218.175.58
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E2960A2601
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 10:46:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86E2960A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QYtjFkK8
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JxbpZPWbvfuRPXcn2jrt5kFSz35KdLS4+oLLTN6f2mY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793616373; v=1; x=1794221173;
 b=QYtjFkK8hdk8uOiuA9MT2L7rULzj6PvZ/woEcPBaMxFOK9IyGKXj46if9X4hA8tRUNGFiCjg
 C7HPhZDSQMLBvF21fWEp+ecXXpS1KL5mc/FMg6wEgebAVov0Exmd0UzZGDodA18lK0sjro9d8Eg
 Qor1mDKFyw2GLZhqJ7x4CPwc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 92e7062bea360beb;
	Mon, 02 Nov 2026 10:46:13 +0000
X-Mizu-Trace-ID: 92e7062bea360beb
X-Migadu-Flow: FLOW_OUT
Message-ID: <2f272a9b-ea83-4157-8968-0081990cb709@linux.dev>
Date: Mon, 2 Nov 2026 18:46:00 +0800
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
Subject: Re: [PATCH v5 2/6] mm/vmscan: move vmscan tracepoints to a local
 header
To: Baoquan He <baoquan.he@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-3-ridong.chen@linux.dev> <aufpQS0XL-CD9YW_@bogon>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aufpQS0XL-CD9YW_@bogon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/2/2026 9:37 AM, Baoquan He wrote:
> On 10/31/26 at 05:00pm, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
>> tracepoints can be extended to reference vmscan-internal structures such
>> as struct scan_control, which is not visible outside mm/.  This mirrors
>> what several other subsystems already do with their trace headers (e.g.
>> fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
>> do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
>> vmscan.o, the only user that defines CREATE_TRACE_POINTS.
>>
>> No functional change.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> Reviewed-by: Barry Song <baohua@kernel.org>
>> ---
>>   MAINTAINERS                                        | 2 ++
>>   mm/Makefile                                        | 1 +
>>   mm/shrinker.c                                      | 2 +-
>>   include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
>>   mm/vmscan.c                                        | 2 +-
>>   5 files changed, 9 insertions(+), 2 deletions(-)
>>   rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index aaf2825ac945..2ad01107fa05 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17653,6 +17653,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>>   F:	Documentation/mm/multigen_lru.rst
>>   F:	include/linux/mm_inline.h
>>   F:	include/linux/mmzone.h
>> +F:	mm/trace_vmscan.h
>>   F:	mm/vmscan.c
>>   F:	mm/workingset.c
>>   
>> @@ -17802,6 +17803,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>>   R:	Lorenzo Stoakes <ljs@kernel.org>
>>   L:	linux-mm@kvack.org
>>   S:	Maintained
>> +F:	mm/trace_vmscan.h
>>   F:	mm/vmscan.c
>>   F:	mm/workingset.c
>>   
>> diff --git a/mm/Makefile b/mm/Makefile
>> index 2a3ec53d62ee..277b97f7f8d7 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -32,6 +32,7 @@ KCOV_INSTRUMENT_vmstat.o := n
>>   KCOV_INSTRUMENT_failslab.o := n
>>   
>>   CFLAGS_init-mm.o += -Wno-override-init
>> +CFLAGS_vmscan.o += -I$(src)
> 
> One nit:
> 
> Does it really need the above line? It affects mm/shrinker.c too, did your
> shrinker.o building fail?
> 
> Seems it's redundant because kbuild adds -I$(src) -I$(obj) for every object
> in the directory since commit cdd750bfb1f7 ("kbuild: remove 'addtree' and
> 'flags' magic for header search paths"). Please correct me if I am
> wrong.
> 

Hi Baoquan,

Thanks for the review.

The line is needed for vmscan.o, and mm/shrinker.c is fine without it,
because the two files include trace_vmscan.h in different ways.

mm/shrinker.c only does a plain #include "trace_vmscan.h". The lookup
starts from mm/, where the header lives, so no -I is needed.

mm/vmscan.c defines CREATE_TRACE_POINTS before including the header.
In that case <trace/define_trace.h>, included at the end of
trace_vmscan.h, includes the header again to generate the tracepoint
definitions:

#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)  /* -> "./trace_vmscan.h" */

This #include is in include/trace/define_trace.h, so the lookup starts
from include/trace/ and only finds the header through -I. Without the
flag, vmscan.o fails to build:

./include/trace/define_trace.h:118:42: fatal error: ./trace_vmscan.h: No such 
file or directory

As for cdd750bfb1f7, it doesn't add -I$(src) for every build. kbuild
only adds -I$(src) -I$(obj) automatically when building with O=
(see "ifdef building_out_of_srctree" in scripts/Makefile.lib). So
with O= the line is indeed redundant and vmscan.o builds fine without
it, but a plain in-tree "make" fails with the error above. The
explicit flag keeps both working.

To be honest, I had the same worry at first: I thought every .c file
that includes the header would need a Makefile change. That's why v3
used a relative TRACE_INCLUDE_PATH (../../mm) instead. Steven corrected
me and pointed out that the proper way is TRACE_INCLUDE_PATH "." plus
-I$(src) for the one object that defines CREATE_TRACE_POINTS [1]. That
turned out to need only this one line. Thanks again to Steven for
that.

[1] https://lore.kernel.org/all/20261014124914.21c21559@gandalf.local.home/


> Other than the nit, this patch looks good to me,
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> 
> Thanks.
>>   
>>   mmu-y			:= nommu.o
>>   mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 4fb424e721bc..4fbdade6d2f6 100644
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
>> index 8a872990b4be..ad90f0e9bf2e 100644
>> --- a/include/trace/events/vmscan.h
>> +++ b/mm/trace_vmscan.h
>> @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>>   #endif /* _TRACE_VMSCAN_H */
>>   
>>   /* This part must be outside protection */
>> +#undef TRACE_INCLUDE_FILE
>> +#undef TRACE_INCLUDE_PATH
>> +#define TRACE_INCLUDE_PATH .
>> +#define TRACE_INCLUDE_FILE trace_vmscan
>>   #include <trace/define_trace.h>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 9959ca158ce8..79d2d614afd0 100644
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
>> -- 
>> 2.43.0
>>

-- 
Best regards
Ridong

