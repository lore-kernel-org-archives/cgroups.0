From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.16] cgroup: clean up MAINTAINERS entries
Date: Tue, 13 May 2014 15:49:58 -0400
Message-ID: <20140513194958.GD28815@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=gKqjGynF7ZqD2JtkZ142PWL8HmPZBvXA+7FGae3ku6g=;
        b=UCwxBM3iIQMZj4zI8LyDSoISMUtGJGy0rWuGULNjoaZ++P135vMHonr0snOQAuN1H6
         vQ9EG7jgJNdpTrt5crdoaD1iptU3am81ARq2+6Ja6BFUHzNMCR/5fCdOgoiMoGAn6neT
         5CSFQNkPBB8388Cen2og8w5ABWTRY/nfP7WodLt3QTRIneVfF6b93ljj9o0FZX8NXgX0
         e4Fs6YDxOzm2SbLVNWcgaCAJYUrY0/qdDBqUg12agVN8UH1/fctMBDhsGn06zVYDf4qp
         VimcNiQIz156bjO0HiOZaNUNfkJ9S7KVlL3uJMQW7gHaQtKLABOSJn8QZ+YZqKRF7Vvo
         06mQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

There are currently three cgroup related entries in MAINTAINERS.  Make
the following updates.

* Make the names - both cgroup and cpuset - singular.  We're mixing
  singular and plural all over the place for no good reason.

* Drop containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org from CGROUP.  That list
  doesn't have much to do with cgroup per-se.

* Add Documentation field to CGROUP.

* Drop mm/*cgroup* from CGROUP.  memcg has separate maintainers.

* Prefix the controller-specific ones with "CONTROL CGROUP -" and
  collect cgroup related entries under the core one.

* Add (MEMCG) abbreviation to MEMCG entry.

* Drop Balbir Singh and KAMEZAWA Hiroyuki from memcg maintainers.  It
  has been quite a while since both actually worked on memcg.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hello,

Summer house cleaning.  If there's any objection, please let me know.

Thanks.

 MAINTAINERS |   47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e67ea24..7202bec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2382,16 +2382,35 @@ L:	netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
 F:	drivers/connector/
 
-CONTROL GROUPS (CGROUPS)
+CONTROL GROUP (CGROUP)
 M:	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
-L:	containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
+F:	Documentation/cgroups/
 F:	include/linux/cgroup*
 F:	kernel/cgroup*
-F:	mm/*cgroup*
+
+CONTROL GROUP - CPUSET
+M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+W:	http://www.bullopensource.org/cpuset/
+W:	http://oss.sgi.com/projects/cpusets/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
+S:	Maintained
+F:	Documentation/cgroups/cpusets.txt
+F:	include/linux/cpuset.h
+F:	kernel/cpuset.c
+
+CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
+M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
+M:	Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
+L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
+S:	Maintained
+F:	mm/memcontrol.c
+F:	mm/page_cgroup.c
 
 CORETEMP HARDWARE MONITORING DRIVER
 M:	Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
@@ -2464,17 +2483,6 @@ M:	Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
 S:	Maintained
 F:	tools/power/cpupower/
 
-CPUSETS
-M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
-L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-W:	http://www.bullopensource.org/cpuset/
-W:	http://oss.sgi.com/projects/cpusets/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
-S:	Maintained
-F:	Documentation/cgroups/cpusets.txt
-F:	include/linux/cpuset.h
-F:	kernel/cpuset.c
-
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
 S:	Orphan / Obsolete
@@ -5731,17 +5739,6 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/vmalloc.h
 F:	mm/
 
-MEMORY RESOURCE CONTROLLER
-M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
-M:	Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
-M:	Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
-M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
-L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
-S:	Maintained
-F:	mm/memcontrol.c
-F:	mm/page_cgroup.c
-
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 M:	Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
