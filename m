From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Wed, 26 Feb 2020 14:01:41 -0500
Message-ID: <20200226190152.16131-1-Kenny.Ho@amd.com>
References: <lkaplan@cray.com;daniel@ffwll.ch;nirmoy.das@amd.com;damon.mcdougall@amd.com;juan.zuniga-anaya@amd.com;hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cbd1SlHF0GT3rkAKka7pQv0vq0zGroXvz/Uf3xVD+j4=;
 b=1PqKup73YTPJxMOXE9gWf+Bq0e+Jnmns5X91AzIocvorV0H+Xer9QWdH+vhxV3ytn4JMinqc2Ei6k2yXshtHmPFBs1s7pFncngKWpapXMvkyyG8Ev/3fM/Cs5BXoKJy03W1VqJlIaFU2MVEVjLJvve7bKLVoIs5C1hjX9VViQc0=
In-Reply-To: <lkaplan-WVYJKLFxKCc@public.gmane.org;daniel-/w4YWyX8dFk@public.gmane.org;nirmoy.das-5C7GfCeVMHo@public.gmane.org;damon.mcdougall-5C7GfCeVMHo@public.gmane.org;juan.zuniga-anaya-5C7GfCeVMHo@public.gmane.org;hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.deucher-5C7GfCeVMHo@public.gmane.org, christian.koenig-5C7GfCeVMHo@public.gmane.org, felix.kuehling-5C7GfCeVMHo@public.gmane.org, joseph.greathouse-5C7GfCeVMHo@public.gmane.org, jsparks-WVYJKLFxKCc@public.gmane.org
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>

This is a submission for the introduction of a new cgroup controller for the drm subsystem follow a series of RFCs [v1, v2, v3, v4]

Changes from PR v1
* changed cgroup controller name from drm to gpu
* removed lgpu
* added compute.weight resources, clarified resources being distributed as partitions of compute device

PR v1: https://www.spinics.net/lists/cgroups/msg24479.html

Changes from the RFC base on the feedbacks:
* drop all drm.memory.* related implementation and focus only on buffer and lgpu
* add weight resource type for logical gpu (lgpu)
* uncoupled drmcg device iteration from drm_minor

I'd also like to highlight the fact that these patches are currently released under MIT/X11 license aligning with the norm of the drm subsystem, but I am working to have the cgroup parts release under GPLv2 to align with the norm of the cgroup subsystem.

RFC:
[v1]: https://lists.freedesktop.org/archives/dri-devel/2018-November/197106.html
[v2]: https://www.spinics.net/lists/cgroups/msg22074.html
[v3]: https://lists.freedesktop.org/archives/amd-gfx/2019-June/036026.html
[v4]: https://patchwork.kernel.org/cover/11120371/

Changes since the start of RFC are as follows:

v4:
Unchanged (no review needed)
* drm.memory.*/ttm resources (Patch 9-13, I am still working on memory bandwidth
and shrinker)
Base on feedbacks on v3:
* update nominclature to drmcg
* embed per device drmcg properties into drm_device
* split GEM buffer related commits into stats and limit
* rename function name to align with convention
* combined buffer accounting and check into a try_charge function
* support buffer stats without limit enforcement
* removed GEM buffer sharing limitation
* updated documentations
New features:
* introducing logical GPU concept
* example implementation with AMD KFD

v3:
Base on feedbacks on v2:
* removed .help type file from v2
* conform to cgroup convention for default and max handling
* conform to cgroup convention for addressing device specific limits (with major:minor)
New function:
* adopted memparse for memory size related attributes
* added macro to marshall drmcgrp cftype private ?(DRMCG_CTF_PRIV, etc.)
* added ttm buffer usage stats (per cgroup, for system, tt, vram.)
* added ttm buffer usage limit (per cgroup, for vram.)
* added per cgroup bandwidth stats and limiting (burst and average bandwidth)

v2:
* Removed the vendoring concepts
* Add limit to total buffer allocation
* Add limit to the maximum size of a buffer allocation

v1: cover letter

The purpose of this patch series is to start a discussion for a generic cgroup
controller for the drm subsystem.  The design proposed here is a very early 
one.  We are hoping to engage the community as we develop the idea.

Backgrounds
===========
Control Groups/cgroup provide a mechanism for aggregating/partitioning sets of
tasks, and all their future children, into hierarchical groups with specialized
behaviour, such as accounting/limiting the resources which processes in a 
cgroup can access[1].  Weights, limits, protections, allocations are the main 
resource distribution models.  Existing cgroup controllers includes cpu, 
memory, io, rdma, and more.  cgroup is one of the foundational technologies 
that enables the popular container application deployment and management method.

