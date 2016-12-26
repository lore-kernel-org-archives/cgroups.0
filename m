From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: reorganize cgroup source files
Date: Mon, 26 Dec 2016 14:23:17 +0800
Message-ID: <5860B755.9000004@huawei.com>
References: <20161220210827.11176-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161220210827.11176-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On 2016/12/21 5:08, Tejun Heo wrote:
> cgroup source files are getting a bit too unwieldy.  Let's reorganize
> them.
> 
> * Move cgroup files in kernel to kernel/cgroup.
> 
> * Split cgroup.c into multiple files.
> 
> The only functional change this patchset causes is loss of a
> WARN_ON(); otherwise, everything remains identical.
> 
> This patchset contains the following eight patches.
> 
>  0001-cgroup-reorder-css_set-fields.patch
>  0002-cgroup-move-cgroup-files-under-kernel-cgroup.patch
>  0003-cgroup-move-cgroup-v1-specific-code-to-kernel-cgroup.patch
>  0004-cgroup-refactor-mount-path-and-clearly-distinguish-v.patch
>  0005-cgroup-separate-out-cgroup1_kf_syscall_ops.patch
>  0006-cgroup-move-v1-mount-functions-to-kernel-cgroup-cgro.patch
>  0007-cgroup-rename-functions-for-consistency.patch
>  0008-cgroup-move-namespace-code-to-kernel-cgroup-namespac.patch
> 
> The patchset is available in the following git branch
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-reorg
> 
> and on top of the following git branch
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-procs
> 
> diffstat follows.  Thanks.
> 
>  include/linux/cgroup-defs.h     |   54 -
>  kernel/Makefile                 |    5 
>  kernel/cgroup/Makefile          |    5 
>  kernel/cgroup/cgroup-internal.h |  155 +++
>  kernel/cgroup/cgroup-v1.c       | 1395 ++++++++++++++++++++++++++++
>  kernel/cgroup/cgroup.c          | 1940 +++-------------------------------------
>  kernel/cgroup/namespace.c       |  155 +++
>  7 files changed, 1907 insertions(+), 1802 deletions(-)
> 

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
