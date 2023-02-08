From: Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] sched/psi: Optimize PSI iteration
Date: Thu,  9 Feb 2023 00:16:52 +0800
Message-ID: <20230208161654.99556-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tzqq5s709T6l/w+9pi74lxvpe8BbE2WIdW1BUQhpDbQ=;
        b=noT7JHKssXq5HEmHAxZXC82FcLwo5xxQtOr1L4ExZ113d77QoohSj2CtErhGNEPtNd
         DmtzNw8zA34e6E8miyKkEx44kh6DySdQBGI/sfJoVSWoh3ZT6J2LfEVc2A9CFTscmziJ
         x3UJauD26xL2f6CCeEOAjHeSy4ja/vBftnMF+2osuOJjr/S7tqbZbEPlMEOdx4zl13IM
         BT05bjXcVILKBEJtE8WA7bJ7DzeL7Xp992kAjhLFuJ2Uden55LIMRM3meXYvwx8LmF8v
         be44fgwHbzaZo8IeeFceI70f3HPCYFsMzdE8Nj2GelKZHOXurCHDdi8vSb/LDY1zAOPq
         Zazw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kairui Song <ryncsn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi all,

Patch 1/2 simplify cgroup_psi, I didn't see a measurable performance
change with this.

Patch 2/2 removed the cache, I just noticed it have the same hierarchy
as the cgroup it's in, so I wondered if it worth adding a cache just for
simplifying the branch, and if we can balance the branch simplification
and minimize the memory footprint in another way, it seems this is
doable.

After the two patches, I see a measurable performance gain
using mmtests/perfpipe:

(AVG of 100 test, ops/sec, the higher the better)
KVM guest on a i7-9700:
        psi=0         root cgroup   5 levels of cgroup
Before: 59221         55352         47821
After:  60100         56036         50884

KVM guest on a Ryzen 9 5900HX:
        psi=0         root cgroup   5 levels of cgroup
Before: 144566        138919        128888
After:  145812        139580        133514

Kairui Song (2):
  sched/psi: simplify cgroup psi retrieving
  sched/psi: iterate through cgroups directly

 include/linux/psi.h       |  2 +-
 include/linux/psi_types.h |  1 -
 kernel/cgroup/cgroup.c    |  7 +++++-
 kernel/sched/psi.c        | 45 ++++++++++++++++++++++++++++-----------
 4 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.39.1

