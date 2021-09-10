From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg] memcg: prohibit unconditional exceeding the limit
 of dying tasks
Date: Fri, 10 Sep 2021 16:20:58 +0300
Message-ID: <4a407474-ff7a-9e4f-d314-ab85f0eeaadf@virtuozzo.com>
References: <5b06a490-55bc-a6a0-6c85-690254f86fad@virtuozzo.com>
 <099aa0db-045a-e5b8-6df7-b7c3fc4d3caa@i-love.sakura.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=JVXUl/vOizFbXr36SIPs7G3RFOBb+JiAbzjybBgSVzo=; b=JLfwkFXuuXp3vd0TC
        /NFlQV+FNFjxEFpmxjyN2Xcau1dZ7GgOhyPyo4HrLhWmnInQ5e1thC1wdt+G+EvfHG8LCuyDQMo4D
        6/cxxh6G/QICGAi+EGhYighds6CAGImWsDXVSdQm/rVweBBVKGuOa2flWL+Ih1/ZygDxHCACfnIBw
        =;
In-Reply-To: <099aa0db-045a-e5b8-6df7-b7c3fc4d3caa-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 9/10/21 4:04 PM, Tetsuo Handa wrote:
> On 2021/09/10 21:39, Vasily Averin wrote:
>> The kernel currently allows dying tasks to exceed the memcg limits.
>> The allocation is expected to be the last one and the occupied memory
>> will be freed soon.
>> This is not always true because it can be part of the huge vmalloc
>> allocation. Allowed once, they will repeat over and over again.
>> Moreover lifetime of the allocated object can differ from
>> In addition the lifetime of the dying task.
> 
> Can't we add fatal_signal_pending(current) test to vmalloc() loop?

1) this has been done in the past but has been reverted later.
2) any vmalloc changes will affect non-memcg allocations too.
 If we're doing memcg-related checks it's better to do it in one place.
3) it is not vmalloc-only issue. Huge number of  kmalloc page allocations 
from N concurrent threads will lead to the same problem. 

>> Multiple such allocations running concurrently can not only overuse
>> the memcg limit, but can lead to a global out of memory and,
>> in the worst case, cause the host to panic.
>>
>> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

