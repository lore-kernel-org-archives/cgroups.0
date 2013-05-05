From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] memcg: check more strictly to avoid PAGE_ALIGN wrapped to 0
Date: Sun,  5 May 2013 23:43:10 +0800
Message-ID: <1367768590-4403-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=2wKXjBBbZXapjiH2L2ULTCQ8yIw5bI7iYE7AHB74BZ8=;
        b=g4kqzMR1J5PDijlgKiPQqox7iXXpErPz9D2A4BRr93Gz1VFzakrn27DWZKzTviMITi
         udbXPOIaNinuwiASQPdMdLi71X2YF4fRJGBx0lM+pzui0D1UBJLbYnbrNCe9Dm04xp2L
         xy6jn/E8x+bISBLTt/Qp08ifKXcxxTibrBW5DCQSBxCE6WURiLFab93BOx5ULspj8Vhr
         EfsMFq3UC91g1/0a+ET4Jdl87ZbmourtIhmLlVgGYAkiaqc8qvE2tvviB/rZM3kmXr4F
         IJw020r4sed5nmpdLxGzS9S3XNS3wX0+K7Aq/CfovxZzdhrM3jSwsHbbnYfrYVnjYdSW
         ap2w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Since PAGE_ALIGN is aligning up(the next page boundary), this can
prevent input values wrapped to 0 and cause strange result to user.

This patch also rename the second arg of
res_counter_memparse_write_strategy() to 'resp' and add a local
variable 'res' to save the too often dereferences. Thanks Andrew
for pointing it out!


Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Reported-by: Li Wenpeng <xingke.lwp-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 kernel/res_counter.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 3f0417f..be8ddda 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -178,23 +178,29 @@ u64 res_counter_read_u64(struct res_counter *counter, int member)
 #endif
 
 int res_counter_memparse_write_strategy(const char *buf,
-					unsigned long long *res)
+					unsigned long long *resp)
 {
 	char *end;
+	unsigned long long res;
 
 	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
 	if (*buf == '-') {
-		*res = simple_strtoull(buf + 1, &end, 10);
-		if (*res != 1 || *end != '\0')
+		res = simple_strtoull(buf + 1, &end, 10);
+		if (res != 1 || *end != '\0')
 			return -EINVAL;
-		*res = RES_COUNTER_MAX;
+		*resp = RES_COUNTER_MAX;
 		return 0;
 	}
 
-	*res = memparse(buf, &end);
+	res = memparse(buf, &end);
 	if (*end != '\0')
 		return -EINVAL;
 
-	*res = PAGE_ALIGN(*res);
+	if (PAGE_ALIGN(res) >= res)
+		res = PAGE_ALIGN(res);
+	else
+		res = RES_COUNTER_MAX; /* avoid PAGE_ALIGN wrapping to zero */
+
+	*resp = res;
 	return 0;
 }
-- 
1.7.9.5
