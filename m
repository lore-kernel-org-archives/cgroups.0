From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup is
 above protection
Date: Tue, 28 Apr 2020 19:26:47 +0100
Message-ID: <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
References: <cover.1588092152.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8ZdOelXqdALp+t5GpXOOCmyCgx7RbdhWdYql4OpbI1c=;
        b=FIUW+caXr+iJxtL6SRGRKizlkX7XhzWQuOY05F0+5+5/65k+s+9ywMQwaLpbod1SvJ
         FfDh3SAdEhODgckqhW2bHwjVwebnbxOH1HsAcAe4T3Fd/1U0rACWccleZh2AdKLIkD+h
         o/RxBNRzbhY/2DUlNUpR3LbBF56ufvPXeDgfo=
Content-Disposition: inline
In-Reply-To: <cover.1588092152.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

A cgroup can have both memory protection and a memory limit to isolate
it from its siblings in both directions - for example, to prevent it
from being shrunk below 2G under high pressure from outside, but also
from growing beyond 4G under low pressure.

Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
implemented proportional scan pressure so that multiple siblings in
excess of their protection settings don't get reclaimed equally but
instead in accordance to their unprotected portion.

During limit reclaim, this proportionality shouldn't apply of course:
there is no competition, all pressure is from within the cgroup and
should be applied as such. Reclaim should operate at full efficiency.

However, mem_cgroup_protected() never expected anybody to look at the
effective protection values when it indicated that the cgroup is above
its protection. As a result, a query during limit reclaim may return
stale protection values that were calculated by a previous reclaim cycle
in which the cgroup did have siblings.

When this happens, reclaim is unnecessarily hesitant and potentially
slow to meet the desired limit. In theory this could lead to premature
OOM kills, although it's not obvious this has occurred in practice.

Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

[hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: rework code comment]
[hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: changelog]
[chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org: fix store tear]
[chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org: retitle]
---
 mm/memcontrol.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0be00826b832..b0374be44e9e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6392,8 +6392,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 
 	if (!root)
 		root = root_mem_cgroup;
-	if (memcg == root)
+	if (memcg == root) {
+		/*
+		 * The cgroup is the reclaim root in this reclaim
+		 * cycle, and therefore not protected. But it may have
+		 * stale effective protection values from previous
+		 * cycles in which it was not the reclaim root - for
+		 * example, global reclaim followed by limit reclaim.
+		 * Reset these values for mem_cgroup_protection().
+		 */
+		WRITE_ONCE(memcg->memory.emin, 0);
+		WRITE_ONCE(memcg->memory.elow, 0);
 		return MEMCG_PROT_NONE;
+	}
 
 	usage = page_counter_read(&memcg->memory);
 	if (!usage)
-- 
2.26.2

