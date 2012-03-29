From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH for-3.4-fixes] cgroup: cgroup_attach_task() could
 return -errno after success
Date: Thu, 29 Mar 2012 11:11:04 -0700
Message-ID: <20120329181104.GC27051@google.com>
References: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
 <20120329160433.GC28941@google.com>
 <20120329162620.GD28941@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        bh=hWN1PBoTAt9706r5xh/SrwTMBd+6FAjoE9JBwsd+heI=;
        b=lsU+131wBqR9ljNmoP9iXfq0TSI84T3gkIP4YYit2hQuoAS84J/uRXeRj6KNHXbW5X
         DlK36vN9yjI3mLAR4L0W2alJo2GqO5apSGQejpa921LRVmSMjnIBFEdZbLScFGRYK1qq
         w48Kfvr/qMorm0WJKTCod2EoJh1JIjrYkwhKpnUnedcfIRGTAJSoXCLC6Nw/meOMCQbA
         lZ8CbrD+EGC2k2/8LviSxtlI0GgXZmZd6j88xwclPkWFZm8InjZJIxvY9U596qyBFXlY
         RYVdMJr8Jzn8vVss8FYa+qlfpmlS4Qv7LuVmlMHIt138Rt3drY9xl7FqyIkmTWw5Z7Ks
         7l+w==
Content-Disposition: inline
In-Reply-To: <20120329162620.GD28941-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:
> 61d1d219c4 "cgroup: remove extra calls to find_existing_css_set" made
> cgroup_task_migrate() return void.  An unfortunate side effect was
> that cgroup_attach_task() was depending on that function's return
> value to clear its @retval on the success path.  On cgroup mounts
> without any subsystem with ->can_attach() callback,
> cgroup_attach_task() ended up returning @retval without initializing
> it on success.
> 
> For some reason, gcc failed to warn about it and it didn't cause
> cgroup_attach_task() to return non-zero value in many cases, probably
> due to difference in register allocation.  When the problem
> materializes, systemd fails to populate /systemd cgroup mount and
> fails to boot.
> 
> Fix it by initializing @retval to zero on declaration.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

> Reported-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> LKML-Reference: <alpine.LNX.2.00.1203282354440.25526-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
> ---
> Jiri, can you please confirm the fix?
> 
> Thanks.
> 
>  kernel/cgroup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index f4ea4b6..ed64cca 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1883,7 +1883,7 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>   */
>  int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>  {
> -	int retval;
> +	int retval = 0;
>  	struct cgroup_subsys *ss, *failed_ss = NULL;
>  	struct cgroup *oldcgrp;
>  	struct cgroupfs_root *root = cgrp->root;
