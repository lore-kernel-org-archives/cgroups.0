From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 07:08:17 +0000
Message-ID: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836908; x=1692428908;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U/LCb/swRVuVzVICP60Gq89mZaxuIEA6maW/j6Ih8uc=;
        b=NmItOuI1BO8FpivokQJywTfJdRc87myk9anTbJ4UoJVsByhpyWZ2NhGs3XaN2cP2Nt
         JOV9ihqCzY8Rxsp+r6isfIFkW/SUwj9Vss4W2DuK2ccFsP635edEhy1jQxM9GiR5RwCK
         5oMMI3/PuSouXpEAZw7u4v68TUmwdBfHnyKCeBIftZE10kZdkxmv5uViyp1Mkr88BgDy
         w0adw8Rgvu0dZI9YOQ0lxUV8rJvfzPt+gm6BycHBJUwzSYgtNUNUoYFoNjXznI+XvsO6
         3RMjTaAvwUCkl3RUI9BRhsU/hvOSutDDKijJFjy210IHQPmnpkspt3yoNydMInG9aMxS
         +bjQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This patch series implements the proposal in LSF/MM/BPF 2023 conference
for reducing offline/zombie memcgs by memory recharging [1]. The main
difference is that this series focuses on recharging and does not
include eviction of any memory charged to offline memcgs.

Two methods of recharging are proposed:

(a) Recharging of mapped folios.

When a memcg is offlined, queue an asynchronous worker that will walk
the lruvec of the offline memcg and try to recharge any mapped folios to
the memcg of one of the processes mapping the folio. The main assumption
is that a process mapping the folio is the "rightful" owner of the
memory.

Currently, this is only supported for evictable folios, as the
unevictable lru is imaginary and we cannot iterate the folios on it. A
separate proposal [2] was made to revive the unevictable lru, which
would allow recharging of unevictable folios.

(b) Deferred recharging of folios.

For folios that are unmapped, or mapped but we fail to recharge them
with (a), we rely on deferred recharging. Simply put, any time a folio
is accessed or dirtied by a userspace process, and that folio is charged
to an offline memcg, we will try to recharge it to the memcg of the
process accessing the folio. Again, we assume this process should be the
"rightful" owner of the memory. This is also done asynchronously to avoid
slowing down the data access path.

In both cases, we never OOM kill the recharging target if it goes above
limit. This is to avoid OOM killing a process an arbitrary amount of
time after it started using memory. This is a conservative policy that
can be revisited later.

The patches in this series are divided as follows:
- Patches 1 & 2 are preliminary refactoring and helpers introducion.
- Patches 3 to 5 implement (a) and (b) above.
- Patches 6 & 7 add stats, a sysctl, and a config option.
- Patch 8 is a selftest.

[1]https://lore.kernel.org/linux-mm/CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
[2]https://lore.kernel.org/lkml/20230618065719.1363271-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Yosry Ahmed (8):
  memcg: refactor updating memcg->moving_account
  mm: vmscan: add lruvec_for_each_list() helper
  memcg: recharge mapped folios when a memcg is offlined
  memcg: support deferred memcg recharging
  memcg: recharge folios when accessed or dirtied
  memcg: add stats for offline memcgs recharging
  memcg: add sysctl and config option to control memory recharging
  selftests: cgroup: test_memcontrol: add a selftest for memcg
    recharging

 include/linux/memcontrol.h                    |  14 +
 include/linux/swap.h                          |   8 +
 include/linux/vm_event_item.h                 |   5 +
 kernel/sysctl.c                               |  11 +
 mm/Kconfig                                    |  12 +
 mm/memcontrol.c                               | 376 +++++++++++++++++-
 mm/page-writeback.c                           |   2 +
 mm/swap.c                                     |   2 +
 mm/vmscan.c                                   |  28 ++
 mm/vmstat.c                                   |   6 +-
 tools/testing/selftests/cgroup/cgroup_util.c  |  14 +
 tools/testing/selftests/cgroup/cgroup_util.h  |   1 +
 .../selftests/cgroup/test_memcontrol.c        | 310 +++++++++++++++
 13 files changed, 784 insertions(+), 5 deletions(-)

-- 
2.41.0.255.g8b1d071c50-goog

