From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] Re: [PATCH 4/5] mm: memcg/slab: Fix root memcg vmstats
Date: Wed, 28 Oct 2020 11:47:52 +0800
Message-ID: <CAMZfGtWP9k8kCY0QxRdoLn1MQ8aiP_R_bRqLYiuGdznRdgFk6g@mail.gmail.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-5-songmuchun@bytedance.com> <20201027184835.GB827280@carbon.dhcp.thefacebook.com>
 <CAMZfGtU1aViokYk1hkHbYEiqW5QNi49UTd-QTrkycLqj6Q+-8g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yam/p71AJ8As7tsiU5BDigXfn1EtsRyjjS0tu9YDXrE=;
        b=zI0AZyeopougGJaeeJKxiy2HLVVsv26SHyuC9lZGn3mHVPG4adTo3D+aO+j0XR44ci
         FfTwaVnJRPi9zVvA6hpf1ZaFfoCoURpS9XHlqQg+ZrxnBO+E8rPyP0tqmQnY3nnjeq9r
         5VGafNNKYn89gOl63qP9XNkAmVpb19eKTiDG3hK4i8x4UAVa72s7TO+CBx0vfglLdF1+
         APNMSS+vFOYw1EXZr6atQtq2nZsb9X0cMA/NSVed5Q/XK5jmkE6PRoRpodiGA9qxLOTT
         qkdrX0ZygO5jnlaXcOL8hyXIPHhNTjGGK/dgRNviCW59mfPLSiuYuaCRwSiCT2KtnBYY
         zj2w==
In-Reply-To: <CAMZfGtU1aViokYk1hkHbYEiqW5QNi49UTd-QTrkycLqj6Q+-8g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, laoar.shao@gmail.com, Chris Down <chris@chrisdown.name>, Christian Brauner <christian.brauner@ubuntu.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com, Suren Baghdasaryan <surenb@google.com>, areber@redhat.com, Marco Elver <elver@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>

On Wed, Oct 28, 2020 at 10:56 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Wed, Oct 28, 2020 at 2:48 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Tue, Oct 27, 2020 at 04:02:55PM +0800, Muchun Song wrote:
> > > If we reparent the slab objects to the root memcg, when we free
> > > the slab object, we need to update the per-memcg vmstats to keep
> > > it correct for the root memcg. Now this at least affects the vmstat
> > > of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
> > > size is smaller than the PAGE_SIZE.
> > >
> > > Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
> > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >
> > Can you, please, drop this patch for now?
> >
> > I'm working on a bigger cleanup related to the handling of the root memory
> > cgroup (I sent a link earlier in this thread), which already does a similar change.
> > There are several issues like this one, so it will be nice to fix them all at once.
>
> I have read the patch of https://lkml.org/lkml/2020/10/14/869. You
> mean this patch
> fixes this issue? It chooses to uncharge the root memcg. But here we may need to

Here I mean "It chooses to not uncharge the root memcg", sorry.

> uncharge the root memcg to keep root vmstats correct. If we do not do
> this, we can
> see the wrong vmstats via root memory.stat(e.g. NR_KERNEL_STACK_KB).
>
> Thanks.
>
> >
> > Thank you!
> >
> > > ---
> > >  mm/memcontrol.c | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 22b4fb941b54..70345b15b150 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -875,8 +875,13 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
> > >       rcu_read_lock();
> > >       memcg = mem_cgroup_from_obj(p);
> > >
> > > -     /* Untracked pages have no memcg, no lruvec. Update only the node */
> > > -     if (!memcg || memcg == root_mem_cgroup) {
> > > +     /*
> > > +      * Untracked pages have no memcg, no lruvec. Update only the
> > > +      * node. If we reparent the slab objects to the root memcg,
> > > +      * when we free the slab object, we need to update the per-memcg
> > > +      * vmstats to keep it correct for the root memcg.
> > > +      */
> > > +     if (!memcg) {
> > >               __mod_node_page_state(pgdat, idx, val);
> > >       } else {
> > >               lruvec = mem_cgroup_lruvec(memcg, pgdat);
> > > --
> > > 2.20.1
> > >
>
>
>
> --
> Yours,
> Muchun



-- 
Yours,
Muchun
