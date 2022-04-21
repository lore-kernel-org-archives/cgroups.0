From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Free percpu stats memory of dying memcg's
Date: Thu, 21 Apr 2022 13:28:20 -0400
Message-ID: <112a4d7f-bc53-6e59-7bb8-6fecb65d045d@redhat.com>
References: <20220421145845.1044652-1-longman@redhat.com>
 <YmGHYNuAp8957ouq@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650562107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C2uOipi3GKnpM62yNx2qLO8Kw4BDhZHaF3HCYYZ6xuI=;
        b=OIdPswRC36WWPIzCIPr5AtdFYC4T8/w+g2KXunJhSvUd9kA8fOigUv9jjZSn4mzwFk9O/i
        Fy4KDwsBDlordBv9DzxiXwh8jovrULaZkTOOSbzZxafpOIRF9K9tIl/6uCtyRT87gbtFrS
        i5K8obDIBhz9B8ViwQOCjj3jBtbCOa8=
Content-Language: en-US
In-Reply-To: <YmGHYNuAp8957ouq@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>


On 4/21/22 12:33, Roman Gushchin wrote:
> On Thu, Apr 21, 2022 at 10:58:45AM -0400, Waiman Long wrote:
>> For systems with large number of CPUs, the majority of the memory
>> consumed by the mem_cgroup structure is actually the percpu stats
>> memory. When a large number of memory cgroups are continuously created
>> and destroyed (like in a container host), it is possible that more
>> and more mem_cgroup structures remained in the dying state holding up
>> increasing amount of percpu memory.
>>
>> We can't free up the memory of the dying mem_cgroup structure due to
>> active references in some other places. However, the percpu stats memory
>> allocated to that mem_cgroup is a different story.
>>
>> This patch adds a new percpu_stats_disabled variable to keep track of
>> the state of the percpu stats memory. If the variable is set, percpu
>> stats update will be disabled for that particular memcg. All the stats
>> update will be forward to its parent instead. Reading of the its percpu
>> stats will return 0.
>>
>> The flushing and freeing of the percpu stats memory is a multi-step
>> process. The percpu_stats_disabled variable is set when the memcg is
>> being set to offline state. After a grace period with the help of RCU,
>> the percpu stats data are flushed and then freed.
>>
>> This will greatly reduce the amount of memory held up by dying memory
>> cgroups.
>>
>> By running a simple management tool for container 2000 times per test
>> run, below are the results of increases of percpu memory (as reported
>> in /proc/meminfo) and nr_dying_descendants in root's cgroup.stat.
> Hi Waiman!
>
> I've been proposing the same idea some time ago:
> https://lore.kernel.org/all/20190312223404.28665-7-guro-b10kYP2dOMg@public.gmane.org/T/ .
>
> However I dropped it with the thinking that with many other fixes
> preventing the accumulation of the dying cgroups it's not worth the added
> complexity and a potential cpu overhead.
>
> I think it ultimately comes to the number of dying cgroups. If it's low,
> memory savings are not worth the cpu overhead. If it's high, they are.
> I hope long-term to drive it down significantly (with lru-pages reparenting
> being the first major milestone), but it might take a while.
>
> I don't have a strong opinion either way, just want to dump my thoughts
> on this.

I have quite a number of customer cases complaining about increasing 
percpu memory usages. The number of dying memcg's can go to tens of 
thousands. From my own investigation, I believe that those dying memcg's 
are not freed because they are pinned down by references in the page 
structure. I am aware that we support the use of objcg in the page 
structure which will allow easy reparenting, but most pages don't do 
that and it is not easy to do this conversion and it may take quite a 
while to do that.

In term of overhead, it is mostly one more memory read from the 
mem_cgroup structure in the update path. I don't expect there will be 
that many updates when the memcg is in an offline state as updates will 
be slower in this case. Freeing the dying memcg will take a bit longer 
though, but its impact on the overall system performance should still be 
negligible.

I am also thinking about using a static_key for turning it on only for 
systems with more than, say, 20 cpus as the percpu memory overhead 
increases linearly with the number of possible cpus.

Any other suggestions and improvements are welcome.

Cheers,
Longman

