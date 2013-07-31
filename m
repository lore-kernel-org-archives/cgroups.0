From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] memcg: avoid overflow caused by PAGE_ALIGN
Date: Wed, 31 Jul 2013 15:31:24 +0800
Message-ID: <1375255885-10648-4-git-send-email-h.huangqiang@huawei.com>
References: <1375255885-10648-1-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375255885-10648-1-git-send-email-h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org

Since PAGE_ALIGN is aligning up(the next page boundary), so after PAGE_ALIGN,
the value might be overflow, such as write the MAX value to *.limit_in_bytes.

$ cat /cgroup/memory/memory.limit_in_bytes
18446744073709551615

# echo 18446744073709551615 > /cgroup/memory/memory.limit_in_bytes
bash: echo: write error: Invalid argument

Some user programs might depend on such behaviours(like libcg, we read the
value in snapshot, then use the value to reset cgroup later), and that
will cause confusion. So we need to fix it.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/res_counter.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 3f0417f..085d3ae 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -195,6 +195,10 @@ int res_counter_memparse_write_strategy(const char *buf,
 	if (*end != '\0')
 		return -EINVAL;
 
-	*res = PAGE_ALIGN(*res);
+	if (PAGE_ALIGN(*res) >= *res)
+		*res = PAGE_ALIGN(*res);
+	else
+		*res = RES_COUNTER_MAX;
+
 	return 0;
 }
-- 
1.8.3

