From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Show control files in cgroup2 root after mount
Date: Tue, 18 Jul 2017 15:51:48 -0400
Message-ID: <20170718195148.GC3365493@devbig577.frc2.facebook.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Oi6Lt84dX+4pkV4g1SXo4jVHX7wtRwDC/wuO4BZU198=;
        b=Lc084io9wrxRoWYNVFGEJZoIQPK6NknMql3xlPCeEe69R0Jvj1Uhjet9qaUbsfbQId
         kJlfWcQhK/lBoUJL/MsIlCrboVuydSngTOs/NHRqUkDx+KFiZ8o22tMRszDy/Fay+qD3
         hpJTmEHPt4HcB6pEz//wwvQCUqPKSg9XlAwbu6CHZycGzsoN5oA4xyAJscs5LfXVxOH5
         GnvZCMDlvfEpjAI/hp+ECfpD4+w7aOSHyiw2VWkn/BRzYm7McE5MIB+Mrg9gvAmYIYOG
         FGCHqOb1dsxlXzLXy7eUEfO5DYbiOag9SJt+k+QeFvNpnPtqXt/MHMiG++t2fbkmvDcc
         XR/g==
Content-Disposition: inline
In-Reply-To: <1500406336-29512-1-git-send-email-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Waiman.

On Tue, Jul 18, 2017 at 03:32:16PM -0400, Waiman Long wrote:
> It was found that when a cgroup2 filesystem was mounted, control
> files other than the base cgroup.* ones were not shown in the root
> directory.  They were shown only after some controllers were activated
> in the root's cgroup.subtree_control file.
> 
> This was caused by a lack of the kernfs_activate() call which was fixed
> by this patch.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 89a23c6..fb1893b 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2024,8 +2024,10 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  
>  		dentry = cgroup_do_mount(&cgroup2_fs_type, flags, &cgrp_dfl_root,
>  					 CGROUP2_SUPER_MAGIC, ns);
> -		if (!IS_ERR(dentry))
> +		if (!IS_ERR(dentry)) {
>  			apply_cgroup_root_flags(root_flags);
> +			kernfs_activate(cgrp_dfl_root.cgrp.kn);
> +		}

Heh, that's tricky.  I'm not quite sure where the unactivated files
are being added tho because that'd be where we should be activating.
I *think* that they are already activated as part of
cgroup_add_cftypes() but I am obviously qmissing something.  I'll try
to repro the issue and find where we're skipping the activation call.

Thanks!

-- 
tejun
