From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v7 0/6] Proposal for a GPU cgroup controller
Date: Fri, 24 Jun 2022 22:17:06 +0200
Message-ID: <YrYbwu0iIAJJGXVg@phenom.ffwll.local>
References: <20220510235653.933868-1-tjmercier@google.com>
 <3365cd1d750e84fedc8e75d646a77ffd85619d35.camel@ndufresne.ca>
 <CABdmKX3ZV6-u-oLvW_wWavAMBfrsZ=C_rCgK_Uz4VjxcRvRFew@mail.gmail.com>
 <81026ef07c1ce20f8673b75b17bab79a2b39c548.camel@ndufresne.ca>
 <CABdmKX2LxZ6zZR=fhXfnuWCB2BR+gzDd1-t1DD2A2XP24wvuGQ@mail.gmail.com>
 <Yn6DpUsoSz1/15Kc@slm.duckdns.org>
 <CABdmKX1xvm87WMEDkMc9Aye46E4zv1-scenwgaRxHesrOCsaYg@mail.gmail.com>
 <YodHjYlMx1XGtM2+@slm.duckdns.org>
 <CABdmKX2Ok023rN1drQgXVZLKUO_DVYrzmEamCgMMu6BPO67yhQ@mail.gmail.com>
 <CABdmKX0WV8VWgeafVGJ++nJ4xsJD7Wpz=3KX=BW1du=huttfvw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=A7KsArznjDszXEtjfLGnA6REJfLUYfQ3Oszk2m5SudA=;
        b=DysS05ypy7Dj7deDljGrAOAbGl2Xyt4/z99Z0sAnWou95elElB1LSY5/Ts4Ksh/mXP
         DLv6fOZpbapyMhr7MkdZvU+yZ2/QnFZ1mpgFnWqAY41HyRd5w3WAVUbpmAQFwqme6Ilf
         NCYlIIWT8tJDBPd7kF3JbEbHU58J7PTZbpGK0=
Content-Disposition: inline
In-Reply-To: <CABdmKX0WV8VWgeafVGJ++nJ4xsJD7Wpz=3KX=BW1du=huttfvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Dufresne <nicolas-dDhyB4GVkw9AFePFGvp55w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Starkey@a>

On Wed, Jun 15, 2022 at 10:31:21AM -0700, T.J. Mercier wrote:
> On Fri, May 20, 2022 at 9:25 AM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Fri, May 20, 2022 at 12:47 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > Hello,
> > >
> > > On Tue, May 17, 2022 at 04:30:29PM -0700, T.J. Mercier wrote:
> > > > Thanks for your suggestion. This almost works. "dmabuf" as a key could
> > > > work, but I'd actually like to account for each heap. Since heaps can
> > > > be dynamically added, I can't accommodate every potential heap name by
> > > > hardcoding registrations in the misc controller.
> > >
> > > On its own, that's a pretty weak reason to be adding a separate gpu
> > > controller especially given that it doesn't really seem to be one with
> > > proper abstractions for gpu resources. We don't want to keep adding random
> > > keys to misc controller but can definitely add limited flexibility. What
> > > kind of keys do you need?
> > >
> > Well the dmabuf-from-heaps component of this is the initial use case.
> > I was envisioning we'd have additional keys as discussed here:
> > https://lore.kernel.org/lkml/20220328035951.1817417-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/T/#m82e5fe9d8674bb60160701e52dae4356fea2ddfa
> > So we'd end up with a well-defined core set of keys like "system", and
> > then drivers would be free to use their own keys for their own unique
> > purposes which could be complementary or orthogonal to the core set.
> > Yesterday I was talking with someone who is interested in limiting gpu
> > cores and bus IDs in addition to gpu memory. How to define core keys
> > is the part where it looks like there's trouble.
> >
> > For my use case it would be sufficient to have current and maximum
> > values for an arbitrary number of keys - one per heap. So the only
> > part missing from the misc controller (for my use case) is the ability
> > to register a new key at runtime as heaps are added. Instead of
> > keeping track of resources with enum misc_res_type, requesting a
> > resource handle/ID from the misc controller at runtime is what I think
> > would be required instead.
> >
> Quick update: I'm going to make an attempt to modify the misc
> controller to support a limited amount of dynamic resource
> registration/tracking in place of the new controller in this series.
> 
> Thanks everyone for the feedback.

Somehow I missed this entire chain here.

I'm not a fan, because I'm kinda hoping we could finally unify gpu memory
account. Atm everyone just adds their one-off solution in a random corner:
- total tracking in misc cgroup controller
- dma-buf sysfs files (except apparently too slow so it'll get deleted
  again)
- random other stuff on open device files os OOM killer can see it

This doesn't look good.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
