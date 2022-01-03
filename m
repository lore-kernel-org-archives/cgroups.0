From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] mm/memcg: Allow the task_obj optimization only on
 non-PREEMPTIBLE kernels.
Date: Mon, 3 Jan 2022 10:04:29 -0500
Message-ID: <df637005-6c72-a1c6-c6b9-70f81f74884d@redhat.com>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-4-bigeasy@linutronix.de>
 <f6bb93c8-3940-6141-d0e0-50144549a4f5@redhat.com>
 <YdML2zaU17clEZgt@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641222277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/azdTXQpdDt54c/qGW2Q0f96DDwXW7aJM/qGAElD6uU=;
        b=X++g/GGfHc4+bLW6NZQEj6JQ/8Tb3Hy5ABjm55DJbhCR3yx49Dy2tfhBdc5AI2BnBT7lfP
        jvVdGra+t6TvpAwVwuGct32M5pVpXDX8AxPDDz6zFHQPSsdg1YvoxfyBaL6836ynudptkL
        BIwMS55HTPK+lRZJKRBe6kIYa4cDIcc=
Content-Language: en-US
In-Reply-To: <YdML2zaU17clEZgt-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>


On 1/3/22 09:44, Sebastian Andrzej Siewior wrote:
> On 2021-12-23 16:48:41 [-0500], Waiman Long wrote:
>> On 12/22/21 06:41, Sebastian Andrzej Siewior wrote:
>>> Based on my understanding the optimisation with task_obj for in_task()
>>> mask sense on non-PREEMPTIBLE kernels because preempt_disable()/enable()
>>> is optimized away. This could be then restricted to !CONFIG_PREEMPTION kernel
>>> instead to only PREEMPT_RT.
>>> With CONFIG_PREEMPT_DYNAMIC a non-PREEMPTIBLE kernel can also be
>>> configured but these kernels always have preempt_disable()/enable()
>>> present so it probably makes no sense here for the optimisation.
>>>
>>> Restrict the optimisation to !CONFIG_PREEMPTION kernels.
>>>
>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>> If PREEMPT_DYNAMIC is selected, PREEMPTION will also be set. My
>> understanding is that some distros are going to use PREEMPT_DYNAMIC, but
>> default to PREEMPT_VOLUNTARY. So I don't believe it is a good idea to
>> disable the optimization based on PREEMPTION alone.
> So there is a benefit to this even if preempt_disable() is not optimized
> away? My understanding was that this depends on preempt_disable() being
> optimized away.
> Is there something you recommend as a benchmark where I could get some
> numbers?

In the case of PREEMPT_DYNAMIC, it depends on the default setting which 
is used by most users. I will support disabling the optimization if 
defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT), just not by 
CONFIG_)PREEMPTION alone.

As for microbenchmark, something that makes a lot of calls to malloc() 
or related allocations can be used.

Cheers,
Longman

