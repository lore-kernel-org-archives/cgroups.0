From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Date: Thu, 12 Dec 2013 10:55:23 -0500
Message-ID: <20131212155523.GF32683@htj.dyndns.org>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
 <20131212153536.GD32683@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=T9Sle7fhEA85wemI/0zu14ZsBdoSjjQNG9Tka2yvp2M=;
        b=A0mcn9Hlj/VPZvG21kLUBKeQ2TSfgr/qeLTGYHWFDqWBAE8XP5S62CyYZ5aHp5t0gT
         A+2QUXQnyB/0ExFmwHFtS0zETtZYAdCUbA9QGl8AJZgwRbFXaIfgyuPY24Fjb616zKPu
         flsFiyikgHcnSf4UVBp1zLfRjhUc+2k7noqdo5C7xrG9lSOJBys8iMZNDFE1FPg3Ogxd
         5SbCo+7cHSsNbat5ALJfh7XfmoJo5xwdndRY1TtOh3VEleU2KgFushshfbFRMjgJnq8a
         iPRlNi9Cnh2L/c7y4/qAKxnf2QyAl05+UeWo6CTXThQIqp2G9O0/nAeEra9zTcUK5ytT
         +9Og==
Content-Disposition: inline
In-Reply-To: <20131212153536.GD32683-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Dec 12, 2013 at 10:35:36AM -0500, Tejun Heo wrote:
> On Sat, Dec 07, 2013 at 11:58:05AM +0400, Vladimir Davydov wrote:
> > We should not call cgroup_unload_subsys() if online_css() fails, because
> > online_css() does not assign css to cgroup on failure, while
> > offline_css() called from cgroup_unload_subsys() expects it is assigned.
> > So let's call everything we need to rollback inline without involving
> > cgroup_unload_subsys().
> > 
> > Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Applied to cgroup/for-3.13-fixes.

Scrap that.  I don't think we can fail css_online for the root css in
3.13-fixes and this would cause conflict with 3.14, so let's not
commit it to 3.13-fixes.  Vladimir, can you please respin the patch on
top of cgroup/for-3.14 but make cgroup_unload_subsys() check whether
css is actually there before calling offline so that it matches the
usual offline path better?

Thanks.

-- 
tejun
