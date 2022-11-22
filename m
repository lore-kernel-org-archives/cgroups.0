From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v1 3/4] mm: Fix demotion-only scanning anon pages
Date: Tue, 22 Nov 2022 12:38:47 -0800
Message-ID: <20221122203850.2765015-3-almasrymina@google.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FPSzCF4B4ZUUfFv+NywISnCJ1Cav2tvMYf25Hqqvvgg=;
        b=Ylw0t/TQAkkJ5ZZ1Pjx3hAcFXh/aS80QxJujdVf6jQSIZZqenDDpuUnVzgNX6ILpOT
         D+OjVdmtDW5/tAPK26Gb1zGy/ZoTCNYUJRF0pyT+nwSM+/hfu38zrqKsPnMqXGmEd+xx
         cuUwYrnWdEWlYYI+NWRholXeyBpeozHwyScvQAjTUOFxdVVobSIfg3zrrhjVGUP9l7Px
         HcnmajR3YLpKxiUY3qDInKNDQjuM2qZP0Bd8vfd5A7IwOfoP5RK2bZZ11acFXKOU83kT
         GwdUHROVxNzf/nQ9nlj5eX8S+GZeK8I5hMFTQ/pyIzMVhZn83FC27sX4jgh9Me5r10Ge
         mRkw==
In-Reply-To: <20221122203850.2765015-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This is likely a missed change from commit a2a36488a61c ("mm/vmscan: Consider
anonymous pages without swap"). Current logic is if !may_swap _or_
!can_reclaim_anon_pages() then we don't scan anon memory.

This should be an 'and'. We would like to scan anon memory if we may swap
or if we can_reclaim_anon_pages().

Fixes: commit a2a36488a61c ("mm/vmscan: Consider anonymous pages without swap")

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8c1f5416d789..d7e509b3f07f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2931,7 +2931,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	enum lru_list lru;

 	/* If we have no swap space, do not bother scanning anon folios. */
-	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+	if (!sc->may_swap && !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
