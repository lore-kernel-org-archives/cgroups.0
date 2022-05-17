From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Add swappiness argument to memory.reclaim
Date: Tue, 17 May 2022 13:11:13 -0700
Message-ID: <CAJD7tkaPWcFyisv3Kso0AFUGkQiiAiFmsV2R3ZU2SNc4XP8v+w@mail.gmail.com>
References: <CAJD7tkbDpyoODveCsnaqBBMZEkDvshXJmNdbk51yKSNgD7aGdg@mail.gmail.com>
 <YoPHtHXzpK51F/1Z@carbon> <CAJD7tkbbiP0RusWBdCvozjauKN-vhgvzWtsL3Hu5y2dLr63idQ@mail.gmail.com>
 <YoP8P7hzXIyogQ68@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h2Eui4Xs+XTv+2fskDeZzVLFI7BoyJsiN1wcr5vwpuw=;
        b=WU/rjkUAPamtv0gkPDycWAE77Am36/IyWuJpo5Zb2eziurBXoSNBUk8a/btdXSi4vl
         JYdTjNlc1tFfa+zFQQGfnVCkC4iSfenQQOnM/K3wh621mRpoPOdyJzslLbh3/4vHD+5+
         9Q+KDe8qFb13wyO/kUhHD8ykWgNnfdQTI9okC1NnIZFUIXltN8CK26H5pdqfKR46vNo8
         wJbBaQSlH6elChFUIYs2QL5H3p/l4vhCPKX7zktNzuNWL/4HU8YhrJ+6JbwYLN0+kyut
         UqAZ6Do0nKd4p6ualilc3kQp8Z/KwO46JHWnNORLCqjsoP/PCpGwNNqdTTCSIZ9Imkvj
         dCag==
In-Reply-To: <YoP8P7hzXIyogQ68@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Tue, May 17, 2022 at 12:49 PM Roman Gushchin
<roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> On Tue, May 17, 2022 at 11:13:10AM -0700, Yosry Ahmed wrote:
> > On Tue, May 17, 2022 at 9:05 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > >
> > > On Mon, May 16, 2022 at 03:29:42PM -0700, Yosry Ahmed wrote:
> > > > The discussions on the patch series [1] to add memory.reclaim has
> > > > shown that it is desirable to add an argument to control the type of
> > > > memory being reclaimed by invoked proactive reclaim using
> > > > memory.reclaim.
> > > >
> > > > I am proposing adding a swappiness optional argument to the interface.
> > > > If set, it overwrites vm.swappiness and per-memcg swappiness. This
> > > > provides a way to enforce user policy on a stateless per-reclaim
> > > > basis. We can make policy decisions to perform reclaim differently for
> > > > tasks of different app classes based on their individual QoS needs. It
> > > > also helps for use cases when particularly page cache is high and we
> > > > want to mainly hit that without swapping out.
> > > >
> > > > The interface would be something like this (utilizing the nested-keyed
> > > > interface we documented earlier):
> > > >
> > > > $ echo "200M swappiness=30" > memory.reclaim
> > >
> > > What are the anticipated use cases except swappiness == 0 and
> > > swappiness == system_default?
> > >
> > > IMO it's better to allow specifying the type of memory to reclaim,
> > > e.g. type="file"/"anon"/"slab", it's a way more clear what to expect.
> >
> > I imagined swappiness would give user space flexibility to reclaim a
> > ratio of file vs. anon as it sees fit based on app class or userspace
> > policy, but I agree that the guarantees of swappiness are weak and we
> > might want an explicit argument that directly controls the return
> > value of get_scan_count() or whether or not we call shrink_slab(). My
> > fear is that this interface may be less flexible, for example if we
> > only want to avoid reclaiming file pages, but we are fine with anon or
> > slab.
> > Maybe in the future we will have a new type of memory to
> > reclaim, does it get implicitly reclaimed when other types are
> > specified or not?
> >
> > Maybe we can use one argument per type instead? E.g.
> >     $ echo "200M file=no anon=yes slab=yes" > memory.reclaim
> >
> > The default value would be "yes" for all types unless stated
> > otherwise. This is also leaves room for future extensions (maybe
> > file=clean to reclaim clean file pages only?). Interested to hear your
> > thoughts on this!
>
> The question to answer is do you want the code which is determining
> the balance of scanning be a part of the interface?
>
> If not, I'd stick with explicitly specifying a type of memory to scan
> (and the "I don't care" mode, where you simply ask to reclaim X bytes).
>
> Otherwise you need to describe how the artificial memory pressure will
> be distributed over different memory types. And with time it might
> start being significantly different to what the generic reclaim code does,
> because the reclaim path is free to do what's better, there are no
> user-visible guarantees.

My understanding is that your question is about the swappiness
argument, and I agree it can get complicated. I am on board with
explicitly specifying the type(s) to reclaim. I think an interface
with one argument per type (whitelist/blacklist approach) could be
more flexible in specifying multiple types per invocation (smaller
race window between reading usages and writing to memory.reclaim), and
has room for future extensions (e.g. file=clean). However, if you
still think a type=file/anon/slab parameter is better we can also go
with this.

I imagine this will be an enum/flags that will be passed to
try_to_free_pages() instead of may_swap, and then we can map it to one
bit flags in struct scan_control. The anon/file flags will be used to
control list type in shrink_lruvec (get_scan_counts) and
mem_cgroup_soft_limit_reclaim(), and the slab flag will be used to
control calls to shrink_slab().

This is orthogonal, but while we are at it we can also add a
"controlled_reclaim" flag that we use to control whether we call
vmpressure or not. I assume we don't want to count vmpressure for
controlled reclaim, similar to PSI. We can then also revert
e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim as
memory pressure") and use the same flag to control calls to psi.

>
> >
> > >
> > > E.g. what
> > > $ echo "200M swappiness=1" > memory.reclaim
> > > means if there is only 10M of pagecache? How much of anon memory will
> > > be reclaimed?
> >
> > Good point. I agree that the type argument or per-type arguments have
> > multiple advantages over swappiness.
>
> If a user wants to select multiple types of memory, can they just run several
> requests in parallel? Or one by one?
>
> Thanks!
