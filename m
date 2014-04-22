From: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: explicitly init the early_init field
Date: Tue, 22 Apr 2014 13:27:29 +0800
Message-ID: <1398144449-9325-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=from:to:cc:subject:date:message-id;
	bh=6rM8Yv2IrVCZar91ogHr/eT0cS1xHw+Xdocdv1fO/ZU=;
	b=m+vpqZ8bvML/kif7N9Y8XZe7NfntWPWZeC0DxldEWjgKMbp1DKlQZfOVQHeSdC2KrN
	i/nwiXVvvdUnAETc+S8zmnt1jeLCWn+bCLc8tBDWdujP2fz3ExPW8HHWo0rC0n0Eyz1z
	nbKFRbq0j7YephY6L+Ovo3DjkXQE1Qgjxl5XfiG9my8kcv4Z7kggPqsltdWMs6f9KvX+
	5vGTqp393ddcgfkOfMhT02jxdoCVOb8fH6fEbaVDXV1EbwXdh7f7n4X6HFvF9zwM9o+e
	xaID52+QxP6mtXkommbc3V9aR8fhrfyCO/IdMbqllK7rNC7AUM4kVM4i6i98AZgCD9Ci
	kH+Q==
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

For a cgroup subsystem who should init early, then it should carefully
take care of the implementation of css_alloc, because it will be called
before mm_init() setup the world.

Luckily we don't, and we better explicitly assign the early_init field
to 0, for document reason.

Signed-off-by: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 559f822..f23cb67 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5325,5 +5325,6 @@ struct cgroup_subsys debug_cgrp_subsys = {
 	.css_alloc = debug_css_alloc,
 	.css_free = debug_css_free,
 	.base_cftypes = debug_files,
+	.early_init = 0,
 };
 #endif /* CONFIG_CGROUP_DEBUG */
-- 
2.0.0-rc0
