From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCHSET] cgroup: misc fixes and cleanups
Date: Tue, 23 Feb 2016 11:55:46 +0800
Message-ID: <56CBD842.9020802@huawei.com>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456182349-18156-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On 2016/2/23 7:05, Tejun Heo wrote:
> Hello,
> 
> This patchset contains the following six patches.  The first one is a
> fix but should be safe to route through for-4.6.  The rest are misc
> cleanups and improvements which don't cause notable behavior changes.
> 
>  0001-cgroup-fix-error-return-value-of-cgroup_addrm_files.patch
>  0002-Revert-cgroup-add-cgroup_subsys-css_e_css_changed.patch
>  0003-cgroup-s-child_subsys_mask-subtree_ss_mask.patch
>  0004-cgroup-convert-for_each_subsys_which-to-do-while-sty.patch
>  0005-cgroup-use-do_each_subsys_mask-where-applicable.patch
>  0006-cgroup-make-cgroup-subsystem-masks-u16.patch
> 
> The patchset based on top of cgroup/for-4.6 223ffb29f972 ("cgroup:
> provide cgroup_nov1= to disable controllers in v1 mounts") and is
> available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-misc
> 
> diffstat follows.  I'll pull in the branch into cgroup/for-4.6
> soonish.
> 
>  include/linux/cgroup-defs.h |   12 +-
>  kernel/cgroup.c             |  217 +++++++++++++++++++-------------------------
>  2 files changed, 102 insertions(+), 127 deletions(-)
> 

Acked-by: Zefan Li <lizefan@huawei.com>

