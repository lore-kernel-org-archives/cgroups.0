From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] Cleanups and fixup for memcontrol
Date: Thu, 29 Jul 2021 20:57:50 +0800
Message-ID: <20210729125755.16871-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi all,
This series contains cleanups to remove unused functions, narrow the
scope of mutex and so on. Also this fix the possible NULL pointer
dereferencing and possible wrong percpu operation. More details can
be found in the respective changelogs. Thanks!

Miaohe Lin (5):
  mm, memcg: remove unused functions
  mm, memcg: narrow the scope of percpu_charge_mutex
  mm, memcg: save some atomic ops when flush is already true
  mm, memcg: avoid possible NULL pointer dereferencing in
    mem_cgroup_init()
  mm, memcg: always call __mod_node_page_state() with preempt disabled

 include/linux/memcontrol.h | 12 ------------
 mm/memcontrol.c            |  8 +++++---
 2 files changed, 5 insertions(+), 15 deletions(-)

-- 
2.23.0

