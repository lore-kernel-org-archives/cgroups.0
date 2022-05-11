From: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Wed, 11 May 2022 03:17:44 +0000
Message-ID: <627b2ad9.1c69fb81.f2bc7.19d6@mx.google.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
 <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
 <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
 <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
 <6278fa75.1c69fb81.9c598.f794@mx.google.com>
 <Ynj/l+pyFJxKfcbQ@dhcp22.suse.cz>
 <6279c354.1c69fb81.7f6c1.15e0@mx.google.com>
 <CAHbLzkqztB+NXVcxtd7bVo7onH6AcMJ3JWCAHHqH3OAdbZsMOQ@mail.gmail.com>
 <627b1d39.1c69fb81.fe952.6426@mx.google.com>
 <CALvZod5aqZjUE8BBQZxwHDBuSWOSEAOqW4_xE22Am0sGZZs4sw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=aeafOzN+KhT6xUt6Ci9vzPISfyWvX+i2zyBA9FualR8=;
        b=mjeGKZrdMWExTOJ6nPIF/ql6gb2ybbylcxERjkn8bZkniAbu+OkCrh5PZomXGZrpa4
         CyAZIcyYNW2HF13bB/wwbu5e3Bw36U7BWCWdePNlS1qBWVrwwatm6VabqeT3f4wJAX74
         f5/BgNdy4+Sdo3Im6khhbbqCdAb4FfNDDIl6lM7EezVKU7aCEWIO2yhAR2P1L1HoLzTU
         ZjPAz4p2JhBF9H6znOW4wi8xBa1OdS7MAMM+DbDy0ayTCYCOKfm7nd6ej2fKBn61MoPe
         XeCCJY2JjdzZJYmI8gwKcfzJxvgd+8RnQSG+0PrjgGXJ9ybnx7vpK5WA4gD7IfKkgc0O
         wSkQ==
Content-Disposition: inline
In-Reply-To: <CALvZod5aqZjUE8BBQZxwHDBuSWOSEAOqW4_xE22Am0sGZZs4sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, William Kucharski <william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Tue, May 10, 2022 at 07:47:29PM -0700, Shakeel Butt wrote:
> On Tue, May 10, 2022 at 7:19 PM CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> [...]
> > > > >
> > > > > All controls in cgroup v2 should be hierarchical. This is really
> > > > > required for a proper delegation semantic.
> > > > >
> > > >
> > > > Could we align to the semantic of /sys/fs/cgroup/memory.swappiness?
> > > > Some distributions like Ubuntu is still using cgroup v1.
> > >
> > > Other than enable flag, how would you handle the defrag flag
> > > hierarchically? It is much more complicated.
> >
> > Refer to memory.swappiness for cgroup, this new interface better be independent.
> 
> Let me give my 0.02. I buy the use-case of Admin restricting THPs to
> low priority jobs but I don't think memory controller is the right
> place to enforce that policy. Michal gave one way (prctl()) to enforce
> that policy. Have you explored the BPF way to enforce this policy?

Thanks!
prctl()(at least for the latest version) only support disable THP, it's semantic is
not very perfection. Maybe we could expand the prctl() for THP?
BPF maybe a way to realize more fine-grained THP control. But I think semantic comes
first.

So what about realize three layers of THP controller? All kinds of users maybe satisfy:
    Layer 1: all system, realized. see /sys/kernel/mm/transparent_hugepage/enabled.
    Layer 2: container/cgroup, unrealized. useful for user who treat container as
lightweight virtual machine, let this overide layer 1.
    Layer 3: process, partial realized. see prctl(), let this overide layer 1 & 2.
