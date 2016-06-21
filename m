From: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH] cgroup: Use lld instead of ld when printing pids controller events_limit
Date: Tue, 21 Jun 2016 11:55:35 -0700
Message-ID: <1466535335-3715145-1-git-send-email-kennyyu@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : mime-version : content-type; s=facebook;
 bh=6yC1FDN9ZnmXjaFZ5ETHIU3Hv6z77So/xNJEO0D0zVM=;
 b=ml4EnrQIHzedySmxtj3SARZqMuI0ToQH1ayJWRMS73c03M79UWIw74i0snverEA3/IxK
 0Tg8/77Cz6YumsIN1FEyUOgihovYGEbnpeqtlk2oijOq3HzMSftJ3o7Z9s7aFtd927jJ
 OqjpvNexCZyUngUvy3PRqKZqDiP4zM+f8lg= 
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org
Cc: kennyyu-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The `events_limit` variable needs to be formatted with %lld and not %ld.
This fixes the following warning discovered by kbuild test robot:

   kernel/cgroup_pids.c: In function 'pids_events_show':
   kernel/cgroup_pids.c:313:24: warning: format '%ld' expects argument of type
   'long int', but argument 3 has type 'long long int' [-Wformat=]
        seq_printf(sf, "max %ld\n", atomic64_read(&pids->events_limit));
                                   ^

Signed-off-by: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
---
 kernel/cgroup_pids.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup_pids.c b/kernel/cgroup_pids.c
index bd2490b..1777d03 100644
--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -310,7 +310,7 @@ static int pids_events_show(struct seq_file *sf, void *v)
 {
 	struct pids_cgroup *pids = css_pids(seq_css(sf));
 
-	seq_printf(sf, "max %ld\n", atomic64_read(&pids->events_limit));
+	seq_printf(sf, "max %lld\n", atomic64_read(&pids->events_limit));
 	return 0;
 }
 
-- 
2.8.0.rc2
