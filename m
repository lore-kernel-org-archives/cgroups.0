From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v4 01/16] drm: Add drm_minor_for_each
Date: Thu, 5 Sep 2019 14:27:00 -0400
Message-ID: <CAOWid-e9t910p2ikKn+S5XG+txyAej=n2YDTYrd9vpm34urTQg@mail.gmail.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-2-Kenny.Ho@amd.com>
 <20190903075719.GK2112@phenom.ffwll.local>
 <CAOWid-dxxDhyxP2+0R0oKAk29rR-1TbMyhshR1+gbcpGJCAW6g@mail.gmail.com>
 <CAKMK7uEofjdVURu+meonh_YdV5eX8vfNALkW3A_+kLapCV8j+w@mail.gmail.com>
 <CAOWid-eUVztW4hNVpznnJRcwHcjCirGL2aS75p4OY8XoGuJqUg@mail.gmail.com>
 <20190904085434.GF2112@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1304886654=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190904085434.GF2112-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, lkaplan-WVYJKLFxKCc@public.gmane.org, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>

--===============1304886654==
Content-Type: multipart/alternative; boundary="0000000000005776e70591d27847"

--0000000000005776e70591d27847
Content-Type: text/plain; charset="UTF-8"

Hi Daniel,

This is the previous patch relevant to this discussion:
https://patchwork.freedesktop.org/patch/314343/

So before I refactored the code to leverage drm_minor, I kept my own list
of "known" drm_device inside the controller and have explicit register and
unregister function to init per device cgroup defaults.  For v4, I
refactored the per device cgroup properties and embedded them into the
drm_device and continue to only use the primary minor as a way to index the
device as v3.

Regards,
Kenny

On Wed, Sep 4, 2019 at 4:54 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:

