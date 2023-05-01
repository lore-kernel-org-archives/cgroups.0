From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 28/40] timekeeping: Fix a circular include dependency
Date: Mon,  1 May 2023 09:54:38 -0700
Message-ID: <20230501165450.15352-29-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960172; x=1685552172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jz3+CZtZwJ9/tSYfHBM/2MHA9DEGGjB4zlxzO096/9Q=;
        b=Glr4JSHsTmaAPI0AWP0PWNaIttgzeyDzPQx4tjZhzhm0zZ4p+1GCcCC3c3r4aXKXSp
         WIW7l4ONjqrOBXvjUIVll03e3w9s+YRWlCSxmsKNK9xzzAcM54D0O3+CWQoKF/ytzIvC
         kOX+0OA2rpltLDjWT1I86SdUtJ7gM1/iT7nXNjbfE5eIm0GIboQlBljhXdjDloTQNmLw
         70IARjApWsmBCF7eSF3LKPA2bTZVurXLcycCJn2u8FXoQc4EQGTI1K+d32OJcow714/u
         3R8ajXD58HPiHypeEQaSKmOGWRsxZiDT+trPafMrQwqkk9Lr9LEGmo4kscoUpmICusqi
         Lbwg==
In-Reply-To: <20230501165450.15352-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

This avoids a circular header dependency in an upcoming patch by only
making hrtimer.h depend on percpu-defs.h

Signed-off-by: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 include/linux/hrtimer.h        | 2 +-
 include/linux/time_namespace.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 0ee140176f10..e67349e84364 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -16,7 +16,7 @@
 #include <linux/rbtree.h>
 #include <linux/init.h>
 #include <linux/list.h>
-#include <linux/percpu.h>
+#include <linux/percpu-defs.h>
 #include <linux/seqlock.h>
 #include <linux/timer.h>
 #include <linux/timerqueue.h>
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index bb9d3f5542f8..d8e0cacfcae5 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -11,6 +11,8 @@
 struct user_namespace;
 extern struct user_namespace init_user_ns;
 
+struct vm_area_struct;
+
 struct timens_offsets {
 	struct timespec64 monotonic;
 	struct timespec64 boottime;
-- 
2.40.1.495.gc816e09b53d-goog

