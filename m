From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] rdmacg: Fixed uninitialized current resource usage
Date: Tue, 10 Jan 2017 17:51:48 +0000
Message-ID: <1484070708-5422-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Cc0I26UA2zGU08gsUhbpXZAEK3uN8CydESV0c1RGzF0=;
        b=dXKRfZfeQqOtdr+YOlvLtLrm/I03scrme0Vx3h49zxIyqvvc2R5jqsroWQ5jiTXDu9
         GDt5AMZ3lKefKN2T6r4AasGAsNe5+m9YVssKQDpg44tV3o5Ugd3/HdSmIUSm5VTlJK2b
         mUkRILBE1gjGi5X/C8EYYAG7gjv7V6pUFai6pXWz5oScx533FbePHFWwhF0a98QBJ5bs
         X5ilGH0osuJIpAvJRuse1P7Pm7xbA3eqcMpKmB5T9M57yxzsx2EqR97NRZG0eU5MKRpv
         ufGZElwloo2sHsrNC4ig6/sWFVnioL5r4nsdLhmAO5mI5cZAmPOa7iddJotFCa7nHy7A
         VYSg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Fixed warning reported by kbuild test robot.
When reading current resource usage value, when no resources are
allocated, its possible that it can report a uninitialized value
for current resource usage.
This fix avoids it by initializing it to zero as no resource is
allocated.

Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/rdma.c b/kernel/cgroup/rdma.c
index 021bee7..defad3c 100644
--- a/kernel/cgroup/rdma.c
+++ b/kernel/cgroup/rdma.c
@@ -518,6 +518,8 @@ static void print_rpool_values(struct seq_file *sf,
 		} else {
 			if (rpool)
 				value = rpool->resources[i].usage;
+			else
+				value = 0;
 		}
 
 		if (value == S32_MAX)
-- 
2.7.4
