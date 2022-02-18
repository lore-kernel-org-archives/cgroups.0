From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v2 0/6] Proposal for a GPU cgroup controller
Date: Fri, 18 Feb 2022 11:12:44 -0800
Message-ID: <CABdmKX3qO7UW-HGXMdZZdVi1P8FnKDh0H=TGT_ct=tHoAeVxbw@mail.gmail.com>
References: <20220211161831.3493782-1-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kFx5mVaEHwZpR1G+osdopjqc+OzJyT2vvM3+pSprCFk=;
        b=EQ+kstcsfvyoiVxpZH4DOveKWuo8ZLZzYUIop0Vlthf3r2DTADG1kDnjLZlmhEiEk+
         6G1pQYgdE0Nh9wv/F/mr614cojFdmQRp2bm+wGYz7pZOcacHQguC10UzY7EM+1ffc44f
         Wm1l5TaMSkrezOOuca+rkd439a22duxj7f/9y8nVcQJWPTcyz8zTDf/7iz5H+ApzRhTQ
         NbqGdRr/U/H9RUKkTlGKY86fsffbY3C0Y3yyKrxlpGI6ol/qaBZxmLnCbHD8+AclEyv0
         7/rPTsF6rq9ujxffbMlZt2i1zvBQfzL4TUlU49jq+ZYhmHm7rxl9MwWPEqQDFslXytJ8
         Gf+w==
In-Reply-To: <20220211161831.3493782-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laur
Cc: Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 11, 2022 at 8:18 AM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> This patch series revisits the proposal for a GPU cgroup controller to
> track and limit memory allocations by various device/allocator
> subsystems. The patch series also contains a simple prototype to
> illustrate how Android intends to implement DMA-BUF allocator
> attribution using the GPU cgroup controller. The prototype does not
> include resource limit enforcements.
>
> Changelog:
>
> v2:
> See the previous revision of this change submitted by Hridya Valsaraju
> at: https://lore.kernel.org/all/20220115010622.3185921-1-hridya-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m/
>
> Move dma-buf cgroup charge transfer from a dma_buf_op defined by every
> heap to a single dma-buf function for all heaps per Daniel Vetter and
> Christian K=C3=B6nig. Pointers to struct gpucg and struct gpucg_device
> tracking the current associations were added to the dma_buf struct to
> achieve this.
>
> Fix incorrect Kconfig help section indentation per Randy Dunlap.
>
> History of the GPU cgroup controller
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The GPU/DRM cgroup controller came into being when a consensus[1]
> was reached that the resources it tracked were unsuitable to be integrate=
d
> into memcg. Originally, the proposed controller was specific to the DRM
> subsystem and was intended to track GEM buffers and GPU-specific
> resources[2]. In order to help establish a unified memory accounting mode=
l
> for all GPU and all related subsystems, Daniel Vetter put forth a
> suggestion to move it out of the DRM subsystem so that it can be used by
> other DMA-BUF exporters as well[3]. This RFC proposes an interface that
> does the same.
>
> [1]: https://patchwork.kernel.org/project/dri-devel/cover/20190501140438.=
9506-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/#22624705
> [2]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty@i=
ntel.com/
> [3]: https://lore.kernel.org/amd-gfx/YCVOl8%2F87bqRSQei-dv86pmgwkMBes7Z6vYuT8fd9D2ou9A/h@public.gmane.org=
l/
>
> T.J. Mercier (6):
>   gpu: rfc: Proposal for a GPU cgroup controller
>   cgroup: gpu: Add a cgroup controller for allocator attribution of GPU
>     memory
>   dmabuf: Use the GPU cgroup charge/uncharge APIs
>   dmabuf: heaps: export system_heap buffers with GPU cgroup charging
>   dmabuf: Add gpu cgroup charge transfer function
>   android: binder: Add a buffer flag to relinquish ownership of fds
>
>  Documentation/gpu/rfc/gpu-cgroup.rst | 195 +++++++++++++++++
>  Documentation/gpu/rfc/index.rst      |   4 +
>  drivers/android/binder.c             |  26 +++
>  drivers/dma-buf/dma-buf.c            | 100 +++++++++
>  drivers/dma-buf/dma-heap.c           |  27 +++
>  drivers/dma-buf/heaps/system_heap.c  |   3 +
>  include/linux/cgroup_gpu.h           | 127 +++++++++++
>  include/linux/cgroup_subsys.h        |   4 +
>  include/linux/dma-buf.h              |  22 +-
>  include/linux/dma-heap.h             |  11 +
>  include/uapi/linux/android/binder.h  |   1 +
>  init/Kconfig                         |   7 +
>  kernel/cgroup/Makefile               |   1 +
>  kernel/cgroup/gpu.c                  | 304 +++++++++++++++++++++++++++
>  14 files changed, 830 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/gpu/rfc/gpu-cgroup.rst
>  create mode 100644 include/linux/cgroup_gpu.h
>  create mode 100644 kernel/cgroup/gpu.c
>
> --
> 2.35.1.265.g69c8d7142f-goog
>

Gentle nudge to GPU maintainers to please provide their feedback on
this RFC. Thanks!
