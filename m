From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.16-fixes] cpuset: break kernfs active protection
 in cpuset_write_resmask()
Date: Mon, 30 Jun 2014 15:47:32 -0400
Message-ID: <20140630194732.GF14807@htj.dyndns.org>
References: <53B0DD8D.5060805@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9zk4F3UtTAI/nWXs0fRp02jJ0Lxhfrs14odEFiXaix0=;
        b=uIIvXYuLaNeguwxDtCdyhM11nYC8mV3LXxaK2SaXN3i1m506dta43zMSrzhXx9huTl
         Buxz3Pl3gpdSEGk8PDxNZi9Zu0Vth5yCFykLwEiA6Dndp8l4kEmK4l3jO0GQk9gQos/r
         NFI7YBfDlvrkSGAxZBlQ3mxG3UvzYSsKjhFEIKjwAcTsjxlgt3PVV1+qNy1nTOCfOiPt
         MmSzCmje8uHeohwqGqibpA2WyeTMXuFZyXF2pRJ0SaATbeqm2OA8QyES+AsnwLnOiT9W
         3xfa+QzQlqECBx0mwABP6LIe1y8vMHrWvd13LEEKuMlQMclU7YfphdH9/aoQLtTAbyJy
         X7FA==
Content-Disposition: inline
In-Reply-To: <53B0DD8D.5060805-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hey, Li.

Can you please test this patch and ack it?

Thanks.
------ 8< ------
Writing to either "cpuset.cpus" or "cpuset.mems" file flushes
cpuset_hotplug_work so that cpu or memory hotunplug doesn't end up
migrating tasks off a cpuset after new resources are added to it.

As cpuset_hotplug_work calls into cgroup core via
cgroup_transfer_tasks(), this flushing adds the dependency to cgroup
core locking from cpuset_write_resmak().  This used to be okay because
cgroup interface files were protected by a different mutex; however,
8353da1f91f1 ("cgroup: remove cgroup_tree_mutex") simplified the
cgroup core locking and this dependency became a deadlock hazard -
cgroup file removal performed under cgroup core lock tries to drain
on-going file operation which is trying to flush cpuset_hotplug_work
blocked on the same cgroup core lock.

The locking simplification was done because kernfs added an a lot
easier way to deal with circular dependencies involving kernfs active
protection.  Let's use the same strategy in cpuset and break active
protection in cpuset_write_resmask().  While it isn't the prettiest,
this is a very rare, likely unique, situation which also goes away on
the unified hierarchy.

The commands to trigger the deadlock warning without the patch and the
lockdep output follow.

 localhost:/ # mount -t cgroup -o cpuset xxx /cpuset
 localhost:/ # mkdir /cpuset/tmp
 localhost:/ # echo 1 > /cpuset/tmp/cpuset.cpus
 localhost:/ # echo 0 > cpuset/tmp/cpuset.mems
 localhost:/ # echo $$ > /cpuset/tmp/tasks
 localhost:/ # echo 0 > /sys/devices/system/cpu/cpu1/online

  ======================================================
  [ INFO: possible circular locking dependency detected ]
  3.16.0-rc1-0.1-default+ #7 Not tainted
  -------------------------------------------------------
  kworker/1:0/32649 is trying to acquire lock:
   (cgroup_mutex){+.+.+.}, at: [<ffffffff8110e3d7>] cgroup_transfer_tasks+0x37/0x150

  but task is already holding lock:
   (cpuset_hotplug_work){+.+...}, at: [<ffffffff81085412>] process_one_work+0x192/0x520

  which lock already depends on the new lock.


  the existing dependency chain (in reverse order) is:

  -> #2 (cpuset_hotplug_work){+.+...}:
  ...
  -> #1 (s_active#175){++++.+}:
  ...
  -> #0 (cgroup_mutex){+.+.+.}:
  ...

  other info that might help us debug this:

  Chain exists of:
    cgroup_mutex --> s_active#175 --> cpuset_hotplug_work

   Possible unsafe locking scenario:

	 CPU0                    CPU1
	 ----                    ----
    lock(cpuset_hotplug_work);
				 lock(s_active#175);
				 lock(cpuset_hotplug_work);
    lock(cgroup_mutex);

   *** DEADLOCK ***

  2 locks held by kworker/1:0/32649:
   #0:  ("events"){.+.+.+}, at: [<ffffffff81085412>] process_one_work+0x192/0x520
   #1:  (cpuset_hotplug_work){+.+...}, at: [<ffffffff81085412>] process_one_work+0x192/0x520

  stack backtrace:
  CPU: 1 PID: 32649 Comm: kworker/1:0 Not tainted 3.16.0-rc1-0.1-default+ #7
 ...
  Call Trace:
   [<ffffffff815a5f78>] dump_stack+0x72/0x8a
   [<ffffffff810c263f>] print_circular_bug+0x10f/0x120
   [<ffffffff810c481e>] check_prev_add+0x43e/0x4b0
   [<ffffffff810c4ee6>] validate_chain+0x656/0x7c0
   [<ffffffff810c53d2>] __lock_acquire+0x382/0x660
   [<ffffffff810c57a9>] lock_acquire+0xf9/0x170
   [<ffffffff815aa13f>] mutex_lock_nested+0x6f/0x380
   [<ffffffff8110e3d7>] cgroup_transfer_tasks+0x37/0x150
   [<ffffffff811129c0>] hotplug_update_tasks_insane+0x110/0x1d0
   [<ffffffff81112bbd>] cpuset_hotplug_update_tasks+0x13d/0x180
   [<ffffffff811148ec>] cpuset_hotplug_workfn+0x18c/0x630
   [<ffffffff810854d4>] process_one_work+0x254/0x520
   [<ffffffff810875dd>] worker_thread+0x13d/0x3d0
   [<ffffffff8108e0c8>] kthread+0xf8/0x100
   [<ffffffff815acaec>] ret_from_fork+0x7c/0xb0

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1617,7 +1617,17 @@ static ssize_t cpuset_write_resmask(stru
 	 * resources, wait for the previously scheduled operations before
 	 * proceeding, so that we don't end up keep removing tasks added
 	 * after execution capability is restored.
+	 *
+	 * cpuset_hotplug_work calls back into cgroup core via
+	 * cgroup_transfer_tasks() and waiting for it from a cgroupfs
+	 * operation like this one can lead to a deadlock through kernfs
+	 * active_ref protection.  Let's break the protection.  Losing the
+	 * protection is okay as we check whether @cs is online after
+	 * grabbing cpuset_mutex anyway.  This only happens on the legacy
+	 * hierarchies.
 	 */
+	css_get(&cs->css);
+	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
 	mutex_lock(&cpuset_mutex);
@@ -1645,6 +1655,8 @@ static ssize_t cpuset_write_resmask(stru
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	kernfs_unbreak_active_protection(of->kn);
+	css_put(&cs->css);
 	return retval ?: nbytes;
 }
 
