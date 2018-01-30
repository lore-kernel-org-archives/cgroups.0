From: Florian Schmidt <florian.schmidt-kcmmt4fgdiuHXe+LvDLADg@public.gmane.org>
Subject: [PATCH] Documentation: Fix 'file_mapped' -> 'mapped_file'
Date: Tue, 30 Jan 2018 17:42:13 +0100
Message-ID: <20180130164213.20387-1-florian.schmidt@neclab.eu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Florian Schmidt <florian.schmidt-kcmmt4fgdiuHXe+LvDLADg@public.gmane.org>

There is no entry file_mapped in the memory.stat file. This looks like a
simple word flip that's gone unnoticed since 2010 (dc10e281f5fc,
memcg: update documentation).

Signed-off-by: Florian Schmidt <florian.schmidt-kcmmt4fgdiuHXe+LvDLADg@public.gmane.org>
---
 Documentation/cgroup-v1/memory.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroup-v1/memory.txt b/Documentation/cgroup-v1/memory.txt
index cefb63639070..a4af2e124e24 100644
--- a/Documentation/cgroup-v1/memory.txt
+++ b/Documentation/cgroup-v1/memory.txt
@@ -524,9 +524,9 @@ Note:
 	Only anonymous and swap cache memory is listed as part of 'rss' stat.
 	This should not be confused with the true 'resident set size' or the
 	amount of physical memory used by the cgroup.
-	'rss + file_mapped" will give you resident set size of cgroup.
+	'rss + mapped_file" will give you resident set size of cgroup.
 	(Note: file and shmem may be shared among other cgroups. In that case,
-	 file_mapped is accounted only when the memory cgroup is owner of page
+	 mapped_file is accounted only when the memory cgroup is owner of page
 	 cache.)
 
 5.3 swappiness
-- 
2.16.1
