From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 0/6] Proposal for a GPU cgroup controller
Date: Mon,  2 May 2022 23:19:34 +0000
Message-ID: <20220502231944.3891435-1-tjmercier@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=3zd6SkVHkE73vtIjS4+ESkFSoXh7wpctsPz+uIVL4JI=;
        b=c0I+qEtJMsrVZZTwAujazrXnHO+aAYhTEZ5z7hMjCZcJ/KXjOOtZIF/ejeAfZaYyos
         dY4AP2Wbz8lb7qhknFlgFZyPHF0zI7zzQZWoaUU102rnxrG7hQ2cnFuSRsDeJkVOizcu
         QO6gw837wQtQ+WkVYeU1Vtq4HjzX32QiQ0ud5nKO+r6QTo/9Ne4NFYPnTOMAcO70QSbm
         q3LnLJZlXIuMqJbIOXDQcrzfao8lJAtRRsfRMbf/34/x9dN+WX58KrhfvF8QvgdJpVWm
         1wFFbMG94teHGS8w8HOcPKLiOO0UANM2uFFBx/DE6WI+UPsEoJNz1I/i+WAnjHnlcze3
         T8Pw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Starkey <Brian.Starkey-5wv7dgnIgG8@public.gmane.org>
Cc: daniel-/w4YWyX8dFk@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linaro-mm-sig-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This patch series revisits the proposal for a GPU cgroup controller to
track and limit memory allocations by various device/allocator
subsystems. The patch series also contains a simple prototype to
illustrate how Android intends to implement DMA-BUF allocator
attribution using the GPU cgroup controller. The prototype does not
include resource limit enforcements.

Changelog:
v6:
Move documentation into cgroup-v2.rst per Tejun Heo.

Rename BINDER_FD{A}_FLAG_SENDER_NO_NEED ->
BINDER_FD{A}_FLAG_XFER_CHARGE per Carlos Llamas.

Return error on transfer failure per Carlos Llamas.

v5:
Rebase on top of v5.18-rc3

Drop the global GPU cgroup "total" (sum of all device totals) portion
of the design since there is no currently known use for this per
Tejun Heo.

Fix commit message which still contained the old name for
dma_buf_transfer_charge per Michal Koutn=C3=BD.

Remove all GPU cgroup code except what's necessary to support charge transf=
er
from dma_buf. Previously charging was done in export, but for non-Android
graphics use-cases this is not ideal since there may be a delay between
allocation and export, during which time there is no accounting.

Merge dmabuf: Use the GPU cgroup charge/uncharge APIs patch into
dmabuf: heaps: export system_heap buffers with GPU cgroup charging as a
result of above.

Put the charge and uncharge code in the same file (system_heap_allocate,
system_heap_dma_buf_release) instead of splitting them between the heap and
the dma_buf_release. This avoids asymmetric management of the gpucg charges=
.

Modify the dma_buf_transfer_charge API to accept a task_struct instead
of a gpucg. This avoids requiring the caller to manage the refcount
of the gpucg upon failure and confusing ownership transfer logic.

Support all strings for gpucg_register_bucket instead of just string
literals.

Enforce globally unique gpucg_bucket names.

Constrain gpucg_bucket name lengths to 64 bytes.

Append "-heap" to gpucg_bucket names from dmabuf-heaps.

Drop patch 7 from the series, which changed the types of
binder_transaction_data's sender_pid and sender_euid fields. This was
done in another commit here:
https://lore.kernel.org/all/20220210021129.3386083-4-masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/

Rename:
  gpucg_try_charge -> gpucg_charge
  find_cg_rpool_locked -> cg_rpool_find_locked
  init_cg_rpool -> cg_rpool_init
  get_cg_rpool_locked -> cg_rpool_get_locked
  "gpu cgroup controller" -> "GPU controller"
  gpucg_device -> gpucg_bucket
  usage -> size

Tests:
  Support both binder_fd_array_object and binder_fd_object. This is
  necessary because new versions of Android will use binder_fd_object
  instead of binder_fd_array_object, and we need to support both.

  Tests for both binder_fd_array_object and binder_fd_object.

  For binder_utils return error codes instead of
  struct binder{fs}_ctx.

  Use ifdef __ANDROID__ to choose platform-dependent temp path instead
  of a runtime fallback.

  Ensure binderfs_mntpt ends with a trailing '/' character instead of
  prepending it where used.

