From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: [PATCH 0/4] mm: memcg kselftests fixes
Date: Thu, 14 Apr 2022 17:01:29 -0700
Message-ID: <20220415000133.3955987-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1649980904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x0OJT7vtHeCsFa3T3M2nSJtuwiJNpM1MZE2d38sUzeE=;
        b=TnMKjcFycGksoGIHsEZYPyuP5tGDPSWVACST3hbjTjCsgJ+rldhg9Bza3n9fsrh56wJTYB
        WJReZfLJggzdlpikXj9ouMRFCzA+2uY3TyOh9z/sguWkNnBzjhfigrHxD+DYDn6mI9XhrM
        kk2gFy8dWtqvNlsR/WkxT/qaUPQbqFc=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

I'm resending two memcg kselftests fixes, which I first posted in 2019 [1],
however they didn't go anywhere. I've rechecked them and they're are both
still actual, even though there were new regressions introduced since that,
so not all tests are passing now. I know that David Vernet (cc'ed) is working
on fixing (some of) them, so hopefully he'll post more fixes soon.

I believe it's better for such patches to go through mm and cgroup trees
(and mailing lists), where there are better chances for them to be properly
reviewed, so adding corresponding entries to the MAINTAINERS file to make it
obvious.

1: https://lore.kernel.org/lkml/20191203165758.GA607734-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org/T/


Roman Gushchin (4):
  kselftests: memcg: update the oom group leaf events test
  kselftests: memcg: speed up the memory.high test
  MAINTAINERS: add corresponding kselftests to cgroup entry
  MAINTAINERS: add corresponding kselftests to memcg entry

 MAINTAINERS                                      | 3 +++
 tools/testing/selftests/cgroup/test_memcontrol.c | 7 ++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
2.35.1

