From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH V4 6/6] memcg: Document cgroup dirty/writeback memory statistics
Date: Sat,  6 Jul 2013 01:34:17 +0800
Message-ID: <1373045657-27750-1-git-send-email-handai.szj@taobao.com>
References: <1373044710-27371-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=b5AgGEaEvzTHKZhq4oYlntY32NNUOFGruRZ8smSq0zk=;
        b=LzpSTvZOGRxNUMa+f1aBF1bVyTknorxoIQ71+VEO+f0ui/+B3UM0gC00kKPA6BDqu+
         ok05YgSOuxv9AkHx29Jcg/VBA8T2s20xUEVnoun6znVOYP8+wDbFpW51dEI7N9+jhNEK
         6j6oa5ykR7Zj6HjP9wDpqU9yozZSUI/aGMOCm1mk89/Z1CzujtYAGWa+VuqxQAyOKLW2
         OITlkQF4/AvbJnE+QTEaZmBhBgaN/GlXASPlVxIbntSz5A7gBXoudM+OClW/XuTH7In2
         c5Slxsz7FSOpWm27H3djhY6TPmmAl3xQBsXxOSFQNqmTuWW4e0uaAfTNFtF45XwIYlux
         r3tg==
In-Reply-To: <1373044710-27371-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: mhocko@suse.cz, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, fengguang.wu@intel.com, mgorman@suse.de, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
cc: Greg Thelen <gthelen@google.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>
cc: Fengguang Wu <fengguang.wu@intel.com>
cc: Mel Gorman <mgorman@suse.de>
---
 Documentation/cgroups/memory.txt |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 327acec..7ed4fa9 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -490,6 +490,8 @@ pgpgin		- # of charging events to the memory cgroup. The charging
 pgpgout		- # of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
+dirty          - # of bytes of file cache that are not in sync with the disk copy.
+writeback      - # of bytes of file/anon cache that are queued for syncing to disk.
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
