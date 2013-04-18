From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] devcg: remove parent_cgroup.
Date: Thu, 18 Apr 2013 11:36:00 -0700
Message-ID: <20130418183600.GI9897@mtj.dyndns.org>
References: <1366143895-21535-1-git-send-email-ramirose@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=1CU/w5+DhnRDMOBYdQCUw0iOYbsaKJ7prcq2T65AVlQ=;
        b=tk5SDWpBYVtVMZrMflTbMTFSxrZWGGeZjI8cdgiBuZ04iwi3ilnVANnNC0YaVsYb+/
         7gfqylUl2MFJQoLf4h8ka8mz1LjTCxSTCiaT+8TUzrO9TiGj8lYR2IM3/g5PurMVEJbr
         61YupVwUpUMrf7JD1dWPJZvOxJWPaAcnVuLYoGfTVFxld5e333e4IdbpvyYqnMJyyTSa
         8Tisdp1wvK9+MouQ/X2fB/c3ZQu/3tcl832KkkKKLHVyB5z2rn2YOlBWm3f4GYN4XOKo
         z1JxnrpBG1s/sbZ1M/qH7qnMPBll6RdWrXT1E4Ti3jfbR09r2JYuRJseur9KLQIXujuG
         GDhg==
Content-Disposition: inline
In-Reply-To: <1366143895-21535-1-git-send-email-ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org

On Tue, Apr 16, 2013 at 11:24:55PM +0300, Rami Rosen wrote:
> In devcgroup_css_alloc(), there is no longer need for parent_cgroup.
> bd2953ebbb("devcg: propagate local changes down the hierarchy") made
> the variable parent_cgroup redundant. This patch removes parent_cgroup
> from devcgroup_css_alloc().
> 
> Signed-off-by: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
