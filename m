From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 9/9 v3] cgroup_freezer: implement proper hierarchy support
Date: Thu, 8 Nov 2012 19:02:46 +0100
Message-ID: <20121108180246.GA17415@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121108175750.GK12973@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wTYyvc4fycLyCpapQruKmwjbJXW4ybtnp7tYXaXeSMM=;
        b=uXQiyOODNnCbcYq1zhCUyIcA5l1xYP5GFGMVsNXy+KSH5nGw6Hln80KomZFr1ztQHk
         Vk1l2MOyw8JZ29Jlt59zFr2ymF6ZwjgOaqskMILg89XWski9+nPbs0guQ9gegDjWKTX+
         HCf7KZccJI6QbHMH3wdN9cl9YufalzOdp6KE0F+l18i3dFBvED/nRHG80eNL724WRiZX
         AlBb6DvuuPpcJiM+SNZqzAsFxvkwdg1192awo5mkpt3EBBLdXtVXyrJwPYhUs6PNbnLX
         Yi6tYNalC4QxfsQJO/022AOFZ8NORDlvGrOo6OsOpGyWm2I9S/MJbeiAZTlTQtyypEFA
         524A==
Content-Disposition: inline
In-Reply-To: <20121108175750.GK12973-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu 08-11-12 09:57:50, Tejun Heo wrote:
> Up until now, cgroup_freezer didn't implement hierarchy properly.
> cgroups could be arranged in hierarchy but it didn't make any
> difference in how each cgroup_freezer behaved.  They all operated
> separately.
> 
> This patch implements proper hierarchy support.  If a cgroup is
> frozen, all its descendants are frozen.  A cgroup is thawed iff it and
> all its ancestors are THAWED.  freezer.self_freezing shows the current
> freezing state for the cgroup itself.  freezer.parent_freezing shows
> whether the cgroup is freezing because any of its ancestors is
> freezing.
> 
> freezer_post_create() locks the parent and new cgroup and inherits the
> parent's state and freezer_change_state() applies new state top-down
> using cgroup_for_each_descendant_pre() which guarantees that no child
> can escape its parent's state.  update_if_frozen() uses
> cgroup_for_each_descendant_post() to propagate frozen states
> bottom-up.
> 
> Synchronization could be coarser and easier by using a single mutex to
> protect all hierarchy operations.  Finer grained approach was used
> because it wasn't too difficult for cgroup_freezer and I think it's
> beneficial to have an example implementation and cgroup_freezer is
> rather simple and can serve a good one.
> 
> As this makes cgroup_freezer properly hierarchical,
> freezer_subsys.broken_hierarchy marking is removed.
> 
> Note that this patch changes userland visible behavior - freezing a
> cgroup now freezes all its descendants too.  This behavior change is
> intended and has been warned via .broken_hierarchy.
> 
> v2: Michal spotted a bug in freezer_change_state() - descendants were
>     inheriting from the wrong ancestor.  Fixed.
> 
> v3: Documentation/cgroups/freezer-subsystem.txt updated.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

You probably meant Reviewed-by: Michal Hocko .... ;)
-- 
Michal Hocko
SUSE Labs
