From: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Mon, 9 May 2022 11:26:43 +0000
Message-ID: <6278fa75.1c69fb81.9c598.f794@mx.google.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
 <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
 <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
 <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Ms5dtQehfkw1mFFz53YAav8LEpkzzlzEpCcB6kSnvY=;
        b=MVsp2jjiHNDmg59AzmpxFmJ7JTasWhUSVTYxRGAhW/4rn2RZgVAzmY6rO8TowyTJAc
         FRAAowpSFJ73ZVtwXcM6SzbbrEpMWO4jA96IwSUd4/toiWyZwJd+kVCybGjjHZXhU9fK
         UuggCJ5SWapCGbLK8LkRCuUXDXr5RQYuW+XEfCvfJCJYNsNg/zVn/XIWfwQ+3qZiNMH1
         97LvMixlZ7SMQ1s2a18HesTT052QM5dR2Ek1eOEDtImvaAHHlFzhloQkJ+MHrkGouvI1
         MGqhXhXrX5KMpOwtQAjOaDdea+K0oLRKdEh1kas3SspjdjBUHiC2UjT31YJxQkqVVm4e
         /eTQ==
Content-Disposition: inline
In-Reply-To: <YnjmPAToTR0C5o8x-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Mon, May 09, 2022 at 12:00:28PM +0200, Michal Hocko wrote:
> On Sat 07-05-22 02:05:25, CGEL wrote:
> [...]
> > If there are many containers to run on one host, and some of them have high
> > performance requirements, administrator could turn on thp for them:
> > # docker run -it --thp-enabled=always
> > Then all the processes in those containers will always use thp.
> > While other containers turn off thp by:
> > # docker run -it --thp-enabled=never
> 
> I do not know. The THP config space is already too confusing and complex
> and this just adds on top. E.g. is the behavior of the knob
> hierarchical? What is the policy if parent memcg says madivise while
> child says always? How does the per-application configuration aligns
> with all that (e.g. memcg policy madivise but application says never via
> prctl while still uses some madvised - e.g. via library).
>

The cgroup THP behavior is align to host and totally independent just likes
/sys/fs/cgroup/memory.swappiness. That means if one cgroup config 'always'
for thp, it has no matter with host or other cgroup. This make it simple for
user to understand or control.

If memcg policy madivise but application says never, just like host, the result
is no THP for that application.

> > By doing this we could promote important containers's performance with less
> > footprint of thp.
> 
> Do we really want to provide something like THP based QoS? To me it
> sounds like a bad idea and if the justification is "it might be useful"
> then I would say no. So you really need to come with a very good usecase
> to promote this further.

At least on some 5G(communication technology) machine, it's useful to provide
THP based QoS. Those 5G machine use micro-service software architecture, in
other words one service application runs in one container. Container becomes
the suitable management unit but not the whole host. And some performance
sensitive containers desiderate THP to provide low latency communication.
But if we use THP with 'always', it will consume more memory(on our machine
that is about 10% of total memory). And unnecessary huge pages will increase
memory pressure, add latency for minor pages faults, and add overhead when
splitting huge pages or coalescing normal sized pages into huge pages.

So container manager should welcome cgroup based THP QoS.

> -- 
> Michal Hocko
> SUSE Labs
