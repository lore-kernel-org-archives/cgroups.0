From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for
 low/min
Date: Mon, 22 Aug 2022 12:18:34 +0200
Message-ID: <YwNX+vq9svMynVgW@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-2-shakeelb@google.com>
 <YwNSlZFPMgclrSCz@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661163514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ddo0jfrwDZ3L4Qe1pkeccO8zwyE5ZTiXSLFicdPBbV0=;
        b=l2HPQA8oiqSWOjr5YISW/KuLciitz9j6RqjXevMJrWGhcaWGKvyX6Zj+/OnVQo4rTK1KnI
        OEM0wcHb3br+QDpCFv3MIB8+FHsWw8B8C938xBwl4d8luxSbGRBkEpdKWb7go6H0Gz2zqd
        gmhm8TA66oR/B1Py5yILH6sDLusq8c8=
Content-Disposition: inline
In-Reply-To: <YwNSlZFPMgclrSCz-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 22-08-22 11:55:33, Michal Hocko wrote:
> On Mon 22-08-22 00:17:35, Shakeel Butt wrote:
[...]
> > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > index eb156ff5d603..47711aa28161 100644
> > --- a/mm/page_counter.c
> > +++ b/mm/page_counter.c
> > @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
> >  				      unsigned long usage)
> >  {
> >  	unsigned long protected, old_protected;
> > -	unsigned long low, min;
> >  	long delta;
> >  
> >  	if (!c->parent)
> >  		return;
> >  
> > -	min = READ_ONCE(c->min);
> > -	if (min || atomic_long_read(&c->min_usage)) {
> > -		protected = min(usage, min);
> > +	protected = min(usage, READ_ONCE(c->min));
> > +	old_protected = atomic_long_read(&c->min_usage);
> > +	if (protected != old_protected) {
> 
> I have to cache that code back into brain. It is really subtle thing and
> it is not really obvious why this is still correct. I will think about
> that some more but the changelog could help with that a lot.

OK, so the this patch will be most useful when the min > 0 && min <
usage because then the protection doesn't really change since the last
call. In other words when the usage grows above the protection and your
workload benefits from this change because that happens a lot as only a
part of the workload is protected. Correct?

Unless I have missed anything this shouldn't break the correctness but I
still have to think about the proportional distribution of the
protection because that adds to the complexity here.
-- 
Michal Hocko
SUSE Labs
