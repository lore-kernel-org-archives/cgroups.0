From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [PATCH v9 3/8] cpuset: Rebuild root domain deadline accounting
 information
Date: Fri, 16 Dec 2022 23:35:01 +0000
Message-ID: <20221216233501.gh6m75e7s66dmjgo@airbuntu>
References: <20190719140000.31694-1-juri.lelli@redhat.com>
 <20190719140000.31694-4-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X0VtzC74LzR2drrGRcJjmM7+tpdFp4NU23zKURKWjt4=;
        b=gfzD/GKB7u5dlxmxEaH6dLYg6YiMvLoKLMxgIkMoYyeq8S3M3btEvu7gt8MXbWzZQa
         G6GWiXE1LS463y8W7c+a+8TF5sjpiYS1ywoBTty38GltUXu05+DWuenht2Ws/g8TvmNe
         iyqheFyZquS57ZRuN+238btFfCxOGFaP6xtKQvuIZQM7dyu262r+ICz2EdaTOkqOsUvd
         mEBFXa8jyLZeeBRo8UenQzbQSrLrGhXEOu+pLOfwZQZIuxwUoLHeco8xLOg03ZSVQVgR
         2B0MKR+nQJO/RifdfQ51o4Jz8gbV7gamHgytNu5OdbfBwQEGy62XkdaDwqRwDUB8XiCI
         e+gw==
Content-Disposition: inline
In-Reply-To: <20190719140000.31694-4-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi

On 07/19/19 15:59, Juri Lelli wrote:
> When the topology of root domains is modified by CPUset or CPUhotplug
> operations information about the current deadline bandwidth held in the
> root domain is lost.
> 
> This patch addresses the issue by recalculating the lost deadline
> bandwidth information by circling through the deadline tasks held in
> CPUsets and adding their current load to the root domain they are
> associated with.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

We see that rebuild_root_domain() can take 10+ ms (I get a max of 20ms quite
consistently) on suspend/resume.

Do we actually need to rebuild_root_domain() if we're going through
a suspend/resume cycle?

ie: would something like the below make sense? We'd skip this logic if
cpuhp_tasks_frozen is set which indicates it's not a real hotplug operation but
we're suspending/resuming.


Cheers

--
Qais Yousef


--->8---


From 4cfd50960ad872c5eb810ad3038eaf840bab5182 Mon Sep 17 00:00:00 2001
From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Date: Tue, 29 Nov 2022 19:01:52 +0000
Subject: [PATCH] sched: cpuset: Don't rebuild sched domains on suspend-resume

Commit f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
enabled rebuilding sched domain on cpuset and hotplug operations to
correct deadline accounting.

Rebuilding sched domain is a slow operation and we see 10+ ms delays
on suspend-resume because of that.

Since nothing is expected to change on suspend-resume operation; skip
rebuilding the sched domains to regain some of the time lost.

Debugged-by: Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Qais Yousef (Google) <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
---
 kernel/cgroup/cpuset.c  | 6 ++++++
 kernel/sched/deadline.c | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b474289c15b8..2ff68d625b7b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1067,6 +1067,9 @@ static void update_tasks_root_domain(struct cpuset *cs)
 	struct css_task_iter it;
 	struct task_struct *task;
 
+	if (cpuhp_tasks_frozen)
+		return;
+
 	css_task_iter_start(&cs->css, 0, &it);
 
 	while ((task = css_task_iter_next(&it)))
@@ -1084,6 +1087,9 @@ static void rebuild_root_domains(void)
 	lockdep_assert_cpus_held();
 	lockdep_assert_held(&sched_domains_mutex);
 
+	if (cpuhp_tasks_frozen)
+		return;
+
 	rcu_read_lock();
 
 	/*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0d97d54276cc..42c1143a3956 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2575,6 +2575,9 @@ void dl_clear_root_domain(struct root_domain *rd)
 {
 	unsigned long flags;
 
+	if (cpuhp_tasks_frozen)
+		return;
+
 	raw_spin_lock_irqsave(&rd->dl_bw.lock, flags);
 	rd->dl_bw.total_bw = 0;
 	raw_spin_unlock_irqrestore(&rd->dl_bw.lock, flags);
-- 
2.25.1

