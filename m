From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cpuset: fix cpu hotplug vs rebuild_sched_domains()
 race
Date: Sat, 27 Apr 2013 07:23:25 -0700
Message-ID: <20130427142325.GA25051@mtj.dyndns.org>
References: <517BA01C.6060806@huawei.com>
 <517BA02C.8080005@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=nwp95FY+amEjeMBw6GUpUL29QATcW6BqDayHC83p27M=;
        b=CL93c+75PKHW9VZv91L5KFF5s+0st2yw445gMgkX0auXKnKQX8Av/Z1RzCUMWOTKyB
         XwiUi92/eGBCIp1O8Tr9jKa455z4hOSDekywj5oQcDEnPytsc2E3KYO2CowwRqPLTGP9
         qR0quzruYRUpwHvrJ/eyhJ/wY72hun4ptlf/qkC0Atuse1zEcDaFWyVtvqTDrgEVdIng
         e4YBgyEiY66ZltEcnuC3i+w6MZKw1MkrzJtDVJaTHrWfZx8JZ5ISG4Js34KxakIYG1kD
         Dskp+zKEqUTAlsgoj6Nqw0SVXxQtiHMzQ0l2NIPQXcvsPkBzGORlz+MEds5pYhCVUPiT
         U/1w==
Content-Disposition: inline
In-Reply-To: <517BA02C.8080005-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, Apr 27, 2013 at 05:53:48PM +0800, Li Zefan wrote:
> rebuild_sched_domains() might pass doms with offlined cpu to
> partition_sched_domains(), which results in an oops:
> 
> general protection fault: 0000 [#1] SMP
> ...
> RIP: 0010:[<ffffffff81077a1e>]  [<ffffffff81077a1e>] get_group+0x6e/0x90
> ...
> Call Trace:
>  [<ffffffff8107f07c>] build_sched_domains+0x70c/0xcb0
>  [<ffffffff8107f2a7>] ? build_sched_domains+0x937/0xcb0
>  [<ffffffff81173f64>] ? kfree+0xe4/0x1b0
>  [<ffffffff8107f6e0>] ? partition_sched_domains+0xc0/0x470
>  [<ffffffff8107f905>] partition_sched_domains+0x2e5/0x470
>  [<ffffffff8107f6e0>] ? partition_sched_domains+0xc0/0x470
>  [<ffffffff810c9007>] ? generate_sched_domains+0xc7/0x530
>  [<ffffffff810c94a8>] rebuild_sched_domains_locked+0x38/0x70
>  [<ffffffff810cb4a4>] cpuset_write_resmask+0x1a4/0x500
>  [<ffffffff810c8700>] ? cpuset_mount+0xe0/0xe0
>  [<ffffffff810c7f50>] ? cpuset_read_u64+0x100/0x100
>  [<ffffffff810be890>] ? cgroup_iter_next+0x90/0x90
>  [<ffffffff810cb300>] ? cpuset_css_offline+0x70/0x70
>  [<ffffffff810c1a73>] cgroup_file_write+0x133/0x2e0
>  [<ffffffff8118995b>] vfs_write+0xcb/0x130
>  [<ffffffff8118a174>] sys_write+0x64/0xa0
> 
> Reported-by: Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-2 to cgroup/for-3.10.

Thanks.

-- 
tejun
