From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v2 6/6] android: binder: Add a buffer flag to relinquish
 ownership of fds
Date: Mon, 14 Feb 2022 14:25:47 -0800
Message-ID: <CABdmKX1eKZZ9809uxnzT_Bm+mdNuK2AObLRxyBpdDF3yE76Hrg@mail.gmail.com>
References: <20220211161831.3493782-1-tjmercier@google.com>
 <20220211161831.3493782-7-tjmercier@google.com> <Ygdfe3XSvN8iFuUc@kroah.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IHISBmUOI/ikE6WItRpq9TFUbX44lb92b2lXd2BONMg=;
        b=kXzDIbeon23MHLMt55FkUQMNMzpbUwjF4pGEHQVVR8kxY9f8bNkaLn7jE0kbUtbn3L
         b9kl4UwC8flsLgF3qVMkSmkvmdF1Jt9Kjef1jBBpf5/Zf+a+E7tm2ei87Qd5NbmIKrOF
         N82gD75TFZH0mtC5IYIsG8oT11N0ErdMbUQ+vDx4iQdPDduvByEYqq0+N85F+cKyEzjH
         qAJ9CPKDgzdEdqLPAEum3T8FIlDiMJQUosPgAeySYE6owzXoDc9a5wNuN0Re5wGSB2JK
         +J/lWvtMVPoSlQn5X6RkXil8/6Lfo9tlft0Vb/pupOfjNdjHeBjWfIslcuL+R2HeH5L/
         d/2g==
In-Reply-To: <Ygdfe3XSvN8iFuUc-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Bri>

