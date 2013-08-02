From: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/4] memcg: correct RESOURCE_MAX to ULLONG_MAX
Date: Fri, 2 Aug 2013 11:25:30 +0800
Message-ID: <1375413933-10732-2-git-send-email-h.huangqiang@huawei.com>
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

Current RESOURCE_MAX is ULONG_MAX, but the value we used to set resource
limit is unsigned long long, so we can set bigger value than that which
is strange. The XXX_MAX should be reasonable max value, bigger than that
should be overflow.

Notice that this change will affect user output of default *.limit_in_bytes:
before change:
$ cat /cgroup/memory/memory.limit_in_bytes
9223372036854775807

after change:
$ cat /cgroup/memory/memory.limit_in_bytes
18446744073709551615

But it doesn't alter the API in term of input - we can still use
"echo -1 > *.limit_in_bytes" to reset the numbers to "unlimited".

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 include/linux/res_counter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 96a509b..586bc7c 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -54,7 +54,7 @@ struct res_counter {
 	struct res_counter *parent;
 };
 
-#define RESOURCE_MAX (unsigned long long)LLONG_MAX
+#define RESOURCE_MAX ULLONG_MAX
 
 /**
  * Helpers to interact with userspace
-- 
1.8.3

