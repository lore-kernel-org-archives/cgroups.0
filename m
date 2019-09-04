From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH v1 0/7] mm/memcontrol: recharge mlocked pages
Date: Wed, 04 Sep 2019 16:53:08 +0300
Message-ID: <156760509382.6560.17364256340940314860.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1567605189; bh=9NG/dDnFeKeZHp7gq4Bt3jk12l8IcLQ6rwdO1YD1xvQ=;
        h=Message-ID:Date:To:From:Subject:Cc;
        b=Ai2bzEbJdK+baGdRKLO3SHZG+trevrPdYggz78BEbE91uKDRhP/r9odOJkZ2Dga3G
         FRTz0fb1uTJTZwcwqMnA44/U1x/ocUIpHSlF7wqoKjKBtWlvjg/cs2pLxaO+QAOYKF
         ZnbqrmTnFEbaAXSvZhbTEvvJhjBU5YXvFV3SbSTs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>

Currently mlock keeps pages in cgroups where they were accounted.
This way one container could affect another if they share file cache.
Typical case is writing (downloading) file in one container and then
locking in another. After that first container cannot get rid of cache.
Also removed cgroup stays pinned by these mlocked pages.

This patchset implements recharging pages to cgroup of mlock user.

There are three cases:
* recharging at first mlock
* recharging at munlock to any remaining mlock
* recharging at 'culling' in reclaimer to any existing mlock

To keep things simple recharging ignores memory limit. After that memory
usage temporary could be higher than limit but cgroup will reclaim memory
later or trigger oom, which is valid outcome when somebody mlock too much.

---

Konstantin Khlebnikov (7):
      mm/memcontrol: move locking page out of mem_cgroup_move_account
      mm/memcontrol: add mem_cgroup_recharge
      mm/mlock: add vma argument for mlock_vma_page()
      mm/mlock: recharge memory accounting to first mlock user
      mm/mlock: recharge memory accounting to second mlock user at munlock
      mm/vmscan: allow changing page memory cgroup during reclaim
      mm/mlock: recharge mlocked pages at culling by vmscan


 Documentation/admin-guide/cgroup-v1/memory.rst |    5 +
 include/linux/memcontrol.h                     |    9 ++
 include/linux/rmap.h                           |    3 -
 mm/gup.c                                       |    2 
 mm/huge_memory.c                               |    4 -
 mm/internal.h                                  |    6 +
 mm/ksm.c                                       |    2 
 mm/memcontrol.c                                |  104 ++++++++++++++++--------
 mm/migrate.c                                   |    2 
 mm/mlock.c                                     |   14 +++
 mm/rmap.c                                      |    5 +
 mm/vmscan.c                                    |   17 ++--
 12 files changed, 121 insertions(+), 52 deletions(-)

--
Signature
