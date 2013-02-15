From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 0/4] devcg: introduce proper hierarchy support
Date: Fri, 15 Feb 2013 11:55:43 -0500
Message-ID: <20130215165543.131282532@napanee.usersys.redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

This patchset implements device cgroup hierarchy. Exceptions will be
propagated down in the tree and local preferences will be re-evaluated
everytime a change in its parent occours, reapplying them if it's still
possible.

git://github.com/aristeu/linux-2.6.git
branch: devcg_hierarchy_review

v5:
- reworked the patchset to not propagate behavior changes

v4:
- minor fixes pointed by Tejun

v3:
- update documentation
- move css_online/css_offline changes to a new patch
- use cgroup_for_each_descendant_pre() instead of own descendant walk
- move exception_copy rework to a separared patch
- move exception_clean rework to a separated patch
- new patch to just move dev_exception_rm() before dev_exception_add()
  as requested by Tejun.
- updated patch description for may_access() changes
- new patch to expand the may_access() logic before changing it
- fixed argument description order in may_access()

v2:
- rebase on top "device_cgroup: don't grab mutex in rcu callback"
- in case parent changes behavior or exceptions and the local exceptions won't
  apply anymore, remove them instead of keeping them around.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>                                                                                               
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>                                                                               
Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>                                                                           

-- 
Aristeu
