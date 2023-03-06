From: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2, 0/4] mm, memcg: cgroup v1 and v2 tunable load/store tearing fixes
Date: Mon,  6 Mar 2023 23:41:34 +0800
Message-ID: <20230306154138.3775-1-findns94@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678117325;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ddh13VuSlVvMq9R5DcJQcv52Z9rBjlC8yPuM/C/Td5E=;
        b=MCGpVA5Twmc5z/yNIE43gFVuQVEit+BiKYabkQjNNN/2ScnKdGlcrnT4Tw1PZtKGIP
         eKTu5pqNmBHJWz4krNPS8BZr6HnJCBbluol3nqwekyFMkqhSRGTvYAVRFkw8JFhieuAZ
         bRL6J+sGg0n1sZ4TkeJ0cu2xTWeCFd5990AVYxGQkIkB8tMkDlrASjCJ0T0wWLDMFTma
         J++aX7oaaYAt4jgoedO2rVUmB6DXoFLCiV+TSdjEFVmPCtLOoNmrY0VpNvmlEvcom334
         Anw06N5MDbJMTBljfWk0MLg3frE/aQWfi7kwrCGSOpuypCk7yyYx7bYso2pCNb6DjaG/
         FAdg==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch series helps to prevent load/store tearing in
several cgroup knobs.

As kindly pointed out by Michal Hocko and Roman Gushchin
, the changelog has been rephrased.

Besides, more knobs were checked, according to kind suggestions
from Shakeel Butt and Muchun Song.

v1:
- Add [WRITE|READ]_ONCE for memcg->oom_group
v2:
- Rephrase changelog
- Add [WRITE|READ]_ONCE for memcg->oom_kill_disable,
 memcg->swappiness, vm_swappiness and memcg->soft_limit

Yue Zhao (4):
  mm, memcg: Prevent memory.oom.group load/store tearing
  mm, memcg: Prevent memory.swappiness load/store tearing
  mm, memcg: Prevent memory.oom_control load/store tearing
  mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing

 include/linux/swap.h |  8 ++++----
 mm/memcontrol.c      | 18 +++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

-- 
2.17.1

