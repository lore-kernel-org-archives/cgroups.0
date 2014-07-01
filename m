From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-3.16-fixes] cpuset: break kernfs active
 protection in cpuset_write_resmask()
Date: Tue, 1 Jul 2014 16:43:26 -0400
Message-ID: <20140701204326.GB12459@htj.dyndns.org>
References: <53B0DD8D.5060805@huawei.com>
 <20140630194732.GF14807@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GMjD+Mzr55pXgGgyzsSKxquLLFrnai9tpVk87vZY0DM=;
        b=WOA7v5SGUu4WN9PvsCVZp1UYOPvNe7kcvLQy4Ns5UJFQNHmtePbcuRsmiwI6CfEoi3
         Eqe5owCfmNJC35M6jwzh2cRSEj+MAVm5SuwmARuWYZ8j0OQyHNFz7K1F5TAaDl/ZFdx3
         EerEq07C+w5WnBeaf+Bx9zfoFQXNyly1p9DS53FS0kEaO0Ihh7YO/D64Y/9g83VTZfRj
         Ck69j5ddu9VuASwjpNfltxFfWiZfQ7pmQn0DFoB+CFGFJDoZ6sLACpNkCuUpFTgcFhWS
         aAOBuXOAVA8J0mIVpk38MfgJnNbsLFkipIKEfc0pd7TngdgRSKGeapQEfgmSE+QziYgC
         TUPA==
Content-Disposition: inline
In-Reply-To: <20140630194732.GF14807@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Mon, Jun 30, 2014 at 03:47:32PM -0400, Tejun Heo wrote:
> Hey, Li.
> 
> Can you please test this patch and ack it?
> 
> Thanks.
> ------ 8< ------
> Writing to either "cpuset.cpus" or "cpuset.mems" file flushes
> cpuset_hotplug_work so that cpu or memory hotunplug doesn't end up
> migrating tasks off a cpuset after new resources are added to it.
> 
> As cpuset_hotplug_work calls into cgroup core via
> cgroup_transfer_tasks(), this flushing adds the dependency to cgroup
> core locking from cpuset_write_resmak().  This used to be okay because
> cgroup interface files were protected by a different mutex; however,
> 8353da1f91f1 ("cgroup: remove cgroup_tree_mutex") simplified the
> cgroup core locking and this dependency became a deadlock hazard -
> cgroup file removal performed under cgroup core lock tries to drain
> on-going file operation which is trying to flush cpuset_hotplug_work
> blocked on the same cgroup core lock.
> 
> The locking simplification was done because kernfs added an a lot
> easier way to deal with circular dependencies involving kernfs active
> protection.  Let's use the same strategy in cpuset and break active
> protection in cpuset_write_resmask().  While it isn't the prettiest,
> this is a very rare, likely unique, situation which also goes away on
> the unified hierarchy.
> 
> The commands to trigger the deadlock warning without the patch and the
> lockdep output follow.
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.16-fixes.

Thanks.

-- 
tejun
