From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 3/3] mm/memcg: Unify swap and memsw page counters
Date: Mon, 24 Aug 2020 12:02:48 -0400
Message-ID: <18d02675-0c2a-bfc3-6953-42dcd10396b1@redhat.com>
References: <20200820130350.3211-1-longman@redhat.com>
 <20200820130350.3211-4-longman@redhat.com>
 <CALvZod7cNkjgd_YWzPSFm=AeC8sy5kWspX3J_Q7237Q9+N5Pxw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598284975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GOOvGMjNbf5XtLNCKd9ysNRuyAgV0fQgbTvlhMQq8xI=;
        b=DhR4iTc47y+ZBv2Yb0yNRGx26eVpZAbahIMo1FqqP+1ecPzgzFs/MSxB5P+m+doz4kk75H
        jbrK++sBKQtgLrlvTXKrkvmm7yOLfcEmAxOtRGyetmzgCjhPWDgBAaoDTCCN+b4WDC6dqL
        Za5fT+WODCbKQumsb6sY4ZjqcfyQdrk=
In-Reply-To: <CALvZod7cNkjgd_YWzPSFm=AeC8sy5kWspX3J_Q7237Q9+N5Pxw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Chris Down <chris@chrisdown.name>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>

On 8/20/20 11:46 AM, Shakeel Butt wrote:
> On Thu, Aug 20, 2020 at 6:04 AM Waiman Long <longman@redhat.com> wrote:
>> The swap page counter is v2 only while memsw is v1 only. As v1 and v2
>> controllers cannot be active at the same time, there is no point to keep
>> both swap and memsw page counters in mem_cgroup. The previous patch has
>> made sure that memsw page counter is updated and accessed only when in
>> v1 code paths. So it is now safe to alias the v1 memsw page counter to v2
>> swap page counter. This saves 14 long's in the size of mem_cgroup. This
>> is a saving of 112 bytes for 64-bit archs.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   include/linux/memcontrol.h | 3 +--
>>   mm/memcontrol.c            | 8 +++++---
>>   2 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index d0b036123c6a..d2a819d7db70 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -216,10 +216,9 @@ struct mem_cgroup {
>>
>>          /* Accounted resources */
>>          struct page_counter memory;
>> -       struct page_counter swap;
>> +       struct page_counter swap;       /* memsw (memory+swap) for v1 */
>>
>>          /* Legacy consumer-oriented counters */
>> -       struct page_counter memsw;
>>          struct page_counter kmem;
>>          struct page_counter tcpmem;
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index d219dca5239f..04c3794cdc98 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -68,6 +68,11 @@
>>
>>   #include <trace/events/vmscan.h>
>>
>> +/*
>> + * The v1 memsw page counter is aliased to the v2 swap page counter.
>> + */
>> +#define memsw  swap
>> +
> Personally I would prefer a union instead of #define.

Yes, that is also what I am thinking about in the v2.

Cheers,
Longman


