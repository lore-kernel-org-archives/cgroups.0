From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Fri, 20 May 2022 19:19:18 -0700
Message-ID: <CABdmKX17aS3nh0UHf+FoM3VPdvMn5NvrZTkGSisznDgjZyeQxw@mail.gmail.com>
References: <20220510235653.933868-1-tjmercier@google.com> <20220519093034.541481-1-eballetbo@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sQlK8EPAE1nmulIIgv5jRhcGPrhGOTgo4V3rKxqmaH4=;
        b=rnCv4bfcViQifT0EnuLazBJP+RPyjJedUNb+XaGcQSXhNUZkgOYt7ievywxjV1c2EE
         MJycHcYkWvToUmN9fth48vtDpbQ8998jU959vlLAp8q+kxszB9zEEIou0KXawjZ0tTVy
         gIKIwNNtpdmIBb2uKjvJhKJoClgHdIw4qEo3rWw4wDzrYVOCXfuwX/+junNVwel4K6KY
         DZMasQmbk8jAgtbeKOxbDF7OHmI6gInClz5ODkttVNJ9T4h+dbgBVX+8jOUQt572JzP/
         q1QAJRiIxjo0ghtkLxdrCVDrXpSQXDQivzghlBw2O5NyNSWzB32vrSjS7mHu9XuiTqWp
         PU3g==
In-Reply-To: <20220519093034.541481-1-eballetbo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: eballetbo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Brian Starkey <Brian.Starkey-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuah@ker>

On Thu, May 19, 2022 at 2:31 AM <eballetbo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> From: Enric Balletbo i Serra <eballetbo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> On Tue, 10 May 2022 23:56:45 +0000, T.J. Mercier wrote:
> > From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
>
> Hi T.J. Mercier,
>
> Many thanks for this effort. It caught my attention because we might have=
 a use
> case where this feature can be useful for us. Hence I'd like to jump and =
be part
> of the discussion, I'd really appreciate if you can cc'me for next versio=
ns.
>
Hi Enric,

Sure thing, thanks for engaging.

> While reading the full patchset I was a bit confused about the status of =
this
> proposal. In fact, the rfc in the subject combined with the number of ite=
rations
> (already seven) confused me. So I'm wondering if this is a RFC or a 'real=
'
> proposal already that you want to land.
>
I'm sorry about this. I'm quite new to kernel development (this is my
first set of patches) and the point at which I should have
transitioned from RFC to PATCH was not clear to me. The status now
could be described as adding initial support for accounting that would
be built upon to expand what is tracked (more than just buffers from
heaps) and to add support for limiting. I see you have also commented
about this below.

> If this is still a RFC I'd remove the 'rfc: Proposal' and use the more ca=
nonical
> way that is put RFC in the []. I.e [PATCH RFC v7] cgroup: Add a GPU cgrou=
p
> controller.
>
> If it is not, I'd just remove the RFC and make the subject in the cgroup
> subsystem instead of the gpu. I.E [PATCH v7] cgroup: Add a GPU cgroup
>
> I don't want to nitpick but IMO that helps new people to join to the hist=
ory of
> the patchset.
>
> > This patch adds a proposal for a new GPU cgroup controller for
> > accounting/limiting GPU and GPU-related memory allocations.
>
> As far as I can see the only thing that is adding here is the accounting,=
 so I'd
> remove any reference to limiting and just explain what the patch really
> introduces, not the future, otherwise is confusing an you expect more tha=
n the
> patch really does.
>
> It is important maintain the commit message sync with what the patch real=
ly
> does.
>
Acknowledged, thank you.

> > The proposed controller is based on the DRM cgroup controller[1] and
> > follows the design of the RDMA cgroup controller.
> >
> > The new cgroup controller would:
> > * Allow setting per-device limits on the total size of buffers
> >   allocated by device within a cgroup.
> > * Expose a per-device/allocator breakdown of the buffers charged to a
> >   cgroup.
> >
> > The prototype in the following patches is only for memory accounting
> > using the GPU cgroup controller and does not implement limit setting.
> >
> > [1]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty=
@intel.com/
> >
>
> I think this is material for the cover more than the commit message. When=
 I read
