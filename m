From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch v2] mm, memcg: periodically schedule when emptying page
 list
Date: Mon, 2 Jun 2014 17:51:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406021749590.13910@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406021612550.6487@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=ewouK5Et3ykPcomUX2B5KcSaDyR4kQH+PJpKIzTinY4=;
        b=c+Jb3qibrNWlM4BbslNn/KRn4uQ48sdUV3RT7kTt2dAwWCwXWWVBWdo3ZaftteA24v
         27QTdvW/rbeKG8dtAJQGVoS5JzQd005Jz1b9WxFmMhwFllWcfHQnQO1Jj5eXZ/ykaj/+
         qSIDUfUvhaKzjnMoudW1+wAjpDORCuGrz8jqbRz0hhj+EbMbHLJI8fdFbQUCwjnOk71C
         plJ9L81qhhqsq6U7ID1/+epts7Y1D6qMaRKZV9Wnv4p/8jUnx5hVyW2utn12N62ilSgK
         5k+SsOPc+nrtYwLLI6Mqj4WMCDbq+BBx6V7GWCB1xH32Hd6dJ/dxkArq8voBIEfIccvD
         lJ2w==
In-Reply-To: <alpine.DEB.2.02.1406021612550.6487-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

mem_cgroup_force_empty_list() can iterate a large number of pages on an lru and 
mem_cgroup_move_parent() doesn't return an errno unless certain criteria, none 
of which indicate that the iteration may be taking too long, is met.

We have encountered the following stack trace many times indicating
"need_resched set for > 51000020 ns (51 ticks) without schedule", for example:

	scheduler_tick()
	<timer irq>
	mem_cgroup_move_account+0x4d/0x1d5
	mem_cgroup_move_parent+0x8d/0x109
	mem_cgroup_reparent_charges+0x149/0x2ba
	mem_cgroup_css_offline+0xeb/0x11b
	cgroup_offline_fn+0x68/0x16b
	process_one_work+0x129/0x350

If this iteration is taking too long, we still need to do cond_resched() even 
when an individual page is not busy.

[rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org: changelog]
Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 v2: always reschedule if needed, "page" itself may not have a pc mismatch
     or been unable to isolate.

 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4784,9 +4784,9 @@ static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 		if (mem_cgroup_move_parent(page, pc, memcg)) {
 			/* found lock contention or "pc" is obsolete. */
 			busy = page;
-			cond_resched();
 		} else
 			busy = NULL;
+		cond_resched();
 	} while (!list_empty(list));
 }
 
