From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-4.6] cgroup: make control mask updates
 modular and recursive
Date: Thu, 3 Mar 2016 11:02:30 +0800
Message-ID: <56D7A946.1090403@huawei.com>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 2016/2/25 6:02, Tejun Heo wrote:
> Hello,
> 
> Changes from v1[1] are
> 
> * Patches 0012-0014 and 0016 added.  They further refactor the
>   operations and convert existing css management paths to use the new
>   modular operations.
> 
> * 0005 updated to yield the correct result on v1 hierarchies too.
> 
> * 0015 updated to reflect earlier changes.
> 
> Currently, subsystem enabling and disabling in the default hierarchy
> are implemented as a long chain of interdependent operations in
> cgroup_subtree_control_write().  The function calculates what need to
> be done to its children and excute the necessary operations.  The
> function unfortunately ends up being a rather opaque blob of
> operations which is difficult to wrap one's head around or reuse.
> 
> This patchset restructures control mask update so that it's composed
> of discrete idempotent and recursive operations and convert existing
> css managment paths to use them which makes them simpler, more robust
> and capable of recursive operations.
> 
> This patchset includes the following 12 patches.
> 
>  0001-cgroup-separate-out-interface-file-creation-from-css.patch
>  0002-cgroup-explicitly-track-whether-a-cgroup_subsys_stat.patch
>  0003-cgroup-reorder-operations-in-cgroup_mkdir.patch
>  0004-cgroup-factor-out-cgroup_create-out-of-cgroup_mkdir.patch
>  0005-cgroup-introduce-cgroup_control-and-cgroup_ss_mask.patch
>  0006-cgroup-factor-out-cgroup_drain_offline-from-cgroup_s.patch
>  0007-cgroup-factor-out-cgroup_apply_control_disable-from-.patch
>  0008-cgroup-factor-out-cgroup_apply_control_enable-from-c.patch
>  0009-cgroup-make-cgroup_drain_offline-and-cgroup_apply_co.patch
>  0010-cgroup-introduce-cgroup_-save-propagate-restore-_con.patch
>  0011-cgroup-factor-out-cgroup_-apply-finalize-_control-fr.patch
>  0012-cgroup-combine-cgroup_mutex-locking-and-offline-css-.patch
>  0013-cgroup-use-cgroup_apply_enable_control-in-cgroup-cre.patch
>  0014-cgroup-reimplement-rebind_subsystems-using-cgroup_ap.patch
>  0015-cgroup-make-cgroup_calc_subtree_ss_mask-take-this_ss.patch
>  0016-cgroup-allocate-2x-cgrp_cset_links-when-setting-up-a.patch
> 
> The patchset is available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-recursive-control
> 
> diffstat follows.  Thanks.
> 
>  include/linux/cgroup-defs.h |    3 
>  kernel/cgroup.c             |  760 +++++++++++++++++++++++++-------------------
>  2 files changed, 446 insertions(+), 317 deletions(-)
> 

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