> this I was expecting all this in this patch.
>
> > Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> > v7 changes
> > Remove comment about duplicate name rejection which is not relevant to
> > cgroups users per Michal Koutn=C3=BD.
> >
> > v6 changes
> > Move documentation into cgroup-v2.rst per Tejun Heo.
> >
> > v5 changes
> > Drop the global GPU cgroup "total" (sum of all device totals) portion
> > of the design since there is no currently known use for this per
> > Tejun Heo.
> >
> > Update for renamed functions/variables.
> >
> > v3 changes
> > Remove Upstreaming Plan from gpu-cgroup.rst per John Stultz.
> >
> > Use more common dual author commit message format per John Stultz.
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/ad=
min-guide/cgroup-v2.rst
> > index 69d7a6983f78..2e1d26e327c7 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -2352,6 +2352,29 @@ first, and stays charged to that cgroup until th=
at resource is freed. Migrating
> >  a process to a different cgroup does not move the charge to the destin=
ation
> >  cgroup where the process has moved.
> >
> > +
> > +GPU
> > +---
> > +
> > +The GPU controller accounts for device and system memory allocated by =
the GPU
> > +and related subsystems for graphics use. Resource limits are not curre=
ntly
> > +supported.
> > +
> > +GPU Interface Files
> > +~~~~~~~~~~~~~~~~~~~~
> > +
> > +  gpu.memory.current
> > +     A read-only file containing memory allocations in flat-keyed form=
at. The key
> > +     is a string representing the device name. The value is the size o=
f the memory
> > +     charged to the device in bytes. The device names are globally uni=
que.::
> > +
> > +       $ cat /sys/kernel/fs/cgroup1/gpu.memory.current
>
> I think this is outdated, you are using cgroup v2, right?
>
Oh "cgroup1" was meant to refer to the name of a cgroup, not to cgroup
v1. A different name would be better here.

> > +       dev1 4194304
> > +       dev2 104857600
> > +
>
> When I applied the full series I was expecting see the memory allocated b=
y the
> gpu devices or users of the gpu in this file but, after some experiments,=
 what I
> saw is the memory allocated via any process that uses the dma-buf heap AP=
I (not
> necessary gpu users). For example, if you create a small program that all=
ocates
> some memory via the dma-buf heap API and then you cat the gpu.memory.curr=
ent
> file, you see that the memory accounted is not related to the gpu.
>
> This is really confusing, looks to me that the patches evolved to account=
 memory
> that is not really related to the GPU but allocated vi the dma-buf heap A=
PI. IMO
> the name of the file should be according to what really does to avoid
> confusions.
>
> So, is this patchset meant to be GPU specific? If the answer is yes that'=
s good
> but that's not what I experienced. I'm missing something?
>
There are two reasons this exists as a GPU controller. The first is
that most graphics buffers in Android come from these heaps, and this
is primarily what we are interested in accounting. However the idea is
to account other graphics memory types more commonly used on desktop
under different resource names with this controller. The second reason
predates my involvement, but my understanding is that Hridya tried to
upstream heap tracking via tracepoints but was asked to try to use GPU
cgroups instead, which led to her initial version of this series. So
this is a starting point. Any commentary on why this controller would
our would not work for any use cases you have in mind (provided the
appropriate charging/uncharging code is plugged in) would be
appreciated!

By the way, discussion around earlier proposals on this topic
suggested the "G" should be for "general" instead of "graphics", I
think in recognition of the breadth of resources that would eventually
be tracked by it.
https://lore.kernel.org/amd-gfx/YBp4ap+1l2KWbqEJ-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org/



> If the answer is that evolved to track dma-buf heap allocations I think a=
ll the
> patches need some rework to adapt the wording as right now, the gpu wordi=
ng
> seems confusing to me.
>
> > +     The device name string is set by a device driver when it register=
s with the
> > +     GPU cgroup controller to participate in resource accounting.
> > +
> >  Others
> >  ------
> >
> >
> Thanks,
>  Enric
>
