From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cfq: explicitly use 64bit divide operation for 64bit arguments
Date: Fri, 30 Aug 2013 10:31:56 -0700
Message-ID: <1377883916-8957-1-git-send-email-anatol.pomozov@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

'samples' is 64bit operant, but do_div() second parameter is 32.
do_div silently truncates high 32 bits and calculated result
is invalid.

In case if low 32bit of 'samples' are zeros then do_div() produces
kernel crash.

Signed-off-by: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d5bbdcf..10fb653 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1803,7 +1803,7 @@ static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
 
 	if (samples) {
 		v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
-		do_div(v, samples);
+		div64_u64(v, samples);
 	}
 	__blkg_prfill_u64(sf, pd, v);
 	return 0;
-- 
1.8.4
