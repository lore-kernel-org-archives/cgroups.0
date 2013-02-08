From: Glauber Costa <glommer@parallels.com>
Subject: [PATCH 0/7] memcg targeted shrinking
Date: Fri,  8 Feb 2013 17:07:30 +0400
Message-ID: <1360328857-28070-1-git-send-email-glommer@parallels.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Dave Shrinnker <david@fromorbit.com>, linux-fsdevel@vger.kernel.org

This patchset implements targeted shrinking for memcg when kmem limits are
present. So far, we've been accounting kernel objects but failing allocations
when short of memory. This is because our only option would be to call the
global shrinker, depleting objects from all caches and breaking isolation.

This patchset builds upon the recent work from David Chinner
(http://oss.sgi.com/archives/xfs/2012-11/msg00643.html) to implement NUMA
aware per-node LRUs. I build heavily on its API, and its presence is implied.

The main idea is to associate per-memcg lists with each of the LRUs. The main
LRU still provides a single entry point and when adding or removing an element
from the LRU, we use the page information to figure out which memcg it belongs
to and relay it to the right list.

This patchset is still not perfect, and some uses cases still need to be
dealt with. But I wanted to get this out in the open sooner rather than
later. In particular, I have the following (noncomprehensive) todo list:

TODO:
* shrink dead memcgs when global pressure kicks in.
* balance global reclaim among memcgs.
* improve testing and reliability (I am still seeing some stalls in some cases)

Glauber Costa (7):
  vmscan: also shrink slab in memcg pressure
  memcg,list_lru: duplicate LRUs upon kmemcg creation
  lru: add an element to a memcg list
  list_lru: also include memcg lists in counts and scans
  list_lru: per-memcg walks
  super: targeted memcg reclaim
  memcg: per-memcg kmem shrinking

 fs/dcache.c                |   7 +-
 fs/inode.c                 |   6 +-
 fs/internal.h              |   5 +-
 fs/super.c                 |  37 ++++--
 include/linux/list_lru.h   |  81 +++++++++++-
 include/linux/memcontrol.h |  34 +++++
 include/linux/shrinker.h   |   4 +
 include/linux/swap.h       |   2 +
 lib/list_lru.c             | 301 ++++++++++++++++++++++++++++++++++++++-------
 mm/memcontrol.c            | 271 ++++++++++++++++++++++++++++++++++++++--
 mm/slab_common.c           |   1 -
 mm/vmscan.c                |  78 +++++++++++-
 12 files changed, 747 insertions(+), 80 deletions(-)

-- 
1.8.1

