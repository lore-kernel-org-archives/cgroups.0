From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 0/6] Proposal for a GPU cgroup controller
Date: Fri, 24 Jun 2022 14:17:49 -0700
Message-ID: <CABdmKX0bJDLwK7JEDGVb=KHtoVbZgnXYr8UE5eUpLYuAyiWwyw__48487.9266283073$1656105497$gmane$org@mail.gmail.com>
References: <CABdmKX3ZV6-u-oLvW_wWavAMBfrsZ=C_rCgK_Uz4VjxcRvRFew@mail.gmail.com>
 <81026ef07c1ce20f8673b75b17bab79a2b39c548.camel@ndufresne.ca>
 <CABdmKX2LxZ6zZR=fhXfnuWCB2BR+gzDd1-t1DD2A2XP24wvuGQ@mail.gmail.com>
 <Yn6DpUsoSz1/15Kc@slm.duckdns.org> <CABdmKX1xvm87WMEDkMc9Aye46E4zv1-scenwgaRxHesrOCsaYg@mail.gmail.com>
 <YodHjYlMx1XGtM2+@slm.duckdns.org> <CABdmKX2Ok023rN1drQgXVZLKUO_DVYrzmEamCgMMu6BPO67yhQ@mail.gmail.com>
 <CABdmKX0WV8VWgeafVGJ++nJ4xsJD7Wpz=3KX=BW1du=huttfvw@mail.gmail.com>
 <YrYbwu0iIAJJGXVg@phenom.ffwll.local> <CANDhNCqGjaq-SFvWwkqnEFj4tJcRqCYupZ03wLyCexqTH5MqMg@mail.gmail.com>
 <YrYgWCTtZqfvCt5D@phenom.ffwll.local>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kOvhoEpSE/InAZniXEti7vxsLeyf1a5ZFLlDrYfEPAA=;
        b=M1hPxnJUFy/KS9mddV1ZPCrOTUCJOFrbdOpyi7j0ftrXkyhBEEnYliwfUMRIJpc302
         UerGSaJuJ0U+ZQOOBbu9YnTTWBPqzn6BGm20kcHK021zUKyUQcLbeROv76yKvkCA4wL5
         TKPV/NeXPSFred9jnh+TebuOPhqPca6DgiiGGp4t7notg/0HrutadjdFHCaRzrR60/SS
         kEf+UPdtfuMWWyAGy3sWvPgk2BDAIWToAkVEoiSpYe94Nv1jd3nvOoAgAb/ln/G4XSiC
         GAFPYKei8IcLsfKWZvc/9gQfNai9RmMKWnJqWlZq+QZRlzREX3RhLKN999kWcpZY7b77
         80Uw==
In-Reply-To: <YrYgWCTtZqfvCt5D-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Dufresne <nicolas-dDhyB4GVkw9AFePFGvp55w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, Liam Mark <lmark@codeauror>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>

