From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] memcg: reduce function dereference
Date: Fri, 2 Aug 2013 11:25:33 +0800
Message-ID: <1375413933-10732-5-git-send-email-h.huangqiang@huawei.com>
References: <1375413933-10732-1-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375413933-10732-1-git-send-email-h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

This function dereferences res far too often, so optimize it.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 kernel/res_counter.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 085d3ae..4aa8a30 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -178,27 +178,30 @@ u64 res_counter_read_u64(struct res_counter *counter, int member)
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
 
-	if (PAGE_ALIGN(*res) >= *res)
-		*res = PAGE_ALIGN(*res);
+	if (PAGE_ALIGN(res) >= res)
+		res = PAGE_ALIGN(res);
 	else
-		*res = RES_COUNTER_MAX;
+		res = RES_COUNTER_MAX;
+
+	*resp = res;
 
 	return 0;
 }
-- 
1.8.3

