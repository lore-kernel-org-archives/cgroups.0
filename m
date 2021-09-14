From: brookxu <brookxu.cn@gmail.com>
Subject: Re: [PATCH v2 1/3] misc_cgroup: introduce misc.events and
 misc_events.local
Date: Tue, 14 Sep 2021 10:23:13 +0800
Message-ID: <b62597e9-72c4-563e-fdc7-3315569502f0@gmail.com>
References: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
 <CAHVum0dmTULvzD6dhr4Jzow-M1ATi-ubDkO5wQR=RQmWtt_78w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6bHeWjV3HGfhLob3U0wkIQ8wiGJnN6iWzgMWgki4WRA=;
        b=KDkT9e32/Y9iJjHHqek7M4egxwe+SRvGz5YRzUEkoBI+GO2NmGzFfAIzOi1trat/2d
         iC6xrRNW6XHGrwX5yKWRp4xAO575uxyYMHEyAKHtl37YY/360gEy3hx/UvRKMqJU14th
         4Nd1+yHQkAxwbvrkLPmPn2TJviUwPvGGpSMipipQB6C3j1Gbs4iPSeodJf+WEqzCoTqY
         v8+OfagxpSQPqhkwIh1pfZr4u+jC7zZXyL4r3mAvH81vHNIbKHMJs9RGsIkomamQCaQq
         cZghOvUn9cFgiLkWwNpcMIN6TDKV1FMq21JNGH5uf9tFd0e/t0C2NfOAs+vGO2+tM6yn
         jEHQ==
In-Reply-To: <CAHVum0dmTULvzD6dhr4Jzow-M1ATi-ubDkO5wQR=RQmWtt_78w@mail.gmail.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vipin Sharma <vipinsh@google.com>, Tejun Heo <tj@kernel.org>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

Thanks for your time.

Vipin Sharma wrote on 2021/9/14 12:51 上午:
> On Sun, Sep 12, 2021 at 10:01 PM brookxu <brookxu.cn@gmail.com> wrote:
>>
>> From: Chunguang Xu <brookxu@tencent.com>
>>
>> Introduce misc.events and misc.events.local to make it easier for
> 
> I thought Tejun only gave go ahead for misc.events and not for
> misc.events.local.
> 

Maybe I missed something. I think events.local is somewhat useful. For
example, the events of node A is large. If we need to determine whether
it is caused by the max of node A, if there is no events.local, then we
need to traverse the events of the child nodes and compare them with
node A. This is a bit complicated. If there is events.local, we can do
it very easily. Should we keep the events.local interface？

>> us to understand the pressure of resources. The main idea comes
>> from mem_cgroup. Currently only the 'max' event is implemented,
>> which indicates the times the resource exceeds the limit.
>>
> 
> For future emails, please provide the links to previous discussions
> like [1], [2],...
> 
>> @@ -36,6 +41,8 @@ enum misc_res_type {
>>  struct misc_res {
>>         unsigned long max;
>>         atomic_long_t usage;
>> +       atomic_long_t events[MISC_CG_EVENT_TYPES];
> 
> Since there is only one event type for now, my recommendation is to
> not use the array and just use a single atomic_long_t.
> 
>>
>> +static const char *const misc_event_name[] = {
>> +       "max"
>> +};
>> +
> 
> We will not need it if you remove the array in struct misc_res.

All right, thanks.

> Thanks
> Vipin
> 