Direct Rendering Manager/drm contains code intended to support the needs of
complex graphics devices. Graphics drivers in the kernel may make use of DRM
functions to make tasks like memory management, interrupt handling and DMA
easier, and provide a uniform interface to applications.  The DRM has also
developed beyond traditional graphics applications to support compute/GPGPU
applications.

Motivations
===========
As GPU grow beyond the realm of desktop/workstation graphics into areas like
data center clusters and IoT, there are increasing needs to monitor and 
regulate GPU as a resource like cpu, memory and io.

Matt Roper from Intel began working on similar idea in early 2018 [2] for the
purpose of managing GPU priority using the cgroup hierarchy.  While that
particular use case may not warrant a standalone drm cgroup controller, there
are other use cases where having one can be useful [3].  Monitoring GPU
resources such as VRAM and buffers, CU (compute unit [AMD's nomenclature])/EU
(execution unit [Intel's nomenclature]), GPU job scheduling [4] can help
sysadmins get a better understanding of the applications usage profile. 
Further usage regulations of the aforementioned resources can also help sysadmins
optimize workload deployment on limited GPU resources.

With the increased importance of machine learning, data science and other
cloud-based applications, GPUs are already in production use in data centers
today [5,6,7].  Existing GPU resource management is very course grain, however,
as sysadmins are only able to distribute workload on a per-GPU basis [8].  An
alternative is to use GPU virtualization (with or without SRIOV) but it
generally acts on the entire GPU instead of the specific resources in a GPU.
With a drm cgroup controller, we can enable alternate, fine-grain, sub-GPU
resource management (in addition to what may be available via GPU
virtualization.)

In addition to production use, the DRM cgroup can also help with testing
graphics application robustness by providing a mean to artificially limit DRM
resources availble to the applications.


Challenges
==========
While there are common infrastructure in DRM that is shared across many vendors
(the scheduler [4] for example), there are also aspects of DRM that are vendor
specific.  To accommodate this, we borrowed the mechanism used by the cgroup to
handle different kinds of cgroup controller.

Resources for DRM are also often device (GPU) specific instead of system
specific and a system may contain more than one GPU.  For this, we borrowed
some of the ideas from RDMA cgroup controller.

Approach
========
To experiment with the idea of a DRM cgroup, we would like to start with basic
accounting and statistics, then continue to iterate and add regulating
mechanisms into the driver.

[1] https://www.kernel.org/doc/Documentation/cgroup-v1/cgroups.txt
[2] https://lists.freedesktop.org/archives/intel-gfx/2018-January/153156.html
[3] https://www.spinics.net/lists/cgroups/msg20720.html
[4] https://elixir.bootlin.com/linux/latest/source/drivers/gpu/drm/scheduler
[5] https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus/
[6] https://blog.openshift.com/gpu-accelerated-sql-queries-with-postgresql-pg-strom-in-openshift-3-10/
[7] https://github.com/RadeonOpenCompute/k8s-device-plugin
[8] https://github.com/kubernetes/kubernetes/issues/52757

Kenny Ho (11):
  cgroup: Introduce cgroup for drm subsystem
  drm, cgroup: Bind drm and cgroup subsystem
  drm, cgroup: Initialize drmcg properties
  drm, cgroup: Add total GEM buffer allocation stats
  drm, cgroup: Add peak GEM buffer allocation stats
  drm, cgroup: Add GEM buffer allocation count stats
  drm, cgroup: Add total GEM buffer allocation limit
  drm, cgroup: Add peak GEM buffer allocation limit
  drm, cgroup: Add compute as gpu cgroup resource
  drm, cgroup: add update trigger after limit change
  drm/amdgpu: Integrate with DRM cgroup

 Documentation/admin-guide/cgroup-v2.rst       | 138 ++-
 Documentation/cgroup-v1/drm.rst               |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |   4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c       |  48 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c    |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      |   7 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h         |   3 +
 .../amd/amdkfd/kfd_process_queue_manager.c    | 153 +++
 drivers/gpu/drm/drm_drv.c                     |  12 +
 drivers/gpu/drm/drm_gem.c                     |  16 +-
 include/drm/drm_cgroup.h                      |  81 ++
 include/drm/drm_device.h                      |   7 +
 include/drm/drm_drv.h                         |  19 +
 include/drm/drm_gem.h                         |  12 +-
 include/linux/cgroup_drm.h                    | 138 +++
 include/linux/cgroup_subsys.h                 |   4 +
 init/Kconfig                                  |   5 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/drm.c                           | 913 ++++++++++++++++++
 19 files changed, 1563 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/cgroup-v1/drm.rst
 create mode 100644 include/drm/drm_cgroup.h
 create mode 100644 include/linux/cgroup_drm.h
 create mode 100644 kernel/cgroup/drm.c

-- 
2.25.0

