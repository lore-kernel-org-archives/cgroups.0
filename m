From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcontrol: Don't increase effective low/min if no protection needed
Date: Tue, 11 Oct 2022 10:30:15 -0400
Message-ID: <20221011143015.1152968-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665498658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4/tx5Hg2EBXygF2G8xfjAkH7UAOIXn21J5RskYrkmds=;
        b=DwjXgvSEvRerTGNgLLu7FR7yhLhl+YK0VdOKH2M5ox9vDwAPkMA8az0zpAYppF1vysR7P4
        S76mEq2PxczCY3Ywcr09QQmHH9hqoKfYOUWpQAf02bnlH/cINtY14v5Ne3gAOqqD2mFZwL
        LrzNnM/gjqDuBNdqEElF/AIV4n9Jpcg=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Since commit bc50bcc6e00b ("mm: memcontrol: clean up and document
effective low/min calculations"), the effective low/min protections can
be non-zero even if the corresponding memory.low/min values are 0. That
can surprise users to see MEMCG_LOW events even when the memory.low
value is not set. One example is the LTP's memcontrol04 test which fails
because it detects some MEMCG_LOW events for a cgroup with a memory.min
value of 0.

Fix this by updating effective_protection() to not returning a non-zero
low/min protection values if the corresponding memory.low/min values
or those of its parent are 0.

Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5..893d4d5e518a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6660,6 +6660,9 @@ static unsigned long effective_protection(unsigned long usage,
 	unsigned long protected;
 	unsigned long ep;
 
+	if (!setting || !parent_effective)
+		return 0UL;	/* No protection is needed */
+
 	protected = min(usage, setting);
 	/*
 	 * If all cgroups at this level combined claim and use more
-- 
2.31.1

