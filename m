From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] memcg: robust enforcement of memory.high
Date: Thu, 10 Feb 2022 00:14:33 -0800
Message-ID: <20220210081437.1884008-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=T9FcBDMwvgeHBlJy4y16uXfaabYSCGyJ3a5EN/2FH/k=;
        b=MxdsYuSId5HtvKIg92vKZD2AqHFrlV0PE/vRdDgoIOtAxeRQ9ojCRGSaEaK45fB/bh
         We8jMJdFWXIW3lmpW/ZDfeZqIzKdt/QwufKjFYFwGOjP5J1vxnhO4F61EVjj6I5nQCH9
         fDEgALX0BPefVUNsfL9sWq0H2oZnkV64CrnT5tb6XTyHRbhSH20LE7MeL9YrcLKE+Upn
         ca0C2CBxPkElew+dpCqGOsBsQheR9rbsOFacWIyuWmkdp6LjxepL0z7kc5y4slTtujd4
         Lyx2Ub3/D9/fZ76P15/g2wgvb8rYb5WxFCWJrzgsjaJGP5phBtg3xbKKR3MOb87xNC86
         TOKw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Due to the semantics of memory.high enforcement i.e. throttle the
workload without oom-kill, we are trying to use it for right sizing the
workloads in our production environment. However we observed the
mechanism fails for some specific applications which does bug chunck of
allocations in a single syscall. The reason behind this failure is due
to the limitation of the memory.high enforcement's current
implementation. This patch series solves this issue by enforcing the
memory.high synchronously and making it more robust.

Shakeel Butt (4):
  memcg: refactor mem_cgroup_oom
  memcg: unify force charging conditions
  selftests: memcg: test high limit for single entry allocation
  memcg: synchronously enforce memory.high

 include/linux/page_counter.h                  |  10 +
 mm/memcontrol.c                               | 175 ++++++++++--------
 mm/page_counter.c                             |  59 ++++--
 tools/testing/selftests/cgroup/cgroup_util.c  |  15 +-
 tools/testing/selftests/cgroup/cgroup_util.h  |   1 +
 .../selftests/cgroup/test_memcontrol.c        |  78 ++++++++
 6 files changed, 240 insertions(+), 98 deletions(-)

-- 
2.35.1.265.g69c8d7142f-goog

