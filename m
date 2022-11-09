From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC 06/13] drm/cgroup: Allow safe external access to file_priv
Date: Wed,  9 Nov 2022 16:11:34 +0000
Message-ID: <20221109161141.2987173-7-tvrtko.ursulin@linux.intel.com>
References: <20221109161141.2987173-1-tvrtko.ursulin@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668010340; x=1699546340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KIk/9mO9BwW8K7kgNQr0OR9vwi+NAqyFfuSgODl/DSc=;
  b=EoAH1m8RfJaGmA0O8K/mo7xEbTHN0CSGPlcq1hfrg7+Obmkfd9J5/nrZ
   Tt0DVZ+GY0jSF8Jqqoz7I/9tmWAJKEPhg6/6xJDdS/MMd5wCuuUijsGtd
   NvMi7vtz8rj/Dcdbvm2I1vJqoynp4CGI7YlkhG54MAu2b5xlr+uhwHk+I
   bPAgC9b00k8RI7x9iwJbLaAMvYqyaoYs8Gej/k9KSNPPuU+9qYzyx/vgd
   RdV5bB1yascVM+G8hrsy9cAi9eFSTAhcLQkVLsMmF4F19RT6SlIZkJqq2
   qCv4ECvS00e2mM9wq0wYg0BqueM7K5iAgo036E02m6ntYGEw1ciOLZAcp
   A==;
In-Reply-To: <20221109161141.2987173-1-tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

From: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Entry points from the cgroup subsystem into the drm cgroup controller will
need to walk the file_priv structures associated with registered clients
and since those are not RCU protected lets add a hack for now to make this
safe.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/gpu/drm/drm_cgroup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/drm_cgroup.c b/drivers/gpu/drm/drm_cgroup.c
index 56aa8303974a..94e6f39b90c7 100644
--- a/drivers/gpu/drm/drm_cgroup.c
+++ b/drivers/gpu/drm/drm_cgroup.c
@@ -17,6 +17,13 @@ __del_clients(struct drm_pid_clients *clients,
 	if (atomic_dec_and_test(&clients->num)) {
 		xa_erase(&drm_pid_clients, pid);
 		kfree_rcu(clients, rcu);
+
+		/*
+		 * FIXME: file_priv is not RCU protected so we add this hack
+		 * to avoid any races with code which walks clients->file_list
+		 * and accesses file_priv.
+		 */
+		synchronize_rcu();
 	}
 }
 
-- 
2.34.1

