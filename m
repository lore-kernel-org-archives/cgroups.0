From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: fix blocking rstat function called from atomic cgroup1 thresholding code
Date: Mon, 26 Jul 2021 11:00:19 -0400
Message-ID: <20210726150019.251820-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xTTsptuLITxPc+Owajv0QCvUN6VmzjQA4sTb/kLyZME=;
        b=ZXLe+pV1dgrpJxW8gR0RgPwPUehS8IrE/2Vbou8UHcmjEUrqODo0mbUUtREDLuboHI
         uRYwy1cK4J2lucpZS2lkrz+Yw3WhqxYpAkUM404nyr8nhUs+xbXAzDBhgicYHjJ02tcT
         P7TwXco+KKFQYqfCwlG7Pa+rFK8sjhe3zkhUEIpLvEhU1x/8TfOIdLv3UNg30/xApIS9
         n+idNUq/UTyY5HU1LEGAlJPZWfKdyKAYAIaaFhvqhVJnPZULfAhZMEDr+qzP1/Amj40Q
         BVflhSLUWnZN5aqLPa75Q9QA+mvqr+1FOMZjDpEEW8gOwUNQA5DRllSRQyw3V6m1xd8f
         cVfQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Dan Carpenter reports:

    The patch 2d146aa3aa84: "mm: memcontrol: switch to rstat" from Apr
    29, 2021, leads to the following static checker warning:

	    kernel/cgroup/rstat.c:200 cgroup_rstat_flush()
	    warn: sleeping in atomic context

    mm/memcontrol.c
      3572  static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
      3573  {
      3574          unsigned long val;
      3575
      3576          if (mem_cgroup_is_root(memcg)) {
      3577                  cgroup_rstat_flush(memcg->css.cgroup);
			    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    This is from static analysis and potentially a false positive.  The
    problem is that mem_cgroup_usage() is called from __mem_cgroup_threshold()
    which holds an rcu_read_lock().  And the cgroup_rstat_flush() function
    can sleep.

      3578                  val = memcg_page_state(memcg, NR_FILE_PAGES) +
      3579                          memcg_page_state(memcg, NR_ANON_MAPPED);
      3580                  if (swap)
      3581                          val += memcg_page_state(memcg, MEMCG_SWAP);
      3582          } else {
      3583                  if (!swap)
      3584                          val = page_counter_read(&memcg->memory);
      3585                  else
      3586                          val = page_counter_read(&memcg->memsw);
      3587          }
      3588          return val;
      3589  }

__mem_cgroup_threshold() indeed holds the rcu lock. In addition, the
thresholding code is invoked during stat changes, and those contexts
have irqs disabled as well. If the lock breaking occurs inside the
flush function, it will result in a sleep from an atomic context.

Use the irsafe flushing variant in mem_cgroup_usage() to fix this.

Fixes: 2d146aa3aa84 ("mm: memcontrol: switch to rstat")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae1f5d0cb581..eb8e87c4833f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3574,7 +3574,8 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		cgroup_rstat_flush(memcg->css.cgroup);
+		/* mem_cgroup_threshold() calls here from irqsafe context */
+		cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
-- 
2.32.0

