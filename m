From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2 0/2] slightly change shrinker behaviour for very small object sets
Date: Fri, 21 Dec 2012 14:46:48 +0400
Message-ID: <1356086810-6950-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Shrinnker <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

Hi,

* v2: fix sysctl_vfs_cache_pressure for all users.

I've recently noticed some glitches in the object shrinker mechanism when a
very small number of objects is used. Those situations are theoretically
possible, albeit unlikely. But although it may feel like it is purely
theoretical, they can become common in environments with many small containers
(cgroups) in a box.

Those patches came from some experimentation I am doing with targetted-shrinking
for kmem-limited memory cgroups (Dave Shrinnker is already aware of such work).
In such scenarios, one can set the available memory to very low limits, and it
becomes easy to see this.



Glauber Costa (2):
  super: fix calculation of shrinkable objects for small numbers
  vmscan: take at least one pass with shrinkers

 fs/gfs2/glock.c        | 2 +-
 fs/gfs2/quota.c        | 2 +-
 fs/mbcache.c           | 2 +-
 fs/nfs/dir.c           | 2 +-
 fs/quota/dquot.c       | 5 ++---
 fs/super.c             | 2 +-
 fs/xfs/xfs_qm.c        | 2 +-
 include/linux/dcache.h | 4 ++++
 mm/vmscan.c            | 4 ++--
 9 files changed, 14 insertions(+), 11 deletions(-)

-- 
1.7.11.7
