From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v3 0/9] memcg: accounting for objects allocated by
 mkdir cgroup
Date: Mon, 30 May 2022 22:58:30 +0300
Message-ID: <3a1d8554-755f-7976-1e00-a0e7fb62c86e@openvz.org>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
 <YpSwvii5etfnOYC9@dhcp22.suse.cz>
 <ef9f7516-853d-ffe4-9a7a-5e87556bdbbe@openvz.org>
 <YpTTL3Ys35kgYyAW@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ApxSBjwUCGt3x4hULPMqV5gemfrp+1rLUwdv7gH9FfE=;
        b=BJRwaKGIHurHh1ayULGoMhnnQuepxbgbughY+CV7pJx306lnZ7xkS+kUjIX/lf1YS6
         qIsBi2XP0heGd6n4ZjLXIk5IbO99lbTkIsxmNzjc6iOwDJ6UyNPdYgL7yadcmECBQE/d
         oV+ngN27o/LB47/miz7JEekrKNTPAbGoB7IbeTY6AP4sU3ojpcQzmmwGx2+rnbTfYzJT
         nk9Pr4LAY+uSVcTvhrb9Yw6Nn7zPxQmSy/4Jp4qZHpqpIyw7hQAD8Ph17R2cYAmGsqRO
         KZLTGKTBXn9q3X7xta3JgKgCGu/uWsj7paK27MQ3WiJxjEfZmNXyqcaAx7C5AyvnUwnD
         wf6A==
Content-Language: en-US
In-Reply-To: <YpTTL3Ys35kgYyAW-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 5/30/22 17:22, Michal Hocko wrote:
> On Mon 30-05-22 16:09:00, Vasily Averin wrote:
>> On 5/30/22 14:55, Michal Hocko wrote:
>>> On Mon 30-05-22 14:25:45, Vasily Averin wrote:
>>>> Below is tracing results of mkdir /sys/fs/cgroup/vvs.test on 
>>>> 4cpu VM with Fedora and self-complied upstream kernel. The calculations
>>>> are not precise, it depends on kernel config options, number of cpus,
>>>> enabled controllers, ignores possible page allocations etc.
>>>> However this is enough to clarify the general situation.
>>>> All allocations are splited into:
>>>> - common part, always called for each cgroup type
>>>> - per-cgroup allocations
>>>>
>>>> In each group we consider 2 corner cases:
>>>> - usual allocations, important for 1-2 CPU nodes/Vms
>>>> - percpu allocations, important for 'big irons'
>>>>
>>>> common part: 	~11Kb	+  318 bytes percpu
>>>> memcg: 		~17Kb	+ 4692 bytes percpu
>>>> cpu:		~2.5Kb	+ 1036 bytes percpu
>>>> cpuset:		~3Kb	+   12 bytes percpu
>>>> blkcg:		~3Kb	+   12 bytes percpu
>>>> pid:		~1.5Kb	+   12 bytes percpu		
>>>> perf:		 ~320b	+   60 bytes percpu
>>>> -------------------------------------------
>>>> total:		~38Kb	+ 6142 bytes percpu
>>>> currently accounted:	  4668 bytes percpu
>>>>
>>>> - it's important to account usual allocations called
>>>> in common part, because almost all of cgroup-specific allocations
>>>> are small. One exception here is memory cgroup, it allocates a few
>>>> huge objects that should be accounted.
>>>> - Percpu allocation called in common part, in memcg and cpu cgroups
>>>> should be accounted, rest ones are small an can be ignored.
>>>> - KERNFS objects are allocated both in common part and in most of
>>>> cgroups 
>>>>
>>>> Details can be found here:
>>>> https://lore.kernel.org/all/d28233ee-bccb-7bc3-c2ec-461fd7f95e6a-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org/
>>>>
>>>> I checked other cgroups types was found that they all can be ignored.
>>>> Additionally I found allocation of struct rt_rq called in cpu cgroup 
>>>> if CONFIG_RT_GROUP_SCHED was enabled, it allocates huge (~1700 bytes)
>>>> percpu structure and should be accounted too.
>>>
>>> One thing that the changelog is missing is an explanation why do we need
>>> to account those objects. Users are usually not empowered to create
>>> cgroups arbitrarily. Or at least they shouldn't because we can expect
>>> more problems to happen.
>>>
>>> Could you clarify this please?
>>
>> The problem is actual for OS-level containers: LXC or OpenVz.
>> They are widely used for hosting and allow to run containers
>> by untrusted end-users. Root inside such containers is able
>> to create groups inside own container and consume host memory
>> without its proper accounting.
> 
> Is the unaccounted memory really the biggest problem here?
> IIRC having really huge cgroup trees can hurt quite some controllers.
> E.g. how does the cpu controller deal with too many or too deep
> hierarchies?

Could you please describe it in more details?
Maybe it was passed me by, maybe I messed or forgot something,
however I cannot remember any other practical cgroup-related issues.

Maybe deep hierarchies does not work well.
however, I have not heard that the internal configuration of cgroup
can affect the upper level too.

Please let me know if this can happen, this is very interesting for us.

In our case, the hoster configures only the top level of the cgroup
and does not worry about possible misconfiguration inside containers
if it does not affect other containers or the host itself.

Unaccounted memory, contrary, can affects both neighbor containers and host system,
we saw it many times, and therefore we pay special attention to such issues.

Thank you,
	Vasily Averin
