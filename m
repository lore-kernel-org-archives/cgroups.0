From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 0/4] mm/slub: Fix sysfs circular locking dependency
Date: Mon, 27 Apr 2020 19:56:17 -0400
Message-ID: <20200427235621.7823-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588031808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=xqSYkkiN5zo6A8A9R6SrdTZLgFG5Vtd3h0pL6NAIaDM=;
        b=fgb9lB1QQNEMwkcUFnXDzgRvoRAfWRK/iBUfLwBhGt3j5X6xnfvCop8JS6A7+C5vkvfyfe
        HMh4jtH9av+fLOj0VdGBe7xtpvVhDeearTgP78q+wg+HsybkT/snufRIy5NPtHiitcP3aR
        xFIcIKJKn4P3xbvo/eoXtbUoqIpDXCI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Qian Cai <cai@lca.pw>, Waiman Long <longman@redhat.com>

v2:
 - Use regular cmpxchg() instead of x86-only try_cmpxchg() in patch 2.
 - Add patches 3 and 4 to fix circular locking dependency showing up
   at shutdown time.

With lockdep enabled, issuing the following command to the slub sysfs
files will cause splat about circular locking dependency to show up
either immediately afterwards or at shutdown time.

 # echo 1 > validate
 # echo 1 > shrink

This patchset fixes these lockdep splats by replacing slab_mutex with
memcg_cache_ids_sem as well as changing some of the lock operations
with trylock.

Waiman Long (4):
  mm, slab: Revert "extend slab/shrink to shrink all memcg caches"
  mm/slub: Fix slab_mutex circular locking problem in slab_attr_store()
  mm/slub: Fix another circular locking dependency in slab_attr_store()
  mm/slub: Fix sysfs shrink circular locking dependency

 include/linux/memcontrol.h     |  1 +
 include/linux/memory_hotplug.h |  2 +
 mm/memcontrol.c                |  5 ++
 mm/memory_hotplug.c            |  5 ++
 mm/slab.h                      |  1 -
 mm/slab_common.c               | 37 -------------
 mm/slub.c                      | 98 +++++++++++++++++++++++++++++-----
 7 files changed, 99 insertions(+), 50 deletions(-)

-- 
2.18.1

