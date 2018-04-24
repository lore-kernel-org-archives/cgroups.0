From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm: introduce memory.min
Date: Tue, 24 Apr 2018 14:54:15 +0100
Message-ID: <20180424135409.GA28080@castle.DHCP.thefacebook.com>
References: <20180423123610.27988-1-guro@fb.com>
 <20180424123002.utwbm54mu46q6aqs@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=sqHu+op4fJJFb9Ol22JNZBTwtb8+xMObI3Cu2VMDp28=;
 b=PlnjQ240wjS/e2oIMpjbGQ7dJa/SYBoYV0V2Is+cbRbQnAtqoCPsB7Eu73lnSyecsfRy
 ++p9wmAtdDVrltxeR1s3O8JV/O8OY1fqPR+FCf7MSHMn+iuLPXZqqYRoFjax9nv8TmU+
 lJAKh/MHpQslzr2o6BaPhy0DjWrBoEQ8bho= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sqHu+op4fJJFb9Ol22JNZBTwtb8+xMObI3Cu2VMDp28=;
 b=Xv573AqrhUBfgZPfuUuwN3VkAJLwlFgcVGHLqfe8ZQ5W7Owjf/MsIp8N4iVIBO0J9OQjXXPDB3hDyJLV/tRrBzSAD2x7fBfv+ztyYvpl+WvwcaGaOVOd09DLSlEOzQG34LSwk6cLux1xKHW20hxGGtte3DvA7dhDs5QjYC4HdR0=
Content-Disposition: inline
In-Reply-To: <20180424123002.utwbm54mu46q6aqs@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>

Hi Vladimir!

> On Mon, Apr 23, 2018 at 01:36:10PM +0100, Roman Gushchin wrote:
> > +  memory.min
> > +	A read-write single value file which exists on non-root
> > +	cgroups.  The default is "0".
> > +
> > +	Hard memory protection.  If the memory usage of a cgroup
> > +	is within its effective min boundary, the cgroup's memory
> > +	won't be reclaimed under any conditions. If there is no
> > +	unprotected reclaimable memory available, OOM killer
> > +	is invoked.
> 
> What will happen if all tasks attached to a cgroup are killed by OOM,
> but its memory usage is still within memory.min? Will memory.min be
> ignored then?

Not really.

I don't think it's a big problem as long as a user isn't doing
something weird (e.g. moving processes with significant
amount of charged memory to other cgroups).

But what we can do here, is to ignore memory.min of empty cgroups
(patch below), it will resolve some edge cases like this.

Thanks!

--------------------------------------------------------------------------------

From 54a4f4fc9f8a6847c8a5814c53f0b575010808e5 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Tue, 24 Apr 2018 14:44:14 +0100
Subject: [PATCH] mm: ignore memory.min of abandoned memory cgroups

If a cgroup has no associated tasks, invoking the OOM killer
won't help release any memory, so respecting the memory.min
can lead to an infinite OOM loop or system stall.

Let's ignore memory.min of unpopulated cgroups.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
---
 mm/vmscan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0a42ab1ce42b..e563d67de787 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2549,8 +2549,11 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 				/*
 				 * Hard protection.
 				 * If there is no reclaimable memory, OOM.
+				 * Abandoned cgroups are loosing protection,
+				 * because OOM killer won't release any memory.
 				 */
-				continue;
+				if (cgroup_is_populated(memcg->css.cgroup))
+					continue;
 			case MEMCG_PROT_LOW:
 				/*
 				 * Soft protection.
-- 
2.14.3

