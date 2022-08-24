From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Wed, 24 Aug 2022 12:27:00 +0200
Message-ID: <YwX89JCQCKMMYdG9@dhcp22.suse.cz>
References: <YwNpI1ydy0yDnBH0@dhcp22.suse.cz>
 <CAGWkznEB+R0YBaBFBL7dPqs8R=qKC6+ixTWEGCYy2PaczXkaPA@mail.gmail.com>
 <YwRjyx6wFLk8WTDe@dhcp22.suse.cz>
 <CAGWkznGaYTv4u4kOo-rupfyWzDNJXNKTchwP6dbUK-=UXWm47w@mail.gmail.com>
 <YwSQ4APOu/H7lYGL@dhcp22.suse.cz>
 <CAGWkznGd6mgareABseMKY5p0f1=5dkfVkj=NS7_B6OkXBYSwyw@mail.gmail.com>
 <YwS/S9Sd1OWnT81Q@dhcp22.suse.cz>
 <CAGWkznGYLyF+njUB0gFF3JVdThnK9JaNsqxXYFhbdSwEQpCxvA@mail.gmail.com>
 <YwXYVjRpXQjQMsxr@dhcp22.suse.cz>
 <CAGWkznEqX3DwHW_owiK+HuuQ-HsUYK4vKmLhSxgzGn20Vzid2A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661336821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=svip1HnOF9D7Fl9aKofEvyk0pEgENUVlEuB1mZtboTA=;
        b=BSwbM9o5a63Dsl3aydVUid7PDlzXWhAjXTXwpvHPRto/Y+Z4jx+DSo3SpxBtt/QERnMVCr
        Bsy6tdYVt8qrRFwuly1qta1c5/YJ/QwiiPW6MwVlDOnVjadS+2kc3loarhh3eYS9c9OEfd
        Ry2BcmegFWJQ3RRPza792trSufbhx4o=
Content-Disposition: inline
In-Reply-To: <CAGWkznEqX3DwHW_owiK+HuuQ-HsUYK4vKmLhSxgzGn20Vzid2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Wed 24-08-22 17:34:42, Zhaoyang Huang wrote:
> On Wed, Aug 24, 2022 at 3:50 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Wed 24-08-22 10:23:14, Zhaoyang Huang wrote:
> > > On Tue, Aug 23, 2022 at 7:51 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > [...]
> > > > One way to achieve that would be shaping the hierarchy the following way
> > > >             root
> > > >         /         \
> > > > no_memcg[1]      memcg[2]
> > > > ||||||||         |||||
> > > > app_cgroups     app_cgroups
> > > >
> > > > with
> > > > no_memcg.subtree_control = ""
> > > > memcg.subtree_control = memory
> > > >
> > > > no?
> > > According to my understanding, No as there will be no no_memcg. All
> > > children groups under root would have its cgroup.controllers = memory
> > > as long as root has memory enabled.
> >
> > Correct
> >
> > > Under this circumstance, all
> > > descendants group under 'no_memcg' will charge memory to its parent
> > > group.
> >
> > Correct. And why is that a problem? I thought you main concern was a per
> > application LRUs. With the above configuration all app_cgroups which do
> > not require an explicit memory control will share the same (no_memcg)
> > LRU and they will be aged together.
> I can't agree since this indicates the processes want memory free
> depending on a specific hierarchy which could have been determined by
> other subsys.

I really fail to understand your requirements.

> IMHO, charging the pages which out of explicitly memory
> enabled group to root could solve all of the above constraints with no
> harm.

This would break the hierarchical property of the controller. So a
strong no no. Consider the following example

       root
	|
	A
controllers="memory"
memory.max = 1G
subtree_control=""
|      |      |
A1     A2     A3

althought A1,2,3 do not have their memory controller enabled explicitly
they are still constrained by the A memcg limit. If you just charge to
the root because it doesn't have memory controller enabled explicitly
then you just evade that constrain. I hope you understand why that is a
problem.
-- 
Michal Hocko
SUSE Labs
