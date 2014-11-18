From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3 cgroup/for-3.19] cgroup: implement cgroup_get_e_css()
Date: Tue, 18 Nov 2014 14:35:21 +0800
Message-ID: <546AE8A9.1090600@huawei.com>
References: <20141117205652.GA23126@htj.dyndns.org> <20141117205734.GB23126@htj.dyndns.org> <20141117205855.GC23126@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141117205855.GC23126-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/11/18 4:58, Tejun Heo wrote:
> Implement cgroup_get_e_css() which finds and gets the effective css
> for the specified cgroup and subsystem combination.  This function
> always returns a valid pinned css.  This will be used by cgroup
> writeback support.
> 
> While at it, add comment to cgroup_e_css() to explain why that
> function is different from cgroup_get_e_css() and has to test
> cgrp->child_subsys_mask instead of cgroup_css(cgrp, ss).
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

For all 3 patches:

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
