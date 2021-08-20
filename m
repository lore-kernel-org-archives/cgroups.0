From: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Subject: [PATCH v2 3/5] cgroup: Fix 'usage_usec' time in root's cpu.stat
Date: Fri, 20 Aug 2021 12:40:03 +0300
Message-ID: <20210820094005.20596-3-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
 <20210820094005.20596-1-arbn@yandex-team.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1629452407; bh=Si8KE1JJWs1mAy9P/ti0+l+WDdAkm3UF36Akx8W4YOM=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=QXbuP8kz8GHvwopKbXXt1NV6c1q55sqAepWaAnDLtj8CX/jQEK3BpptH1re2TfJjx
         iNXzsUpoQuPfry0/uyEzMSN5+A75rs4yXa6i87Lj6xyjK5QHDPd7KQV8G8ZIQAtzZe
         ZxyoYdcFSUA7y4AHw5KZUiWJ2fE5DuYiwccG5DqQ=
In-Reply-To: <20210820094005.20596-1-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, boris-UrQYPotlwNs@public.gmane.org, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Global CPUTIME_USER counter already includes CPUTIME_GUEST
Also CPUTIME_NICE already includes CPUTIME_GUEST_NICE.

Remove additions of CPUTIME_GUEST[_NICE] to total ->sum_exec_runtime
to not account them twice.

Fixes: 936f2a70f207 ("cgroup: add cpu.stat file to root cgroup")
Signed-off-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reviewed-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 Changes since v1:
  - Add review/tested tags in changelog
---
 kernel/cgroup/rstat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index b264ab5652ba..1486768f2318 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -433,8 +433,6 @@ static void root_cgroup_cputime(struct task_cputime *cputime)
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
 		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST_NICE];
 	}
 }
 
-- 
2.31.1

