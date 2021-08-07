From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/3] Cleanups and fixup for memcontrol
Date: Sat, 7 Aug 2021 16:28:32 +0800
Message-ID: <20210807082835.61281-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi all,
This series contains cleanups to remove unused functions, save some
atomic ops and get rid of unneeded lock. More details can be found
in the respective changelogs. Thanks!

Miaohe Lin (3):
  mm, memcg: remove unused functions
  mm, memcg: save some atomic ops when flush is already true
  mm, memcg: get rid of percpu_charge_mutex lock

v1-->v2:
  drop mm, memcg: avoid possible NULL pointer dereferencing in
mem_cgroup_init()
  drop mm, memcg: always call __mod_node_page_state() with preempt
disabled
  collect Reviewed-by and Acked-by tag
  get rid of percpu_charge_mutex instead of narrowing the scope

 include/linux/memcontrol.h | 12 ------------
 mm/memcontrol.c            |  7 +------
 2 files changed, 1 insertion(+), 18 deletions(-)

-- 
2.23.0

