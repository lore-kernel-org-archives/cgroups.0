From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: remove synchronize_rcu() from
 rebind_subsystems()
Date: Mon, 14 Jan 2013 10:55:46 -0800
Message-ID: <20130114185546.GH27942@mtj.dyndns.org>
References: <50F3CE8E.5000402@huawei.com>
 <50F3CEC2.1020909@huawei.com>
 <20130114185512.GG27942@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=XUmWqbxit58mLvzzpaZ233drZ/1aORdcZZGtd2z+8vI=;
        b=iKtKCL8SN85y0cexz80s38XoxkTtoYtObjAAR0NgCd2dWH7xLx5Q6JuHoRb1QKBL/r
         +TN0odV5WbJQpMwBIbrIMUA1YADPfFZTHHKVYQAjpgKr/dslBXRdmwmP0VyO1rR1rQA0
         xzuIQxOqzHe+RNlbT2gu4zhqM4yDswc+KuUlVa0wNrNb4YTBKr/lg68aTiiMvGHyHGMi
         WKgixyU6H3LcJU86YZyG3d/tephmJQd8nOzc7lPMKuBSWOVJWsRNAQJ36b6dyO6nPKp+
         c1Q+mgbllXToolILZ1/g6Q5xgufW3PHELEEKTOdQy4ia94qiqPcgMbHVqtryvuumNHgn
         PJWw==
Content-Disposition: inline
In-Reply-To: <20130114185512.GG27942-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jan 14, 2013 at 10:55:12AM -0800, Tejun Heo wrote:
> On Mon, Jan 14, 2013 at 05:24:18PM +0800, Li Zefan wrote:
> > Nothing's protected by RCU in rebind_subsystems(), and I can't think
> > of a reason why it is needed.
> > 
> > Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Applied to cgroup/for-3.9.  We probably should synchornize_rcu() from
                                                ^
						remove

> cgroup_diput() too.  Probably by punting css_free() and cgrp freeing
> to a work item from call_rcu() callback.

-- 
tejun
