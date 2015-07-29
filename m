From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/10] cgroup: don't print subsystems for the default
 hierarchy
Date: Wed, 29 Jul 2015 09:18:02 +0800
Message-ID: <55B829CA.1040106@huawei.com>
References: <1437763434-28699-1-git-send-email-tj@kernel.org> <1437763434-28699-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437763434-28699-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015/7/25 2:43, Tejun Heo wrote:
> It doesn't make sense to print subsystems on mount option or
> /proc/PID/cgroup for the default hierarchy.
> 
> * cgroup.controllers file at the root of the default hierarchy lists
>   the currently attached controllers.
> 
> * The default hierarchy is catch-all for unmounted subsystems.
> 
> * The default hierarchy doesn't accept any mount options.
> 
> Suppress subsystem printing on mount options and /proc/PID/cgroup for
> the default hierarchy.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked
