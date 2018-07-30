From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: Remove memcg_cgroup::id from IDR on
 mem_cgroup_css_alloc() failure
Date: Mon, 30 Jul 2018 11:31:13 -0400
Message-ID: <20180730153113.GB4567@cmpxchg.org>
References: <6dbc33bb-f3d5-1a46-b454-13c6f5865fcd@virtuozzo.com>
 <20180413113855.GI17484@dhcp22.suse.cz>
 <8a81c801-35c8-767d-54b0-df9f1ca0abc0@virtuozzo.com>
 <20180413115454.GL17484@dhcp22.suse.cz>
 <abfd4903-c455-fac2-7ed6-73707cda64d1@virtuozzo.com>
 <20180413121433.GM17484@dhcp22.suse.cz>
 <20180413125101.GO17484@dhcp22.suse.cz>
 <20180726162512.6056b5d7c1d2a5fbff6ce214@linux-foundation.org>
 <20180727193134.GA10996@cmpxchg.org>
 <20180729192621.py4znecoinw5mqcp@esperanza>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bAQF7G4YSF50LkEIXaJPuasuOF/yCfd4ZGRA+h6Ym/4=;
        b=R8JqAUrhIbmTFWTuYNCGMeXv2jvp+chwIXdu3dNce8B0Z7YCDSOE6mx8X8SqbjfZ7I
         4UCuDSUQztdzKXEoj2jmJ8ZcakSCTd2wLsNy9GuhFDjTbUSIhuAz+xEFKeRvPRVG86OB
         MCQLcgJJRh85xSXAAey8O4F5oQc0jeKj4w6pH1oFf4nsISPs8ATcDsswtl0kYEuhGzuu
         jZKcS34VuuMulycq/344wqPb/iSfG15cVKvVGEmo9ev+lW6nc+Ag1Hr1fo71b+d4zCY5
         MQg1/z455wQRImjIbwYtevHSQDGDwhYDGZ4VRVIsePxX+RIHCXg+8YYxVOf+PMhx/Le+
         IBew==
Content-Disposition: inline
In-Reply-To: <20180729192621.py4znecoinw5mqcp@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sun, Jul 29, 2018 at 10:26:21PM +0300, Vladimir Davydov wrote:
> On Fri, Jul 27, 2018 at 03:31:34PM -0400, Johannes Weiner wrote:
> > That said, the lifetime of the root reference on the ID is the online
> > state, we put that in css_offline. Is there a reason we need to have
> > the ID ready and the memcg in the IDR before onlining it?
> 
> I fail to see any reason for this in the code.

Me neither, thanks for double checking.

The patch also survives stress testing cgroup creation and destruction
with the script from 73f576c04b94 ("mm: memcontrol: fix cgroup
creation failure after many small jobs").

> > Can we do something like this and not mess with the alloc/free
> > sequence at all?
> 
> I guess so, and this definitely looks better to me.

Cool, then I think we should merge Kirill's patch as the fix and mine
as a follow-up cleanup.

---

From b4106ea1f163479da805eceada60c942bd66e524 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 30 Jul 2018 11:03:55 -0400
Subject: [PATCH] mm: memcontrol: simplify memcg idr allocation and error
 unwinding

The memcg ID is allocated early in the multi-step memcg creation
process, which needs 2-step ID allocation and IDR publishing, as well
as two separate IDR cleanup/unwind sites on error.

Defer the IDR allocation until the last second during onlining to
eliminate all this complexity. There is no requirement to have the ID
and IDR entry earlier than that. And the root reference to the ID is
put in the offline path, so this matches nicely.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 12205159b462..12339ae779ca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4151,12 +4151,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	if (!memcg)
 		return NULL;
 
-	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
-				 1, MEM_CGROUP_ID_MAX,
-				 GFP_KERNEL);
-	if (memcg->id.id < 0)
-		goto fail;
-
 	memcg->stat_cpu = alloc_percpu(struct mem_cgroup_stat_cpu);
 	if (!memcg->stat_cpu)
 		goto fail;
@@ -4183,10 +4177,8 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&memcg->cgwb_list);
 #endif
-	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
 	return memcg;
 fail:
-	mem_cgroup_id_remove(memcg);
 	__mem_cgroup_free(memcg);
 	return NULL;
 }
@@ -4245,7 +4237,6 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 
 	return &memcg->css;
 fail:
-	mem_cgroup_id_remove(memcg);
 	mem_cgroup_free(memcg);
 	return ERR_PTR(-ENOMEM);
 }
@@ -4253,10 +4244,17 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	int i;
+
+	i = idr_alloc(&mem_cgroup_idr, memcg, 1, MEM_CGROUP_ID_MAX, GFP_KERNEL);
+	if (i < 0)
+		return i;
 
 	/* Online state pins memcg ID, memcg ID pins CSS */
+	memcg->id.id = i;
 	atomic_set(&memcg->id.ref, 1);
 	css_get(css);
+
 	return 0;
 }
 
-- 
2.18.0

