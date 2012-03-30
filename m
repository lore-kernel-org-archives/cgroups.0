From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH for-3.4-fixes] cgroup: cgroup_attach_task() could return
 -errno after success
Date: Fri, 30 Mar 2012 10:38:01 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1203301037380.25526@pobox.suse.cz>
References: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz> <20120329160433.GC28941@google.com> <20120329162620.GD28941@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120329162620.GD28941-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

On Thu, 29 Mar 2012, Tejun Heo wrote:

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
> Reported-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> LKML-Reference: <alpine.LNX.2.00.1203282354440.25526-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
> ---
> Jiri, can you please confirm the fix?

Thanks Tejun, it works here.

Tested-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>

-- 
Jiri Kosina
SUSE Labs