> On Tue, Sep 03, 2019 at 04:43:45PM -0400, Kenny Ho wrote:
> > On Tue, Sep 3, 2019 at 4:12 PM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org> wrote:
> > > On Tue, Sep 3, 2019 at 9:45 PM Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > > On Tue, Sep 3, 2019 at 3:57 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
> wrote:
> > > > > Iterating over minors for cgroups sounds very, very wrong. Why do
> we care
> > > > > whether a buffer was allocated through kms dumb vs render nodes?
> > > > >
> > > > > I'd expect all the cgroup stuff to only work on drm_device, if it
> does
> > > > > care about devices.
> > > > >
> > > > > (I didn't look through the patch series to find out where exactly
> you're
> > > > > using this, so maybe I'm off the rails here).
> > > >
> > > > I am exposing this to remove the need to keep track of a separate
> list
> > > > of available drm_device in the system (to remove the registering and
> > > > unregistering of drm_device to the cgroup subsystem and just use
> > > > drm_minor as the single source of truth.)  I am only filtering out
> the
> > > > render nodes minor because they point to the same drm_device and is
> > > > confusing.
> > > >
> > > > Perhaps I missed an obvious way to list the drm devices without
> > > > iterating through the drm_minors?  (I probably jumped to the minors
> > > > because $major:$minor is the convention to address devices in
> cgroup.)
> > >
> > > Create your own if there's nothing, because you need to anyway:
> > > - You need special locking anyway, we can't just block on the idr lock
> > > for everything.
> > > - This needs to refcount drm_device, no the minors.
> > >
> > > Iterating over stuff still feels kinda wrong still, because normally
> > > the way we register/unregister userspace api (and cgroups isn't
> > > anything else from a drm driver pov) is by adding more calls to
> > > drm_dev_register/unregister. If you put a drm_cg_register/unregister
> > > call in there we have a clean separation, and you can track all the
> > > currently active devices however you want. Iterating over objects that
> > > can be hotunplugged any time tends to get really complicated really
> > > quickly.
> >
> > Um... I thought this is what I had previously.  Did I misunderstood
> > your feedback from v3?  Doesn't drm_minor already include all these
> > facilities so isn't creating my own kind of reinventing the wheel?
> > (as I did previously?)  drm_minor_register is called inside
> > drm_dev_register so isn't leveraging existing drm_minor facilities
> > much better solution?
>
> Hm the previous version already dropped out of my inbox, so hard to find
> it again. And I couldn't find this in archieves. Do you have pointers?
>
> I thought the previous version did cgroup init separately from drm_device
> setup, and I guess I suggested that it should be moved int
> drm_dev_register/unregister?
>
> Anyway, I don't think reusing the drm_minor registration makes sense,
> since we want to be on the drm_device, not on the minor. Which is a bit
> awkward for cgroups, which wants to identify devices using major.minor
> pairs. But I guess drm is the first subsystem where 1 device can be
> exposed through multiple minors ...
>
> Tejun, any suggestions on this?
>
> Anyway, I think just leveraging existing code because it can be abused to
> make it fit for us doesn't make sense. E.g. for the kms side we also don't
> piggy-back on top of drm_minor_register (it would be technically
> possible), but instead we have drm_modeset_register_all().
> -Daniel
>
> >
> > Kenny
> >
> > >
> > >
> > > >
> > > > Kenny
> > > >
> > > > > -Daniel
> > > > >
> > > > > > ---
> > > > > >  drivers/gpu/drm/drm_drv.c      | 19 +++++++++++++++++++
> > > > > >  drivers/gpu/drm/drm_internal.h |  4 ----
> > > > > >  include/drm/drm_drv.h          |  4 ++++
> > > > > >  3 files changed, 23 insertions(+), 4 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/gpu/drm/drm_drv.c
> b/drivers/gpu/drm/drm_drv.c
> > > > > > index 862621494a93..000cddabd970 100644
> > > > > > --- a/drivers/gpu/drm/drm_drv.c
> > > > > > +++ b/drivers/gpu/drm/drm_drv.c
> > > > > > @@ -254,11 +254,13 @@ struct drm_minor
> *drm_minor_acquire(unsigned int minor_id)
> > > > > >
> > > > > >       return minor;
> > > > > >  }
> > > > > > +EXPORT_SYMBOL(drm_minor_acquire);
> > > > > >
> > > > > >  void drm_minor_release(struct drm_minor *minor)
> > > > > >  {
> > > > > >       drm_dev_put(minor->dev);
> > > > > >  }
> > > > > > +EXPORT_SYMBOL(drm_minor_release);
> > > > > >
> > > > > >  /**
> > > > > >   * DOC: driver instance overview
> > > > > > @@ -1078,6 +1080,23 @@ int drm_dev_set_unique(struct drm_device
> *dev, const char *name)
> > > > > >  }
> > > > > >  EXPORT_SYMBOL(drm_dev_set_unique);
> > > > > >
> > > > > > +/**
> > > > > > + * drm_minor_for_each - Iterate through all stored DRM minors
> > > > > > + * @fn: Function to be called for each pointer.
> > > > > > + * @data: Data passed to callback function.
> > > > > > + *
> > > > > > + * The callback function will be called for each @drm_minor
> entry, passing
> > > > > > + * the minor, the entry and @data.
> > > > > > + *
> > > > > > + * If @fn returns anything other than %0, the iteration stops
> and that
> > > > > > + * value is returned from this function.
> > > > > > + */
> > > > > > +int drm_minor_for_each(int (*fn)(int id, void *p, void *data),
> void *data)
> > > > > > +{
> > > > > > +     return idr_for_each(&drm_minors_idr, fn, data);
> > > > > > +}
> > > > > > +EXPORT_SYMBOL(drm_minor_for_each);
> > > > > > +
> > > > > >  /*
> > > > > >   * DRM Core
> > > > > >   * The DRM core module initializes all global DRM objects and
> makes them
> > > > > > diff --git a/drivers/gpu/drm/drm_internal.h
> b/drivers/gpu/drm/drm_internal.h
> > > > > > index e19ac7ca602d..6bfad76f8e78 100644
> > > > > > --- a/drivers/gpu/drm/drm_internal.h
> > > > > > +++ b/drivers/gpu/drm/drm_internal.h
> > > > > > @@ -54,10 +54,6 @@ void drm_prime_destroy_file_private(struct
> drm_prime_file_private *prime_fpriv);
> > > > > >  void drm_prime_remove_buf_handle_locked(struct
> drm_prime_file_private *prime_fpriv,
> > > > > >                                       struct dma_buf *dma_buf);
> > > > > >
> > > > > > -/* drm_drv.c */
> > > > > > -struct drm_minor *drm_minor_acquire(unsigned int minor_id);
> > > > > > -void drm_minor_release(struct drm_minor *minor);
> > > > > > -
> > > > > >  /* drm_vblank.c */
> > > > > >  void drm_vblank_disable_and_save(struct drm_device *dev,
> unsigned int pipe);
> > > > > >  void drm_vblank_cleanup(struct drm_device *dev);
> > > > > > diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
> > > > > > index 68ca736c548d..24f8d054c570 100644
> > > > > > --- a/include/drm/drm_drv.h
> > > > > > +++ b/include/drm/drm_drv.h
> > > > > > @@ -799,5 +799,9 @@ static inline bool
> drm_drv_uses_atomic_modeset(struct drm_device *dev)
> > > > > >
> > > > > >  int drm_dev_set_unique(struct drm_device *dev, const char
> *name);
> > > > > >
> > > > > > +int drm_minor_for_each(int (*fn)(int id, void *p, void *data),
> void *data);
> > > > > > +
> > > > > > +struct drm_minor *drm_minor_acquire(unsigned int minor_id);
> > > > > > +void drm_minor_release(struct drm_minor *minor);
> > > > > >
> > > > > >  #endif
> > > > > > --
> > > > > > 2.22.0
> > > > > >
> > > > >
> > > > > --
> > > > > Daniel Vetter
> > > > > Software Engineer, Intel Corporation
> > > > > http://blog.ffwll.ch
> > >
> > >
> > >
> > > --
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch
>

