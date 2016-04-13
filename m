From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Wed, 13 Apr 2016 14:57:54 -0400
Message-ID: <20160413185754.GI3676@htj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Pdz1W92wF4aUh+amgzokjOqh+8jqSXemlyuLer1qV0c=;
        b=P+UDe/LibLxkozJPRDes3WEVTk1Oj0b3+lIHUjF+wQP81ToKTqtRiAsjd+8i8m4pdB
         d17DRSB476kz0A2X+uOH9VXRV+obSgDgGoZb7uiuP+twIJuoTv13UYIZbOxDk4j+/z7c
         AFJ12iJeN81LKzsrvmfFZWjol7++96uyDj86Nh7mU95GZr1SKiqtSDoiBGUsjQ+tfj4j
         7k4OVouWomYA/CPiqrsJELCO6TUWk5X2ZYsKOI2LDhStAl62OVWAbRGlPDfssl+bRgik
         /HQvgj1raNMbWFecF2iu31TdueM+NLIcU/BaJaIe6pBJNckRAzkQM+FulIrjtqI+WAbT
         3Y+A==
Content-Disposition: inline
In-Reply-To: <20160413183309.GG3676-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed, Apr 13, 2016 at 02:33:09PM -0400, Tejun Heo wrote:
> An easy solution would be to make lru_add_drain_all() use a
> WQ_MEM_RECLAIM workqueue.  A better way would be making charge moving
> asynchronous similar to cpuset node migration but I don't know whether
> that's realistic.  Will prep a patch to add a rescuer to
> lru_add_drain_all().

So, something like the following.  Can you please see whether the
deadlock goes away with the patch?

diff --git a/mm/swap.c b/mm/swap.c
index a0bc206..7022872 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -664,8 +664,16 @@ static void lru_add_drain_per_cpu(struct work_struct *dummy)
 	lru_add_drain();
 }
 
+static struct workqueue_struct *lru_add_drain_wq;
 static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
+static int __init lru_add_drain_wq_init(void)
+{
+	lru_add_drain_wq = alloc_workqueue("lru_add_drain", WQ_MEM_RECLAIM, 0);
+	return lru_add_drain_wq ? 0 : -ENOMEM;
+}
+core_initcall(lru_add_drain_wq_init);
+
 void lru_add_drain_all(void)
 {
 	static DEFINE_MUTEX(lock);
@@ -685,13 +693,12 @@ void lru_add_drain_all(void)
 		    pagevec_count(&per_cpu(lru_deactivate_pvecs, cpu)) ||
 		    need_activate_page_drain(cpu)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
-			schedule_work_on(cpu, work);
+			queue_work_on(cpu, lru_add_drain_wq, work);
 			cpumask_set_cpu(cpu, &has_work);
 		}
 	}
 
-	for_each_cpu(cpu, &has_work)
-		flush_work(&per_cpu(lru_add_drain_work, cpu));
+	flush_workqueue(lru_add_drain_wq);
 
 	put_online_cpus();
 	mutex_unlock(&lock);
