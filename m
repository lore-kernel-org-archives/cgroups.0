From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH mm v3 0/9] memcg: accounting for objects allocated by
 mkdir cgroup
Date: Wed, 1 Jun 2022 11:26:55 +0200
Message-ID: <Ypcw3xhumvH3KDkD@dhcp22.suse.cz>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
 <YpSwvii5etfnOYC9@dhcp22.suse.cz>
 <ef9f7516-853d-ffe4-9a7a-5e87556bdbbe@openvz.org>
 <YpTTL3Ys35kgYyAW@dhcp22.suse.cz>
 <3a1d8554-755f-7976-1e00-a0e7fb62c86e@openvz.org>
 <YpXA35F33hvrxNLf@dhcp22.suse.cz>
 <118bcb39-1281-0d1d-b163-3f6bcc99c3e2@openvz.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654075617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=umyJ259eqDO/AWl48+5+ukfsnKPvszoN7+zzaQVPwm8=;
        b=WoreISCAqGglNQ8BJCy9DimpyyoJ5TmjQXs5xFqaChdfvvjWTEM/Z/C/9xylNwI8JCAecl
        dlXZ3yxKbq25Ub4V0OGKQ6Jw0yolmXWFO7VolBdU29hcv+0VkSMqBfc1HQQ4fU0y3OB2+j
        eO7TltYUvtkJnEhhoEHEbHPVjSWSSkU=
Content-Disposition: inline
In-Reply-To: <118bcb39-1281-0d1d-b163-3f6bcc99c3e2@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

On Wed 01-06-22 06:43:27, Vasily Averin wrote:
[...]
> However, it isn't critical for OpenVz. Our kernel does not allow
> to change of cgroup.subgroups_limit from inside containers.

What is the semantic of this limit?

> CT-901 /# cat /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> 512
> CT-901 /# echo 3333 > /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> -bash: echo: write error: Operation not permitted
> CT-901 /# echo 333 > /sys/fs/cgroup/memory/cgroup.subgroups_limit 
> -bash: echo: write error: Operation not permitted
> 
> I doubt this way can be accepted in upstream, however for OpenVz
> something like this it is mandatory because it much better
> than nothing.
> 
> The number can be adjusted by host admin. The current default limit
> looks too small for me, however it is not difficult to increase it
> to a reasonable 10,000.
> 
> My experiments show that ~10000 cgroups consumes 0.5 Gb memory on 4cpu VM.
> On "big irons" it can easily grow up to several Gb. This is quite a lot
> to ignore its accounting.

Too many cgroups can certainly have a high memory footprint. I guess
this is quite clear. The question is whether trying to limit them by the
memory footprint is really the right way to go. I would be especially
worried about those smaller machines because of a smaller footprint
which would allow to deplete the id space faster.

Maybe we need some sort of limit on the number of cgroups in a subtree
so that any potential runaway can be prevented regardless of the cgroups
memory footprint. One potentially big problem with that is that cgroups
can live quite long after being offlined (e.g. memcg) so such a limit
could easily trigger I can imagine.
-- 
Michal Hocko
SUSE Labs
