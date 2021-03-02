From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH 2/5] mm: memcontrol: make page_memcg{_rcu}
 only applicable for non-kmem page
Date: Tue, 2 Mar 2021 11:49:21 +0800
Message-ID: <CAMZfGtWJRS=Cjx5HKt02-pzw7UOn-qhwR21fmDS6fcpntprbCQ@mail.gmail.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-3-songmuchun@bytedance.com> <CALvZod7sysj0+wrzLTXnwn7s_Gf-V2eFPJ6cLcoRmR0LdAFk0Q@mail.gmail.com>
 <YD08A+fEp/4pw10I@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zR9rZ5Vo7n4Jx4LSiCHtKNBAWL0tmz/mJnFtTbDqbIU=;
        b=v9fAqyuNhDoUw3dtU1vnpYtIU5IhN9QKuc3uYH/Oncb9JTBA0DAi9YtlWkm2stJ90r
         +PRYhf+SGzC8j9uqnJHPm3vCzMPuzAlnRV+vZMvYST7E5TMq44Rfk3kwAWcFcB46Sq41
         vFesKUHLPs83TWyyQCS5dXK5ciQhNVQKs4VGeOCSJchW2M9Dd07uGTBp4LJtvxYatGgm
         sha9dr2oAKShevSBQhU6iX58QJjZVzwmCF0nNJCAcZeNG/9JX/jUobwm9Bc9XIzTh7wD
         oMMjslfibt+eQ+1H+3/V5FkViK5z1Qxnvh3OuG/KKQ6i1oEnosdWfybQ1+34pqH7hfV2
         +ufg==
In-Reply-To: <YD08A+fEp/4pw10I@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org, Ingo Molnar <mingo@redhat.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>, Benjamin Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, bristot@redhat.com, Michal Hocko <mhocko@kernel.org>

On Tue, Mar 2, 2021 at 3:09 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> Muchun, can you please reduce the CC list to mm/memcg folks only for
> the next submission? I think probably 80% of the current recipients
> don't care ;-)

At first, I just used scripts/get_maintainer.pl to get the
CC list. I will reduce the CC list in the next version.
Thanks.

>
> On Mon, Mar 01, 2021 at 10:11:45AM -0800, Shakeel Butt wrote:
> > On Sun, Feb 28, 2021 at 10:25 PM Muchun Song <songmuchun@bytedance.com> wrote:
> > >
> > > We want to reuse the obj_cgroup APIs to reparent the kmem pages when
> > > the memcg offlined. If we do this, we should store an object cgroup
> > > pointer to page->memcg_data for the kmem pages.
> > >
> > > Finally, page->memcg_data can have 3 different meanings.
> > >
> > >   1) For the slab pages, page->memcg_data points to an object cgroups
> > >      vector.
> > >
> > >   2) For the kmem pages (exclude the slab pages), page->memcg_data
> > >      points to an object cgroup.
> > >
> > >   3) For the user pages (e.g. the LRU pages), page->memcg_data points
> > >      to a memory cgroup.
> > >
> > > Currently we always get the memcg associated with a page via page_memcg
> > > or page_memcg_rcu. page_memcg_check is special, it has to be used in
> > > cases when it's not known if a page has an associated memory cgroup
> > > pointer or an object cgroups vector. Because the page->memcg_data of
> > > the kmem page is not pointing to a memory cgroup in the later patch,
> > > the page_memcg and page_memcg_rcu cannot be applicable for the kmem
> > > pages. In this patch, we introduce page_memcg_kmem to get the memcg
> > > associated with the kmem pages. And make page_memcg and page_memcg_rcu
> > > no longer apply to the kmem pages.
> > >
> > > In the end, there are 4 helpers to get the memcg associated with a
> > > page. The usage is as follows.
> > >
> > >   1) Get the memory cgroup associated with a non-kmem page (e.g. the LRU
> > >      pages).
> > >
> > >      - page_memcg()
> > >      - page_memcg_rcu()
> >
> > Can you rename these to page_memcg_lru[_rcu] to make them explicitly
> > for LRU pages?
>
> The next patch removes page_memcg_kmem() again to replace it with
> page_objcg(). That should (luckily) remove the need for this
> distinction and keep page_memcg() simple and obvious.
>
> It would be better to not introduce page_memcg_kmem() in the first
> place in this patch, IMO.

OK. I will follow your suggestion. Thanks.
