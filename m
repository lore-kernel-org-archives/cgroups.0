From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm: memcg/slab: Fix return child memcg objcg for root
 memcg
Date: Thu, 29 Oct 2020 10:09:55 -0700
Message-ID: <20201029170955.GI827280@carbon.dhcp.thefacebook.com>
References: <20201028035013.99711-1-songmuchun@bytedance.com>
 <CALvZod6p_y2fTEK5fzAL=JfPsguqYbttgWC4_GPc=rF1PsN6TQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=APzs3PbGPrjNJb2CBBRZg3gOxaBp2qvf/TPBM3BJxtE=;
 b=mFHcE/Ganwj37eCh8LsANZiq12+Zi6jsuE7egjFBUUU0O9DPu5/U7/6VBDxVPUUjH1Ra
 kX+5rZkG3BFFKUjJDpZwzuqQUd9pnopvyAVCpzZARdVY6ktHvYdKa41P6yROo9EXqbXJ
 y1uWvYdBscLQTZ+W+xJKGMX5xyiC9rECgqg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APzs3PbGPrjNJb2CBBRZg3gOxaBp2qvf/TPBM3BJxtE=;
 b=k87AMIJbDtKr0USW0j7xOCtUVCgMXPDqmBOD99pWO3XL+AkPRG2mLBHEx/xdMs3Y5mTDgV9ykvQWDs6zvunh8I0DLMUTp3/69jCL7bEMWvI/H5u/L4GMUtRW7Z3IxEGssqdSQEnLCW89ozIQb4UOmEECz9BOdiuCkOs9/bx+Dm8=
Content-Disposition: inline
In-Reply-To: <CALvZod6p_y2fTEK5fzAL=JfPsguqYbttgWC4_GPc=rF1PsN6TQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Yafang Shao <laoar.shao@gmail.com>, Chris Down <chris@chrisdown.name>, Christian Brauner <christian.brauner@ubuntu.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, Suren Baghdasaryan <surenb@google.com>, areber@redhat.com, Marco Elver <elver@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Thu, Oct 29, 2020 at 08:48:45AM -0700, Shakeel Butt wrote:
> On Tue, Oct 27, 2020 at 8:50 PM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > Consider the following memcg hierarchy.
> >
> >                     root
> >                    /    \
> >                   A      B
> >
> > If we get the objcg of memcg A failed,
> 
> Please fix the above statement.
> 
> > the get_obj_cgroup_from_current
> > can return the wrong objcg for the root memcg.
> >
> > Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  changelog in v2:
> >  1. Do not use a comparison with the root_mem_cgroup
> >
> >  mm/memcontrol.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1337775b04f3..8c8b4c3ed5a0 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2961,6 +2961,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
> >                 objcg = rcu_dereference(memcg->objcg);
> >                 if (objcg && obj_cgroup_tryget(objcg))
> >                         break;
> > +               objcg = NULL;
> 
> Roman, in your cleanup, are you planning to have objcg for root memcg as well?

Yes. I'll just change the for loop to include the root_mem_cgroup.

Thanks!
