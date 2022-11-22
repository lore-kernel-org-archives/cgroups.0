From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v1] mm: Add memory.demote for proactive demotion only
Date: Tue, 22 Nov 2022 12:38:46 -0800
Message-ID: <20221122203850.2765015-2-almasrymina@google.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mH2xKyLbtphuPdUJ732OjxOQc7w7f5rhMLqPKs8ZczA=;
        b=qdsmec8olNuJkHjim4tCNOzdWa/frQp8m5lufYNaqejkZMLoMUUyW+CWmAkGziybpf
         XVtKd/0LwOGTSKPzuW0laRVzBchDj/eYAtuTCSNB8IMPYcpApfCWC2zjH37lPwrTquSo
         e6VwPwg/ku5WTWy2ImXR0wgUFLZ1Bya8Re9NroqrrjtTrQdgeKHCixYvONLr+VBOSK7D
         y/z7y3/mili8PPvIi+kePEDEmzvJZh09v92ohyzbQ5RuROFwKw5KgQsz7VHG+PzHsW5E
         1yg6L/6VSUWRD0wFpHrfizjK3o+Nif6zqdPMbBMhrgAWMlNgfhUP/5lOq0C7Wj8y1WM3
         OO7A==
In-Reply-To: <20221122203850.2765015-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Add the proactive demotion interface memory.demote. This interface can
be used as follows:

echo "1m" > memory.demote

At this command the kernel will attempt to demote 1m of memory from this
cgroup. The kernel may not be able to demote the full amount requested
by the userspace and in that case EAGAIN would be returned to the user
(similar to memory.reclaim).

The kernel will only attempt to demote pages with this interface. It
will not attempt any other kind of reclaim (swap, writeback or
reclaiming clean file pages).

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 38 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c     | 18 ++++++++++++++----
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fd4ff1c865a2..427c79e467eb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6623,6 +6623,39 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	return nbytes;
 }

+static ssize_t memory_demote(struct kernfs_open_file *of, char *buf,
+			     size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned long nr_to_demote, nr_demoted = 0;
+	unsigned int reclaim_options = MEMCG_RECLAIM_ONLY_DEMOTE;
+	int err;
+
+	buf = strstrip(buf);
+	err = page_counter_memparse(buf, "", &nr_to_demote);
+	if (err)
+		return err;
+
+	while (nr_demoted < nr_to_demote) {
+		unsigned long demoted;
+
+		if (signal_pending(current))
+			return -EINTR;
+
+		demoted = try_to_free_mem_cgroup_pages(
+			memcg, nr_to_demote - nr_demoted, GFP_KERNEL,
+			reclaim_options);
+
+		if (!demoted && !nr_retries--)
+			return -EAGAIN;
+
+		nr_demoted += demoted;
+	}
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6691,6 +6724,11 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.write = memory_reclaim,
 	},
+	{
+		.name = "demote",
+		.flags = CFTYPE_NS_DELEGATABLE,
+		.write = memory_demote,
+	},
 	{ }	/* terminate */
 };

diff --git a/mm/vmscan.c b/mm/vmscan.c
index dea05ad8ece5..8c1f5416d789 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1657,12 +1657,13 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	LIST_HEAD(demote_folios);
 	unsigned int nr_reclaimed = 0;
 	unsigned int pgactivate = 0;
-	bool do_demote_pass;
+	bool do_demote_pass, only_demote_pass;
 	struct swap_iocb *plug = NULL;

 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc);
+	only_demote_pass = sc->demotion == 2;

 retry:
 	while (!list_empty(folio_list)) {
@@ -2091,10 +2092,19 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	nr_reclaimed += demote_folio_list(&demote_folios, pgdat);
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
-		/* Folios which weren't demoted go back on @folio_list for retry: */
+		/*
+		 * Folios which weren't demoted go back on @folio_list.
+		 */
 		list_splice_init(&demote_folios, folio_list);
-		do_demote_pass = false;
-		goto retry;
+
+		/*
+		 * goto retry to reclaim the undemoted folios in folio_list if
+		 * desired.
+		 */
+		if (!only_demote_pass) {
+			do_demote_pass = false;
+			goto retry;
+		}
 	}

 	pgactivate = stat->nr_activate[0] + stat->nr_activate[1];
