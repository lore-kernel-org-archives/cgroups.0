From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] a few cleanups about kmem code
Date: Wed, 23 Oct 2013 19:31:12 +0800
Message-ID: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


Qiang Huang (3):
  memcg, kmem: Use is_root_cache instead of hard code
  memcg, kmem: rename cache_from_memcg to cache_from_memcg_idx
  memcg, kmem: use cache_from_memcg_idx instead of hard code

 mm/memcontrol.c  | 15 ++++++++-------
 mm/slab.c        |  2 +-
 mm/slab.h        |  6 ++++--
 mm/slab_common.c |  2 +-
 mm/slub.c        |  2 +-
 5 files changed, 15 insertions(+), 12 deletions(-)

-- 
1.8.3

