From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter
 fields
Date: Mon, 22 Aug 2022 17:15:07 +0200
Message-ID: <YwOde3qFvne7Umld@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-3-shakeelb@google.com>
 <YwNZD4YlRkvQCWFi@dhcp22.suse.cz>
 <CALvZod5pw_7hnH44hdC3rDGQxQB2XATrViNNGosG3FnUoWo-4A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661181308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ko/ZbbYlRZVDcCBDACh47r5MpCi7V/QJtzGfx/uTT4o=;
        b=AXWrARvl88HySuV2IvKZojEAAxu+6WFr21jizwVhd03l87uhLlzEhtWF1q5t+tYCKFoU1r
        zhU9Xf5P/O2u82zIGY3fhc2PPA5D+bx5XJNxv1WYALMnAhhLQVdq10YN3QdYT/wpkS5CBR
        HnhzLzMG9IccwSBFROGrZYIj9DWOx1g=
Content-Disposition: inline
In-Reply-To: <CALvZod5pw_7hnH44hdC3rDGQxQB2XATrViNNGosG3FnUoWo-4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 22-08-22 08:06:14, Shakeel Butt wrote:
[...]
> > >  struct page_counter {
> > > +     /*
> > > +      * Make sure 'usage' does not share cacheline with any other field. The
> > > +      * memcg->memory.usage is a hot member of struct mem_cgroup.
> > > +      */
> > > +     PC_PADDING(_pad1_);
> >
> > Why don't you simply require alignment for the structure?
> 
> I don't just want the alignment of the structure. I want different
> fields of this structure to not share the cache line. More
> specifically the 'high' and 'usage' fields. With this change the usage
> will be its own cache line, the read-most fields will be on separate
> cache line and the fields which sometimes get updated on charge path
> based on some condition will be a different cache line from the
> previous two.

I do not follow. If you make an explicit requirement for the structure
alignement then the first field in the structure will be guarantied to
have that alignement and you achieve the rest to be in the other cache
line by adding padding behind that.

-- 
Michal Hocko
SUSE Labs
