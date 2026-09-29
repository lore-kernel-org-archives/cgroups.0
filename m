Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6C4321445
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 01:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790644995; cv=none; b=BGdIuD38zJT1n5dyKivYxYRGgOR+WHBoPSR6kkGXNmIpGjfMJRzl1ky6sbLhQimXMao3p8/KoFyF2Q9QFGslJzlDEZFDRg2N6hLDXRxDEUS4lP4zHy4AIKT+pCOIxaIuVoKgf3dHp0hDca0hgbnWLgizX8pj/DoV6BXar2veB48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790644995; c=relaxed/simple;
	bh=XyITaakx/9RJUoMK2YKO6mwBOUANECL8e5bCzpNLG+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BNcihLocmY76yXXmEvNV5Dck0Mw+2ySAD34Q4BkWvNlbL6ad6RiCCfe76/PxmaxfCsaaPHBRKQwmhP364jQrIsfbQGllLyucVjHQRrh5jaKWGGtS+kl9D/ZyNnsGhWZivshqIW5vxEZbRyLe6221fa6f2q42pUd7adiqXR60N9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lpzghxEc; arc=none smtp.client-ip=95.215.58.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lpzghxEc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XyITaakx/9RJUoMK2YKO6mwBOUANECL8e5bCzpNLG+Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790644992; v=1; x=1791249792;
 b=lpzghxEcAc61Mq0M3jbMVIPTQLZI/unrfekJIP1XM+D4PdhLn0PEdgyN0JpBos9yMQYWnz4I
 mrJr1QSSVt3lSwTHUrVmC9Tpj0RCiYBdG3n6ocN6tb2LMiUFeDr+LjyBP+5r54Kyp+zERK0/yEo
 52sGTKUqR5tsaoDHJJlL3OSk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 20ec7aca34141e9c;
	Tue, 29 Sep 2026 01:23:11 +0000
X-Mizu-Trace-ID: 20ec7aca34141e9c
X-Migadu-Flow: FLOW_OUT
Message-ID: <9bd4bf8e-c159-400d-abd1-d6084bf94148@linux.dev>
Date: Tue, 29 Sep 2026 09:23:00 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 1/7] mm/memcontrol: drop unused vmscan tracepoint
 include
To: Muchun Song <muchun.song@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, Ridong Chen <chenridong@xiaomi.com>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
 <20260928114625.3609130-2-ridong.chen@linux.dev>
 <FFCBD11C-B723-441A-B6ED-6AD6E59648E7@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <FFCBD11C-B723-441A-B6ED-6AD6E59648E7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/28/2026 8:08 PM, Muchun Song wrote:
> 
> 
>> On Sep 28, 2026, at 19:46, Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> memcontrol.c includes <trace/events/vmscan.h> but does not use any of
>> the tracepoints or macros it defines: all tracepoints invoked here come
>> from memcg.h and writeback.h.  Removing the include still compiles
>> cleanly.
>>
>> Assisted-by: Claude:claude-opus-4-8
> 
> Since commit 816d9992d9ed, the label we recommend is Assisted-by: LLM.
> 

Thank you for the reminder; I will update it in the next version.


>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>> mm/memcontrol.c | 2 --
>> 1 file changed, 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index aad0498a7bd6..95c2322d4a6f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -77,8 +77,6 @@
>> #include <trace/events/memcg.h>
>> #undef CREATE_TRACE_POINTS
>>
>> -#include <trace/events/vmscan.h>
>> -
>> struct cgroup_subsys memory_cgrp_subsys __read_mostly;
>> EXPORT_SYMBOL(memory_cgrp_subsys);
> 
> Acked-by: Muchun Song <muchun.song@linux.dev>
> 
> Thanks.

-- 
Best regards
Ridong

