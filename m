From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Wed, 18 May 2022 18:14:45 +1000
Message-ID: <YoSq9W995QPM6tWQ@balbir-desktop>
References: <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
 <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
 <6278fa75.1c69fb81.9c598.f794@mx.google.com>
 <Ynj/l+pyFJxKfcbQ@dhcp22.suse.cz>
 <6279c354.1c69fb81.7f6c1.15e0@mx.google.com>
 <CAHbLzkqztB+NXVcxtd7bVo7onH6AcMJ3JWCAHHqH3OAdbZsMOQ@mail.gmail.com>
 <627b1d39.1c69fb81.fe952.6426@mx.google.com>
 <CALvZod5aqZjUE8BBQZxwHDBuSWOSEAOqW4_xE22Am0sGZZs4sw@mail.gmail.com>
 <YnspVPGOtzlo5n+7@carbon>
 <627b2df5.1c69fb81.4a22.160f@mx.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WoEf2mJXOA2MejlK2DAjiC6YKTbTSAG0lBrKeEx56e8=;
        b=JnJoLDdO3Cr3yxlTa2CqxnmoSJWnIgeN9bE1GtOXbZrEi3HH/aUCbqqMPQ1XBmuuDJ
         CufWXNwnV9NyvbwBtELZ+WkzLZdqsS56GMSgC3kQHMqjWqfnT54P/ue6lfRVzzV1rzES
         wv7OaWRhgrmMWDNDK1pwopJLJlxnEoS5IjKy8hCTeBmUwvvlS+7icQS5kLusciC2wXhC
         /hjwWCtRUTnnm1EOpgUHfBmvsFlrP2rmD8SQkTzy4+4aCHWzXXDc+KhJObrWWetXXoMe
         tujFvcq7DTJF0XhdEM/hvgE+S9mIuWOC9YkMxDtHXmov36dPVh6XKcOavrVzsBQbmrbn
         VAOA==
Content-Disposition: inline
In-Reply-To: <627b2df5.1c69fb81.4a22.160f-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, William Kucharski <william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Wed, May 11, 2022 at 03:31:00AM +0000, CGEL wrote:
> On Tue, May 10, 2022 at 08:11:16PM -0700, Roman Gushchin wrote:
> > On Tue, May 10, 2022 at 07:47:29PM -0700, Shakeel Butt wrote:
> > > On Tue, May 10, 2022 at 7:19 PM CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > >
> > > [...]
> > > > > > >
> > > > > > > All controls in cgroup v2 should be hierarchical. This is really
> > > > > > > required for a proper delegation semantic.
> > > > > > >
> > > > > >
> > > > > > Could we align to the semantic of /sys/fs/cgroup/memory.swappiness?
> > > > > > Some distributions like Ubuntu is still using cgroup v1.
> > > > >
> > > > > Other than enable flag, how would you handle the defrag flag
> > > > > hierarchically? It is much more complicated.
> > > >
> > > > Refer to memory.swappiness for cgroup, this new interface better be independent.
> > > 
> > > Let me give my 0.02. I buy the use-case of Admin restricting THPs to
> > > low priority jobs but I don't think memory controller is the right
> > > place to enforce that policy. Michal gave one way (prctl()) to enforce
> > > that policy. Have you explored the BPF way to enforce this policy?
> > 
> > +1 for bpf
> > 
> > I think these THP hints are too implementation-dependent and unstable to become
> > a part of cgroup API.
> >
> 
> Thanks! If no other suggesting we will submit a bpf version of this patch.
>

What is your proposal for BPF? How do you intend to add attach points
(attach_type) for policy? Is it still going to be per cgroup?

Balbir Singh
