From: Michal Hocko <mhocko@suse.com>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Thu, 25 Aug 2022 10:50:41 +0200
Message-ID: <Ywc34ci5XUMXOSYA@dhcp22.suse.cz>
References: <YwSQ4APOu/H7lYGL@dhcp22.suse.cz>
 <CAGWkznGd6mgareABseMKY5p0f1=5dkfVkj=NS7_B6OkXBYSwyw@mail.gmail.com>
 <YwS/S9Sd1OWnT81Q@dhcp22.suse.cz>
 <CAGWkznGYLyF+njUB0gFF3JVdThnK9JaNsqxXYFhbdSwEQpCxvA@mail.gmail.com>
 <YwXYVjRpXQjQMsxr@dhcp22.suse.cz>
 <CAGWkznEqX3DwHW_owiK+HuuQ-HsUYK4vKmLhSxgzGn20Vzid2A@mail.gmail.com>
 <YwX89JCQCKMMYdG9@dhcp22.suse.cz>
 <CAGWkznF+dBjLzAxMMXWYSZ_5q3KA-ou0P7XM7jSYN7JSRp8N0w@mail.gmail.com>
 <YwcZctA2S3Sd0LBN@dhcp22.suse.cz>
 <CAGWkznH5gQXigdLx=fwdL0uqdGx4WE9QP8b8cbWFxr=Rdg-CZQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661417442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zP6YQmZN7163OEbBczeU7FAkSDwVdl5LC3HTPoybyrM=;
        b=FXgUGZB+osz5E4JAckwNcEMAP2NfQm322eTKa+A9/pgC4y/sgW0XuNYetBenNlNDIxO/fw
        vWwoqK/wBxIIugpIEItM7OO/MDtdysSicXWJ68yqmO/LCq9pJTk8VfZAR9VnTVJV5y6C7h
        8JbaOXXlGeGJ4aCK+1vxzqr2MxONwPg=
Content-Disposition: inline
In-Reply-To: <CAGWkznH5gQXigdLx=fwdL0uqdGx4WE9QP8b8cbWFxr=Rdg-CZQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Shakeel Butt <shakeelb@google.com>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Ke Wang <ke.wang@unisoc.com>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>

On Thu 25-08-22 16:34:04, Zhaoyang Huang wrote:
> On Thu, Aug 25, 2022 at 2:40 PM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Thu 25-08-22 08:43:52, Zhaoyang Huang wrote:
> > > On Wed, Aug 24, 2022 at 6:27 PM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Wed 24-08-22 17:34:42, Zhaoyang Huang wrote:
> > [...]
> > > > > IMHO, charging the pages which out of explicitly memory
> > > > > enabled group to root could solve all of the above constraints with no
> > > > > harm.
> > > >
> > > > This would break the hierarchical property of the controller. So a
> > > > strong no no. Consider the following example
> > > >
> > > >        root
> > > >         |
> > > >         A
> > > > controllers="memory"
> > > > memory.max = 1G
> > > > subtree_control=""
> > > > |      |      |
> > > > A1     A2     A3
> > > >
> > > > althought A1,2,3 do not have their memory controller enabled explicitly
> > > > they are still constrained by the A memcg limit. If you just charge to
> > > > the root because it doesn't have memory controller enabled explicitly
> > > > then you just evade that constrain. I hope you understand why that is a
> > > > problem.
> > > IMO, A1-A3 should be explicitly enabled via echo "+memory" >
> > > A/subtree_control since memory.max has been set.
> >
> > You seem to be missing the point I've triedy to make here. It is not
> > about how the respective subtree should or shouldn't be configured. It
> > is about the hierarchical behavior. Configuration at a higher level should be
> > enforced under subtree no matter how that subtree decides to
> > enabled/disable controllers. Such subtree might have beeb delegated
> > and configured differently yet the constrain should be still applied.
> > See the point?
> >
> > What you seem to be proposing is similar to cgroup v1 use_hierarchy
> > configuration. It has been decided that this is undesirable very early
> > in the cgroup v2 development because it make delegation impossible
> > (among other reasons).
> Ok, I would like to know how AA3 achieve the goal of competing with A1
> and A2 for cpu but keep memory out of control under current policy?
>         root
>          |
>          A
>  controllers="memory,cpu"
>  memory.max = 1G
>  subtree_control="memory,cpu"
>  |      |            |
>  A1     A2     A3 subtree_control="cpu"
>                       |      |
>                     AA3   AA4 controllers="cpu"

I cannot really give you configuration you want without understanding
what you are trying to achieve and why do you need it that way. Really,
you can construct arbitrary hierarchies and only a very small subset of
them actually makes sense. So far you have been very terse at your goals
and intentions but rather demanding on the underlying mechanisms. This
doesn't really makes the discussion productive.

I hope you have at least understood that hierarchical property of the
cgroup v2 is a must and it won't change. If you need a help to construct
hierarchy for your specific workload I would recommend to clearly state
your final goal and reasoning behind. Maybe you will get a more specific
help that way. Good luck!
-- 
Michal Hocko
SUSE Labs
