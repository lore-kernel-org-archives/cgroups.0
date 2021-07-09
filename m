From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] mm, memcg: Optimizations to minimize overhead when memcgs
 are disabled
Date: Thu,  8 Jul 2021 17:05:06 -0700
Message-ID: <20210709000509.2618345-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HcLnGXZfaeqCi0d4EsoaKKelu1NS9rMOMY3OT5HTNvs=;
        b=c+KFF36BFzAWbZ1ZqezCaWKkP9YnbQF8Z1exFWSQlGnsvkb6rwZgB5lPB6tZRCFSL/
         2e79NSQQsiyezU4RQCDxHfPlWsi6YTf1z98QAYFY+FNDZcHcFLisxhJYYm4MuhClcr0L
         iTSQFrSE/fJlNePefffT+DV0/KtGATS+VIhreboD6UhWQOtO+fHKucBKP4tNtAzuF6xN
         hRNEZI2oOI1CO5qUjzjj1hpxFivEdX9lLsZCgXvkSRwcRNX/xdPl8MChwTtLcO46X1eS
         6fmZYbxdNiwjfzfpzpNsDnt2sAPjYdsxhv2xWGbbsMAsuE8RvJqEwhZ3g/XB/JdF/JD6
         u4hA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Disabling memcgs on Android from kernel command-line because important due to
new requirements for all vendors to share the same kernel config and because
some vendors use memcgs while others don't. The ones who don't, have to disable
memcgs via "cgroup_disable=memory" kernel command-line option and we would like
to minimize the cost of disabling memcgs this way vs disabling CONFIG_MEMCG.
This patchset is focused on minimizing performance costs of this option.
When running pft test with memcgs disabled via CONFIG_MEMCG=n vs
"cgroup_disable=memory" command-line option, we measured ~6% drop in the
average pagefault/sec rate with stddev of ~2%. The results were obtained by
running pft test 1500 times and averaging the results on an 8-core ARM64
Android device with system services stopped, performance governor and enabling
only Big or Little cores in one test to minimize the noise.
Using perf, a number of relatively high-cost areas were identified where extra
operations can be minimized. The patchset consists of a number of optimisations
gradually reducing this regression. Patches are applied incrementally while
testing and recording the impact for each one:

6.01% with vanilla cgroup_disable vs CONFIG_MEMCG=n
3.87% after patch #1 adding mem_cgroup_disabled checks vs CONFIG_MEMCG=n
3.49% after patch #2 inlining mem_cgroup_{charge/uncharge} vs CONFIG_MEMCG=n
2.48% After patch #3 inlining swap-related functions vs CONFIG_MEMCG=n

I kept them separate because they vary in their "impact vs readability cost"
and I'm not sure which ones pass the acceptable threashold.

Suren Baghdasaryan (3):
  mm, memcg: add mem_cgroup_disabled checks in vmpressure and
    swap-related functions
  mm, memcg: inline mem_cgroup_{charge/uncharge} to improve disabled
    memcg config
  mm, memcg: inline swap-related functions to improve disabled memcg
    config

 include/linux/memcontrol.h | 54 ++++++++++++++++++++++++++++++++++----
 include/linux/swap.h       | 26 +++++++++++++++---
 mm/memcontrol.c            | 52 +++++-------------------------------
 mm/swapfile.c              |  2 +-
 mm/vmpressure.c            |  7 ++++-
 5 files changed, 86 insertions(+), 55 deletions(-)

-- 
2.32.0.93.g670b81a890-goog

