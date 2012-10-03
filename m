From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Thu, 4 Oct 2012 07:43:16 +0900
Message-ID: <20121003224316.GD19248@localhost>
References: <50635B9D.8020205@parallels.com>
 <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120927120806.GA29104@dhcp22.suse.cz>
 <20120927143300.GA4251@mtj.dyndns.org>
 <20120927150950.GG29104@dhcp22.suse.cz>
 <20120930084750.GI10383@mtj.dyndns.org>
 <20121001092756.GA8622@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5Bw+XeOG41aYBKim6nWK4e4KM8ozPM3c43h+imXMSIg=;
        b=Lf06IOH4RpKTnmKRPJMpQuDuz95A0mkATbUjWKorTfcLRUMNHP6CDUdCdqD5qtWphk
         vzr9j55e7q2rIrS2Y2YaV97Mjy988a5L+khHzythjVLty1oXvxH3kISrWpDh9wJ91/M+
         WrsX3ECpUdr+4QPpLDcz1wDiWsa/7pLAfmLbbzDi+75rZCh4NqUlblUgJ7pZUZ5aWTq/
         hWkujjJZR3gDEYfjGzry70RQMDa7w7UY6U0htD7z8UsK5ktT8rWWDvdIaIqGj+E/dZCn
         xJQO6SS3xlgyGrY/jD4lknB/tQoa/wL4MIKtJh9Hrkqkqo+LsOjzIuSEZ2RXHmgp4Hhv
         ZWGg==
Content-Disposition: inline
In-Reply-To: <20121001092756.GA8622-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hey, Michal.

On Mon, Oct 01, 2012 at 11:27:56AM +0200, Michal Hocko wrote:
> > Yeah but, if we can get it down to, say, around 1% under most
> > workloads for memcg users, it is quite questionable to introduce full
> > hierarchical configuration to allow avoiding that, isn't it?
> 
> Remember that the kmem memory is still accounted to u+k if it is enabled
> which could be a no-go because some workloads (I have provided an
> example that those which are trusted are generally safe to ignore kernel
> memory overhead) simply don't want to consider additional memory which
> is mostly invisible for them.

Maybe it's because my exposure to cgroup usage is different from yours
but the argument that not accounting kernel memory is something
inherently beneficial is lost on me.  For compatibility, overhead
and/or implementation complexity issues, yeah, sure, we can't always
(well more like usually) have all we want but I don't get how not
accounting kernel memory is something inherently necessary or
beneficial.  This is all about provisioning physical memory to
different groups of users and memory is memory (that's why u+k makes
sense, right?).  Without kmemcg enabled, we not only lack a way to
control kernel memory usage but also a way to even watch per-group
usages.

> > But you can apply the same "do I need/want it at all" question to the
> > configuration parameter too.  
> 
> Yes but, as I've said, the global configuration parameter is too
> coarse. You can have a mix of trusted and untrusted workloads at the
> same machine (e.g. web server which is inherently untrusted) and trusted
> (local batch jobs which just needs a special LRU aging).

This too stems from the same difference stated above.  You think
there's inherent distinction between trusted and untrusted workloads
and they need different features from the kernel while I think why
trust anyone if you can untrust everyone and consider the knob as a
compatibility thing.

> I think that comparing kmem accounting with use_hierarchy is not fair.
> Glauber tried to explain why already so I will not repeat it here.
> I will just mention one thing. use_hierarchy has been introduces becuase
> hierarchies were expensive at the time. kmem accounting is about should
> we do u or u+k accounting. So there is a crucial difference.

It may be less crazy but I think there are enough commonalities to at
least make a comparison.  Mel seems to think it's mostly about
performance overhead.  You think that not accounting kmem is something
inherently necessary.

> That is right but I think that the current discussion shows that a mixed
> (kmem disabled and kmem enabled hierarchies) workloads are far from
> being theoretical and a global knob is just too coarse. I am afraid we

I'm not sure there's much evidence in this thread.  The strongest upto
this point seems to be performance overhead / difficulty of general
enough implementation.  As for "trusted" workload, what are the
inherent benefits of trusting if you don't have to?

> will see "we want that per hierarchy" requests shortly and that would
> just add a new confusion where global knob would complicate it
> considerably (do we really want on/off/per_hierarchy global knob?).

Hmmm?  The global knob is just the same per_hierarchy knob at the
root.  It's hierarchical after all.

Anyways, as long as the "we silently ignore what happened before being
enabled" is gone, I won't fight this anymore.  It isn't broken after
all.  But, please think about making things simpler in general, cgroup
is riddled with mis-designed complexities and memcg seems to be
leading the charge at times.

Thanks.

-- 
tejun
