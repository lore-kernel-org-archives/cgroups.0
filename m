From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RESEND PATCH] cgroup: use tsk->in_iowait instead of delayacct_is_task_waiting_on_io()
Date: Tue, 13 Apr 2021 09:39:05 +0800
Message-ID: <7fee39d482a783254379f2419a00b9a9f32d7f2e.1618275776.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=D8cI9p8duSAuwc0HuZGq6ac3QTWtYsZEHTOhpxbujwY=;
        b=VEAgWfFzhjH6Aq/MB7OIrsgZ27v6iLoERBo84DYM2EtxfQjTQw6u5Hc439W+fhK8rh
         sCNSLEsFZd5nIOJzec8uQ4dLoceN/7urm7KmQQ+AS4wocWlG/wg2C0O3kUi7+xdZBWpj
         eIYy45pXDN8DEJnTyk619D0G+PeSyupZeJ9eyuU6gcdr8W37soX3Z5haOHeGvKMxxUyz
         yNGiSxmvHBDTi3wDc3jl+2/pwwWNQWDF2TYYY1Z7SQahiblPItifkLI+mcP+GsDWmcAh
         C32HbbEwchQQbJTYKCuIyO+6hcMqkfeXFd0a8FN4gllacZlTCWabfH0+NU6Ehsb61kTf
         0Isg==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

If delayacct is disabled, then delayacct_is_task_waiting_on_io()
always returns false, which causes the statistical value to be
wrong. Perhaps tsk->in_iowait is better.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 32596fd..91991e2 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -727,7 +727,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 			stats->nr_stopped++;
 			break;
 		default:
-			if (delayacct_is_task_waiting_on_io(tsk))
+			if (tsk->in_iowait)
 				stats->nr_io_wait++;
 			break;
 		}
-- 
1.8.3.1

