From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Date: Thu, 12 Dec 2013 10:35:36 -0500
Message-ID: <20131212153536.GD32683@htj.dyndns.org>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hLrR+2Q6HPb7zP6jdnMVD+AT+xpKxegykIQehxp2aF8=;
        b=IIhzjTliFadLpEWBzuVQRJKg7h86q3PClv6S7f0jxwHCgU5R20sZgij5JOqKX1QP6Y
         rzYSWQbZ2m4Ug5CMr60XudIIbEafIi4D/UbSbJgQfOYPjsoY4wwhO/+El/0z8BNTOvZt
         N1FlgT/zlLc0ffOCoS7Jwj2hy513BdWEs1efmGhaLro9f7VYs2dvMGeYnWPHYWM3Tv8L
         nZpGgsreOvrPQvySdevpn3Nxq4VZ1gf/GJ9YtHnyyLrlqjOP0tsPA8uMmFXC9KAiPEzU
         SFijeFGCvgnlXkhH7zh+g1ra3ddX5V0nGoy9YhygQInoXviwrCjT/drkz0xB2AK0TCOz
         E4DQ==
Content-Disposition: inline
In-Reply-To: <1386403085-24866-1-git-send-email-vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Sat, Dec 07, 2013 at 11:58:05AM +0400, Vladimir Davydov wrote:
> We should not call cgroup_unload_subsys() if online_css() fails, because
> online_css() does not assign css to cgroup on failure, while
> offline_css() called from cgroup_unload_subsys() expects it is assigned.
> So let's call everything we need to rollback inline without involving
> cgroup_unload_subsys().
> 
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.13-fixes.

Thanks.

-- 
tejun