v4:
Skip test if not run as root per Shuah Khan

Add better test logging for abnormal child termination per Shuah Khan

Adjust ordering of charge/uncharge during transfer to avoid potentially
hitting cgroup limit per Michal Koutn=C3=BD

Adjust gpucg_try_charge critical section for charge transfer functionality

Fix uninitialized return code error for dmabuf_try_charge error case

v3:
Remove Upstreaming Plan from gpu-cgroup.rst per John Stultz

Use more common dual author commit message format per John Stultz

Remove android from binder changes title per Todd Kjos

Add a kselftest for this new behavior per Greg Kroah-Hartman

Include details on behavior for all combinations of kernel/userspace
versions in changelog (thanks Suren Baghdasaryan) per Greg Kroah-Hartman.

Fix pid and uid types in binder UAPI header

v2:
See the previous revision of this change submitted by Hridya Valsaraju
at: https://lore.kernel.org/all/20220115010622.3185921-1-hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Move dma-buf cgroup charge transfer from a dma_buf_op defined by every
heap to a single dma-buf function for all heaps per Daniel Vetter and
Christian K=C3=B6nig. Pointers to struct gpucg and struct gpucg_device
tracking the current associations were added to the dma_buf struct to
achieve this.

Fix incorrect Kconfig help section indentation per Randy Dunlap.

History of the GPU cgroup controller
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The GPU/DRM cgroup controller came into being when a consensus[1]
was reached that the resources it tracked were unsuitable to be integrated
into memcg. Originally, the proposed controller was specific to the DRM
subsystem and was intended to track GEM buffers and GPU-specific
resources[2]. In order to help establish a unified memory accounting model
for all GPU and all related subsystems, Daniel Vetter put forth a
suggestion to move it out of the DRM subsystem so that it can be used by
other DMA-BUF exporters as well[3]. This RFC proposes an interface that
does the same.

[1]: https://patchwork.kernel.org/project/dri-devel/cover/20190501140438.95=
06-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/#22624705
[2]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty@int=
el.com/
[3]: https://lore.kernel.org/amd-gfx/YCVOl8%2F87bqRSQei-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org/

Hridya Valsaraju (3):
  gpu: rfc: Proposal for a GPU cgroup controller
  cgroup: gpu: Add a cgroup controller for allocator attribution of GPU
    memory
  binder: Add flags to relinquish ownership of fds

T.J. Mercier (3):
  dmabuf: heaps: export system_heap buffers with GPU cgroup charging
  dmabuf: Add gpu cgroup charge transfer function
  selftests: Add binder cgroup gpu memory transfer tests

 Documentation/admin-guide/cgroup-v2.rst       |  24 +
 drivers/android/binder.c                      |  31 +-
 drivers/dma-buf/dma-buf.c                     |  80 ++-
 drivers/dma-buf/dma-heap.c                    |  39 ++
 drivers/dma-buf/heaps/system_heap.c           |  28 +-
 include/linux/cgroup_gpu.h                    | 137 +++++
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/dma-buf.h                       |  49 +-
 include/linux/dma-heap.h                      |  15 +
 include/uapi/linux/android/binder.h           |  23 +-
 init/Kconfig                                  |   7 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/gpu.c                           | 386 +++++++++++++
 .../selftests/drivers/android/binder/Makefile |   8 +
 .../drivers/android/binder/binder_util.c      | 250 +++++++++
 .../drivers/android/binder/binder_util.h      |  32 ++
 .../selftests/drivers/android/binder/config   |   4 +
 .../binder/test_dmabuf_cgroup_transfer.c      | 526 ++++++++++++++++++
 18 files changed, 1621 insertions(+), 23 deletions(-)
 create mode 100644 include/linux/cgroup_gpu.h
 create mode 100644 kernel/cgroup/gpu.c
 create mode 100644 tools/testing/selftests/drivers/android/binder/Makefile
 create mode 100644 tools/testing/selftests/drivers/android/binder/binder_u=
til.c
 create mode 100644 tools/testing/selftests/drivers/android/binder/binder_u=
til.h
 create mode 100644 tools/testing/selftests/drivers/android/binder/config
 create mode 100644 tools/testing/selftests/drivers/android/binder/test_dma=
buf_cgroup_transfer.c

--=20
2.36.0.464.gb9c8b46e94-goog

