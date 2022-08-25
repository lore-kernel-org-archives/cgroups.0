From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Thu, 25 Aug 2022 08:40:50 +0200
Message-ID: <YwcZctA2S3Sd0LBN@dhcp22.suse.cz>
References: <YwRjyx6wFLk8WTDe@dhcp22.suse.cz>
 <CAGWkznGaYTv4u4kOo-rupfyWzDNJXNKTchwP6dbUK-=UXWm47w@mail.gmail.com>
 <YwSQ4APOu/H7lYGL@dhcp22.suse.cz>
 <CAGWkznGd6mgareABseMKY5p0f1=5dkfVkj=NS7_B6OkXBYSwyw@mail.gmail.com>
 <YwS/S9Sd1OWnT81Q@dhcp22.suse.cz>
 <CAGWkznGYLyF+njUB0gFF3JVdThnK9JaNsqxXYFhbdSwEQpCxvA@mail.gmail.com>
 <YwXYVjRpXQjQMsxr@dhcp22.suse.cz>
 <CAGWkznEqX3DwHW_owiK+HuuQ-HsUYK4vKmLhSxgzGn20Vzid2A@mail.gmail.com>
 <YwX89JCQCKMMYdG9@dhcp22.suse.cz>
 <CAGWkznF+dBjLzAxMMXWYSZ_5q3KA-ou0P7XM7jSYN7JSRp8N0w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661409650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8tP0U7uO6jkjoWoaVJTMGffTLHsMTAeM7ZO+0Ttzpnc=;
        b=Rlq2EbXz/KoWktPrNnKN7AIXIeIrydmCssc+ZXhRb8K/2E3gz3XlPnDJOGqi2IIcPcmtAO
        /gA127K196XnzQb58YhLdftTVYTGJzLNuLnqgaP2dPun3n3mKuze7iKY/qiq73UzJvHzsO
        XCPRI/PrCt8PtA7mhOsqkjocr6NW3hs=
Content-Disposition: inline
In-Reply-To: <CAGWkznF+dBjLzAxMMXWYSZ_5q3KA-ou0P7XM7jSYN7JSRp8N0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Thu 25-08-22 08:43:52, Zhaoyang Huang wrote:
> On Wed, Aug 24, 2022 at 6:27 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Wed 24-08-22 17:34:42, Zhaoyang Huang wrote:
[...]
> > > IMHO, charging the pages which out of explicitly memory
> > > enabled group to root could solve all of the above constraints with no
> > > harm.
> >
> > This would break the hierarchical property of the controller. So a
> > strong no no. Consider the following example
> >
> >        root
> >         |
> >         A
> > controllers="memory"
> > memory.max = 1G
> > subtree_control=""
> > |      |      |
> > A1     A2     A3
> >
> > althought A1,2,3 do not have their memory controller enabled explicitly
> > they are still constrained by the A memcg limit. If you just charge to
> > the root because it doesn't have memory controller enabled explicitly
> > then you just evade that constrain. I hope you understand why that is a
> > problem.
> IMO, A1-A3 should be explicitly enabled via echo "+memory" >
> A/subtree_control since memory.max has been set.

You seem to be missing the point I've triedy to make here. It is not
about how the respective subtree should or shouldn't be configured. It
is about the hierarchical behavior. Configuration at a higher level should be
enforced under subtree no matter how that subtree decides to
enabled/disable controllers. Such subtree might have beeb delegated
and configured differently yet the constrain should be still applied.
See the point?

What you seem to be proposing is similar to cgroup v1 use_hierarchy
configuration. It has been decided that this is undesirable very early
in the cgroup v2 development because it make delegation impossible
(among other reasons).

-- 
Michal Hocko
SUSE Labs
