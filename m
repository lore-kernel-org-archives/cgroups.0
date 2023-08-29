From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Tue, 29 Aug 2023 11:05:28 -0400
Message-ID: <5906501e-4dff-4c66-7ab3-e9193d312270@redhat.com>
References: <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
 <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz>
 <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
 <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg@mail.gmail.com>
 <CAJD7tkbnvMCNfQwY_dmVe2SWR5NeN+3RzFhsVyimM1ATaX0D5A@mail.gmail.com>
 <599b167c-deaf-4b92-aa8b-5767b8608483@redhat.com>
 <ZO2d7dT8gulMyb8g@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693321534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZA14b/tmA/wTpAgcSwxLG1sI93f6oKp/7oBZg84XpyU=;
        b=armjlI/aeAzGEG1+k5MO+52MyJGrdP2n+l/aDtGiPuYLNmWOZ3XquIYP+P2cuVNvYhhS+m
        YbaeIK8ZjVhJyGU949DNdL8RHSEDzXtUT2LMZ8Sx7gk/X7utWmKf6GAulp5eNI7GZX5PXO
        1h18k3ZCfNUGUT1bfbdFEvZru1jicgQ=
Content-Language: en-US
In-Reply-To: <ZO2d7dT8gulMyb8g-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 8/29/23 03:27, Michal Hocko wrote:
> On Mon 28-08-23 13:27:23, Waiman Long wrote:
>> On 8/28/23 13:07, Yosry Ahmed wrote:
>>>> Here I agree with you. Let's go with the approach which is easy to
>>>> undo for now. Though I prefer the new explicit interface for flushing,
>>>> that step would be very hard to undo. Let's reevaluate if the proposed
>>>> approach shows negative impact on production traffic and I think
>>>> Cloudflare folks can give us the results soon.
>>> Do you prefer we also switch to using a mutex (with preemption
>>> disabled) to avoid the scenario Michal described where flushers give
>>> up the lock and sleep resulting in an unbounded wait time in the worst
>>> case?
>> Locking with mutex with preemption disabled is an oxymoron.
> I believe Yosry wanted to disable preemption _after_ the lock is taken
> to reduce the time spent while it is held. The idea to use the mutex is
> to reduce spinning and more importantly to get rid of lock dropping
> part. It is not really clear (but unlikely) we can drop it while
> preserving the spinlock as the thing scales with O(#cgroups x #cpus)
> in the worst case.

As I have said later in my email, I am not against disabling preemption 
selectively on some parts of the lock critical section where preemption 
is undesirable. However, I am against disabling preemption for the whole 
duration of the code where the mutex lock is held as it defeats the 
purpose of using mutex in the first place.

Cheers,
Longman

