From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3, 0/4] mm, memcg: cgroup v1 and v2 tunable load/store tearing fixes
Date: Thu,  9 Mar 2023 00:25:51 +0800
Message-ID: <20230308162555.14195-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678292771;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWwMHeJpend+hzpuPqFIQzMgVunHLYMAMCx5MYeNU2o=;
        b=CNf5LmESb4+kOCQPbjMP3umJWUrWFr7U3y+v8xZk5znqjCZWCO/16aFonllNQHNRat
         Z2dON/28zs8dIvG93QXsMc8SjqHPhwmN/CEm+ULLN7V3peF9D09lEhm/2OMLfA92Q39I
         hQ7D6o6MgkuomYj5Dmzoio/OCP1Ym6QmxKFpFadpIpSXZtvbyTicuMJX2ucI4Axzwjjh
         9xsz2lXZR+ynHCDTZ830xdWISm4rQF89FOJbbiTjhcgfeBMsfgwTUp6X4eLFzxqMn2lb
         VE72KXOQ4EXPKjmYmVa8Cc4zqMO5BZpM6TyRJGTv6mXp6qoYE9oeg2vmrsP+GZnxY/dS
         OQkQ==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch series helps to prevent load/store tearing in
several cgroup knobs.

As kindly pointed out by Michal Hocko, we should add 
[WRITE|READ]_ONCE for all occurrences of memcg->oom_kill_disable,
memcg->swappiness and memcg->soft_limit.

v3:
- Add [WRITE|READ]_ONCE for all occurrences of
memcg->oom_kill_disable, memcg->swappiness and memcg->soft_limit
v2:
- Rephrase changelog
- Add [WRITE|READ]_ONCE for memcg->oom_kill_disable,
 memcg->swappiness, vm_swappiness and memcg->soft_limit
v1:
- Add [WRITE|READ]_ONCE for memcg->oom_group

Past patches:
V2: https://lore.kernel.org/linux-mm/20230306154138.3775-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/
V1: https://lore.kernel.org/linux-mm/20230220151638.1371-1-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/

Yue Zhao (4):
  mm, memcg: Prevent memory.oom.group load/store tearing
  mm, memcg: Prevent memory.swappiness load/store tearing
  mm, memcg: Prevent memory.oom_control load/store tearing
  mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing

 include/linux/swap.h |  8 ++++----
 mm/memcontrol.c      | 30 +++++++++++++++---------------
 2 files changed, 19 insertions(+), 19 deletions(-)

-- 
2.17.1

