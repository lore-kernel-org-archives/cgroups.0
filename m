From: Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] docs: admin-guide: cgroup-v1: Fix typos in the file memory.rst
Date: Sat, 13 Mar 2021 11:40:29 +0530
Message-ID: <20210313061029.28024-1-unixbhaskar@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhJjvom66vWXKl1dRRY7urBL+2AkflR90bJnAsiNVs0=;
        b=F1PhW6/1e0GK1MFV1fErIjvorj1XvA8fYbgQ+EBS2xpTPDvLQE3OfN8UuruqsI26/R
         ZyDKY85MRnrK8iSjHxVFbhnMmLbO1dk2/2Ddu+y8lgkkEIPMK9rOpLq/TyNxCJavBGm+
         XMQ7N1Gw5xxGsTAaJ5VLJVwKRrmywjrZen1GHlnxUvXBt8CLz+GsRNnUygUOxM8m6hEW
         agapUrIR9+qmpif5lwqWNI4UmZSeczjjbvND3FYs7PBfQFDx+mAFTtuFpP29FHIEUcqe
         d/KVUyrLxQTJfozyesGmOoAkwdelT/lcQE4PtvqenL6/ileoCUL66HRiOB2BaozcAFpC
         BFdw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


s/overcommited/overcommitted/
s/Overcommiting/Overcommitting/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 52688ae34461..0d574fd3f8e3 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -360,8 +360,8 @@ U != 0, K = unlimited:

 U != 0, K < U:
     Kernel memory is a subset of the user memory. This setup is useful in
-    deployments where the total amount of memory per-cgroup is overcommited.
-    Overcommiting kernel memory limits is definitely not recommended, since the
+    deployments where the total amount of memory per-cgroup is overcommitted.
+    Overcommitting kernel memory limits is definitely not recommended, since the
     box can still run out of non-reclaimable memory.
     In this case, the admin could set up K so that the sum of all groups is
     never greater than the total memory, and freely set U at the cost of his
