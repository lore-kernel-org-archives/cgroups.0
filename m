From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/3] mm: memcg: fix protection of reclaim target memcg
Date: Fri,  2 Dec 2022 03:15:09 +0000
Message-ID: <20221202031512.1365483-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lkiKsrGghY1+tqWu87j/dNVPvsb88bb2RpuXGbm+/VA=;
        b=LXzuBlaIaDeExqyOu2SdEI33qKVHVaAEa6EBq1XyrSfE3rPSCPGLQMVSyRpXtUvgsv
         rag+Aod0HZ1ICNfmgPf0FXBTk9sXmj6APzu29c5Vcz/J9gOfjBAozJ2PH+2isG/LYyXc
         Yp85TmDwppCvYZoGFOjIx9LLQ9Z1QqdaG7UpMW3tN2jUFxqisPg6npmhYNF1MmkXUms8
         VsjDCaKCzaKQYHmNTmXZEzIBmo5staiT+/m4ihPkR3p5IMQh9R8gVZYyC4MT4eFJbuxg
         /6pZ6r3d1p1eOsOqeXVposFeHPyNUHmmdD900WgzrlQPSiIyIeFhwYx+u6N5VNukvH0r
         udoA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This series fixes a bug in calculating the protection of the reclaim
target memcg where we end up using stale effective protection values from
the last reclaim operation, instead of completely ignoring the
protection of the reclaim target as intended. More detailed explanation
and examples in patch 1, which includes the fix.
Patches 2 & 3 introduce a selftest case that catches the bug.

v2 -> v3:
- Refactoring selftest helper reclaim_until (suggested by Roman).
- Collected review tags on patch 1 & 3 from Roman (Thanks!).

v1 -> v2:
- Instead of adding a new helper, extended
  mem_cgroup_supports_protection() to check if the current memcg is the
  target memcg, renamed to mem_cgroup_unprotected() which is much easier
  to reason about (suggested by Roman).
- Add a selftest case to catch the bug (suggested by Roman).

Yosry Ahmed (3):
  mm: memcg: fix stale protection of reclaim target memcg
  selftests: cgroup: refactor proactive reclaim code to reclaim_until()
  selftests: cgroup: make sure reclaim target memcg is unprotected

 include/linux/memcontrol.h                    | 31 +++++--
 mm/vmscan.c                                   | 11 ++-
 .../selftests/cgroup/test_memcontrol.c        | 91 +++++++++++--------
 3 files changed, 82 insertions(+), 51 deletions(-)

-- 
2.39.0.rc0.267.gcb52ba06e7-goog

