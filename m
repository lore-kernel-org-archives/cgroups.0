From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [RFC v4 4/8] dmabuf: heaps: export system_heap buffers with GPU
 cgroup charging
Date: Mon, 28 Mar 2022 16:36:47 +0200
Message-ID: <YkHH/0Use7F30UUE@phenom.ffwll.local>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-5-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=v/hbcKwqx1gvBKjVXl56S5be+OnNXrcnFIQY2VQf+GQ=;
        b=P3s83mzPAy1oHFyyIJNDomqrIFEN+HTK2X/xxvM6jHZRRhY1ia7LMcyS1CUq2WRLIt
         5SoYJ0xl/ZAWRBo9MGjmVgpPNSAyN2Cue489qnIcE9rOOsVfG8KpauNpaa5c3+CHpQSK
         gw9dIkAY9rZoEPI7OMXBY9dnJLfptFfKQMVcs=
Content-Disposition: inline
In-Reply-To: <20220328035951.1817417-5-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura

On Mon, Mar 28, 2022 at 03:59:43AM +0000, T.J. Mercier wrote:
> From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>=20
> All DMA heaps now register a new GPU cgroup device upon creation, and the
> system_heap now exports buffers associated with its GPU cgroup device for
> tracking purposes.
>=20
> Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gma=
ne.org>
> Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gman=
e.org>
>=20
> ---
> v3 changes
> Use more common dual author commit message format per John Stultz.
>=20
> v2 changes
> Move dma-buf cgroup charge transfer from a dma_buf_op defined by every
> heap to a single dma-buf function for all heaps per Daniel Vetter and
> Christian K=F6nig.

Apologies for being out of the loop quite a bit. I scrolled through this
all and I think it looks good to get going.

The only thing I have is whether we should move the cgroup controllers out
of dma-buf heaps, since that's rather android centric. E.g.
- a system gpucg_device which is used by all the various single page
  allocators (dma-buf heap but also shmem helpers and really anything
  else)
- same for cma, again both for dma-buf heaps and also for the gem cma
  helpers in drm

Otherwise this will only work on non-upstream android where gpu drivers
allocate everything from dma-buf heap. If you use something like the x86
android project with mesa drivers, then driver-internal buffers will be
allocated through gem and not through dma-buf heaps. Or at least I think
that's how it works.

But also meh, we can fix this fairly easily later on by adding these
standard gpucg_dev somwehere with a bit of kerneldoc.

Anyway has my all my ack, but don't count this as my in-depth review :-)
-Daniel

> ---
>  drivers/dma-buf/dma-heap.c          | 27 +++++++++++++++++++++++++++
>  drivers/dma-buf/heaps/system_heap.c |  3 +++
>  include/linux/dma-heap.h            | 11 +++++++++++
>  3 files changed, 41 insertions(+)
>=20
> diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> index 8f5848aa144f..885072427775 100644
> --- a/drivers/dma-buf/dma-heap.c
> +++ b/drivers/dma-buf/dma-heap.c
> @@ -7,6 +7,7 @@
>   */
> =20
>  #include <linux/cdev.h>
> +#include <linux/cgroup_gpu.h>
>  #include <linux/debugfs.h>
>  #include <linux/device.h>
>  #include <linux/dma-buf.h>
> @@ -31,6 +32,7 @@
>   * @heap_devt		heap device node
>   * @list		list head connecting to list of heaps
>   * @heap_cdev		heap char device
> + * @gpucg_dev		gpu cgroup device for memory accounting
>   *
>   * Represents a heap of memory from which buffers can be made.
>   */
> @@ -41,6 +43,9 @@ struct dma_heap {
>  	dev_t heap_devt;
>  	struct list_head list;
>  	struct cdev heap_cdev;
> +#ifdef CONFIG_CGROUP_GPU
> +	struct gpucg_device gpucg_dev;
> +#endif
>  };
> =20
>  static LIST_HEAD(heap_list);
> @@ -216,6 +221,26 @@ const char *dma_heap_get_name(struct dma_heap *heap)
>  	return heap->name;
>  }
> =20
> +#ifdef CONFIG_CGROUP_GPU
> +/**
> + * dma_heap_get_gpucg_dev() - get struct gpucg_device for the heap.
> + * @heap: DMA-Heap to get the gpucg_device struct for.
> + *
> + * Returns:
> + * The gpucg_device struct for the heap. NULL if the GPU cgroup controll=
er is
> + * not enabled.
> + */
> +struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap)
> +{
> +	return &heap->gpucg_dev;
> +}
> +#else /* CONFIG_CGROUP_GPU */
> +struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap)
> +{
> +	return NULL;
> +}
> +#endif /* CONFIG_CGROUP_GPU */
> +
>  struct dma_heap *dma_heap_add(const struct dma_heap_export_info *exp_inf=
o)
>  {
>  	struct dma_heap *heap, *h, *err_ret;
> @@ -288,6 +313,8 @@ struct dma_heap *dma_heap_add(const struct dma_heap_e=
xport_info *exp_info)
>  	list_add(&heap->list, &heap_list);
>  	mutex_unlock(&heap_list_lock);
> =20
> +	gpucg_register_device(dma_heap_get_gpucg_dev(heap), exp_info->name);
> +
>  	return heap;
> =20
>  err2:
> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/=
system_heap.c
> index ab7fd896d2c4..752a05c3cfe2 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -395,6 +395,9 @@ static struct dma_buf *system_heap_allocate(struct dm=
a_heap *heap,
>  	exp_info.ops =3D &system_heap_buf_ops;
>  	exp_info.size =3D buffer->len;
>  	exp_info.flags =3D fd_flags;
> +#ifdef CONFIG_CGROUP_GPU
> +	exp_info.gpucg_dev =3D dma_heap_get_gpucg_dev(heap);
> +#endif
>  	exp_info.priv =3D buffer;
>  	dmabuf =3D dma_buf_export(&exp_info);
>  	if (IS_ERR(dmabuf)) {
> diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
> index 0c05561cad6e..e447a61d054e 100644
> --- a/include/linux/dma-heap.h
> +++ b/include/linux/dma-heap.h
> @@ -10,6 +10,7 @@
>  #define _DMA_HEAPS_H
> =20
>  #include <linux/cdev.h>
> +#include <linux/cgroup_gpu.h>
>  #include <linux/types.h>
> =20
>  struct dma_heap;
> @@ -59,6 +60,16 @@ void *dma_heap_get_drvdata(struct dma_heap *heap);
>   */
>  const char *dma_heap_get_name(struct dma_heap *heap);
> =20
> +/**
> + * dma_heap_get_gpucg_dev() - get a pointer to the struct gpucg_device f=
or the
> + * heap.
> + * @heap: DMA-Heap to retrieve gpucg_device for.
> + *
> + * Returns:
> + * The gpucg_device struct for the heap.
> + */
> +struct gpucg_device *dma_heap_get_gpucg_dev(struct dma_heap *heap);
> +
>  /**
>   * dma_heap_add - adds a heap to dmabuf heaps
>   * @exp_info:		information needed to register this heap
> --=20
> 2.35.1.1021.g381101b075-goog
>=20

--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
