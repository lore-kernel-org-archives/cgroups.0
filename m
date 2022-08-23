From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: an argument for keeping oom_control in cgroups v2
Date: Tue, 23 Aug 2022 09:10:37 -0700
Message-ID: <YwT7/VFUTNmjarTh@P9FQF9L96D>
References: <20220822120402.GA20333@foursquare.net>
 <YwRIDTmZJflhKP2n@slm.duckdns.org>
 <YwRgOcfagx4FfQcY@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661271056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qlxaZaSbPuFAJAQmo0ckaf7Kb7p2BorSsDJez+m/eoE=;
        b=J9YnRL0W8M84pc3H0HjPvYnR1NkEHKI4fQ80YSaSPLrwa5jf41S40YOYdw+wD6ywLUcj3e
        E5cIimTUCD6vkRDK2wYktIeDPJFHHRxxTG36JatJBY/f80tEU7tujUSsr2/UvK7147Fs4w
        S/OUrXqfNb8X9sfMmjaSY5vw7QV7cB4=
Content-Disposition: inline
In-Reply-To: <YwRgOcfagx4FfQcY-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Frey <cdfrey-4/nNOD19pEMY+eTVAdjFZg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Tue, Aug 23, 2022 at 07:06:01AM +0200, Michal Hocko wrote:
> On Mon 22-08-22 17:22:53, Tejun Heo wrote:
> > (cc'ing memcg folks for visiblity)
> > 
> > On Mon, Aug 22, 2022 at 08:04:02AM -0400, Chris Frey wrote:
> > > In cgroups v1 we had:
> > > 
> > > 	memory.soft_limit_in_bytes
> > > 	memory.limit_in_bytes
> > > 	memory.memsw.limit_in_bytes
> > > 	memory.oom_control
> > > 
> > > Using these features, we could achieve:
> > > 
> > > 	- cause programs that were memory hungry to suffer performance, but
> > > 	  not stop (soft limit)
> 
> There is memory.high with a much more sensible semantic and
> implementation to achieve a similar thing.
> 
> > > 	- cause programs to swap before the system actually ran out of memory
> > > 	  (limit)
> 
> Not sure what this is supposed to mean.
> 
> > > 	- cause programs to be OOM-killed if they used too much swap
> > > 	  (memsw.limit...)
> 
> 
> There is an explicit swap limit. It is true that the semantic is
> different but do you have an example where you cannot really achieve
> what you need by the swap limit?
> 
> > > 
> > > 	- cause programs to halt instead of get killed (oom_control)
> > > 
> > > That last feature is something I haven't seen duplicated in the settings
> > > for cgroups v2.  In terms of handling a truly non-malicious memory hungry
> > > program, it is a feature that has no equal, because the user may require
> > > time to free up memory elsewhere before allocating more to the program,
> > > and he may not want the performance degredation, nor the loss of work,
> > > that comes from the other options.
> 
> Yes this functionality is not available in v2 anymore. One reason is
> that the implementation had to be considerably reduced to only block on
> OOM for user space triggered page faults 3812c8c8f395 ("mm: memcg: do
> not trap chargers with full callstack on OOM"). The primary reason is,
> as Tejun indicated, that we cannot simply block a random kernel code
> path and wait for userspace because that is a potential DoS on the rest
> of the system and unrelated workloads which is a trivial breakage of
> workload separation.
> 
> This means that many other kernel paths which can cause memcg OOM cannot
> be blocked and so the feature is severly crippled. In order to allow for
> this feature we would essentially need a safe place to wait for the
> userspace for any allocation (charging) kernel path where no locks are
> held yet allocation failure is not observed and that is not feasible.

Btw, it's fairly easy to emulate the oom_control behaviour using cgroups v2:
a userspace agent can listen to memory.high/max events and use the cgroup v2
freezer to stop the workload and handle the oom in v1 oom_control style.
An agent can have a high/real-time priority, so I guess the behavior will be
actually quite close to the v1 experience. Much safer though.

Thanks!
