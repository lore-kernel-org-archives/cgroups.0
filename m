From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH v2] vmpressure: wake up work only when there is
 registration event
Date: Tue, 14 Sep 2021 17:49:06 +0100
Message-ID: <YUDSgr+iwVz7iFBN@chrisdown.name>
References: <1631635551-8583-1-git-send-email-wang.yong12@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8cZjnBfKQ98RvNo+t8dXEqCfexHSNrNgQFLczr/dzUw=;
        b=ZIQJC39PqdNfy6y886PfF/Xyv2QsZ3DqnoJ0S5ozQT5AMmPORdXwJF0cgGxR1S51r3
         gipsEbV0W+CTKwig18Aid5zMp4RYSRvdqQYmr6PPuQTB/g14jrFlsq00X+H7aoLp4CvG
         NSESuAgGbCn+bU1oZspQ0hEyU8eCwIaHXmNCE=
Content-Disposition: inline
In-Reply-To: <1631635551-8583-1-git-send-email-wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org writes:
>From: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>
>Use the global variable num_events to record the number of vmpressure
>events registered by the system, and wake up work only when there is
>registration event.
>Usually, the vmpressure event is not registered in the system, this patch
>can avoid waking up work and doing nothing.
>
>Test with 5.14.0-rc5-next-20210813 on x86_64 4G ram.
>Consume cgroup memory until it is about to be reclaimed, then execute
>"perf stat -I 2000 malloc.out" command to trigger memory reclamation
>and get performance results.
>The context-switches is reduced by about 20 times.
>
>unpatched:
>Average of 10 test results
>582.4674048	task-clock(msec)
>19910.8		context-switches
>0		cpu-migrations
>1292.9		page-faults
>414784733.1	cycles
><not supported>	stalled-cycles-frontend
><not supported>	stalled-cycles-backend
>580070698.4	instructions
>125572244.7	branches
>2073541.2	branch-misses
>
>patched
>Average of 10 test results
>973.6174796	task-clock(msec)
>988.6		context-switches
>0		cpu-migrations
>1785.2		page-faults
>772883602.4	cycles
><not supported>	stalled-cycles-frontend
><not supported>	stalled-cycles-backend
>1360280911	instructions
>290519434.9	branches
>3378378.2	branch-misses
>
>Tested-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

That's not how Tested-by works. Tested-by is for human testers who have 
actively understand and have validated the effects of the code, not CI: please 
remove the tag.

>Signed-off-by: wangyong <wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
>---
>
>Changes since v1:
>-Use static_key type data as global variable
>-Make event registration judgment earlier
>
> mm/vmpressure.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>
>diff --git a/mm/vmpressure.c b/mm/vmpressure.c
>index 76518e4..6f4e984 100644
>--- a/mm/vmpressure.c
>+++ b/mm/vmpressure.c
>@@ -67,6 +67,11 @@ static const unsigned int vmpressure_level_critical = 95;
>  */
> static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
>
>+/*
>+ * Count the number of vmpressure events registered in the system.
>+ */
>+DEFINE_STATIC_KEY_FALSE(num_events);
>+
> static struct vmpressure *work_to_vmpressure(struct work_struct *work)
> {
> 	return container_of(work, struct vmpressure, work);
>@@ -272,6 +277,9 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> 		return;
>
> 	if (tree) {
>+		if (!static_branch_unlikely(&num_events))
>+			return;
>+
> 		spin_lock(&vmpr->sr_lock);
> 		scanned = vmpr->tree_scanned += scanned;
> 		vmpr->tree_reclaimed += reclaimed;
>@@ -407,6 +415,7 @@ int vmpressure_register_event(struct mem_cgroup *memcg,
> 	mutex_lock(&vmpr->events_lock);
> 	list_add(&ev->node, &vmpr->events);
> 	mutex_unlock(&vmpr->events_lock);
>+	static_branch_inc(&num_events);
> 	ret = 0;
> out:
> 	kfree(spec_orig);
>@@ -435,6 +444,7 @@ void vmpressure_unregister_event(struct mem_cgroup *memcg,
> 		if (ev->efd != eventfd)
> 			continue;
> 		list_del(&ev->node);
>+		static_branch_dec(&num_events);
> 		kfree(ev);
> 		break;
> 	}
>-- 
>2.7.4
>
>
