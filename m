From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup, memcg, writeback: drop spurious rcu locking around
 mem_cgroup_css_from_page()
Date: Fri, 8 Jan 2016 17:00:53 -0500
Message-ID: <20160108220053.GB1898@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=P459Qjupi+qOm8Qp3rtjQWp/cj0HieyGHEbGqlt7vlk=;
        b=TfR0nRvwKcvMsLC8NxPxeJIdYohnUFVNpm/5MaXXSFOumZqDNPpwn+VkxB+xTtRmZy
         AkbFPBPqjOqmHkRKcFh/bijetQfjAeUmzl9YUjDbTV2STeRho6ycnbD/MUkBgUGgTtDE
         I1+J4XbWTwk18fSPbhFfdCsF9TBKGlTJrLGYJWXRF3QxWxCjZmrLMOJrGNMDWw3jav4w
         gTGR3Je4JAB5cAE9DJC/64/bjpYFLBf+vwkRd2b/G87sJIScJv5XDG7qg6uq0utZpqon
         jEbdq0m2vEYN0zdfLIP1lxgyanYViYtWCXIJdVgbJN/+TjOHLDjKbITGBanGVw8jsynT
         WUUA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

In earlier versions, mem_cgroup_css_from_page() could return non-root
css on a legacy hierarchy which can go away and required rcu locking;
however, the eventual version simply returns the root cgroup if memcg
is on a legacy hierarchy and thus doesn't need rcu locking around or
in it.  Remove spurious rcu lockings.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 fs/fs-writeback.c |    2 --
 mm/memcontrol.c   |    3 ---
 2 files changed, 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 023f6a1..6915c95 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -677,9 +677,7 @@ void wbc_account_io(struct writeback_control *wbc, struct page *page,
 	if (!wbc->wb)
 		return;
 
-	rcu_read_lock();
 	id = mem_cgroup_css_from_page(page)->id;
-	rcu_read_unlock();
 
 	if (id == wbc->wb_id) {
 		wbc->wb_bytes += bytes;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index fc10620..3230201 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -431,14 +431,11 @@ struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
 {
 	struct mem_cgroup *memcg;
 
-	rcu_read_lock();
-
 	memcg = page->mem_cgroup;
 
 	if (!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		memcg = root_mem_cgroup;
 
-	rcu_read_unlock();
 	return &memcg->css;
 }
 
