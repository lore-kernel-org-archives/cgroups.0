From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [RFC v4 4/8] dmabuf: heaps: export system_heap buffers with GPU
 cgroup charging
Date: Tue, 29 Mar 2022 10:42:20 +0200
Message-ID: <YkLGbL5Z3HVCyVkK@phenom.ffwll.local>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-5-tjmercier@google.com>
 <YkHH/0Use7F30UUE@phenom.ffwll.local>
 <CABdmKX01p6g_iHsB6dd4Wwh=8iLdYiUqdY6_yyA5ax2YNHt6tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lFgsYM4zWagmGFR0mX6PcOwk+1vvvPuWIVIxk5q1HzY=;
        b=hvVW6QkfUoJI7v+QSqi4yNrySbRNmw6dpN3LGpOoEN+D5BX0bDR5eMx3aXp0NJl47N
         KOKHZ2JRZUpYhPm5RhWck5cLNWp2nTzcW13KOo0EzQkLMh7zcAdwHPty91/OFL/Yf33K
         b3pfLfKWpmSo1+KfbbJPJQup0g3wrzlk7QejA=
Content-Disposition: inline
In-Reply-To: <CABdmKX01p6g_iHsB6dd4Wwh=8iLdYiUqdY6_yyA5ax2YNHt6tQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Br

On Mon, Mar 28, 2022 at 11:28:24AM -0700, T.J. Mercier wrote:
> On Mon, Mar 28, 2022 at 7:36 AM Daniel Vetter <daniel-/w4YWyX8dFk@public.=
gmane.org> wrote:
> >
> > On Mon, Mar 28, 2022 at 03:59:43AM +0000, T.J. Mercier wrote:
> > > From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.or=
g>
> > >
> > > All DMA heaps now register a new GPU cgroup device upon creation, and=
 the
> > > system_heap now exports buffers associated with its GPU cgroup device=
 for
> > > tracking purposes.
> > >
> > > Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public=
.gmane.org>
> > > Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.=
gmane.org>
> > >
> > > ---
> > > v3 changes
> > > Use more common dual author commit message format per John Stultz.
> > >
> > > v2 changes
> > > Move dma-buf cgroup charge transfer from a dma_buf_op defined by every
> > > heap to a single dma-buf function for all heaps per Daniel Vetter and
> > > Christian K=F6nig.
> >
> > Apologies for being out of the loop quite a bit. I scrolled through this
> > all and I think it looks good to get going.
> >
> > The only thing I have is whether we should move the cgroup controllers =
out
> > of dma-buf heaps, since that's rather android centric. E.g.
> > - a system gpucg_device which is used by all the various single page
> >   allocators (dma-buf heap but also shmem helpers and really anything
> >   else)
> > - same for cma, again both for dma-buf heaps and also for the gem cma
> >   helpers in drm
>=20
> Thanks Daniel, in general that makes sense to me as an approach to
> making this more universal. However for the Android case I'm not sure
> if the part about a single system gpucg_device would be sufficient,
> because there are at least 12 different graphics related heaps that
> could potentially be accounted/limited differently. [1]  So that
> raises the question of how fine grained we want this to be... I tend
> towards separating them all, but I haven't formed a strong opinion
> about this at the moment. It sounds like you are in favor of a
> smaller, more rigidly defined set of them? Either way, we need to add
> code for accounting at points where we know memory is specifically for
> graphics use and not something else right? (I.E. Whether it is a
> dma-buf heap or somewhere like drm_gem_object_init.) So IIUC the only
> question is what to use for the gpucg_device(s) at these locations.

We don't have 12 in upstream, so this is a lot easier here :-)

I'm not exactly sure why you have such a huge pile of them.

For gem buffers it would be fairly similar to what you've done for dma-buf
heaps I think, with the various helper libraries (drivers stopped
hand-rolling their gem buffer) setting the right accounting group. And
yeah for system memory I think we'd need to have standard ones, for driver
specific ones it's kinda different.

> [1] https://cs.android.com/android/platform/superproject/+/master:hardwar=
e/google/graphics/common/libion/ion.cpp;l=3D39-50
>=20
> >
> > Otherwise this will only work on non-upstream android where gpu drivers
> > allocate everything from dma-buf heap. If you use something like the x86
> > android project with mesa drivers, then driver-internal buffers will be
> > allocated through gem and not through dma-buf heaps. Or at least I think
> > that's how it works.
> >
> > But also meh, we can fix this fairly easily later on by adding these
> > standard gpucg_dev somwehere with a bit of kerneldoc.
>=20
> This is what I was thinking would happen next, but IDK if anyone sees
> a more central place to do this type of use-specific accounting.

Hm I just realized ... are the names in the groups abi? If yes then I
think we need to fix this before we merge anything.
-Daniel

