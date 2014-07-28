From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: WARNING: at kernel/cpuset.c:1139
Date: Mon, 28 Jul 2014 15:20:26 -0400
Message-ID: <20140728192026.GI7462@htj.dyndns.org>
References: <53CF22F5.6000206@linux.vnet.ibm.com>
 <20140723151220.GD7103@htj.dyndns.org>
 <53D052FC.3070409@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QnnxZ6FDhXKmDvovHoZhs/OW2U5GSvFeDbsUfiHxXF0=;
        b=MZGWFWn8neOjBk2bBqeQRIdh1BILZ+xniO9qz2pHUmmDtvMwQ+maMKR4RIr1FeifrI
         OkYPjGpshAUYbdpAmpU6sabAEcl3kvmMIIRCZnrtJtfPYSqyWDB2HH/ise94SBe0TvW2
         rFLk5Mi4O+xM1SQaetpZJVhnkMmHaMvrxzkwc3BT/7Ky8R/WZoB9TYhyKBzQZtXKH1bH
         WDm6VidApSMAcg3Ckmov/uCaLPAIhMkHlcGYiBhA2aanjR0IcrC9lK00jpx3/oZZtt/8
         xk2MkghDyE82XJsBNIgEQ37eFScZ6j5jSrKvKo+GLv0B+xFv+PGypCWH0peL2yrrb5cH
         rYmA==
Content-Disposition: inline
In-Reply-To: <53D052FC.3070409-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 24, 2014 at 08:27:40AM +0800, Li Zefan wrote:
> On 2014/7/23 23:12, Tejun Heo wrote:
> > On Wed, Jul 23, 2014 at 10:50:29AM +0800, Mike Qiu wrote:
> >> commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when config
> >> changes") introduce the below warning in my server.
> >>
> >> [   35.652137] ------------[ cut here ]------------
> >> [   35.652141] WARNING: at kernel/cpuset.c:1139
> > 
> > Hah, can you reproduce it?  If so, can you detail how?
> > 
> 
> It's a typo.
> 
> WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
> 	nodes_equal(cp->mems_allowed, cp->effective_mems));
> 
> should be
> 
> WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
> 	!nodes_equal(cp->mems_allowed, cp->effective_mems));

Care to post a patch?

Thanks.

-- 
tejun
