From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 3/3] docs/admin-guide/cgroup-v2: add cpuset.mems.migration
Date: Thu, 22 Apr 2021 17:06:08 +0800
Message-ID: <20210422090608.7160-4-wuyun.abel@bytedance.com>
References: <20210422090608.7160-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SfF/Z0ScslK5LaLkBhpaNHR++tEupceqm51lspaZqiM=;
        b=DDJ1gaaHVhTnJEYif/PYB82fh8uyWeB0mKRq575+v9VXDwnUsvR0QZrLWnxhvjzeKP
         GBvaClcBVchRRh34BoRsfFf/JWIhLmVsBHRGBlfCpxnj3LFsc9mZ9E16wl3fhjnx0PwI
         YML3XbmzkG6cmYHj4FydNXJewHjMOjfmq9jPXRqt05Ktm5GVHcWQQJxN7gRVaN01chh7
         VlB5G0U1VIGpRexa5T40CJpjITNHl/c/2zMpH5u3Smlih3z8dkCcp0EnuCh3ymT06htv
         dsBv1yoDXNEaPYqKFMIKnRDUmHgudqSxqy8zkT1AR5nLtXTOW/0Gf+G6hEN5rC3/u7t7
         Kb5A==
In-Reply-To: <20210422090608.7160-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Add docs for new interface cpuset.mems.migration, most of which
are stolen from cpuset(7) manpages.

Signed-off-by: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 36 +++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b1e81aa8598a..abf6589a390d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2079,6 +2079,42 @@ Cpuset Interface Files
 	Changing the partition state of an invalid partition root to
 	"member" is always allowed even if child cpusets are present.
 
+  cpuset.mems.migration
+	A read-write single value file which exists on non-root
+	cpuset-enabled cgroups.
+
+	Only the following migration modes are defined.
+
+	  ========	==========================================
+	  "none"	migration disabled [default]
+	  "sync"	move pages to cpuset nodes synchronously
+	  "lazy"	move pages to cpuset nodes on second touch
+	  ========	==========================================
+
+	By default, "none" mode is enabled. In this mode, once a page
+	is allocated (given a physical page of main memory) then that
+	page stays on whatever node it was allocated, so long as it
+	remains allocated, even if the cpusets memory placement policy
+	'cpuset.mems' subsequently changes.
+
+	If "sync" mode is enabled in a cpuset, when the 'cpuset.mems'
+	setting is changed, any memory page in use by any process in
+	the cpuset that is on a memory node that is no longer allowed
+	will be migrated to a memory node that is allowed synchronously.
+	The relative placement of a migrated page within the cpuset is
+	preserved during these migration operations if possible.
+
+	The "lazy" mode is almost the same as "sync" mode, except that
+	it doesn't move the pages right away. Instead it sets these
+	pages to protnone, and numa faults triggered by second touching
+	these pages will handle the movement.
+
+	Furthermore, if a process is moved into a cpuset with migration
+	enabled ("sync" or "lazy" enabled), any memory pages it uses
+	that on memory nodes allowed in its previous cpuset, but which
+	are not allowed in its new cpuset, will be migrated to a memory
+	node allowed in the new cpuset.
+
 
 Device controller
 -----------------
-- 
2.31.1

