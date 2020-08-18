From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 15:27:21 -0400
Message-ID: <3a4d858c-0605-c5fc-4a9e-f05cf221d6ac@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597778850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EYREHDLi/OwVaks7d7Yd3+mLedE3CgJg65cYrNwwqcA=;
        b=AhuqMZwjHMXxwIJLh2/xk46SPDY0TnodDuFG3LkQhEeE8xa4mG1jtLxCFpOQdaJ6sCUNwR
        Vh7sebKCp+3mf99lrHZc9RSJItQB+jLbfofWTEOVq00TAss4hKcxbNcn02P4klILVMQ4go
        +Y/TWvpLffwQrg8UUTw/b4bdVLjJfsg=
In-Reply-To: <20200818091453.GL2674@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: peterz@infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On 8/18/20 5:14 AM, peterz@infradead.org wrote:
> On Mon, Aug 17, 2020 at 10:08:23AM -0400, Waiman Long wrote:
>> Memory controller can be used to control and limit the amount of
>> physical memory used by a task. When a limit is set in "memory.high" in
>> a v2 non-root memory cgroup, the memory controller will try to reclaim
>> memory if the limit has been exceeded. Normally, that will be enough
>> to keep the physical memory consumption of tasks in the memory cgroup
>> to be around or below the "memory.high" limit.
>>
>> Sometimes, memory reclaim may not be able to recover memory in a rate
>> that can catch up to the physical memory allocation rate. In this case,
>> the physical memory consumption will keep on increasing.
> Then slow down the allocator? That's what we do for dirty pages too, we
> slow down the dirtier when we run against the limits.
>
I missed that there are already allocator throttling done in upstream 
code. So I will need to reexamine if this patch is necessary or not.

Thanks,
Longman

