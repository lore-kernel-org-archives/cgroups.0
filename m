From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v10 0/3] Charge loop device i/o to issuing cgroup
Date: Thu, 18 Mar 2021 17:56:28 -0700
Message-ID: <CALvZod6FMQQC17Zsu9xoKs=dFWaJdMC2Qk3YiDPUUQHx8teLYg@mail.gmail.com>
References: <20210316153655.500806-1-schatzberg.dan@gmail.com>
 <7ca79335-026f-2511-2b58-0e9f32caa063@kernel.dk> <CALvZod6tvrZ_sj=BnM4baQepexwvOPREx3qe5ZJrmqftrqwBEA@mail.gmail.com>
 <8c32421c-4bd8-ec46-f1d0-25996956f4da@kernel.dk> <20210318164625.1018062b042e540bd83bb08e@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6gTh132+rc2eC7+iuJdnPJjGut8rCOk0bv/jkoJwjos=;
        b=dKTes1FKvp/DzPE43p1AwRBeRVKFON9qL1XwrpMNHUbvBm7Q85xfRixMCaNBCkPDxx
         0f3qo6HyoxcRQkWCXA7TtPgH5vMcUYGmA00b6LpeYS9SUx5dWhNQ5hHuH8Ii4ULjkflM
         DigmBVyvCZL7eApstVvrAD96tXpWWwyXd6EVlj/yWRcT/pSoyuIBa19KQlI93IT5oxFQ
         jQPgTzIe2XuV+LhQ5xRI/GFv83yN7Oy3IDPCR1nXVyyWo3aDBIdHKjeVV0VuKMe79nnm
         gVIggj7RDj13QlGC0t80BCt3pm87t/v49IonN9jOSlziU2Jz2l93SA0lqzWnN8OIDREF
         2IfA==
In-Reply-To: <20210318164625.1018062b042e540bd83bb08e@linux-foundation.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Schatzberg <schatzberg.dan@gmail.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>

On Thu, Mar 18, 2021 at 4:46 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 18 Mar 2021 10:00:17 -0600 Jens Axboe <axboe@kernel.dk> wrote:
>
> > On 3/18/21 9:53 AM, Shakeel Butt wrote:
> > > On Wed, Mar 17, 2021 at 3:30 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>
> > >> On 3/16/21 9:36 AM, Dan Schatzberg wrote:
> > >>> No major changes, just rebasing and resubmitting
> > >>
> > >> Applied for 5.13, thanks.
> > >>
> > >
> > > I have requested a couple of changes in the patch series. Can this
> > > applied series still be changed or new patches are required?
> >
> > I have nothing sitting on top of it for now, so as far as I'm concerned
> > we can apply a new series instead. Then we can also fold in that fix
> > from Colin that he posted this morning...
>
> The collision in memcontrol.c is a pain, but I guess as this is mainly
> a loop patch, the block tree is an appropriate route.
>
> Here's the collision between "mm: Charge active memcg when no mm is
> set" and Shakeels's
> https://lkml.kernel.org/r/20210305212639.775498-1-shakeelb@google.com
>
>
> --- mm/memcontrol.c
> +++ mm/memcontrol.c
> @@ -6728,8 +6730,15 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
>                 rcu_read_unlock();
>         }
>
> -       if (!memcg)
> -               memcg = get_mem_cgroup_from_mm(mm);
> +       if (!memcg) {
> +               if (!mm) {
> +                       memcg = get_mem_cgroup_from_current();
> +                       if (!memcg)
> +                               memcg = get_mem_cgroup_from_mm(current->mm);
> +               } else {
> +                       memcg = get_mem_cgroup_from_mm(mm);
> +               }
> +       }
>
>         ret = try_charge(memcg, gfp_mask, nr_pages);
>         if (ret)
>
>
> Which I resolved thusly:
>
> int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
> {
>         struct mem_cgroup *memcg;
>         int ret;
>
>         if (mem_cgroup_disabled())
>                 return 0;
>
>         if (!mm) {
>                 memcg = get_mem_cgroup_from_current();
>                 (!memcg)
>                         memcg = get_mem_cgroup_from_mm(current->mm);
>         } else {
>                 memcg = get_mem_cgroup_from_mm(mm);
>         }
>
>         ret = __mem_cgroup_charge(page, memcg, gfp_mask);
>         css_put(&memcg->css);
>
>         return ret;
> }
>

We need something similar for mem_cgroup_swapin_charge_page() as well.

It is better to take this series in mm tree and Jens is ok with that [1].

[1] https://lore.kernel.org/linux-next/4fea89a5-0e18-0791-18a8-4c5907b0d2c4@kernel.dk/
