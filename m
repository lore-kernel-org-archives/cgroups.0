From: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Documentation: cgroup: update the index file
Date: Sat,  8 Dec 2012 15:02:36 +0900
Message-ID: <1354946557-7938-1-git-send-email-linkinjeon@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=BxVvjj+9eWRR7tu0m9T426zWagInVfL4+lVOpwg8Sco=;
        b=M+bJc9E3Gq7jcrT4uI8UMHGYbZtewxIQtk97Eghz9v8Uy3VuKB4460uHOyy2bJEVjM
         VWjvH7mJkjr1O5yS5o7+fAdCaFVawoi2nzf3XPGyOjJjWusi+AB+7h2f4iWhxZ4jN9+W
         s7CQnFAIwqFXtobjKBkneLYWWjh4HftY1r6OXV/DXUgcMTmbmMweR7kaOcRRozMsw44q
         CazK6tSM/zGxXrPDg4ohnca7nrWi2Xr9OpVhcrybSPBnVYp6jUiV1De7y0NvkQ9M2aba
         Lq1T2vlrRebsBjxsBi55shdq6Vqj8lRC1V5OJpXQChNHUrz431In6EyR2MWlL09anbRm
         Xvbw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

There are new files added to cgroup documentation. Lets
update the index file listing all the remaining files

Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Amit Sahrawat <a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 Documentation/cgroups/00-INDEX |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/cgroups/00-INDEX b/Documentation/cgroups/00-INDEX
index 3f58fa3..f78b90a 100644
--- a/Documentation/cgroups/00-INDEX
+++ b/Documentation/cgroups/00-INDEX
@@ -1,7 +1,11 @@
 00-INDEX
 	- this file
+blkio-controller.txt
+	- Description for Block IO Controller, implementation and usage details.
 cgroups.txt
 	- Control Groups definition, implementation details, examples and API.
+cgroup_event_listener.c
+	- A user program for cgroup listener.
 cpuacct.txt
 	- CPU Accounting Controller; account CPU usage for groups of tasks.
 cpusets.txt
@@ -10,9 +14,13 @@ devices.txt
 	- Device Whitelist Controller; description, interface and security.
 freezer-subsystem.txt
 	- checkpointing; rationale to not use signals, interface.
+hugetlb.txt
+	- HugeTLB Controller implementation and usage details.
 memcg_test.txt
 	- Memory Resource Controller; implementation details.
 memory.txt
 	- Memory Resource Controller; design, accounting, interface, testing.
+net_prio.txt
+	- Network priority cgroups details and usages.
 resource_counter.txt
 	- Resource Counter API.
-- 
1.7.9.5
