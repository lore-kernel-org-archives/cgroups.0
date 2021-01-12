From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: prevent starvation when writing memory.high
Date: Tue, 12 Jan 2021 11:30:11 -0500
Message-ID: <20210112163011.127833-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aSfbgJHMgHLM9rzB5N8TPqwylQdBK6aN3u6pmU/8Jk4=;
        b=XRtRi+npxUhv1aIaFonEpF9d9xK4DvoowayUJ3B3qkBd1aLaEH2E7JKQzu/AV9pDOT
         fIETBbFsDj6lgUWnkEQOnMgb7rUD27wGjJ5x5wHlEWIAsCLQgmMLTbbFJKgO6jhO5aFm
         4xwavol2Mz98x5eMv0tqfMrRy+KoNbmEtxmNcHHm2cFTepKbx9AmChWp/aH65taw8I7q
         MYxPRcAhTffnCW9cbjoc4FdWKHgpDC4bT+m0LLWJAmr4sKbd8tpTA4wO5kOY8VehxlL7
         tABlka6b/ikymYrABypNGD7TfR74nzqfsrYHaT9I0xbrxyLhmu4wIAZH3UjsqchkNTx6
         2fuA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

When a value is written to a cgroup's memory.high control file, the
write() context first tries to reclaim the cgroup to size before
putting the limit in place for the workload. Concurrent charges from
the workload can keep such a write() looping in reclaim indefinitely.

In the past, a write to memory.high would first put the limit in place
for the workload, then do targeted reclaim until the new limit has
been met - similar to how we do it for memory.max. This wasn't prone
to the described starvation issue. However, this sequence could cause
excessive latencies in the workload, when allocating threads could be
put into long penalty sleeps on the sudden memory.high overage created
by the write(), before that had a chance to work it off.

Now that memory_high_write() performs reclaim before enforcing the new
limit, reflect that the cgroup may well fail to converge due to
concurrent workload activity. Bail out of the loop after a few tries.

Fixes: 536d3bf261a2 ("mm: memcontrol: avoid workload stalls when lowering memory.high")
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 5.8+
Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 605f671203ef..63a8d47c1cd3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6275,7 +6275,6 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
-		unsigned long reclaimed;
 
 		if (nr_pages <= high)
 			break;
@@ -6289,10 +6288,10 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 			continue;
 		}
 
-		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-							 GFP_KERNEL, true);
+		try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+					     GFP_KERNEL, true);
 
-		if (!reclaimed && !nr_retries--)
+		if (!nr_retries--)
 			break;
 	}
 
-- 
2.30.0

