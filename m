From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Mon, 9 May 2022 12:00:28 +0200
Message-ID: <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
 <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
 <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652090433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EnVbGbF3CiTcycSBZO/loerdaCBwAlV6olMPMO9R0Qs=;
        b=crXHB0LGP0sk30wzd0kWaM5SpjARbCCh70lfRoTsVFXEIuaZcoMvyMb1tID3C62z31gqYe
        yQ7D8QfaK+pJpNbEPL+K5d78N02gEkqfCsXBVAgUwGGbsSMibVYHliBh+Lr3X45ftFpA+w
        keJFS3J/goZuc+Z0vjcFJEU3EQEGDXE=
Content-Disposition: inline
In-Reply-To: <6275d3e7.1c69fb81.1d62.4504-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Sat 07-05-22 02:05:25, CGEL wrote:
[...]
> If there are many containers to run on one host, and some of them have high
> performance requirements, administrator could turn on thp for them:
> # docker run -it --thp-enabled=always
> Then all the processes in those containers will always use thp.
> While other containers turn off thp by:
> # docker run -it --thp-enabled=never

I do not know. The THP config space is already too confusing and complex
and this just adds on top. E.g. is the behavior of the knob
hierarchical? What is the policy if parent memcg says madivise while
child says always? How does the per-application configuration aligns
with all that (e.g. memcg policy madivise but application says never via
prctl while still uses some madvised - e.g. via library).

> By doing this we could promote important containers's performance with less
> footprint of thp.

Do we really want to provide something like THP based QoS? To me it
sounds like a bad idea and if the justification is "it might be useful"
then I would say no. So you really need to come with a very good usecase
to promote this further.
-- 
Michal Hocko
SUSE Labs