On Fri, Jun 24, 2022 at 1:36 PM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
>
> On Fri, Jun 24, 2022 at 01:32:45PM -0700, John Stultz wrote:
> > On Fri, Jun 24, 2022 at 1:17 PM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > >
> > > On Wed, Jun 15, 2022 at 10:31:21AM -0700, T.J. Mercier wrote:
> > > > On Fri, May 20, 2022 at 9:25 AM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > >
> > > > > On Fri, May 20, 2022 at 12:47 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > > >
> > > > > > Hello,
> > > > > >
> > > > > > On Tue, May 17, 2022 at 04:30:29PM -0700, T.J. Mercier wrote:
> > > > > > > Thanks for your suggestion. This almost works. "dmabuf" as a key could
> > > > > > > work, but I'd actually like to account for each heap. Since heaps can
> > > > > > > be dynamically added, I can't accommodate every potential heap name by
> > > > > > > hardcoding registrations in the misc controller.
> > > > > >
> > > > > > On its own, that's a pretty weak reason to be adding a separate gpu
> > > > > > controller especially given that it doesn't really seem to be one with
> > > > > > proper abstractions for gpu resources. We don't want to keep adding random
> > > > > > keys to misc controller but can definitely add limited flexibility. What
> > > > > > kind of keys do you need?
> > > > > >
> > > > > Well the dmabuf-from-heaps component of this is the initial use case.
> > > > > I was envisioning we'd have additional keys as discussed here:
> > > > > https://lore.kernel.org/lkml/20220328035951.1817417-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/T/#m82e5fe9d8674bb60160701e52dae4356fea2ddfa
> > > > > So we'd end up with a well-defined core set of keys like "system", and
> > > > > then drivers would be free to use their own keys for their own unique
> > > > > purposes which could be complementary or orthogonal to the core set.
> > > > > Yesterday I was talking with someone who is interested in limiting gpu
> > > > > cores and bus IDs in addition to gpu memory. How to define core keys
> > > > > is the part where it looks like there's trouble.
> > > > >
> > > > > For my use case it would be sufficient to have current and maximum
> > > > > values for an arbitrary number of keys - one per heap. So the only
> > > > > part missing from the misc controller (for my use case) is the ability
> > > > > to register a new key at runtime as heaps are added. Instead of
> > > > > keeping track of resources with enum misc_res_type, requesting a
> > > > > resource handle/ID from the misc controller at runtime is what I think
> > > > > would be required instead.
> > > > >
> > > > Quick update: I'm going to make an attempt to modify the misc
> > > > controller to support a limited amount of dynamic resource
> > > > registration/tracking in place of the new controller in this series.
> > > >
> > > > Thanks everyone for the feedback.
> > >
> > > Somehow I missed this entire chain here.
> > >
> > > I'm not a fan, because I'm kinda hoping we could finally unify gpu memory
> > > account. Atm everyone just adds their one-off solution in a random corner:
> > > - total tracking in misc cgroup controller
> > > - dma-buf sysfs files (except apparently too slow so it'll get deleted
> > >   again)
> > > - random other stuff on open device files os OOM killer can see it
> > >
> > > This doesn't look good.
> >
> > But I also think one could see it as "gpu memory" is the drm subsystem
> > doing the same thing (in that it's artificially narrow to gpus). It
> > seems we need something to account for buffers allocated by drivers,
> > no matter which subsystem it was in (drm, v4l2, or networking or
> > whatever).
>
> This is what the gpucg was. It wasn't called the dmabuf cg because we want
> to account also memory of other types (e.g. drm gem buffer objects which
> aren't exported), and I guess people didn't dare call it an xpu.
>
> But this was absolutely for a lot more than just "gpu drivers in drm".
> Better names welcome.
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

From an API perspective the two approaches (misc vs GPU) seem similar
to me. Someone comes up with a name of a resource they want to track,
and it's added as a key in a cgroup interface file as drivers register
and perform accounting on that resource. Considering just the naming,
what do you see as the appeal of a controller named GPU/XPU vs one
named Misc? Folks seem to have assumptions about the type of resources
a "GPU" controller should be tracking, and potentially also how
different resources are grouped under a single resource name. So is
your thought that non-graphics related accounting of the same sort
should be using a differently named controller, even if that
controller could have the same implementation?

My thought is that the resource names should be as specific as
possible to allow fine-grained accounting, and leave any grouping of
resources to userspace. We can do that under any controller. If you'd
like to see a separate controller for graphics related stuff... well
that's what I was aiming for with the GPU cgroup controller. It's just
that dmabufs from heaps are the first use-case wired up.

I haven't put much time into the misc controller effort yet, and I'd
still be happy to see the GPU controller accepted if we can agree
about how it'd be used going forward. Daniel, I think you're in a
great position to comment about this. :) If there's a place where the
implementation is missing the mark, then let's change it. Are the
controller and resource naming the only issues?
