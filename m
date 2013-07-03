From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cpuset changes for v3.11-rc1
Date: Tue, 2 Jul 2013 19:47:09 -0700
Message-ID: <20130703024709.GB17986@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=UIivX/ChvLKFvKnHa2iF0ciza0XS2vnok18FBuxtZaE=;
        b=mTsx9ntD0SNDhkDDaYZWYcgCUb8AjMHWgiBc6v1BlNVoF/Y+H574Zi5xVqTpdarVfQ
         hpPr8TqV71kB+mv90Zyc9j3Yt/vvSfKeW3XGPtonv6NgeC+/2DeGM7eUbz9Ako2GMTzY
         jWzqOJlGsYGGpAHn53NmtQm5B2Nx4aTL6yS1QTnS4BNK3r8Loh8oUI+IA+3JwjSbG4U9
         LUhD7dILoKEbmZSRgMJaZ5laiPbKDHuwECr8Pl8lOiSwMI1jr4g6y+01Y53OEl32DVj2
         FnM80yeToBpa5pGZfdtZTKJmGD+wghRMna0yGbyvhAC2bDDHc4KYhSmZVgEroN/rge2Z
         0HSA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Please note that this cgroup/for-3.11-cpuset pull request assumes that
cgroup/for-3.11 branch is pulled in first.

cpuset has always been rather odd about its configurations - a cgroup
right after creation didn't allow any task executions before
configuration, changing configuration in the parent modifies the
descendants irreversibly and so on.  These behaviors are inherently
nasty and almost hostile against sharing the hierarchy with other
controllers making it very difficult to use in unified hierarchy.

Li is currently in the process of updating the behaviors for
__DEVEL__sane_behavior which is the bulk of changes in this pull
request.  It isn't complete yet and the behaviors will change further
but all changes are gated behind sane_behavior.  In the process, the
rather hairy work-item punting which was used to work around the
limitations of cgroup descendant iterator was simplified.

Pulling this branch creates a conflict in include/linux/cgroup.h in
the comment area which catalogues the behavior changes gated by
__DEVEL__sane_behavior.  The cgroup main branch reorganized and added
some entries and this branch adds to it too.  The conflict and
resolution is trivial.

The conflict:

<<<<<<< HEAD
	 * - "tasks" is removed.  Everything should be at process
	 *   granularity.  Use "cgroup.procs" instead.
=======
	 * - cpuset: tasks will be kept in empty cpusets when hotplug happens
	 *   and take masks of ancestors with non-empty cpus/mems, instead of
	 *   being moved to an ancestor.
	 *
	 * - cpuset: a task can be moved into an empty cpuset, and again it
	 *   takes masks of ancestors.
	 *
	 * - memcg: use_hierarchy is on by default and the cgroup file for
	 *   the flag is not created.
>>>>>>> c9e5fe66f5947c9e56dfc7655e5b4b127ca2120f
	 *
	 * - "release_agent" and "notify_on_release" are removed.
	 *   Replacement notification mechanism will be implemented.
	 *
	 * - rename(2) is disallowed.
	 *
	 * - memcg: use_hierarchy is on by default and the cgroup file for
	 *   the flag is not created.
	 */

The resolution:

 	 * - "tasks" is removed.  Everything should be at process
	 *   granularity.  Use "cgroup.procs" instead.
	 *
	 * - "release_agent" and "notify_on_release" are removed.
	 *   Replacement notification mechanism will be implemented.
	 *
	 * - rename(2) is disallowed.
	 *
	 * - cpuset: tasks will be kept in empty cpusets when hotplug happens
	 *   and take masks of ancestors with non-empty cpus/mems, instead of
	 *   being moved to an ancestor.
	 *
	 * - cpuset: a task can be moved into an empty cpuset, and again it
	 *   takes masks of ancestors.
	 *
	 * - memcg: use_hierarchy is on by default and the cgroup file for
	 *   the flag is not created.
	 */

The described changes are available in the following branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11-cpuset

for you to fetch changes up to c9e5fe66f5947c9e56dfc7655e5b4b127ca2120f:

  cpuset: rename @cont to @cgrp (2013-06-13 20:48:19 -0700)

Just in case, an example merge is available.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git test-merge-3.11

----------------------------------------------------------------
Li Zefan (13):
      cpuset: remove redundant check in cpuset_cpus_allowed_fallback()
      cpuset: cleanup guarantee_online_{cpus|mems}()
      cpuset: remove unnecessary variable in cpuset_attach()
      cpuset: remove cpuset_test_cpumask()
      cpuset: re-structure update_cpumask() a bit
      cpuset: let hotplug propagation work wait for task attaching
      cpuset: remove async hotplug propagation work
      cpuset: record old_mems_allowed in struct cpuset
      cpuset: introduce effective_{cpumask|nodemask}_cpuset()
      cpuset: allow to keep tasks in empty cpusets
      cpuset: allow to move tasks to empty cpusets
      cpuset: fix to migrate mm correctly in a corner case
      cpuset: rename @cont to @cgrp

 include/linux/cgroup.h |   7 +
 kernel/cpuset.c        | 478 +++++++++++++++++++++++++++++--------------------
 2 files changed, 294 insertions(+), 191 deletions(-)

Thanks.

-- 
tejun
