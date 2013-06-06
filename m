From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v11 21/25] i915: bail out earlier when shrinker cannot acquire mutex
Date: Fri,  7 Jun 2013 00:34:54 +0400
Message-ID: <1370550898-26711-22-git-send-email-glommer@openvz.org>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370550898-26711-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mhocko-Y4LbUc7mvzI@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The main shrinker driver will keep trying for a while to free objects if
the returned value from the shrink scan procedure is 0.  That means "no
objects now", but a retry could very well succeed.

But what we should say here is a different thing: that it is impossible to
shrink, and we would better bail out soon. We find this behavior more
appropriate for the case where the lock cannot be taken. Specially given the
hammer behavior of the i915: if another thread is already shrinking, we are
likely not to be able to shrink anything anyway when we finally acquire the
mutex.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Acked-by: Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>
CC: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
CC: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/gpu/drm/i915/i915_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 22a0556..101504f 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4497,10 +4497,10 @@ i915_gem_inactive_count(struct shrinker *shrinker, struct shrink_control *sc)
 
 	if (!mutex_trylock(&dev->struct_mutex)) {
 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
-			return 0;
+			return SHRINK_STOP;
 
 		if (dev_priv->mm.shrinker_no_lock_stealing)
-			return 0;
+			return SHRINK_STOP;
 
 		unlock = false;
 	}
-- 
1.8.1.4
