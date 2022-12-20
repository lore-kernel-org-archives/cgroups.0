From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: [PATCH RFC 0/2] mm: kmem: optimize obj_cgroup pointer retrieval
Date: Tue, 20 Dec 2022 10:27:43 -0800
Message-ID: <20221220182745.1903540-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671560881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Fg7QsgWuG0CK6tIt3L6718+/M9y6wWUM/N8cNALh9TI=;
        b=ZHVNnOLpMF+Ywc7fWfYrtgEJG7ECKPNcowJh37ZPNcPXh37spKjvpph0drQIetn8FffIYU
        3uVakPqt+fudCFRJgjA5Fx+RTpdJ6Rc4DVHwgYHe6JVo6Dnq6hLyjc7+8HKqabHCxkpipV
        D0OC2p5gt02s6fn4ps0pVPWnG7XrepY=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

This patchset improves the performance of get_obj_cgroup_from_current(), which
is used to get an objcg pointer on the kernel memory allocation fast path.

Results (1M 8-bytes accounted allocations):

| version         | accounted (us) | delta | unaccounted (us) |  delta |
|-----------------+----------------+-------+------------------+--------|
| baseline (6.1+) |          81042 |       |            45269 |        |
| patch 1         |          78756 | -2.8% |            42731 |  -5.6% |
| patch 2         |          73650 | -9.1% |            30662 | -32.3% |

Unaccounted allocations were performed from a user's task belonging to
the root cgroup, so savings are particularly large because previously
the root_mem_cgroup pointer was obtained first just to learn that it's
corresponding objcg is NULL.


Roman Gushchin (2):
  mm: kmem: optimize get_obj_cgroup_from_current()
  mm: kmem: add direct objcg pointer to task_struct

 include/linux/sched.h |   4 ++
 mm/memcontrol.c       | 102 ++++++++++++++++++++++++++++++++----------
 2 files changed, 83 insertions(+), 23 deletions(-)

-- 
2.39.0

