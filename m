From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 0/6] memcg/kmem: switch to white list policy
Date: Tue, 10 Nov 2015 21:34:01 +0300
Message-ID: <cover.1447172835.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Currently, all kmem allocations (namely every kmem_cache_alloc, kmalloc,
alloc_kmem_pages call) are accounted to memory cgroup automatically.
Callers have to explicitly opt out if they don't want/need accounting
for some reason. Such a design decision leads to several problems:

 - kmalloc users are highly sensitive to failures, many of them
   implicitly rely on the fact that kmalloc never fails, while memcg
   makes failures quite plausible.

 - A lot of objects are shared among different containers by design.
   Accounting such objects to one of containers is just unfair.
   Moreover, it might lead to pinning a dead memcg along with its kmem
   caches, which aren't tiny, which might result in noticeable increase
   in memory consumption for no apparent reason in the long run.

 - There are tons of short-lived objects. Accounting them to memcg will
   only result in slight noise and won't change the overall picture, but
   we still have to pay accounting overhead.

For more info, see

 - http://lkml.kernel.org/r/20151105144002.GB15111%40dhcp22.suse.cz
 - http://lkml.kernel.org/r/20151106090555.GK29259@esperanza

Therefore this patch switches to the white list policy. Now kmalloc
users have to explicitly opt in by passing __GFP_ACCOUNT flag.

Currently, the list of accounted objects is quite limited and only
includes those allocations that (1) are known to be easily triggered
from userspace and (2) can fail gracefully (for the full list see patch
no. 6) and it still misses many object types. However, accounting only
those objects should be a satisfactory approximation of the behavior we
used to have for most sane workloads.

Changes in v2:
 - add and use SLAB_ACCOUNT flag (Tejun)

v1: http://marc.info/?l=linux-mm&m=144692684713032&w=2

Thanks,

Vladimir Davydov (6):
  Revert "kernfs: do not account ino_ida allocations to memcg"
  Revert "gfp: add __GFP_NOACCOUNT"
  memcg: only account kmem allocations marked as __GFP_ACCOUNT
  slab: add SLAB_ACCOUNT flag
  vmalloc: allow to account vmalloc to memcg
  Account certain kmem allocations to memcg

 arch/powerpc/platforms/cell/spufs/inode.c     |  2 +-
 drivers/staging/lustre/lustre/llite/super25.c |  3 ++-
 fs/9p/v9fs.c                                  |  2 +-
 fs/adfs/super.c                               |  2 +-
 fs/affs/super.c                               |  2 +-
 fs/afs/super.c                                |  2 +-
 fs/befs/linuxvfs.c                            |  2 +-
 fs/bfs/inode.c                                |  2 +-
 fs/block_dev.c                                |  2 +-
 fs/btrfs/inode.c                              |  3 ++-
 fs/ceph/super.c                               |  4 ++--
 fs/cifs/cifsfs.c                              |  2 +-
 fs/coda/inode.c                               |  6 +++---
 fs/dcache.c                                   |  5 +++--
 fs/ecryptfs/main.c                            |  6 ++++--
 fs/efs/super.c                                |  6 +++---
 fs/exofs/super.c                              |  4 ++--
 fs/ext2/super.c                               |  2 +-
 fs/ext4/super.c                               |  2 +-
 fs/f2fs/super.c                               |  5 +++--
 fs/fat/inode.c                                |  2 +-
 fs/file.c                                     |  7 ++++---
 fs/fuse/inode.c                               |  4 ++--
 fs/gfs2/main.c                                |  3 ++-
 fs/hfs/super.c                                |  4 ++--
 fs/hfsplus/super.c                            |  2 +-
 fs/hostfs/hostfs_kern.c                       |  2 +-
 fs/hpfs/super.c                               |  2 +-
 fs/hugetlbfs/inode.c                          |  2 +-
 fs/inode.c                                    |  2 +-
 fs/isofs/inode.c                              |  2 +-
 fs/jffs2/super.c                              |  2 +-
 fs/jfs/super.c                                |  2 +-
 fs/kernfs/dir.c                               |  9 +--------
 fs/logfs/inode.c                              |  3 ++-
 fs/minix/inode.c                              |  2 +-
 fs/ncpfs/inode.c                              |  2 +-
 fs/nfs/inode.c                                |  2 +-
 fs/nilfs2/super.c                             |  3 ++-
 fs/ntfs/super.c                               |  4 ++--
 fs/ocfs2/dlmfs/dlmfs.c                        |  2 +-
 fs/ocfs2/super.c                              |  2 +-
 fs/openpromfs/inode.c                         |  2 +-
 fs/proc/inode.c                               |  3 ++-
 fs/qnx4/inode.c                               |  2 +-
 fs/qnx6/inode.c                               |  2 +-
 fs/reiserfs/super.c                           |  3 ++-
 fs/romfs/super.c                              |  4 ++--
 fs/squashfs/super.c                           |  3 ++-
 fs/sysv/inode.c                               |  2 +-
 fs/ubifs/super.c                              |  4 ++--
 fs/udf/super.c                                |  3 ++-
 fs/ufs/super.c                                |  2 +-
 fs/xfs/kmem.h                                 |  1 +
 fs/xfs/xfs_super.c                            |  4 ++--
 include/linux/gfp.h                           |  6 ++++--
 include/linux/memcontrol.h                    | 15 +++++++--------
 include/linux/slab.h                          |  5 +++++
 include/linux/thread_info.h                   |  5 +++--
 ipc/mqueue.c                                  |  2 +-
 kernel/cred.c                                 |  4 ++--
 kernel/delayacct.c                            |  2 +-
 kernel/fork.c                                 | 22 +++++++++++++---------
 kernel/pid.c                                  |  2 +-
 mm/kmemleak.c                                 |  3 +--
 mm/memcontrol.c                               |  8 +++++++-
 mm/nommu.c                                    |  2 +-
 mm/page_alloc.c                               |  3 ++-
 mm/rmap.c                                     |  6 ++++--
 mm/shmem.c                                    |  2 +-
 mm/slab.h                                     |  5 +++--
 mm/slab_common.c                              |  3 ++-
 mm/slub.c                                     |  2 ++
 mm/vmalloc.c                                  |  6 +++---
 net/socket.c                                  |  2 +-
 net/sunrpc/rpc_pipe.c                         |  2 +-
 76 files changed, 151 insertions(+), 120 deletions(-)

-- 
2.1.4
