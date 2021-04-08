From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: page_counter: mitigate consequences of a page_counter underflow
Date: Thu,  8 Apr 2021 10:31:55 -0400
Message-ID: <20210408143155.2679744-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=btC50RWZIR531OhYeaaK7FrT2NEPi0tjXTwyDrbtV5o=;
        b=i6e9rr/E1F5vh2gsAqs1AjButTuV2db5PXnLnGsrylcSpVrAPBMDWw7TlkxlPuEcfR
         69vzlUrbGFl3mdMfMTrED2E20o/836zklqnPuO8grp+mwVmWtAl9sMJVQGN2R4Dfib4q
         Osvj9Hy/tqt2ZffewcVDUwMkxVb1ZeXE1xfdOe+xF3NssK0biDNoBBJm2sBSeWzjxNij
         nr9QqJj/dqmY/PhUHIQC7nJV/X2Y7+GSQPCA2WhHya1WL9wC13mjR7Cy40Od+40yG4kd
         Csi505C9RBKkqCoYQSty2edESBk7g/mzSEKx6/oZPMUVrtNTtAaw7umqVm4t7n/HereL
         hQBg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

When the unsigned page_counter underflows, even just by a few pages, a
cgroup will not be able to run anything afterwards and trigger the OOM
killer in a loop.

Underflows shouldn't happen, but when they do in practice, we may just
be off by a small amount that doesn't interfere with the normal
operation - consequences don't need to be that dire.

Reset the page_counter to 0 upon underflow. We'll issue a warning that
the accounting will be off and then try to keep limping along.

[ We used to do this with the original res_counter, where it was a
  more straight-forward correction inside the spinlock section. I
  didn't carry it forward into the lockless page counters for
  simplicity, but it turns out this is quite useful in practice. ]

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/page_counter.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index c6860f51b6c6..7d83641eb86b 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -52,9 +52,13 @@ void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
 	long new;
 
 	new = atomic_long_sub_return(nr_pages, &counter->usage);
-	propagate_protected_usage(counter, new);
 	/* More uncharges than charges? */
-	WARN_ON_ONCE(new < 0);
+	if (WARN_ONCE(new < 0, "page_counter underflow: %ld nr_pages=%lu\n",
+		      new, nr_pages)) {
+		new = 0;
+		atomic_long_set(&counter->usage, new);
+	}
+	propagate_protected_usage(counter, new);
 }
 
 /**
-- 
2.31.1

