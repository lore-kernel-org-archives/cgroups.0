From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Tue, 23 Aug 2022 10:31:57 +0800
Message-ID: <CAGWkznEB+R0YBaBFBL7dPqs8R=qKC6+ixTWEGCYy2PaczXkaPA@mail.gmail.com>
References: <1660908562-17409-1-git-send-email-zhaoyang.huang@unisoc.com>
 <Yv+6YjaGAv52yvq9@slm.duckdns.org> <CALvZod7QdLSMdBoD2WztL72qS8kJe7F79JuCH6t19rRcw6Pn1w@mail.gmail.com>
 <Yv/EArPDTcCrGqJh@slm.duckdns.org> <YwNpI1ydy0yDnBH0@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=azDpKc6FmKTWyiu0fmvIHIHwLpZTiSK1Vlo7KGhRPTI=;
        b=mOKeqhKYQhMwTLb/MJ8y4BKHtrVT0tL2CLpCqVd982RWh8CKypL1YXMQXH9RXkOYQr
         svAS8E3tjh/3TZXskHT6eiLzVii7BtFjyyzENE09sgcCl7PJOTZQWNQD8oFDmCLcPXxa
         R/SMm/X+qEvkdwTnfYLBoFOyLKxMa7H4tewBNQKxpr2iMRa4oHMf6GfZsxsD05kpWw6K
         L/savuxwWhzpBfzVfVKYEpe6LpvurZbJQkwKDJE7yHE72w3Ud+yG4pGeBHqQHKtM7eGC
         4y4R1fkzSDJznz1sFG8M7pcRZw1BIJ/Zv3f9VGj0uvD2h7jmIDOaTWdLm9GEI9Yyev0m
         4fOA==
In-Reply-To: <YwNpI1ydy0yDnBH0@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Shakeel Butt <shakeelb@google.com>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Ke Wang <ke.wang@unisoc.com>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>

On Mon, Aug 22, 2022 at 7:31 PM Michal Hocko <mhocko@suse.com> wrote:
>
> On Fri 19-08-22 07:10:26, Tejun Heo wrote:
> > On Fri, Aug 19, 2022 at 10:08:59AM -0700, Shakeel Butt wrote:
> > > On Fri, Aug 19, 2022 at 9:29 AM Tejun Heo <tj@kernel.org> wrote:
> > > >
> > > > On Fri, Aug 19, 2022 at 07:29:22PM +0800, zhaoyang.huang wrote:
> > > > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > > >
> > > > > It is observed in android system where per-app cgroup is demanded by freezer
> > > > > subsys and part of groups require memory control. The hierarchy could be simplized
> > > > > as bellowing where memory charged on group B abserved while we only want have
> > > > > group E's memory be controlled and B's descendants compete freely for memory.
> > > > > This should be the consequences of unified hierarchy.
> > > > > Under this scenario, less efficient memory reclaim is observed when comparing
> > > > > with no memory control. It is believed that multi LRU scanning introduces some
> > > > > of the overhead. Furthermore, page thrashing is also heavier than global LRU
> > > > > which could be the consequences of partial failure of WORKINGSET mechanism as
> > > > > LRU is too short to protect the active pages.
> > > > >
> > > > > A(subtree_control = memory) - B(subtree_control = NULL) - C()
> > > > >                                                       \ D()
> > > > >                           - E(subtree_control = memory) - F()
> > > > >                                                         \ G()
> > > > >
> > > > > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > >
> > > > Just in case it wasn't clear.
> > > >
> > > > Nacked-by: Tejun Heo <tj@kernel.org>
> > > >
> > > > Thanks.
> > > >
> > >
> > > Was there a previous discussion on this? The commit message is unreadable.
> >
> > http://lkml.kernel.org/r/1660298966-11493-1-git-send-email-zhaoyang.huang@unisoc.com
>
> Even that discussion doesn't really explain the real underlying problem.
> There are statements about inefficiency and trashing without any further
> details or clarifications.
I would like to quote the comments from google side for more details
which can also be observed from different vendors.
"Also be advised that when you enable memcg v2 you will be using
per-app memcg configuration which implies noticeable overhead because
every app will have its own group. For example pagefault path will
regress by about 15%. And obviously there will be some memory overhead
as well. That's the reason we don't enable them in Android by
default."
>
> My very vague understanding is that the Android system would like to
> freeze specific applications and for that it requires each application
> to live in its own cgroup. This clashes with a requirement to age and
> reclaim memory on a different granularity (aka no per process reclaim).
> So in fact something that cgroup v1 would achieve by having 2
> hierarchies, one for the freezer which would have a dedicated cgroup for
> each application and the other for the memory controller where tasks are
> grouped by a different criteria. This would rule out that a global (or
> any external memory pressure) reclaim would age LRUs that contain a mix
> bag of application pages rather than iterate over per-application LRUs.
> Is that understanding correct?
Correct, this is just our confusion. Besides, we believe that charge
the pages to implicit memory enabled parent control group doesn't make
sense as the memory cannot be managed at all.
> --
> Michal Hocko
> SUSE Labs
