From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH 4/5] mm: memcg/slab: Fix root memcg vmstats
Date: Thu, 29 Oct 2020 14:15:43 +0800
Message-ID: <CAMZfGtW9wa=S7+OQw_R+4LU5VzcN0H0OUPw-2XfTAJFniQN3TA@mail.gmail.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-5-songmuchun@bytedance.com> <20201027184835.GB827280@carbon.dhcp.thefacebook.com>
 <CAMZfGtU1aViokYk1hkHbYEiqW5QNi49UTd-QTrkycLqj6Q+-8g@mail.gmail.com> <20201029001408.GF827280@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n7NRtz56PDrI9TlnLNjgdlxbuOLi2alt2q22qA5ZMDM=;
        b=jQ2Vn+hlZsZS9o3ITt59L/OK0Z6t3j2+1+WF33ekNAIhXNb3Pu44yIxwScTO18PQTZ
         EYIkIi/RZVDGQZSc16nb7gnKbf8Xh0MEFCILhPzbYX2xZln+4wzKEfRtQVqiAtcH2697
         LVLQcf7/Kwy7MgKBYXCW7Xx/4OnuqeZTrGumdH0W/R3oKdB9powFDeomnAWQYWgrFda+
         I7CFDxh910gYVWYr5s/MJvpZs+/Bd1/UTbZIqYqC7sRuRDRY1FeWOaWNdnXJMxVVRNqa
         QduYL17Ccef4j2aAPbpwov6T3yydVsku7bFJMZ5h6U8wzCB3QWq8SCQPcfV+dTucgKjk
         QvkA==
In-Reply-To: <20201029001408.GF827280@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, laoar.shao@gmail.com, Chris Down <chris@chrisdown.name>, Christian Brauner <christian.brauner@ubuntu.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, Suren Baghdasaryan <surenb@google.com>, areber@redhat.com, Marco Elver <elver@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>

On Thu, Oct 29, 2020 at 8:14 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Wed, Oct 28, 2020 at 10:56:20AM +0800, Muchun Song wrote:
> > On Wed, Oct 28, 2020 at 2:48 AM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Tue, Oct 27, 2020 at 04:02:55PM +0800, Muchun Song wrote:
> > > > If we reparent the slab objects to the root memcg, when we free
> > > > the slab object, we need to update the per-memcg vmstats to keep
> > > > it correct for the root memcg. Now this at least affects the vmstat
> > > > of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
> > > > size is smaller than the PAGE_SIZE.
> > > >
> > > > Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
> > > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > >
> > > Can you, please, drop this patch for now?
> > >
> > > I'm working on a bigger cleanup related to the handling of the root memory
> > > cgroup (I sent a link earlier in this thread), which already does a similar change.
> > > There are several issues like this one, so it will be nice to fix them all at once.
> >
> > I have read the patch of https://lkml.org/lkml/2020/10/14/869. You
> > mean this patch
> > fixes this issue? It chooses to uncharge the root memcg. But here we may need to
> > uncharge the root memcg to keep root vmstats correct. If we do not do
> > this, we can
> > see the wrong vmstats via root memory.stat(e.g. NR_KERNEL_STACK_KB).
>
> I pointed at a different patch in the same thread (it looks like you read the first one):
> https://lkml.org/lkml/2020/10/21/612

Got it. Thanks. That is fine to me.

>
> It contained the following part:
>
> @@ -868,7 +860,7 @@ void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
>         memcg = mem_cgroup_from_obj(p);
>
>         /* Untracked pages have no memcg, no lruvec. Update only the node */
> -       if (!memcg || memcg == root_mem_cgroup) {
> +       if (!memcg) {
>                 __mod_node_page_state(pgdat, idx, val);
>         } else {
>                 lruvec = mem_cgroup_lruvec(memcg, pgdat);
>
> So it's exactly what your patch does.
>
> Thanks!



-- 
Yours,
Muchun
