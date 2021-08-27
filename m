From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-5.15 v2] io_uring: consider cgroup setting when
 binding sqpoll cpu
Date: Fri, 27 Aug 2021 11:09:07 -0600
Message-ID: <9028a8de-a290-a955-1eac-43bec6e8702d@kernel.dk>
References: <20210827141315.235974-1-haoxu@linux.alibaba.com>
 <0988b0dc-232f-80cd-c984-2364c0dee69f@kernel.dk>
 <592ba01a-a128-f781-d920-2b480f91c451@linux.alibaba.com>
 <d413acfe-333a-9b7d-aba8-6e99db376fd6@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cOCQPSAXEBI18L8GLJfeEJCDZQiWKeHIWKJBdyqkyqo=;
        b=bmlb2tCkX487OfI8Ekc5/Q1GwX7To/VXB9ALS8vkjTegZTuEpC09J2fUFHPPArl/Zi
         6AKOwo5BQL4BwstsEGfj6iiJRWUe327XXdnq2Tn2OzkrUZ15dVJerHPMKg2qy5TwquKD
         VfVWRYlnQybeAXMkbcdu2cfbOUYeBpXNf6UUGd7eJwUPk2Kt4w5otxc2HzobwgCr+9X1
         TzldE1Km9uGPYd+8yk4RLGAeK6B1SEv24EWZiuoBgbuiXCP5+bYZGSoUWOpWNZ92Qum/
         Mh35m5BkKgpG3wXVw2o8MAKzxvqk2KFsPTJB7SZeKGHbj1h/Fe86/riB+FBSP9NFS3vW
         DgKA==
In-Reply-To: <d413acfe-333a-9b7d-aba8-6e99db376fd6@linux.alibaba.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hao Xu <haoxu@linux.alibaba.com>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

On 8/27/21 11:03 AM, Hao Xu wrote:
> 在 2021/8/28 上午12:57, Hao Xu 写道:
>> 在 2021/8/27 下午10:18, Jens Axboe 写道:
>>> On 8/27/21 8:13 AM, Hao Xu wrote:
>>>> Since sqthread is userspace like thread now, it should respect cgroup
>>>> setting, thus we should consider current allowed cpuset when doing
>>>> cpu binding for sqthread.
>>>
>>> In general, this looks way better than v1. Just a few minor comments
>>> below.
>>>
>>>> @@ -7000,6 +7001,16 @@ static bool io_sqd_handle_event(struct 
>>>> io_sq_data *sqd)
>>>>       return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
>>>>   }
>>>> +static int io_sq_bind_cpu(int cpu)
>>>> +{
>>>> +    if (!test_cpu_in_current_cpuset(cpu))
>>>> +        pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
>>>> +    else
>>>> +        set_cpus_allowed_ptr(current, cpumask_of(cpu));
>>>> +
>>>> +    return 0;
>>>> +}
>>>
>>> This should not be triggerable, unless the set changes between creation
>>> and the thread being created. Hence maybe the warn is fine. I'd probably
>>> prefer terminating the thread at that point, which would result in an
>>> -EOWNERDEAD return when someone attempts to wake the thread.
>>>
>>> Which is probably OK, as we really should not hit this path.
>> Actually I think cpuset change offen happen in container environment(
>> at leaset in my practice), eg. by resource monitor and balancer. So I
>> did this check to make sure we are still maintain sq_cpu logic at that
>> time as possible as we can. Though the problem is still there during
>> sqthread running time(the cpuset can change at anytime, which changes
>> the cpumask of sqthread)
> And because the cpumask of sqthread may be changed by the cgroup cpuset
> change at any time, so here I just print a warnning rather than
> terminating sqthread due to this 'normal thing'..

Do we even want the warning then? If it's an expected thing, seems very
annoying to warn about it.

-- 
Jens Axboe

