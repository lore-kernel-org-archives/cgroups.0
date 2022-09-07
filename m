From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] memcg: reduce memory overhead of memory cgroups
Date: Wed,  7 Sep 2022 04:35:34 +0000
Message-ID: <20220907043537.3457014-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=ARY6z7c/YNSdIuDysr3yMfPrF2u31pVSHbSH5GcWfeE=;
        b=q9iz05jUj6H8xeR7Sm+d7zjR+v2lZM1+/kobuusBNoE0JoCXsnK5bvzGtwyNvIi+8U
         GH0rPOO/xKYtM5rIULeimIKEZZVJeN/gEjimKq/+hEkeS7sgv9BRF1RCpPU7KRJNQYSM
         /IzUDL95+VcFL2q0Hl1EA+8A4hiMO8I4UOYJkfJk31lHrFMFpY3kU6ZhV5p0RvFXs2Fc
         UlZLfi/vZLQbZVH2VXXNbSO7/GoY43Xu+6nJQn00xcfl2xayw4LodDd3F6zHSD8U1xOT
         jmaT8lo9ciYyboax/cu4Uy4QhBL7yP5SMSve8KtYnM2oG0G9+Ws+S3Z7uRssba6RB5BT
         8dcw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently a lot of memory is wasted to maintain the vmevents for memory
cgroups as we have multiple arrays of size NR_VM_EVENT_ITEMS which can
be as large as 110. However memcg code uses small portion of those
entries. This patch series eliminate this overhead by removing the
unneeded vmevent entries from memory cgroup data structures.

Shakeel Butt (3):
  memcg: extract memcg_vmstats from struct mem_cgroup
  memcg: rearrange code
  memcg: reduce size of memcg vmstats structures

 include/linux/memcontrol.h |  37 +---------
 mm/memcontrol.c            | 145 ++++++++++++++++++++++++++++---------
 2 files changed, 113 insertions(+), 69 deletions(-)

-- 
2.37.2.789.g6183377224-goog

