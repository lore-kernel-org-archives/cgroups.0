From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH 4/5] mm: memcontrol: move remote memcg
 charging APIs to CONFIG_MEMCG_KMEM
Date: Tue, 2 Mar 2021 12:12:16 +0800
Message-ID: <CAMZfGtXdPw41iFUjDbkkAwm+D3ut-U+GpZC3Zz9cvS2FTCCYzw@mail.gmail.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-5-songmuchun@bytedance.com> <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJaPLF9X1F6hvOBAXTHBgh9HYMVdoLjPILjLEfD7bkc=;
        b=YEZ1cocgpsBHNkw0q+n3c+WrJ0f5ZYMWZ5GgZymplzz/JjXP3J3GP3MQPyOD+t7hxj
         AsK2COA53kOesfdd7nTgEuKuQJ7B+1JaLSiIWqINpSswz1f453uWWv5cf5Zy9QVnSZdd
         X0vMaEoLsxLAVk5K6hSFHHKSylttTe535bfBlRj9YLzzI2p9d5SVShpMsGrjNw3iULbC
         +mik6ICMk5ltsWjqpAmuGCd/qH7Pw0q8Y8kTUadbUjZeBEzXHeBTNP0c+D7LqoTso/Yu
         kjJIpeToFr5LIiD+nTQahXyU61ghaF6X5hl9rGGDki1aC/DUcXPcY0IZd4brRdl8pXp+
         iUug==
In-Reply-To: <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>, Benjamin Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, bristot@redhat.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimi

On Tue, Mar 2, 2021 at 9:15 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Mon, Mar 01, 2021 at 02:22:26PM +0800, Muchun Song wrote:
> > The remote memcg charing APIs is a mechanism to charge kernel memory
> > to a given memcg. So we can move the infrastructure to the scope of
> > the CONFIG_MEMCG_KMEM.
>
> This is not a good idea, because there is nothing kmem-specific
> in the idea of remote charging, and we definitely will see cases
> when user memory is charged to the process different from the current.

Got it. Thanks for your reminder.


>
> >
> > As a bonus, on !CONFIG_MEMCG_KMEM build some functions and variables
> > can be compiled out.
> >
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  include/linux/sched.h    | 2 ++
> >  include/linux/sched/mm.h | 2 +-
> >  kernel/fork.c            | 2 +-
> >  mm/memcontrol.c          | 4 ++++
> >  4 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index ee46f5cab95b..c2d488eddf85 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1314,7 +1314,9 @@ struct task_struct {
> >
> >       /* Number of pages to reclaim on returning to userland: */
> >       unsigned int                    memcg_nr_pages_over_high;
> > +#endif
> >
> > +#ifdef CONFIG_MEMCG_KMEM
> >       /* Used by memcontrol for targeted memcg charge: */
> >       struct mem_cgroup               *active_memcg;
> >  #endif
> > diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> > index 1ae08b8462a4..64a72975270e 100644
> > --- a/include/linux/sched/mm.h
> > +++ b/include/linux/sched/mm.h
> > @@ -294,7 +294,7 @@ static inline void memalloc_nocma_restore(unsigned int flags)
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_MEMCG
> > +#ifdef CONFIG_MEMCG_KMEM
> >  DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
> >  /**
> >   * set_active_memcg - Starts the remote memcg charging scope.
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index d66cd1014211..d66718bc82d5 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -942,7 +942,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
> >       tsk->use_memdelay = 0;
> >  #endif
> >
> > -#ifdef CONFIG_MEMCG
> > +#ifdef CONFIG_MEMCG_KMEM
> >       tsk->active_memcg = NULL;
> >  #endif
> >       return tsk;
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 39cb8c5bf8b2..092dc4588b43 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -76,8 +76,10 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
> >
> >  struct mem_cgroup *root_mem_cgroup __read_mostly;
> >
> > +#ifdef CONFIG_MEMCG_KMEM
> >  /* Active memory cgroup to use from an interrupt context */
> >  DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
> > +#endif
> >
> >  /* Socket memory accounting disabled? */
> >  static bool cgroup_memory_nosocket;
> > @@ -1054,6 +1056,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
> >  }
> >  EXPORT_SYMBOL(get_mem_cgroup_from_mm);
> >
> > +#ifdef CONFIG_MEMCG_KMEM
> >  static __always_inline struct mem_cgroup *active_memcg(void)
> >  {
> >       if (in_interrupt())
> > @@ -1074,6 +1077,7 @@ static __always_inline bool memcg_kmem_bypass(void)
> >
> >       return false;
> >  }
> > +#endif
> >
> >  /**
> >   * mem_cgroup_iter - iterate over memory cgroup hierarchy
> > --
> > 2.11.0
> >
