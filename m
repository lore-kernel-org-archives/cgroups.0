From: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Subject: [PATCH 2/4] cgroup: Fix 'usage_usec' time in root's cpu.stat
Date: Wed, 17 Feb 2021 15:00:02 +0300
Message-ID: <20210217120004.7984-2-arbn@yandex-team.com>
References: <20210217120004.7984-1-arbn@yandex-team.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1613563136; bh=LuoQeMQQrtl1XmsM4uDiGZRevLihMSflRpO6W5fFyf0=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=iybY8AoBRftH99ramFuGRb5GUmT6U/wQcK1Gi1xbBbUU7TBa1/tc/Ot7KuEvV1pO7
         U1ZgzNTf7n/OF1Tz1XJKJxD3U16PrTGUMlORyWBJcO2nEEnj+PX6ELkP/rOjz7qyA6
         7ICJfly+A12/+0hR2VwnVkUsWxW9eq3lehDr9Q8A=
In-Reply-To: <20210217120004.7984-1-arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>, Bharata B Rao <bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Global CPUTIME_USER counter already includes CPUTIME_GUEST
Also CPUTIME_NICE already includes CPUTIME_GUEST_NICE.

Remove additions of CPUTIME_GUEST[_NICE] to total ->sum_exec_runtime
to not account them twice.

Fixes: 936f2a70f207 ("cgroup: add cpu.stat file to root cgroup")
Signed-off-by: Andrey Ryabinin <arbn-XoJtRXgx1JtgGdypvdXH1w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 kernel/cgroup/rstat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index d51175cedfca..89ca9b61aa0d 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -421,8 +421,6 @@ static void root_cgroup_cputime(struct task_cputime *cputime)
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
 		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST_NICE];
 	}
 }
 
-- 
2.26.2

