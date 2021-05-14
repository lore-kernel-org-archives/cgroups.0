From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: make per-cgroup pressure stall tracking
 configurable
Date: Fri, 14 May 2021 19:52:04 +0200
Message-ID: <YJ64xHoogrowXTok@hirez.programming.kicks-ass.net>
References: <20210513175349.959661-1-surenb@google.com>
 <YJ5iAvqAmIhzJRot@hirez.programming.kicks-ass.net>
 <CAJuCfpHy+MknCepfjx9XYUA1j42Auauv7MFQbt+zOU-tA4gasA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HdZ+Rvb3VddDC+nVIUj42YinsKumWXhl2FsoYoSKcTw=; b=MlhCqueTaVBVJquCeH+yCh0mNn
        DWQa9KPy6TjpHwTVqGPctwkRkkm7WYcbTKbR3BnJnNQwRZm2C8UaQgPY522CQoRXLO6O+1pTV+mas
        dKpzpvYnQL+t4hdwCIYtN6cLPasFRXYO+UuH58XydP4dQ8L0yW79ol4kJsBmHQ5348JfDO9SSxpf8
        0yeMNi8e254eAojsjvy+g1z52WWvIL3venwPje2pWY0s8kSNGvArS4VnB2jpLOoriOick18LHRkQP
        UuJzP9Q71riB+cDvdaQvzFEEcm1nOhmlVb9+DqMlCv6ANXJ+6XPSvnsRU9Jl0ohR2Zz9FmYy6R9+O
        LsYUevOQ==;
Content-Disposition: inline
In-Reply-To: <CAJuCfpHy+MknCepfjx9XYUA1j42Auauv7MFQbt+zOU-tA4gasA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, mgorman-l3A5Bk7waGM@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Paul E . McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, macro-fOkVWZO6G+f10XsdtD+oqA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 14, 2021 at 08:54:47AM -0700, Suren Baghdasaryan wrote:

> Correct, for this function CONFIG_CGROUPS=n and
> cgroup_disable=pressure are treated the same. True, from the code it's
> not very obvious. Do you have some refactoring in mind that would make
> it more explicit?

Does this make sense?

--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -744,24 +744,26 @@ static void psi_group_change(struct psi_
 
 static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
 {
+	if (cgroup_psi_enabled()) {
 #ifdef CONFIG_CGROUPS
-	struct cgroup *cgroup = NULL;
+		struct cgroup *cgroup = NULL;
 
-	if (!*iter)
-		cgroup = task->cgroups->dfl_cgrp;
-	else if (*iter == &psi_system)
-		return NULL;
-	else
-		cgroup = cgroup_parent(*iter);
+		if (!*iter)
+			cgroup = task->cgroups->dfl_cgrp;
+		else if (*iter == &psi_system)
+			return NULL;
+		else
+			cgroup = cgroup_parent(*iter);
 
-	if (cgroup && cgroup_parent(cgroup)) {
-		*iter = cgroup;
-		return cgroup_psi(cgroup);
-	}
-#else
-	if (*iter)
-		return NULL;
+		if (cgroup && cgroup_parent(cgroup)) {
+			*iter = cgroup;
+			return cgroup_psi(cgroup);
+		}
 #endif
+	} else {
+		if (*iter)
+			return NULL;
+	}
 	*iter = &psi_system;
 	return &psi_system;
 }
