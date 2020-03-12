From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: [PATCH 6/6] mm, memcg: Prevent mem_cgroup_protected store tearing
Date: Thu, 12 Mar 2020 17:33:16 +0000
Message-ID: <d1e9fbc0379fe8db475d82c8b6fbe048876e12ae.1584034301.git.chris@chrisdown.name>
References: <cover.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NoiaqPMaLbyoL7WcV9VE9eKkmobOKnQ4L0s3bngIbSs=;
        b=qaWsULht3bWoY5iXQLEcDGdBTFV6hjN7lpV33RTCtB3xWc1PLX/WRxZQohX8Xrl/9w
         UmohlrmtFgTmdaoEpFrPYYLSu55234z8uvo9TnjcyiBJbYmm2fJpmw10ZPHUC3T9G4Z3
         CvKX3yFDACoE48iNQsDgNcSOYv8fqeVuxR4Rk=
Content-Disposition: inline
In-Reply-To: <cover.1584034301.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The read side of this is all protected, but we can still tear if
multiple iterations of mem_cgroup_protected are going at the same time.

There's some intentional racing in mem_cgroup_protected which is ok, but
load/store tearing should be avoided.

Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-b10kYP2dOMg@public.gmane.org
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 57048a38c75d..e9af606238ab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6301,8 +6301,8 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
 	}
 
 exit:
-	memcg->memory.emin = emin;
-	memcg->memory.elow = elow;
+	WRITE_ONCE(memcg->memory.emin, emin);
+	WRITE_ONCE(memcg->memory.elow, elow);
 
 	if (usage <= emin)
 		return MEMCG_PROT_MIN;
-- 
2.25.1

