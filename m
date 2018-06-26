From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 26 Jun 2018 13:05:55 -0700
Message-ID: <CALvZod5VU0_==ggX82P19v=X7zpKj1xO5qPZ1mep4yRVhr7qaw@mail.gmail.com>
References: <20180625230659.139822-1-shakeelb@google.com> <20180625230659.139822-2-shakeelb@google.com>
 <20180626190619.GB3958@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X7FVMGJWHOZkxWyXcdo36JkO3xwzZOdCUPu5WvzQPEg=;
        b=Egiy5RCh6DAmIf2HiXn77yjfDD3Xjah/greibEYUXcxxlqczW0R+a4TtrKJb0sYqRD
         j+3fhiqOQ8eOyscy+60SO1yTfNZxJPD4/cOPaCwPUBm5d9MPB9srwBSbaTZ7QUasJ7lv
         Er6YuGbTJ07eGC7achVVqTnMGxK9UPrhGBPeYOOPOs9dy/PR2Yth+OH8a6M8e5CcMuuz
         0gb384MUTDY8o6a3n8i2Y9lCfdURGuqkeb4Tfx5upQuOZUdd80jdNt0QtYtrpUrp6uIz
         r9MSGR+l2r1FmroiqPAwaFum4mSsjvQUD2iGYJtaFLyoM9b2sSKlHSm5xLEsl0NXtz0N
         zLDA==
In-Reply-To: <20180626190619.GB3958@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Amir Goldstein <amir73il@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>

On Tue, Jun 26, 2018 at 12:03 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Jun 25, 2018 at 04:06:58PM -0700, Shakeel Butt wrote:
> > @@ -140,8 +141,9 @@ struct fanotify_event_info *fanotify_alloc_event(struct fsnotify_group *group,
> >                                                struct inode *inode, u32 mask,
> >                                                const struct path *path)
> >  {
> > -     struct fanotify_event_info *event;
> > +     struct fanotify_event_info *event = NULL;
> >       gfp_t gfp = GFP_KERNEL;
> > +     struct mem_cgroup *old_memcg = NULL;
> >
> >       /*
> >        * For queues with unlimited length lost events are not expected and
> > @@ -151,19 +153,25 @@ struct fanotify_event_info *fanotify_alloc_event(struct fsnotify_group *group,
> >       if (group->max_events == UINT_MAX)
> >               gfp |= __GFP_NOFAIL;
> >
> > +     /* Whoever is interested in the event, pays for the allocation. */
> > +     if (group->memcg) {
> > +             gfp |= __GFP_ACCOUNT;
> > +             old_memcg = memalloc_use_memcg(group->memcg);
> > +     }
>
> group->memcg is only NULL when memcg is disabled or there is some
> offlining race. Can you make memalloc_use_memcg(NULL) mean that it
> should charge root_mem_cgroup instead of current->mm->memcg? That way
> we can make this site unconditional while retaining the behavior:
>
>         gfp_t gfp = GFP_KERNEL | __GFP_ACCOUNT;
>
>         memalloc_use_memcg(group->memcg);
>         kmem_cache_alloc(..., gfp);
> out:
>         memalloc_unuse_memcg();
>
> (dropping old_memcg and the unuse parameter as per the other mail)
>

group->memcg is only NULL when memcg is disabled (i.e.
get_mem_cgroup_from_mm() returns root_mem_cgroup for offlined
mm->memcg). Though group->memcg can point to an offlined memcg.

If I understand you correctly this is what we want:

1. If group->memcg is NULL then __GFP_ACCOUNT is a noop i.e. memcg is disabled.
2. If group->memcg is root_mem_cgroup, then __GFP_ACCOUNT again is a
kind of noop (charges to root_mem_cgroups are bypassed).
3. If group->memcg is offlined memcg, then make __GFP_ACCOUNT noop by
returning root_mem_cgroup from get_mem_cgroup_from_current().
4. Else charge group->memcg.

This seems reasonable. After your Ack and Amir's or Jan's answer to
the nesting query, I will resend the next version of this patch
series.

In future if we find any use-cases of memalloc_use_memcg nesting then
we can make it work for nesting.

thanks,
Shakeel
