From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem
 isolation
Date: Tue, 13 Jun 2023 14:46:55 +0800
Message-ID: <554cd1a7-83a3-ae49-0770-2321c79472a1@bytedance.com>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com>
 <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
 <CALvZod4BuY=kHnQov6Ho+UT0_0oG6nEX1Z-pU-f4Yt9w7-=5Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686638830; x=1689230830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UIt7yjEGnPmfSnSW7ej7mUT8lTrDwLThOBy1DhvgW+8=;
        b=cOnUQuywUfCqQExpNyKzwnRKwjIhzVJw961gL0WjaMUc+Sv1fmcEnvEmTIQY5ecCgP
         dio5TjN0kwdQPlpGXydTOGeB2Jwc9fCu8IM/ZJZfVOXmCfHY7hWy95VXW8COKOIncsY3
         YhRPSXXbHRhta7HJwgme9EHTPGSZRqp3nvHJ33t7hr5/oUUQvAubZRJ6ydRJQNZ0dik2
         uz9rxO/887/0vqThciHPE3nO4EFbXj/dtWgIb4AJp2eRSAyx9v+DHatVow/sGRdTgAf6
         663cJpcmuQEjmH/xCk9pAdmevfYljg9kOThryDFU6YHrUdDNwVQrMJutUGIvVc/8CyFd
         RS2g==
Content-Language: en-US
In-Reply-To: <CALvZod4BuY=kHnQov6Ho+UT0_0oG6nEX1Z-pU-f4Yt9w7-=5Hg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Warloe <cwarloe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Xin Long <lucien.xin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Xing <kernelxing-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Mich

On 6/10/23 1:53 AM, Shakeel Butt wrote:
> On Fri, Jun 9, 2023 at 2:07 PM Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On Fri, Jun 9, 2023 at 10:28 AM Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>>>
>>> This is just a PoC patch intended to resume the discussion about
>>> tcpmem isolation opened by Google in LPC'22 [1].
>>>
>>> We are facing the same problem that the global shared threshold can
>>> cause isolation issues. Low priority jobs can hog TCP memory and
>>> adversely impact higher priority jobs. What's worse is that these
>>> low priority jobs usually have smaller cpu weights leading to poor
>>> ability to consume rx data.
>>>
>>> To tackle this problem, an interface for non-root cgroup memory
>>> controller named 'socket.urgent' is proposed. It determines whether
>>> the sockets of this cgroup and its descendants can escape from the
>>> constrains or not under global socket memory pressure.
>>>
>>> The 'urgent' semantics will not take effect under memcg pressure in
>>> order to protect against worse memstalls, thus will be the same as
>>> before without this patch.
>>>
>>> This proposal doesn't remove protocal's threshold as we found it
>>> useful in restraining memory defragment. As aforementioned the low
>>> priority jobs can hog lots of memory, which is unreclaimable and
>>> unmovable, for some time due to small cpu weight.
>>>
>>> So in practice we allow high priority jobs with net-memcg accounting
>>> enabled to escape the global constrains if the net-memcg itselt is
>>> not under pressure. While for lower priority jobs, the budget will
>>> be tightened as the memory usage of 'urgent' jobs increases. In this
>>> way we can finally achieve:
>>>
>>>    - Important jobs won't be priority inversed by the background
>>>      jobs in terms of socket memory pressure/limit.
>>>
>>>    - Global constrains are still effective, but only on non-urgent
>>>      jobs, useful for admins on policy decision on defrag.
>>>
>>> Comments/Ideas are welcomed, thanks!
>>>
>>
>> This seems to go in a complete opposite direction than memcg promises.
>>
>> Can we fix memcg, so that :
>>
>> Each group can use the memory it was provisioned (this includes TCP buffers)
>>
>> Global tcp_memory can disappear (set tcp_mem to infinity)
> 
> I agree with Eric and this is exactly how we at Google overcome the
> isolation issue. We have set tcp_mem to unlimited and enabled memcg
> accounting of network memory (by surgically incorporating v2 semantics
> of network memory accounting in our v1 environment).
> 
> I do have one question though:
> 
>> This proposal doesn't remove protocal's threshold as we found it
>> useful in restraining memory defragment.
> 
> Can you explain how you find the global tcp limit useful? What does
> memory defragment mean?

We co-locate different kinds of jobs with different priority in cgroups,
among which there are some background jobs can have lots of net data to
process, e.g. training jobs. These background jobs usually don't have
enough cpu bandwidth to consume the rx data in time if more important
jobs are running simultaneously. The data can be accumulated to eat up
some or all of the provisioned memory. These unreclaimable memory could
gradually fragment whole memory. We have already found many such cases
in production environment.

Maybe it's not proper to use the word 'defragment' as what we do is to
try to prevent from fragmentation rather than defrag like compaction.
With global tcp_mem pressure/limit and socket.urgent, we are able to
achieve this goal, at least at some extent.

And not only global tcp limit, the pressure threshold could also make
something like priority inversion happen. We monitored top20 priority
jobs and found their performance reduced by 2~9% when under global tcp
memory pressure (and sometimes the majority of sk_memory_allocated()
can be contributed by the low priority jobs). Although this has nothing
to do with 'memory defrag'.
