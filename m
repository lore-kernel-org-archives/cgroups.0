From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Thu, 25 Aug 2022 18:11:09 +0800
Message-ID: <CAGWkznHL_G3OoAc5gJ+iwxqxonr21-fU+F4T2gkpXH68keLpuQ@mail.gmail.com>
References: <YwSQ4APOu/H7lYGL@dhcp22.suse.cz> <CAGWkznGd6mgareABseMKY5p0f1=5dkfVkj=NS7_B6OkXBYSwyw@mail.gmail.com>
 <YwS/S9Sd1OWnT81Q@dhcp22.suse.cz> <CAGWkznGYLyF+njUB0gFF3JVdThnK9JaNsqxXYFhbdSwEQpCxvA@mail.gmail.com>
 <YwXYVjRpXQjQMsxr@dhcp22.suse.cz> <CAGWkznEqX3DwHW_owiK+HuuQ-HsUYK4vKmLhSxgzGn20Vzid2A@mail.gmail.com>
 <YwX89JCQCKMMYdG9@dhcp22.suse.cz> <CAGWkznF+dBjLzAxMMXWYSZ_5q3KA-ou0P7XM7jSYN7JSRp8N0w@mail.gmail.com>
 <YwcZctA2S3Sd0LBN@dhcp22.suse.cz> <CAGWkznH5gQXigdLx=fwdL0uqdGx4WE9QP8b8cbWFxr=Rdg-CZQ@mail.gmail.com>
 <Ywc34ci5XUMXOSYA@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vnEJEeMF2AE4KxAkE8pFWCq29ZFBba+mEDUrxnkbubM=;
        b=mxRAvOKhdn8T9NwgbWp0p3+x7XpqNID2pV90xgRQeuY9cXpHX8jpfcu515trEPmGIk
         yXpm6WKMG2ujC33kXZlEbt7CFaCFh2qqB2KO+AHFU8Z8NQDWGNqLDBsM+X5i0DnkGX2K
         dr7liyUGjF4cymJwj1hyeZsoVXLqownOuwKrgcStuLIlTIY/bGCjk7I1DpT1RuA6dQs4
         soXomcu2m/MrFqNhsPUFwGIFxOVpa+GANbCZ75+y/TBD/U5JunxlxfAkWtHfFnLaNo/p
         SU+aK56MqrnU18R7CLczUwjBW7rYEdtcdvgtKogZzNkAQeSKd32wCBNkEOZzQzGioN3t
         C+WQ==
In-Reply-To: <Ywc34ci5XUMXOSYA-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Thu, Aug 25, 2022 at 4:50 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 25-08-22 16:34:04, Zhaoyang Huang wrote:
> > On Thu, Aug 25, 2022 at 2:40 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Thu 25-08-22 08:43:52, Zhaoyang Huang wrote:
> > > > On Wed, Aug 24, 2022 at 6:27 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > >
> > > > > On Wed 24-08-22 17:34:42, Zhaoyang Huang wrote:
> > > [...]
> > > > > > IMHO, charging the pages which out of explicitly memory
> > > > > > enabled group to root could solve all of the above constraints with no
> > > > > > harm.
> > > > >
> > > > > This would break the hierarchical property of the controller. So a
> > > > > strong no no. Consider the following example
> > > > >
> > > > >        root
> > > > >         |
> > > > >         A
> > > > > controllers="memory"
> > > > > memory.max = 1G
> > > > > subtree_control=""
> > > > > |      |      |
> > > > > A1     A2     A3
> > > > >
> > > > > althought A1,2,3 do not have their memory controller enabled explicitly
> > > > > they are still constrained by the A memcg limit. If you just charge to
> > > > > the root because it doesn't have memory controller enabled explicitly
> > > > > then you just evade that constrain. I hope you understand why that is a
> > > > > problem.
> > > > IMO, A1-A3 should be explicitly enabled via echo "+memory" >
> > > > A/subtree_control since memory.max has been set.
> > >
> > > You seem to be missing the point I've triedy to make here. It is not
> > > about how the respective subtree should or shouldn't be configured. It
> > > is about the hierarchical behavior. Configuration at a higher level should be
> > > enforced under subtree no matter how that subtree decides to
> > > enabled/disable controllers. Such subtree might have beeb delegated
> > > and configured differently yet the constrain should be still applied.
> > > See the point?
> > >
> > > What you seem to be proposing is similar to cgroup v1 use_hierarchy
> > > configuration. It has been decided that this is undesirable very early
> > > in the cgroup v2 development because it make delegation impossible
> > > (among other reasons).
> > Ok, I would like to know how AA3 achieve the goal of competing with A1
> > and A2 for cpu but keep memory out of control under current policy?
> >         root
> >          |
> >          A
> >  controllers="memory,cpu"
> >  memory.max = 1G
> >  subtree_control="memory,cpu"
> >  |      |            |
> >  A1     A2     A3 subtree_control="cpu"
> >                       |      |
> >                     AA3   AA4 controllers="cpu"
>
> I cannot really give you configuration you want without understanding
> what you are trying to achieve and why do you need it that way. Really,
> you can construct arbitrary hierarchies and only a very small subset of
> them actually makes sense. So far you have been very terse at your goals
> and intentions but rather demanding on the underlying mechanisms. This
> doesn't really makes the discussion productive.
>
> I hope you have at least understood that hierarchical property of the
> cgroup v2 is a must and it won't change. If you need a help to construct
> hierarchy for your specific workload I would recommend to clearly state
> your final goal and reasoning behind. Maybe you will get a more specific
> help that way. Good luck!
Sorry for any misunderstanding among the discussion. My purpose is
real and simple as I have stated from the very beginning that I would
like to have per-app cgroup hierarchy to charge memory to root if it
is not enabled explicitly for memory. The reason has also been stated
like reclaim and workingset regression in suren's report. I don't
think my proposal will do any harm to current v2's mechanism besides
asking for the admin echo "+memory" to their desire group.
> --
> Michal Hocko
> SUSE Labs