On Fri, Feb 11, 2022 at 11:19 PM Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>
> On Fri, Feb 11, 2022 at 04:18:29PM +0000, T.J. Mercier wrote:
> > This patch introduces a buffer flag BINDER_BUFFER_FLAG_SENDER_NO_NEED
> > that a process sending an fd array to another process over binder IPC
> > can set to relinquish ownership of the fds being sent for memory
> > accounting purposes. If the flag is found to be set during the fd array
> > translation and the fd is for a DMA-BUF, the buffer is uncharged from
> > the sender's cgroup and charged to the receiving process's cgroup
> > instead.
> >
> > It is up to the sending process to ensure that it closes the fds
> > regardless of whether the transfer failed or succeeded.
> >
> > Most graphics shared memory allocations in Android are done by the
> > graphics allocator HAL process. On requests from clients, the HAL proce=
ss
> > allocates memory and sends the fds to the clients over binder IPC.
> > The graphics allocator HAL will not retain any references to the
> > buffers. When the HAL sets the BINDER_BUFFER_FLAG_SENDER_NO_NEED for fd
> > arrays holding DMA-BUF fds, the gpu cgroup controller will be able to
> > correctly charge the buffers to the client processes instead of the
> > graphics allocator HAL.
> >
> > From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Co-developed-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> > changes in v2
> > - Move dma-buf cgroup charge transfer from a dma_buf_op defined by ever=
y
> > heap to a single dma-buf function for all heaps per Daniel Vetter and
> > Christian K=C3=B6nig.
> >
> >  drivers/android/binder.c            | 26 ++++++++++++++++++++++++++
> >  include/uapi/linux/android/binder.h |  1 +
> >  2 files changed, 27 insertions(+)
> >
> > diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> > index 8351c5638880..f50d88ded188 100644
> > --- a/drivers/android/binder.c
> > +++ b/drivers/android/binder.c
> > @@ -42,6 +42,7 @@
> >
> >  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> >
> > +#include <linux/dma-buf.h>
> >  #include <linux/fdtable.h>
> >  #include <linux/file.h>
> >  #include <linux/freezer.h>
> > @@ -2482,8 +2483,10 @@ static int binder_translate_fd_array(struct list=
_head *pf_head,
> >  {
> >       binder_size_t fdi, fd_buf_size;
> >       binder_size_t fda_offset;
> > +     bool transfer_gpu_charge =3D false;
> >       const void __user *sender_ufda_base;
> >       struct binder_proc *proc =3D thread->proc;
> > +     struct binder_proc *target_proc =3D t->to_proc;
> >       int ret;
> >
> >       fd_buf_size =3D sizeof(u32) * fda->num_fds;
> > @@ -2521,8 +2524,15 @@ static int binder_translate_fd_array(struct list=
_head *pf_head,
> >       if (ret)
> >               return ret;
> >
> > +     if (IS_ENABLED(CONFIG_CGROUP_GPU) &&
> > +             parent->flags & BINDER_BUFFER_FLAG_SENDER_NO_NEED)
> > +             transfer_gpu_charge =3D true;
> > +
> >       for (fdi =3D 0; fdi < fda->num_fds; fdi++) {
> >               u32 fd;
> > +             struct dma_buf *dmabuf;
> > +             struct gpucg *gpucg;
> > +
> >               binder_size_t offset =3D fda_offset + fdi * sizeof(fd);
> >               binder_size_t sender_uoffset =3D fdi * sizeof(fd);
> >
> > @@ -2532,6 +2542,22 @@ static int binder_translate_fd_array(struct list=
_head *pf_head,
> >                                                 in_reply_to);
> >               if (ret)
> >                       return ret > 0 ? -EINVAL : ret;
> > +
> > +             if (!transfer_gpu_charge)
> > +                     continue;
> > +
> > +             dmabuf =3D dma_buf_get(fd);
> > +             if (IS_ERR(dmabuf))
> > +                     continue;
> > +
> > +             gpucg =3D gpucg_get(target_proc->tsk);
> > +             ret =3D dma_buf_charge_transfer(dmabuf, gpucg);
> > +             if (ret) {
> > +                     pr_warn("%d:%d Unable to transfer DMA-BUF fd char=
ge to %d",
> > +                             proc->pid, thread->pid, target_proc->pid)=
;
> > +                     gpucg_put(gpucg);
> > +             }
> > +             dma_buf_put(dmabuf);
> >       }
> >       return 0;
> >  }
> > diff --git a/include/uapi/linux/android/binder.h b/include/uapi/linux/a=
ndroid/binder.h
> > index 3246f2c74696..169fd5069a1a 100644
> > --- a/include/uapi/linux/android/binder.h
> > +++ b/include/uapi/linux/android/binder.h
> > @@ -137,6 +137,7 @@ struct binder_buffer_object {
> >
> >  enum {
> >       BINDER_BUFFER_FLAG_HAS_PARENT =3D 0x01,
> > +     BINDER_BUFFER_FLAG_SENDER_NO_NEED =3D 0x02,
> >  };
> >
> >  /* struct binder_fd_array_object - object describing an array of fds i=
n a buffer
> > --
> > 2.35.1.265.g69c8d7142f-goog
> >
>
> How does userspace know that binder supports this new flag?

Sorry, I don't completely follow even after Todd's comment. Doesn't
the presence of BINDER_BUFFER_FLAG_SENDER_NO_NEED in the header do
this? So wouldn't userspace need to be compiled against the wrong
kernel headers for there to be a problem? In that case the allocation
would still succeed, but there would be no charge transfer and
unfortunately no error code.

> And where is the userspace test for this new feature?

I tested this on a Pixel after modifying the gralloc implementation to
mark allocated buffers as not used by the sender. This required
setting the BINDER_BUFFER_FLAG_SENDER_NO_NEED in libhwbinder. That
code can be found here:
https://android-review.googlesource.com/c/platform/system/libhwbinder/+/191=
0752/1/Parcel.cpp
https://android-review.googlesource.com/c/platform/system/libhidl/+/1910611=
/

Then by inspecting gpu.memory.current files in sysfs I was able to see
the memory attributed to processes other than the graphics allocator
service. Before this change, several megabytes of memory were
attributed to the graphics allocator service but those buffers are
actually used by other processes like surfaceflinger, the camera, etc.
After the change, the gpu.memory.current amount for the graphics
allocator service was 0 and the charges showed up in the
gpu.memory.current files for those other processes like this:

PID: 764 Process Name: zygote64
system 8192
system-uncached 23191552

PID: 529 Process Name: /system/bin/surfaceflinger
system-uncached 109535232
system 92196864

PID: 530 Process Name:
/vendor/bin/hw/android.hardware.graphics.allocator@4.0-service
system-uncached 0
system 0
sensor_direct_heap 0

PID: 806 Process Name:
/apex/com.google.pixel.camera.hal/bin/hw/android.hardware.camera.provider@2=
.7-service-google
system 1196032

PID: 4608 Process Name: com.google.android.GoogleCamera
system 2408448
system-uncached 38887424
sensor_direct_heap 0

PID: 32102 Process Name: com.google.android.googlequicksearchbox:search
system-uncached 91279360
system 20480

PID: 2758 Process Name: com.google.android.youtube
system-uncached 1662976
system 8192

PID: 2517 Process Name: com.google.android.apps.nexuslauncher
system-uncached 115662848
system 122880

PID: 2066 Process Name: com.android.systemui
system 86016
system-uncached 37957632

>  Isn't there a binder test framework somewhere?

Android has the Vendor Test Suite where automated tests could be added
for this. Is that what you're thinking of?

>
> thanks,
>
> greg k-h
