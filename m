From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 3/3] vmpressure: do not check for pending work to prevent from new work
Date: Fri, 12 Jul 2013 11:24:58 +0200
Message-ID: <1373621098-15261-3-git-send-email-mhocko@suse.cz>
References: <20130712084039.GA13224@dhcp22.suse.cz>
 <1373621098-15261-1-git-send-email-mhocko@suse.cz>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373621098-15261-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

because it is racy and it doesn't give us much anyway as schedule_work
handles this case already.

Brought-up-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/vmpressure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index b8e16fe..581a7d7 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -253,7 +253,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
 	scanned = vmpr->scanned;
 	spin_unlock(&vmpr->sr_lock);
 
-	if (scanned < vmpressure_win || work_pending(&vmpr->work))
+	if (scanned < vmpressure_win)
 		return;
 	schedule_work(&vmpr->work);
 }
-- 
1.8.3.2
