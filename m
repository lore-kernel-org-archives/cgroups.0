From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] memcg: fix the document of pgpgin/pgpgout
Date: Mon, 21 Nov 2011 16:48:45 -0800
Message-ID: <1321922925-14930-1-git-send-email-yinghan@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
        bh=0cqx1xTPWBdvgWxBpEBilOZVswzbyF/i+x8VnJescYk=;
        b=e51vzk99Jy6bj2QAc2euzOcrcUGfJ+S+KWz64MyqSltCzjUP72/EGi5qOsdGhhcrvp
         R5/k2cIBT//HBOsy/QXQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Wanlong Gao <gaowanlong-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

The two memcg stats pgpgin/pgpgout have different meaning than the ones in
vmstat, which indicates that we picked a bad naming for them. It might be late
to change the stat name, but better documentation is always helpful.

Signed-off-by: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/memory.txt |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index cc0ebc5..eb6a911 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -386,8 +386,11 @@ memory.stat file includes following statistics
 cache		- # of bytes of page cache memory.
 rss		- # of bytes of anonymous and swap cache memory.
 mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
-pgpgin		- # of pages paged in (equivalent to # of charging events).
-pgpgout		- # of pages paged out (equivalent to # of uncharging events).
+pgpgin		- # of charging events to the memory cgroup. The charging
+		event happens each time a page is accounted as either mapped
+		anon page(RSS) or cache page(Page Cache) to the cgroup.
+pgpgout		- # of uncharging events to the memory cgroup. The uncharging
+		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
-- 
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
