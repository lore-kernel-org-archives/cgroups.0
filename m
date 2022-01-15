From: Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC 0/6] Proposal for a GPU cgroup controller
Date: Fri, 14 Jan 2022 17:05:58 -0800
Message-ID: <20220115010622.3185921-1-hridya@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wG/PbGVmKjgf1eOd11ftVQTDqJEywAnSirRvk8YQoEA=;
        b=ra40WJSnTd+Sg9D3TIvHREEZJO5QmFxwXzwakhy95Pj15AdCn96Rg7F+gGkzzdoPHL
         /LCXltr47kWOGGC4J/j+jKdN7xu6RyW7gUeuH5vavWrndAu7BzKurEIyahiOS6sTnazd
         kjhutzh5GjtqfNnBjsMi1N1OKm+eTNmejUCgViGcOUkB/EFui5twnu1ZKaXi21WPA1C7
         hDv3dAKWpj1mixAwX1dUro0zgPo6Npzf7sXOSvaZIstusYMToZmeNzSzidVL3FAMroY6
         HrShrnaUArO3g2alaInh2tQWQ8dpEbE6FBLnde1xIXMV4W2bjw4NgeUFBmdKReIihG44
         DGmQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Sta>
Cc: Kenny.Ho-5C7GfCeVMHo@public.gmane.org, daniels-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

This patch series revisits the proposal for a GPU cgroup controller to
track and limit memory allocations by various device/allocator
subsystems. The patch series also contains a simple prototype to
illustrate how Android intends to implement DMA-BUF allocator
attribution using the GPU cgroup controller. The prototype does not
include resource limit enforcements.

History of the GPU cgroup controller
====================================
The GPU/DRM cgroup controller came into being when a consensus[1]
was reached that the resources it tracked were unsuitable to be integrated
into memcg. Originally, the proposed controller was specific to the DRM
subsystem and was intended to track GEM buffers and GPU-specific resources[2].
In order to help establish a unified memory accounting model for all GPU and
all related subsystems, Daniel Vetter put forth a suggestion to move it out of
the DRM subsystem so that it can be used by other DMA-BUF exporters as well[3].
This RFC proposes an interface that does the same.

[1]: https://patchwork.kernel.org/project/dri-devel/cover/20190501140438.9506-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/#22624705
[2]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
[3]: https://lore.kernel.org/amd-gfx/YCVOl8%2F87bqRSQei-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org/

Hridya Valsaraju (6):
  gpu: rfc: Proposal for a GPU cgroup controller
  cgroup: gpu: Add a cgroup controller for allocator attribution of GPU
    memory
  dmabuf: heaps: Use the GPU cgroup charge/uncharge APIs
  dma-buf: Add DMA-BUF exporter op to charge a DMA-BUF to a cgroup.
  dmabuf: system_heap: implement dma-buf op for GPU cgroup charge
    transfer
  android: binder: Add a buffer flag to relinquish ownership of fds

 Documentation/gpu/rfc/gpu-cgroup.rst | 192 +++++++++++++++++
 Documentation/gpu/rfc/index.rst      |   4 +
 drivers/android/binder.c             |  32 +++
 drivers/dma-buf/dma-heap.c           |  27 +++
 drivers/dma-buf/heaps/system_heap.c  |  68 ++++++
 include/linux/cgroup_gpu.h           | 120 +++++++++++
 include/linux/cgroup_subsys.h        |   4 +
 include/linux/dma-buf.h              |  18 ++
 include/linux/dma-heap.h             |  11 +
 include/uapi/linux/android/binder.h  |   1 +
 init/Kconfig                         |   7 +
 kernel/cgroup/Makefile               |   1 +
 kernel/cgroup/gpu.c                  | 305 +++++++++++++++++++++++++++
 13 files changed, 790 insertions(+)
 create mode 100644 Documentation/gpu/rfc/gpu-cgroup.rst
 create mode 100644 include/linux/cgroup_gpu.h
 create mode 100644 kernel/cgroup/gpu.c

-- 
2.34.1.703.g22d0c6ccf7-goog

