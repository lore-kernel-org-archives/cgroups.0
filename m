From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 15:30:02 -0400
Message-ID: <b11ce701-e824-793c-cc7f-4c3bbe08cf80@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092737.GA148695@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597779011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TzOEgoxnjJc+44XQtv3kAPBEJXFL3VlSz++wwm59Khc=;
        b=bQZrn8stH9h3pMfBCJVUXeTQnSdzdkfWOcXZo73QR9MsSPF5UZfMBOxXC6dGXZ/4wuPKx5
        ipUUwtKSgh5JJ5u0aPZn85IohTCf9cOI2LNktbTLgO+fM97MsgDzDThMVczURFaQ8RYMHB
        KnAPmWo9VUV1025q6meM9xnQ7kH5dbw=
In-Reply-To: <20200818092737.GA148695@chrisdown.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chris Down <chris@chrisdown.name>, peterz@infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On 8/18/20 5:27 AM, Chris Down wrote:
> peterz@infradead.org writes:
>> On Mon, Aug 17, 2020 at 10:08:23AM -0400, Waiman Long wrote:
>>> Memory controller can be used to control and limit the amount of
>>> physical memory used by a task. When a limit is set in "memory.high" in
>>> a v2 non-root memory cgroup, the memory controller will try to reclaim
>>> memory if the limit has been exceeded. Normally, that will be enough
>>> to keep the physical memory consumption of tasks in the memory cgroup
>>> to be around or below the "memory.high" limit.
>>>
>>> Sometimes, memory reclaim may not be able to recover memory in a rate
>>> that can catch up to the physical memory allocation rate. In this case,
>>> the physical memory consumption will keep on increasing.
>>
>> Then slow down the allocator? That's what we do for dirty pages too, we
>> slow down the dirtier when we run against the limits.
>
> We already do that since v5.4. I'm wondering whether Waiman's customer 
> is just running with a too-old kernel without 0e4b01df865 ("mm, memcg: 
> throttle allocators when failing reclaim over memory.high") backported.
>
The fact is that we don't have that in RHEL8 yet and cgroup v2 is still 
not the default at the moment.

I am planning to backport the throttling patches to RHEL and hopefully 
can switch to use cgroup v2 soon.

Cheers,
Longman

