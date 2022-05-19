From: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Thu, 19 May 2022 15:11:41 +0530
Message-ID: <875ym1hnai.fsf@vajain21.in.ibm.com>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <20220519050835.ebpiukexgiys6t57@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=OJteXu18Mv+sn23pdhZQcdzdXFdGcyM9JOV5loEpHpk=;
 b=E9lrofY1GFhlXL1u+ccKtgGozb6tczzv0sXWdh/8z6/sni2D8WKZRbk+0xxqC6PREdA5
 hKqVML5YJKrLG+zKyTMibSol3ByZI1nr4W12Pfpv6NnaooTQSXZ7dF6xvrvlXpS73iJR
 yB++dUCc/JPs3iAxZ9WsW20lk3vXBXN2RyBWC8ZvNOZfs2pu/Y2gkQWl0MmJqVDr0zky
 R8zvAb7CQd86cowK+wiiBgzSRN/vyM4A6BLducb3c8++bD/wnICsW0mlNF2c+nMJtJ/d
 brGN+fNw25c1SWpEMLnCpJE4x2ckWxqRb5yJ0ItgxH+ZijcSntbNSLCueXr8TGnlM9nQ jg== 
In-Reply-To: <20220519050835.ebpiukexgiys6t57@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Yosry Ahmed <yosryahmed@google.com>

Hi,

Thanks for looking into this patch,

Shakeel Butt <shakeelb@google.com> writes:

> On Thu, May 19, 2022 at 04:08:15AM +0530, Vaibhav Jain wrote:
>> [1] Provides a way for user-space to trigger proactive reclaim by introducing
>> a write-only memcg file 'memory.reclaim'. However reclaim stats like number
>> of pages scanned and reclaimed is still not directly available to the
>> user-space.
>> 
>> This patch proposes to extend [1] to make the memcg file 'memory.reclaim'
>> readable which returns the number of pages scanned / reclaimed during the
>> reclaim process from 'struct vmpressure' associated with each memcg. This should
>> let user-space asses how successful proactive reclaim triggered from memcg
>> 'memory.reclaim' was ?
>> 
>> With the patch following command flow is expected:
>> 
>>  # echo "1M" > memory.reclaim
>> 
>>  # cat memory.reclaim
>>    scanned 76
>>    reclaimed 32
>> 
>
> Yosry already mentioned the race issue with the implementation and I
> would prefer we don't create any new dependency on vmpressure which I
> think we should deprecate.
Ok,

>
> Anyways my question is how are you planning to use these metrics i.e.
> scanned & reclaimed? I wonder if the data you are interested in can be
> extracted without a stable interface. Have you tried BPF way to get
> these metrics? We already have a tracepoint in vmscan tracing the
> scanned and reclaimed. 
>
Agree that there are enough static trace_mm_vmscan_ tracepoints in
vmscan to get that info.

Also agree that exposing nr_scanned/nr_reclaimed directly to userspace may not
be a good idea but knowing the amount of memory reclaimed might be
useful.

With user-space triggered proactive reclaim user-space code can try to
write a certain value to "memory.reclaim" in a loop till it returns
'-EBUSY'.

Right now there is no direct way for it to get feedback on the progress
of the requested reclaim. Providing a stable interface to ascertain the
progress of reclaim lets that userspace provide smaller values for
proactive reclaim 

-- 
Cheers
~ Vaibhav
