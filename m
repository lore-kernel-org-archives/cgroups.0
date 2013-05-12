From: Glauber Costa <glommer@openvz.org>
Subject: [PATCH v6 17/31] i915: bail out earlier when shrinker cannot acquire mutex
Date: Sun, 12 May 2013 22:13:38 +0400
Message-ID: <1368382432-25462-18-git-send-email-glommer@openvz.org>
References: <1368382432-25462-1-git-send-email-glommer@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1368382432-25462-1-git-send-email-glommer@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>, Mel Gorman <mgorman@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>, Kent Overstreet <koverstreet@google.com>

The main shrinker driver will keep trying for a while to free objects if
the returned value from the shrink scan procedure is 0.  That means "no
objects now", but a retry could very well succeed.

A negative value has a different meaning. It means it is impossible to
shrink, and we would better bail out soon. We find this behavior more
appropriate for the case where the lock cannot be taken. Specially given
the hammer behavior of the i915: if another thread is already shrinking,
we are likely not to be able to shrink anything anyway when we finally
acquire the mutex.

Signed-off-by: Glauber Costa <glommer@openvz.org>
CC: Dave Chinner <dchinner@redhat.com>
CC: Mel Gorman <mgorman@suse.de>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Kent Overstreet <koverstreet@google.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 6b17122..52b3ac1 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4448,10 +4448,10 @@ i915_gem_inactive_count(struct shrinker *shrinker, struct shrink_control *sc)
 
 	if (!mutex_trylock(&dev->struct_mutex)) {
 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
-			return 0;
+			return -1;
 
 		if (dev_priv->mm.shrinker_no_lock_stealing)
-			return 0;
+			return -1;
 
 		unlock = false;
 	}
-- 
1.8.1.4

