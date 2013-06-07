From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v11 00/25] shrinkers rework: per-numa, generic lists,
 etc
Date: Fri, 7 Jun 2013 12:04:44 +0400
Message-ID: <51B1941C.80707@parallels.com>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org> <20130606141501.72d80a9a5c7bce4c4a002906@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------040000060903070107070709"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130606141501.72d80a9a5c7bce4c4a002906@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com

--------------040000060903070107070709
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 06/07/2013 01:15 AM, Andrew Morton wrote:
> On Fri,  7 Jun 2013 00:34:33 +0400 Glauber Costa <glommer@openvz.org> wrote:
> 
>> Andrew,
>>
>> I believe I have addressed most of your comments, while attempting to address
>> all of them. If there is anything I have missed after this long day, let me
>> know and I will go over it promptly.
> 
> I'll trust you - I've had my fill of costacode this week ;)
> 
> Can you send over a nice introductory [patch 0/n] as an overview of the
> whole series?
> 
here it is.


--------------040000060903070107070709
Content-Type: text/x-patch; name="0000-cover-letter.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="0000-cover-letter.patch"

From 748b830897f3b62271f92a01abc2a32c1d5d41cd Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@openvz.org>
Date: Fri, 7 Jun 2013 00:00:44 +0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH v11 00/25] shrinkers rework: per-numa, generic lists, etc

This series rework out current object cache shrinking infrastructure in two
main ways:

 * Noticing that a lot of users copy and paste their own version of LRU
   lists for objects, we put some effort in providing a generic version. It is
   modeled after the filesystem users: dentries, inodes, and xfs (for various
   tasks), but we expect that other users could benefit in the near future with
   little or no modification. Let us know if you have any issues.

 * The underlying list_lru being proposed automatically and transparently keeps
   the elements in per-node lists, and is able to manipulate the node lists
   individually. Given this infrastructure, we are able to modify the up-to-now
   hammer called shrink_slab to proceed with node-reclaim instead of always
   searching memory from all over like it has been doing.

Per-node lru lists are also expected to lead to less contention in the lru
locks on multi-node scans, since we are now no longer fighting for a global
lock. The locks usually disappear from the profilers with this change.

Although we have no official benchmarks for this version - be our guest to
independently evaluate this -  earlier versions of this series were performance
tested (details at http://permalink.gmane.org/gmane.linux.kernel.mm/100537)
yielding no visible performance regressions while yielding a better qualitative
behavior in NUMA machines.

With this infrastructure in place, we can use the list_lru entry point to
provide memcg isolation and per-memcg targeted reclaim. Historically, those
two pieces of work have been posted together. This version presents only
the infrastructure work, deferring the memcg work for a later time, so we can
focus on getting this part tested. You can see more about the history of
such work at http://lwn.net/Articles/552769/

Dave Chinner (18):
  dcache: convert dentry_stat.nr_unused to per-cpu counters
  dentry: move to per-sb LRU locks
  dcache: remove dentries from LRU before putting on dispose list
  mm: new shrinker API
  shrinker: convert superblock shrinkers to new API
  list: add a new LRU list type
  inode: convert inode lru list to generic lru list code.
  dcache: convert to use new lru list infrastructure
  list_lru: per-node list infrastructure
  shrinker: add node awareness
  fs: convert inode and dentry shrinking to be node aware
  xfs: convert buftarg LRU to generic code
  xfs: rework buffer dispose list tracking
  xfs: convert dquot cache lru to list_lru
  fs: convert fs shrinkers to new scan/count API
  drivers: convert shrinkers to new count/scan API
  shrinker: convert remaining shrinkers to count/scan API
  shrinker: Kill old ->shrink API.

Glauber Costa (7):
  fs: bump inode and dentry counters to long
  super: fix calculation of shrinkable objects for small numbers
  list_lru: per-node API
  vmscan: per-node deferred work
  i915: bail out earlier when shrinker cannot acquire mutex
  hugepage: convert huge zero page shrinker to new shrinker API
  list_lru: dynamically adjust node arrays

 arch/x86/kvm/mmu.c                        |  24 ++-
 drivers/gpu/drm/i915/i915_dma.c           |   4 +-
 drivers/gpu/drm/i915/i915_gem.c           |  71 +++++---
 drivers/gpu/drm/ttm/ttm_page_alloc.c      |  44 +++--
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c  |  51 ++++--
 drivers/md/bcache/btree.c                 |  43 +++--
 drivers/md/bcache/sysfs.c                 |   2 +-
 drivers/md/dm-bufio.c                     |  61 ++++---
 drivers/staging/android/ashmem.c          |  44 +++--
 drivers/staging/android/lowmemorykiller.c |  40 +++--
 drivers/staging/zcache/zcache-main.c      |  29 +--
 fs/dcache.c                               | 270 +++++++++++++++++-----------
 fs/drop_caches.c                          |   1 +
 fs/ext4/extents_status.c                  |  30 ++--
 fs/gfs2/glock.c                           |  30 ++--
 fs/gfs2/main.c                            |   3 +-
 fs/gfs2/quota.c                           |  16 +-
 fs/gfs2/quota.h                           |   4 +-
 fs/inode.c                                | 193 +++++++++-----------
 fs/internal.h                             |   6 +-
 fs/mbcache.c                              |  49 ++---
 fs/nfs/dir.c                              |  16 +-
 fs/nfs/internal.h                         |   4 +-
 fs/nfs/super.c                            |   3 +-
 fs/nfsd/nfscache.c                        |  31 +++-
 fs/quota/dquot.c                          |  34 ++--
 fs/super.c                                | 106 ++++++-----
 fs/ubifs/shrinker.c                       |  22 ++-
 fs/ubifs/super.c                          |   3 +-
 fs/ubifs/ubifs.h                          |   3 +-
 fs/xfs/xfs_buf.c                          | 253 +++++++++++++-------------
 fs/xfs/xfs_buf.h                          |  17 +-
 fs/xfs/xfs_dquot.c                        |   7 +-
 fs/xfs/xfs_icache.c                       |   4 +-
 fs/xfs/xfs_icache.h                       |   2 +-
 fs/xfs/xfs_qm.c                           | 285 ++++++++++++++++--------------
 fs/xfs/xfs_qm.h                           |   4 +-
 fs/xfs/xfs_super.c                        |  12 +-
 include/linux/dcache.h                    |  14 +-
 include/linux/fs.h                        |  25 ++-
 include/linux/list_lru.h                  | 148 ++++++++++++++++
 include/linux/shrinker.h                  |  54 ++++--
 include/trace/events/vmscan.h             |   4 +-
 include/uapi/linux/fs.h                   |   6 +-
 kernel/sysctl.c                           |   6 +-
 mm/Makefile                               |   2 +-
 mm/huge_memory.c                          |  17 +-
 mm/list_lru.c                             | 186 +++++++++++++++++++
 mm/memory-failure.c                       |   2 +
 mm/vmscan.c                               | 242 ++++++++++++++-----------
 net/sunrpc/auth.c                         |  41 +++--
 51 files changed, 1620 insertions(+), 948 deletions(-)
 create mode 100644 include/linux/list_lru.h
 create mode 100644 mm/list_lru.c

-- 
1.8.1.4


--------------040000060903070107070709--
