From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: protect modifications to cgroup_idr with
 cgroup_mutex
Date: Tue, 11 Feb 2014 10:36:30 -0500
Message-ID: <20140211153630.GB24490@htj.dyndns.org>
References: <52F9D9DA.7040108@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cvcH8l9zIAR9MCARQorFvbz8oC95KZdRiw3VB79GU2w=;
        b=NiLWvYwLLW9HO7Fk/jbMhE+V0yv9N3x2V9ZfQL53LFpSZ/3D1ka5Q/g5cSji1HIA9P
         DR2lNCbhelAAZWx3OowcjRbVe9905gac+dRNaork0wWbd1c8rzizp2Q1BkWMLWfYWN7S
         DdPo8xLyhbNlJ5fnAfAO58gKTk2amBizZSII14UcTxKpT7npZgyLOWtFGoDmOQ2iAh0Y
         AnvBOBaZ6n9qLK+fYgiDIk1xdK8S7EWv8i6alQac0tS6lyFrDwP536VsW/+MPqClvH1r
         yBZbxd0zF7HgQh5AwcxPSkQ9I+0+avwsVeurdHAu7bdO7PuaSCqnDhC0nSP5Iatmld6n
         UhQw==
Content-Disposition: inline
In-Reply-To: <52F9D9DA.7040108-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Feb 11, 2014 at 04:05:46PM +0800, Li Zefan wrote:
> Setup cgroupfs like this:
>   # mount -t cgroup -o cpuacct xxx /cgroup
>   # mkdir /cgroup/sub1
>   # mkdir /cgroup/sub2
> 
> Then run these two commands:
>   # for ((; ;)) { mkdir /cgroup/sub1/tmp && rmdir /mnt/sub1/tmp; } &
>   # for ((; ;)) { mkdir /cgroup/sub2/tmp && rmdir /mnt/sub2/tmp; } &
> 
> After seconds you may see this warning:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 25243 at lib/idr.c:527 sub_remove+0x87/0x1b0()
> idr_remove called for id=6 which is not allocated.
> ...
> Call Trace:
>  [<ffffffff8156063c>] dump_stack+0x7a/0x96
>  [<ffffffff810591ac>] warn_slowpath_common+0x8c/0xc0
>  [<ffffffff81059296>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff81300aa7>] sub_remove+0x87/0x1b0
>  [<ffffffff810f3f02>] ? css_killed_work_fn+0x32/0x1b0
>  [<ffffffff81300bf5>] idr_remove+0x25/0xd0
>  [<ffffffff810f2bab>] cgroup_destroy_css_killed+0x5b/0xc0
>  [<ffffffff810f4000>] css_killed_work_fn+0x130/0x1b0
>  [<ffffffff8107cdbc>] process_one_work+0x26c/0x550
>  [<ffffffff8107eefe>] worker_thread+0x12e/0x3b0
>  [<ffffffff81085f96>] kthread+0xe6/0xf0
>  [<ffffffff81570bac>] ret_from_fork+0x7c/0xb0
> ---[ end trace 2d1577ec10cf80d0 ]---
> 
> It's because allocating/removing cgroup ID is not properly synchronized.
> 
> The bug was introduced when we converted cgroup_ida to cgroup_idr.
> While synchronization is already done inside ida_simple_{get,remove}(),
> users are responsible for concurrent calls to idr_{alloc,remove}().
> 
> Fixes: 4e96ee8e981b ("cgroup: convert cgroup_ida to cgroup_idr")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #3.12+
> Reported-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Jesus, you're right.  I missed that completely.  It conflicts with the
return value fix in cgroup/for-3.14-fixes but easy to fix up.
Applying to cgroup/for-3.14-fixes.

Thanks!

-- 
tejun
