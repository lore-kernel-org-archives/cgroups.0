From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] docs: cgroup: mm: Document why inactive_X + active_X may not
 equal X
Date: Mon, 11 Nov 2019 14:49:58 +0000
Message-ID: <20191111144958.GA11914@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=OPnJSf+FsDJ4AK8qgreISZQp/qVRV4crg89KAbDdM7k=;
        b=C7l91imCRxRt/iXdRWLRpgFZp+d1cU9X9RIrPYVByasB726nYNdqnnPU+D6mL5YSmC
         ihwV7cizd9tDvrMcKaNzoVQxPLyM5LDI4eAZPTQ7r8KNQ960vI4xRHHlXIeCnT9flJgn
         DPgoxIo/FKx56KEMNcFDpRr7eoWz9x+qywUn8=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

This has confused a significant number of people using cgroups inside
Facebook, and some of those outside as well judging by posts like
this[0] (although it's not a problem unique to cgroup v2). If shmem
handling in particular becomes more coherent at some point in the future
-- although that seems unlikely now -- we can change the wording here.

[0]: https://unix.stackexchange.com/q/525092/10762

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 Documentation/admin-guide/cgroup-v2.rst | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0704552ed94f..0636bcb60b5a 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1289,7 +1289,12 @@ PAGE_SIZE multiple when read back.
 	  inactive_anon, active_anon, inactive_file, active_file, unevictable
 		Amount of memory, swap-backed and filesystem-backed,
 		on the internal memory management lists used by the
-		page reclaim algorithm
+		page reclaim algorithm.
+
+		As these represent internal list state (eg. shmem pages are on anon
+		memory management lists), inactive_foo + active_foo may not be equal to
+		the value for the foo counter, since the foo counter is type-based, not
+		list-based.
 
 	  slab_reclaimable
 		Part of "slab" that might be reclaimed, such as
-- 
2.24.0

