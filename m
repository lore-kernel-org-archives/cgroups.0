From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Thu, 28 Jun 2018 12:21:26 -0700
Message-ID: <CALvZod5Fy7cUnqMvCqw8M52wm8+wBtGD-bhUibN=Uwdzb+5Kyw@mail.gmail.com>
References: <20180627191250.209150-1-shakeelb@google.com> <20180627191250.209150-2-shakeelb@google.com>
 <20180628100253.jscxkw2d6vfhnbo5@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sl4nwqWfnH9Gvz1ACEYRylPJ37Hrc1olYzQgqFwLlaQ=;
        b=RjOqkSxFKoddwTbAamPV/hqIss4Pj36ZC08NHJGh0ggi/OnSyWS4ey8fHMwf7aL9X7
         YDqo+gqR4VSk/KbmSWpsAsEdff2tYmZa1y4Bn4GOj8SOTRschD34IDdd/F1V73rcUwdu
         Y+ZgKwyA7w1WT0a5cxEr/rvtLoLTqqgoNjwU9cl9ehhSd5EKHerLse6TzDXyV452EOZk
         FpzOhLZ20Ze7QJXHKdI5WDnuTBh4Qi9sc8qPgxNoQc7+wFZf4Kr47USrCwnkJYS20hWl
         jmSsF2AYe+X+rfLG/tBps3nTIYR1SfTEPU+ItFopptjDXwkpHZgEKdMxPkRJ/6bdX8WE
         nPsQ==
In-Reply-To: <20180628100253.jscxkw2d6vfhnbo5@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Amir Goldstein <amir73il@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Thu, Jun 28, 2018 at 12:03 PM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 27-06-18 12:12:49, Shakeel Butt wrote:
> > A lot of memory can be consumed by the events generated for the huge or
> > unlimited queues if there is either no or slow listener.  This can cause
> > system level memory pressure or OOMs.  So, it's better to account the
> > fsnotify kmem caches to the memcg of the listener.
> >
> > However the listener can be in a different memcg than the memcg of the
> > producer and these allocations happen in the context of the event
> > producer. This patch introduces remote memcg charging API which the
> > producer can use to charge the allocations to the memcg of the listener.
> >
> > There are seven fsnotify kmem caches and among them allocations from
> > dnotify_struct_cache, dnotify_mark_cache, fanotify_mark_cache and
> > inotify_inode_mark_cachep happens in the context of syscall from the
> > listener.  So, SLAB_ACCOUNT is enough for these caches.
> >
> > The objects from fsnotify_mark_connector_cachep are not accounted as they
> > are small compared to the notification mark or events and it is unclear
> > whom to account connector to since it is shared by all events attached to
> > the inode.
> >
> > The allocations from the event caches happen in the context of the event
> > producer.  For such caches we will need to remote charge the allocations
> > to the listener's memcg.  Thus we save the memcg reference in the
> > fsnotify_group structure of the listener.
> >
> > This patch has also moved the members of fsnotify_group to keep the size
> > same, at least for 64 bit build, even with additional member by filling
> > the holes.
>
> ...
>
> >  static int __init fanotify_user_setup(void)
> >  {
> > -     fanotify_mark_cache = KMEM_CACHE(fsnotify_mark, SLAB_PANIC);
> > +     fanotify_mark_cache = KMEM_CACHE(fsnotify_mark,
> > +                                      SLAB_PANIC|SLAB_ACCOUNT);
> >       fanotify_event_cachep = KMEM_CACHE(fanotify_event_info, SLAB_PANIC);
> >       if (IS_ENABLED(CONFIG_FANOTIFY_ACCESS_PERMISSIONS)) {
> >               fanotify_perm_event_cachep =
>
> Why don't you setup also fanotify_event_cachep and
> fanotify_perm_event_cachep caches with SLAB_ACCOUNT and instead specify
> __GFP_ACCOUNT manually? Otherwise the patch looks good to me.
>

Hi Jan, IMHO having a visible __GFP_ACCOUNT along with
memalloc_use_memcg() makes the code more explicit and readable that we
want to targeted/remote memcg charging. However if you think
otherwise, I will replace __GFP_ACCOUNT with SLAB_ACCOUNT.

thanks,
Shakeel
