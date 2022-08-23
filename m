From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: an argument for keeping oom_control in cgroups v2
Date: Tue, 23 Aug 2022 07:06:01 +0200
Message-ID: <YwRgOcfagx4FfQcY@dhcp22.suse.cz>
References: <20220822120402.GA20333@foursquare.net>
 <YwRIDTmZJflhKP2n@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661231162; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n13NAN9ffJ2MVaULyYx08l67c4Jvz9ioDGiOIBNWoTA=;
        b=kV4cusk4xw/njZv0QPW2NMdhCsG/V77aYBeqmeW6P1+q8rM2Rd/aGS9Vqwrcub7DJK2QBR
        DFE0caAsqwYmUCjtoNCTBFiJ80LY25e+Cj0vqwR20ImkMyeEaNymjdOJpkGJ3nrZcvnk4P
        DCwR71kL2yF8tTBLIclCp4Nn+l3Y/Nw=
Content-Disposition: inline
In-Reply-To: <YwRIDTmZJflhKP2n-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Frey <cdfrey-4/nNOD19pEMY+eTVAdjFZg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Mon 22-08-22 17:22:53, Tejun Heo wrote:
> (cc'ing memcg folks for visiblity)
> 
> On Mon, Aug 22, 2022 at 08:04:02AM -0400, Chris Frey wrote:
> > In cgroups v1 we had:
> > 
> > 	memory.soft_limit_in_bytes
> > 	memory.limit_in_bytes
> > 	memory.memsw.limit_in_bytes
> > 	memory.oom_control
> > 
> > Using these features, we could achieve:
> > 
> > 	- cause programs that were memory hungry to suffer performance, but
> > 	  not stop (soft limit)

There is memory.high with a much more sensible semantic and
implementation to achieve a similar thing.

> > 	- cause programs to swap before the system actually ran out of memory
> > 	  (limit)

Not sure what this is supposed to mean.

> > 	- cause programs to be OOM-killed if they used too much swap
> > 	  (memsw.limit...)


There is an explicit swap limit. It is true that the semantic is
different but do you have an example where you cannot really achieve
what you need by the swap limit?

> > 
> > 	- cause programs to halt instead of get killed (oom_control)
> > 
> > That last feature is something I haven't seen duplicated in the settings
> > for cgroups v2.  In terms of handling a truly non-malicious memory hungry
> > program, it is a feature that has no equal, because the user may require
> > time to free up memory elsewhere before allocating more to the program,
> > and he may not want the performance degredation, nor the loss of work,
> > that comes from the other options.

Yes this functionality is not available in v2 anymore. One reason is
that the implementation had to be considerably reduced to only block on
OOM for user space triggered page faults 3812c8c8f395 ("mm: memcg: do
not trap chargers with full callstack on OOM"). The primary reason is,
as Tejun indicated, that we cannot simply block a random kernel code
path and wait for userspace because that is a potential DoS on the rest
of the system and unrelated workloads which is a trivial breakage of
workload separation.

This means that many other kernel paths which can cause memcg OOM cannot
be blocked and so the feature is severly crippled. In order to allow for
this feature we would essentially need a safe place to wait for the
userspace for any allocation (charging) kernel path where no locks are
held yet allocation failure is not observed and that is not feasible.

Hope this helps clarify
-- 
Michal Hocko
SUSE Labs