--0000000000005776e70591d27847
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Daniel,<br><br>This is the previous patch relevant to t=
his discussion:<br><a href=3D"https://patchwork.freedesktop.org/patch/31434=
3/">https://patchwork.freedesktop.org/patch/314343/</a><br><br>So before I =
refactored the code to leverage drm_minor, I kept my own list of &quot;know=
n&quot; drm_device inside the controller and have explicit register and unr=
egister function to init per device cgroup defaults.=C2=A0 For v4, I refact=
ored the per device cgroup properties and embedded them into the drm_device=
 and continue to only use the primary minor as a way to index the device as=
 v3.<div><br></div><div>Regards,<br>Kenny</div></div><br><div class=3D"gmai=
l_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Sep 4, 2019 at 4:54 =
AM Daniel Vetter &lt;<a href=3D"mailto:daniel-/w4YWyX8dFk@public.gmane.org">daniel-/w4YWyX8dFk@public.gmane.org</a>=
&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On T=
ue, Sep 03, 2019 at 04:43:45PM -0400, Kenny Ho wrote:<br>
&gt; On Tue, Sep 3, 2019 at 4:12 PM Daniel Vetter &lt;<a href=3D"mailto:dan=
iel-/w4YWyX8dFk@public.gmane.org" target=3D"_blank">daniel-/w4YWyX8dFk@public.gmane.org</a>&gt; wrote:<br>
&gt; &gt; On Tue, Sep 3, 2019 at 9:45 PM Kenny Ho &lt;<a href=3D"mailto:y2k=
enny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" target=3D"_blank">y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt; wrote:<br>
&gt; &gt; &gt; On Tue, Sep 3, 2019 at 3:57 AM Daniel Vetter &lt;<a href=3D"=
mailto:daniel-/w4YWyX8dFk@public.gmane.org" target=3D"_blank">daniel-/w4YWyX8dFk@public.gmane.org</a>&gt; wrote:<br=
>
&gt; &gt; &gt; &gt; Iterating over minors for cgroups sounds very, very wro=
ng. Why do we care<br>
&gt; &gt; &gt; &gt; whether a buffer was allocated through kms dumb vs rend=
er nodes?<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; I&#39;d expect all the cgroup stuff to only work on drm=
_device, if it does<br>
&gt; &gt; &gt; &gt; care about devices.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; (I didn&#39;t look through the patch series to find out=
 where exactly you&#39;re<br>
&gt; &gt; &gt; &gt; using this, so maybe I&#39;m off the rails here).<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I am exposing this to remove the need to keep track of a sep=
arate list<br>
&gt; &gt; &gt; of available drm_device in the system (to remove the registe=
ring and<br>
&gt; &gt; &gt; unregistering of drm_device to the cgroup subsystem and just=
 use<br>
&gt; &gt; &gt; drm_minor as the single source of truth.)=C2=A0 I am only fi=
ltering out the<br>
&gt; &gt; &gt; render nodes minor because they point to the same drm_device=
 and is<br>
&gt; &gt; &gt; confusing.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Perhaps I missed an obvious way to list the drm devices with=
out<br>
&gt; &gt; &gt; iterating through the drm_minors?=C2=A0 (I probably jumped t=
o the minors<br>
&gt; &gt; &gt; because $major:$minor is the convention to address devices i=
n cgroup.)<br>
&gt; &gt;<br>
&gt; &gt; Create your own if there&#39;s nothing, because you need to anywa=
y:<br>
&gt; &gt; - You need special locking anyway, we can&#39;t just block on the=
 idr lock<br>
&gt; &gt; for everything.<br>
&gt; &gt; - This needs to refcount drm_device, no the minors.<br>
&gt; &gt;<br>
&gt; &gt; Iterating over stuff still feels kinda wrong still, because norma=
lly<br>
&gt; &gt; the way we register/unregister userspace api (and cgroups isn&#39=
;t<br>
&gt; &gt; anything else from a drm driver pov) is by adding more calls to<b=
r>
&gt; &gt; drm_dev_register/unregister. If you put a drm_cg_register/unregis=
ter<br>
&gt; &gt; call in there we have a clean separation, and you can track all t=
he<br>
&gt; &gt; currently active devices however you want. Iterating over objects=
 that<br>
&gt; &gt; can be hotunplugged any time tends to get really complicated real=
ly<br>
&gt; &gt; quickly.<br>
&gt; <br>
&gt; Um... I thought this is what I had previously.=C2=A0 Did I misundersto=
od<br>
&gt; your feedback from v3?=C2=A0 Doesn&#39;t drm_minor already include all=
 these<br>
&gt; facilities so isn&#39;t creating my own kind of reinventing the wheel?=
<br>
&gt; (as I did previously?)=C2=A0 drm_minor_register is called inside<br>
&gt; drm_dev_register so isn&#39;t leveraging existing drm_minor facilities=
<br>
&gt; much better solution?<br>
<br>
Hm the previous version already dropped out of my inbox, so hard to find<br=
>
it again. And I couldn&#39;t find this in archieves. Do you have pointers?<=
br>
<br>
I thought the previous version did cgroup init separately from drm_device<b=
r>
setup, and I guess I suggested that it should be moved int<br>
drm_dev_register/unregister?<br>
<br>
Anyway, I don&#39;t think reusing the drm_minor registration makes sense,<b=
r>
since we want to be on the drm_device, not on the minor. Which is a bit<br>
awkward for cgroups, which wants to identify devices using major.minor<br>
pairs. But I guess drm is the first subsystem where 1 device can be<br>
exposed through multiple minors ...<br>
<br>
Tejun, any suggestions on this?<br>
<br>
Anyway, I think just leveraging existing code because it can be abused to<b=
r>
make it fit for us doesn&#39;t make sense. E.g. for the kms side we also do=
n&#39;t<br>
piggy-back on top of drm_minor_register (it would be technically<br>
possible), but instead we have drm_modeset_register_all().<br>
-Daniel<br>
<br>
&gt; <br>
&gt; Kenny<br>
&gt; <br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Kenny<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; -Daniel<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; ---<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 drivers/gpu/drm/drm_drv.c=C2=A0 =C2=A0 =C2=
=A0 | 19 +++++++++++++++++++<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 drivers/gpu/drm/drm_internal.h |=C2=A0 4 ---=
-<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 include/drm/drm_drv.h=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 4 ++++<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 3 files changed, 23 insertions(+), 4 deletio=
ns(-)<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/g=
pu/drm/drm_drv.c<br>
&gt; &gt; &gt; &gt; &gt; index 862621494a93..000cddabd970 100644<br>
&gt; &gt; &gt; &gt; &gt; --- a/drivers/gpu/drm/drm_drv.c<br>
&gt; &gt; &gt; &gt; &gt; +++ b/drivers/gpu/drm/drm_drv.c<br>
&gt; &gt; &gt; &gt; &gt; @@ -254,11 +254,13 @@ struct drm_minor *drm_minor_=
acquire(unsigned int minor_id)<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return minor;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt; +EXPORT_SYMBOL(drm_minor_acquire);<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 void drm_minor_release(struct drm_minor *min=
or)<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0drm_dev_put(minor-&gt;de=
v);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt; +EXPORT_SYMBOL(drm_minor_release);<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 /**<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0* DOC: driver instance overview<br>
&gt; &gt; &gt; &gt; &gt; @@ -1078,6 +1080,23 @@ int drm_dev_set_unique(stru=
ct drm_device *dev, const char *name)<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 }<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 EXPORT_SYMBOL(drm_dev_set_unique);<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; +/**<br>
&gt; &gt; &gt; &gt; &gt; + * drm_minor_for_each - Iterate through all store=
d DRM minors<br>
&gt; &gt; &gt; &gt; &gt; + * @fn: Function to be called for each pointer.<b=
r>
&gt; &gt; &gt; &gt; &gt; + * @data: Data passed to callback function.<br>
&gt; &gt; &gt; &gt; &gt; + *<br>
&gt; &gt; &gt; &gt; &gt; + * The callback function will be called for each =
@drm_minor entry, passing<br>
&gt; &gt; &gt; &gt; &gt; + * the minor, the entry and @data.<br>
&gt; &gt; &gt; &gt; &gt; + *<br>
&gt; &gt; &gt; &gt; &gt; + * If @fn returns anything other than %0, the ite=
ration stops and that<br>
&gt; &gt; &gt; &gt; &gt; + * value is returned from this function.<br>
&gt; &gt; &gt; &gt; &gt; + */<br>
&gt; &gt; &gt; &gt; &gt; +int drm_minor_for_each(int (*fn)(int id, void *p,=
 void *data), void *data)<br>
&gt; &gt; &gt; &gt; &gt; +{<br>
&gt; &gt; &gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0return idr_for_each(&amp;drm_=
minors_idr, fn, data);<br>
&gt; &gt; &gt; &gt; &gt; +}<br>
&gt; &gt; &gt; &gt; &gt; +EXPORT_SYMBOL(drm_minor_for_each);<br>
&gt; &gt; &gt; &gt; &gt; +<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 /*<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0* DRM Core<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0* The DRM core module initializes all =
global DRM objects and makes them<br>
&gt; &gt; &gt; &gt; &gt; diff --git a/drivers/gpu/drm/drm_internal.h b/driv=
ers/gpu/drm/drm_internal.h<br>
&gt; &gt; &gt; &gt; &gt; index e19ac7ca602d..6bfad76f8e78 100644<br>
&gt; &gt; &gt; &gt; &gt; --- a/drivers/gpu/drm/drm_internal.h<br>
&gt; &gt; &gt; &gt; &gt; +++ b/drivers/gpu/drm/drm_internal.h<br>
&gt; &gt; &gt; &gt; &gt; @@ -54,10 +54,6 @@ void drm_prime_destroy_file_pri=
vate(struct drm_prime_file_private *prime_fpriv);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 void drm_prime_remove_buf_handle_locked(stru=
ct drm_prime_file_private *prime_fpriv,<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0struct dma_buf *dma_buf);<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; -/* drm_drv.c */<br>
&gt; &gt; &gt; &gt; &gt; -struct drm_minor *drm_minor_acquire(unsigned int =
minor_id);<br>
&gt; &gt; &gt; &gt; &gt; -void drm_minor_release(struct drm_minor *minor);<=
br>
&gt; &gt; &gt; &gt; &gt; -<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 /* drm_vblank.c */<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 void drm_vblank_disable_and_save(struct drm_=
device *dev, unsigned int pipe);<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 void drm_vblank_cleanup(struct drm_device *d=
ev);<br>
&gt; &gt; &gt; &gt; &gt; diff --git a/include/drm/drm_drv.h b/include/drm/d=
rm_drv.h<br>
&gt; &gt; &gt; &gt; &gt; index 68ca736c548d..24f8d054c570 100644<br>
&gt; &gt; &gt; &gt; &gt; --- a/include/drm/drm_drv.h<br>
&gt; &gt; &gt; &gt; &gt; +++ b/include/drm/drm_drv.h<br>
&gt; &gt; &gt; &gt; &gt; @@ -799,5 +799,9 @@ static inline bool drm_drv_use=
s_atomic_modeset(struct drm_device *dev)<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 int drm_dev_set_unique(struct drm_device *de=
v, const char *name);<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; +int drm_minor_for_each(int (*fn)(int id, void *p,=
 void *data), void *data);<br>
&gt; &gt; &gt; &gt; &gt; +<br>
&gt; &gt; &gt; &gt; &gt; +struct drm_minor *drm_minor_acquire(unsigned int =
minor_id);<br>
&gt; &gt; &gt; &gt; &gt; +void drm_minor_release(struct drm_minor *minor);<=
br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 #endif<br>
&gt; &gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; &gt; 2.22.0<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; --<br>
&gt; &gt; &gt; &gt; Daniel Vetter<br>
&gt; &gt; &gt; &gt; Software Engineer, Intel Corporation<br>
&gt; &gt; &gt; &gt; <a href=3D"http://blog.ffwll.ch" rel=3D"noreferrer" tar=
get=3D"_blank">http://blog.ffwll.ch</a><br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; --<br>
&gt; &gt; Daniel Vetter<br>
&gt; &gt; Software Engineer, Intel Corporation<br>
&gt; &gt; +41 (0) 79 365 57 48 - <a href=3D"http://blog.ffwll.ch" rel=3D"no=
referrer" target=3D"_blank">http://blog.ffwll.ch</a><br>
<br>
-- <br>
Daniel Vetter<br>
Software Engineer, Intel Corporation<br>
<a href=3D"http://blog.ffwll.ch" rel=3D"noreferrer" target=3D"_blank">http:=
//blog.ffwll.ch</a><br>
</blockquote></div>

--0000000000005776e70591d27847--

--===============1304886654==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBt
YWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4

--===============1304886654==--
