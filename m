From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH V4 00/18] IOASID extensions for guest SVA
Date: Sat, 27 Feb 2021 14:01:08 -0800
Message-ID: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

I/O Address Space ID (IOASID) core code was introduced in v5.5 as a generic
kernel allocator service for both PCIe Process Address Space ID (PASID) and
ARM SMMU's Substream ID. IOASIDs are used to associate DMA requests with
virtual address spaces, including both host and guest.

In addition to providing basic ID allocation, ioasid_set was defined as a
token that is shared by a group of IOASIDs. This set token can be used
for permission checking, but lack some features to address the following
needs by guest Shared Virtual Address (SVA).
- Manage IOASIDs by group, group ownership, quota, etc.
- State synchronization among IOASID users (e.g. IOMMU driver, KVM, device
drivers)
- Non-identity guest-host IOASID mapping
- Lifecycle management

This patchset introduces the following extensions as solutions to the
problems above.
- Redefine and extend IOASID set such that IOASIDs can be managed by groups/pools.
- Add notifications for IOASID state synchronization
- Extend reference counting for life cycle alignment among multiple users
- Support ioasid_set private IDs, which can be used as guest IOASIDs
- Add a new cgroup controller for resource distribution

Please refer to Documentation/admin-guide/cgroup-v1/ioasids.rst and
Documentation/driver-api/ioasid.rst in the enclosed patches for more
details.

Based on discussions on LKML[1], a direction change was made in v4 such that
the user interfaces for IOASID allocation are extracted from VFIO
subsystem. The proposed IOASID subsystem now consists of three components:
1. IOASID core[01-14]: provides APIs for allocation, pool management,
  notifications, and refcounting.
2. IOASID cgroup controller[RFC 15-17]: manage resource distribution[2].
3. IOASID user[RFC 18]:  provides user allocation interface via /dev/ioasid 

This patchset only included VT-d driver as users of some of the new APIs.
VFIO and KVM patches are coming up to fully utilize the APIs introduced here.

[1] https://lore.kernel.org/linux-iommu/1599734733-6431-1-git-send-email-yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
[2] Note that ioasid quota management code can be removed once the IOASIDs
cgroup is ratified.

You can find this series, VFIO, KVM, and IOASID user at:
https://github.com/jacobpan/linux.git ioasid_v4
(VFIO and KVM patches will be available at this branch when published.)

This work is a result of collaboration with many people:
Liu, Yi L <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Ashok Raj <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Kevin Tian <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks,

Jacob

Changelog:

v4
- Introduced IOASIDs cgroup controller
- Introduced /dev/ioasid user API for allocation/free
- Added IOASID states and free function, aligned refcounting on v5.11
  introduced by Jean.
- Support iommu-sva-lib (will converge VT-d code afterward)
- Added a shared ordered workqueue for notification work that requires
  thread context. Streamlined notification framework among multiple IOASID
  users.
- Added ioasid_set helper functions for taking per set operations

V3:
- Use consistent ioasid_set_ prefix for ioasid_set level APIs
- Make SPID and private detach/attach APIs symmetric
- Use the same ioasid_put semantics as Jean-Phillippe IOASID reference patch
- Take away the public ioasid_notify() function, notifications are now emitted
  by IOASID core as a result of certain IOASID APIs
- Partition into finer incremental patches
- Miscellaneous cleanup, locking, exception handling fixes based on v2 reviews

V2:
- Redesigned ioasid_set APIs, removed set ID
- Added set private ID (SPID) for guest PASID usage.
- Add per ioasid_set notification and priority support.
- Back to use spinlocks and atomic notifications.
- Added async work in VT-d driver to perform teardown outside atomic context


Jacob Pan (17):
  docs: Document IO Address Space ID (IOASID) APIs
  iommu/ioasid: Rename ioasid_set_data()
  iommu/ioasid: Add a separate function for detach data
  iommu/ioasid: Support setting system-wide capacity
  iommu/ioasid: Redefine IOASID set and allocation APIs
  iommu/ioasid: Add free function and states
  iommu/ioasid: Add ioasid_set iterator helper functions
  iommu/ioasid: Introduce ioasid_set private ID
  iommu/ioasid: Introduce notification APIs
  iommu/ioasid: Support mm token type ioasid_set notifications
  iommu/ioasid: Add ownership check in guest bind
  iommu/vt-d: Remove mm reference for guest SVA
  iommu/ioasid: Add a workqueue for cleanup work
  iommu/vt-d: Listen to IOASID notifications
  cgroup: Introduce ioasids controller
  iommu/ioasid: Consult IOASIDs cgroup for allocation
  docs: cgroup-v1: Add IOASIDs controller

Liu Yi L (1):
  ioasid: Add /dev/ioasid for userspace

 Documentation/admin-guide/cgroup-v1/index.rst |   1 +
 .../admin-guide/cgroup-v1/ioasids.rst         | 107 ++
 Documentation/driver-api/index.rst            |   1 +
 Documentation/driver-api/ioasid.rst           | 510 +++++++++
 Documentation/userspace-api/index.rst         |   1 +
 Documentation/userspace-api/ioasid.rst        |  49 +
 drivers/iommu/Kconfig                         |   5 +
 drivers/iommu/Makefile                        |   1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   1 +
 drivers/iommu/intel/Kconfig                   |   1 +
 drivers/iommu/intel/iommu.c                   |  32 +-
 drivers/iommu/intel/pasid.h                   |   1 +
 drivers/iommu/intel/svm.c                     | 145 ++-
 drivers/iommu/ioasid.c                        | 983 +++++++++++++++++-
 drivers/iommu/ioasid_user.c                   | 297 ++++++
 drivers/iommu/iommu-sva-lib.c                 |  19 +-
 drivers/iommu/iommu.c                         |  16 +-
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/intel-iommu.h                   |   2 +
 include/linux/ioasid.h                        | 256 ++++-
 include/linux/miscdevice.h                    |   1 +
 include/uapi/linux/ioasid.h                   |  98 ++
 init/Kconfig                                  |   7 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/ioasids.c                       | 345 ++++++
 25 files changed, 2794 insertions(+), 90 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/ioasids.rst
 create mode 100644 Documentation/driver-api/ioasid.rst
 create mode 100644 Documentation/userspace-api/ioasid.rst
 create mode 100644 drivers/iommu/ioasid_user.c
 create mode 100644 include/uapi/linux/ioasid.h
 create mode 100644 kernel/cgroup/ioasids.c

-- 
2.25.1
