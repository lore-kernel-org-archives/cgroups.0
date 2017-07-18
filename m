From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Show control files in cgroup2 root after mount
Date: Tue, 18 Jul 2017 16:50:10 -0400
Message-ID: <20170718205009.GE3365493@devbig577.frc2.facebook.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
 <20170718195148.GC3365493@devbig577.frc2.facebook.com>
 <539870d2-8b85-2f54-61bd-4ba068e75ce0@redhat.com>
 <20170718201229.GD3365493@devbig577.frc2.facebook.com>
 <255cc198-2c10-af76-98ca-086807d11540@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oO76b5z8eGER/X25TnNn5UB5UGb2vFPfncB99bMlo04=;
        b=uX8/SPhdzeHLyZ1fVVyRINW4UqpxKDTQsFngr+GsoOH/mI+gsZQQoiAz4B+AElotus
         ogMxA7QH2vdlni/T58V/C7bjVzUM8jH0zafe1ciBv1KlNPNKA4JQsgYEfxWybSg6M86U
         Lfh1GEj9z09pxQcz925v6/2igg1gfGqQHE5J2bqG5NEkFkORNf5Ld2PO2BbFhqPdt2Ak
         YhGBvslNcvuA7bkEXvIafN5gGyu+dwdQkEMe5PLz9kqpBS0Pe2MG6Oc6knMnS0bmh1jP
         fQN8M/+qFFpoKVss7bcl/97bSBp6VkTTctpihvBuNqxgBy6hZ9UNT06nO4irXWZlXSYI
         Oe4w==
Content-Disposition: inline
In-Reply-To: <255cc198-2c10-af76-98ca-086807d11540-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jul 18, 2017 at 04:29:40PM -0400, Waiman Long wrote:
> I think the kernfs_activate() call is for the cgroup1 mount of debug

kernfs_activate() there is for any files which are created while a
controller moves between hierarchies, so, yeah, during boot, this is
where the root files for cgroup1 hierarchies would be activated.

> cgroup which probably failed as I put debug in the cgroup_no_v1= option.

Yeah, they just get skipped over.

> The RHEL7 system that I ran the test on tried to do v1-mount of all the
> cgroup controllers available. I am also wondering how a v1-mount of
> debug controller will make the controller files appear on cgroup2 root.
> Maybe I miss something in the code.

When a controller gets mounted on v1, the controller is detached from
cgroup2 hierarchy, so the corresponding files are removed from v2 root
and then created on v1, which are activated by the kernfs_activate()
call at the end of rebind.

> My test kernel was built out of your latest cgroup git tree with the
> thread mode patches on (review-cgroup2-threads-v3 branch).

I see.  I'm testing with the same kernel.

> As I said above, I put in the kernel command line option
> "cgroup_no_v1=pids,debug,memory". Then I mounted the cgroup2 filesystem
> after boot.
> 
> # mount -t cgroup2 cgroup2 /cgroup2
> # ls /cgroup2/
> cgroup.controllers  cgroup.procs  cgroup.subtree_control  cgroup.threads
> # echo +memory > /cgroup2/cgroup.subtree_control
> # ls /cgroup2/
> cgroup.controllers    debug.current_css_set
> cgroup.procs        debug.current_css_set_cg_links
> cgroup.subtree_control    debug.current_css_set_refcount
> cgroup.threads        debug.masks
> debug.csses        debug.taskcount
> debug.css_links

Heh, I'm really confused.  If I do the same thing, I get the following
result which makes sense as the files would be activated in
cgroup_apply_cftypes() when the debug controller is registered during
boot.

 # mkdir /cgroup2
 # mount -t cgroup2 cgroup2 /cgroup2
 # ls /cgroup2/
 cgroup.controllers      debug.current_css_set
 cgroup.procs            debug.current_css_set_cg_links
 cgroup.subtree_control  debug.current_css_set_refcount
 cgroup.threads          debug.masks
 debug.csses             debug.taskcount
 debug.css_links

Thanks.

-- 
tejun
