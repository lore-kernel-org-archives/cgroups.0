From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: Check more strictly to avoid ULLONG overflow by PAGE_ALIGN
Date: Fri, 12 Apr 2013 14:39:23 +0800
Message-ID: <1365748763-4350-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=mLhXFnjMaHf8rCWA9eT+fg37zPRTCrjs89JMnrXWLtc=;
        b=LUxg39AcMzlCUtpVVOiec2vAqgByLMCDiCq8zwqzocd0Z98Boap+28bKQe4/LikD8J
         XHAj2C74k3viapvgmcgMRoAF7P+TKLYQ8mv/jjnqC1ujDeAIZQ1V8yotgD2al0JXJHgU
         7nYTd0l7pyDyCVwsDEgZGcG0R7buEVPxPKCli4/635pPqVRy+yuyjnacDjzqNr6VniKz
         2Wy90ckXGQocsPFhKhsClWs+H9sodQ4TYw05xoNsofUztiP1Gr78llic8rliLSSELZq7
         olW0JXYZJDhh5PHGpMafwY3DOMRdgZMxdlmFuGlyuVZTxZdDgZ1YIvWjMZTaey7WfjjO
         jf/A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

While writing memory.limit_in_bytes, a confusing result may happen:

$ mkdir /memcg/test
$ cat /memcg/test/memory.limit_in_bytes
9223372036854775807
$ cat /memcg/test/memory.memsw.limit_in_bytes
9223372036854775807
$ echo 18446744073709551614 > /memcg/test/memory.limit_in_bytes
$ cat /memcg/test/memory.limit_in_bytes
0

Strangely, the write successed and reset the limit to 0.
The patch corrects RESOURCE_MAX and fixes this kind of overflow.


Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Reported-by: Li Wenpeng < xingke.lwp-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Cc: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/res_counter.h |    2 +-
 kernel/res_counter.c        |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index c230994..c2f01fc 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -54,7 +54,7 @@ struct res_counter {
 	struct res_counter *parent;
 };
 
-#define RESOURCE_MAX (unsigned long long)LLONG_MAX
+#define RESOURCE_MAX (unsigned long long)ULLONG_MAX
 
 /**
  * Helpers to interact with userspace
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index ff55247..6c35310 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -195,6 +195,12 @@ int res_counter_memparse_write_strategy(const char *buf,
 	if (*end != '\0')
 		return -EINVAL;
 
-	*res = PAGE_ALIGN(*res);
+	/* Since PAGE_ALIGN is aligning up(the next page boundary),
+	 * check the left space to avoid overflow to 0. */
+	if (RESOURCE_MAX - *res < PAGE_SIZE - 1)
+		*res = RESOURCE_MAX;
+	else
+		*res = PAGE_ALIGN(*res);
+
 	return 0;
 }
-- 
1.7.9.5