>=20
> >
> > Anyway has my all my ack, but don't count this as my in-depth review :-)
> > -Daniel
>=20
> Thanks again for taking a look!
> >
> > > ---
> > >  drivers/dma-buf/dma-heap.c          | 27 +++++++++++++++++++++++++++
> > >  drivers/dma-buf/heaps/system_heap.c |  3 +++
> > >  include/linux/dma-heap.h            | 11 +++++++++++
> > >  3 files changed, 41 insertions(+)
> > >
> > > diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> > > index 8f5848aa144f..885072427775 100644
> > > --- a/drivers/dma-buf/dma-heap.c
> > > +++ b/drivers/dma-buf/dma-heap.c
> > > @@ -7,6 +7,7 @@
> > >   */
> > >
> > >  #include <linux/cdev.h>
> > > +#include <linux/cgroup_gpu.h>
> > >  #include <linux/debugfs.h>
> > >  #include <linux/device.h>
> > >  #include <linux/dma-buf.h>
> > > @@ -31,6 +32,7 @@
> > >   * @heap_devt                heap device node
> > >   * @list             list head connecting to list of heaps
> > >   * @heap_cdev                heap char device
> > > + * @gpucg_dev                gpu cgroup device for memory accounting
> > >   *
> > >   * Represents a heap of memory from which buffers can be made.
> > >   */
> > > @@ -41,6 +43,9 @@ struct dma_heap {
> > >       dev_t heap_devt;
> > >       struct list_head list;
> > >       struct cdev heap_cdev;
> > > +#ifdef CONFIG_CGROUP_GPU
> > > +     struct gpucg_device gpucg_dev;
> > > +#endif
> > >  };
> > >
> > >  static LIST_HEAD(heap_list);
> > > @@ -216,6 +221,26 @@ const char *dma_heap_get_name(struct dma_heap *h=
eap)
> > >       return heap->name;
> > >  }
> > >
> > > +#ifdef CONFIG_CGROUP_GPU
> > > +/**
> > > + * dma_heap_get_gpucg_dev() - get struct gpucg_device for the heap.
> > > + * @heap: DMA-Heap to get the gpucg_device struct for.
> > > + *
> > > + * Returns:
> > > + * The gpucg_device struct for the heap. NULL if the GPU cgroup cont=
roller is
> > > + * not enabled.
> > > + */
> > > +struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap)
> > > +{
> > > +     return &heap->gpucg_dev;
> > > +}
> > > +#else /* CONFIG_CGROUP_GPU */
> > > +struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap)
> > > +{
> > > +     return NULL;
> > > +}
> > > +#endif /* CONFIG_CGROUP_GPU */
> > > +
> > >  struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp=
_info)
> > >  {
> > >       struct dma_heap *heap, *h, *err_ret;
> > > @@ -288,6 +313,8 @@ struct dma_heap *dma_heap_add(const struct dma_he=
ap_export_info *exp_info)
> > >       list_add(&heap->list, &heap_list);
> > >       mutex_unlock(&heap_list_lock);
> > >
> > > +     gpucg_register_device(dma_heap_get_gpucg_dev(heap), exp_info->n=
ame);
> > > +
> > >       return heap;
> > >
> > >  err2:
> > > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/he=
aps/system_heap.c
> > > index ab7fd896d2c4..752a05c3cfe2 100644
> > > --- a/drivers/dma-buf/heaps/system_heap.c
> > > +++ b/drivers/dma-buf/heaps/system_heap.c
> > > @@ -395,6 +395,9 @@ static struct dma_buf *system_heap_allocate(struc=
t dma_heap *heap,
> > >       exp_info.ops =3D &system_heap_buf_ops;
> > >       exp_info.size =3D buffer->len;
> > >       exp_info.flags =3D fd_flags;
> > > +#ifdef CONFIG_CGROUP_GPU
> > > +     exp_info.gpucg_dev =3D dma_heap_get_gpucg_dev(heap);
> > > +#endif
> > >       exp_info.priv =3D buffer;
> > >       dmabuf =3D dma_buf_export(&exp_info);
> > >       if (IS_ERR(dmabuf)) {
> > > diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
> > > index 0c05561cad6e..e447a61d054e 100644
> > > --- a/include/linux/dma-heap.h
> > > +++ b/include/linux/dma-heap.h
> > > @@ -10,6 +10,7 @@
> > >  #define _DMA_HEAPS_H
> > >
> > >  #include <linux/cdev.h>
> > > +#include <linux/cgroup_gpu.h>
> > >  #include <linux/types.h>
> > >
> > >  struct dma_heap;
> > > @@ -59,6 +60,16 @@ void *dma_heap_get_drvdata(struct dma_heap *heap);
> > >   */
> > >  const char *dma_heap_get_name(struct dma_heap *heap);
> > >
> > > +/**
> > > + * dma_heap_get_gpucg_dev() - get a pointer to the struct gpucg_devi=
ce for the
> > > + * heap.
> > > + * @heap: DMA-Heap to retrieve gpucg_device for.
> > > + *
> > > + * Returns:
> > > + * The gpucg_device struct for the heap.
> > > + */
> > > +struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap);
> > > +
> > >  /**
> > >   * dma_heap_add - adds a heap to dmabuf heaps
> > >   * @exp_info:                information needed to register this heap
> > > --
> > > 2.35.1.1021.g381101b075-goog
> > >
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch

--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
