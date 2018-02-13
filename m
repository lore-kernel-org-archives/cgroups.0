From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V3 01/10] sched/topology: Add check to backup comment about hotplug lock
Date: Tue, 13 Feb 2018 13:32:38 -0700
Message-ID: <1518553967-20656-2-git-send-email-mathieu.poirier@linaro.org>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EN03PbsrZiRRqe4tJq7u3W330XNNPxoiJqtHTysQnFs=;
        b=dcOKRsEoc1JKX6Br+4wnJstQv600hGAlsAcCP2/+h0WJurO14ocItmm21QqUPsSd9D
         tUteljV0oeogOyCJDl3e2eD3PL/2T6jpxQav4TviqavnrbInaTyP8BZ9OIwnKBOH0jQr
         Ec03h9IxEhLwYf8NikCJppXuQr1VoFByI0ePE=
In-Reply-To: <1518553967-20656-1-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The comment above function partition_sched_domains() clearly state that
the cpu_hotplug_lock should be held but doesn't mandate one to abide to
it.  Adding an explicit check backs that comment and make it impossible
for anyone to miss the requirement.

Suggested-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 kernel/sched/topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8010c2974d30..7c744c7425ec 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1863,6 +1863,7 @@ void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 	int i, j, n;
 	int new_topology;
 
+	lockdep_assert_cpus_held();
 	mutex_lock(&sched_domains_mutex);
 
 	/* Always unregister in case we don't destroy any domains: */
-- 
2.7.4
