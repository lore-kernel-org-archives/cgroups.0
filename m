From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks
 allocations
Date: Wed, 27 Apr 2022 14:22:32 +0200
Message-ID: <20220427122232.GA9823@blackbody.suse.cz>
References: <YmdeCqi6wmgiSiWh@carbon>
 <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651062154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bPJVJ/mvoFlMUFOZPBJ+knXZSOjq1aUlwWwkq9LhQTo=;
        b=n6Zsmd3ZvSPkPhiIdXXfFL6ehZn8AL7BshvVE3p+w5JDx9muTQd5wKkGExHgczFgQH8G4e
        d8rlT0rW81Ve1qiYTkNlC1dukAx4Q4DIDccyG20zh1OfPZXR6eF7ygx84SM0nBfFl5krNz
        Ihf/Jng1e1v9VeCT1AdFdSHRSN77vjg=
Content-Disposition: inline
In-Reply-To: <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> [...]
> >
> > +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> > +{
> > +       struct mem_cgroup *memcg;
> > +
> 
> Do we need memcg_kmem_enabled() check here or maybe
> mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
> mem_cgroup_disabled() as we can have "cgroup.memory=nokmem" boot
> param.

I reckon such a guard is on the charge side and readers should treat
NULL and root_mem_group equally. Or is there a case when these two are
different? 

(I can see it's different semantics when stored in current->active_memcg
(and active_memcg() getter) but for such "outer" callers like here it
seems equal.)

Regards,
Michal

