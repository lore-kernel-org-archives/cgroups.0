From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 0/3] mm: memcontrol: eliminate charge reparenting
Date: Sat, 20 Sep 2014 16:00:32 -0400
Message-ID: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

we've come a looong way when it comes to the basic cgroups model, and
the recent changes there open up a lot of opportunity to make drastic
simplifications to memory cgroups as well.

The decoupling of css from the user-visible cgroup, word-sized per-cpu
css reference counters, and css iterators that include offlined groups
means we can take per-charge css references, continue to reclaim from
offlined groups, and so get rid of the error-prone charge reparenting.

Combined with the higher-order reclaim fixes, lockless page counters,
and memcg iterator simplification I sent on Friday, the memory cgroup
core code is finally no longer the biggest file in mm/.  Yay!

These patches are based on mmotm + the above-mentioned changes + Tj's
percpu-refcount conversion to atomic_long_t.

Thanks!

 include/linux/cgroup.h          |  26 +++
 include/linux/percpu-refcount.h |  43 ++++-
 mm/memcontrol.c                 | 337 ++------------------------------------
 3 files changed, 75 insertions(+), 331 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
