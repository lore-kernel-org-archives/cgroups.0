From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroupns: Only allow creation of hierarchies in the
 initial cgroup namespace
Date: Fri, 15 Jul 2016 07:16:59 -0400
Message-ID: <20160715111659.GB3078@mtj.duckdns.org>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
 <87r3av32g1.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yTm5WCeZkVOGLzbLvbcEJ2M8eFchBJP4c7bZzWgWTEA=;
        b=fjxAl4UtqstM0/xSGXBmY9EFWmoLgZgvoa5dde7q7mmWtXJ4cLdzw9oPTZ4Mm0zcqj
         J66M8Ribb6DA8sU/3V6avGj/oKURxrLQUo1wSgmM8bh3f/3aw8EZX22QUj1tmCNzyBdg
         f3T98ew0/s9bQtij+h5O5kqJV95FBBAZXFeh1Dv0rJSmNwFX4cHWqwVMyAdO75TPWDza
         HNjMmFygGxeD/WasFCNmMUmNNf/gaxDaVX9a0GN3lbuxLZ2jN7CL1HLtJZyTdVmF1a1J
         H2CJ2o2kS5ITZGzv7aV4uwrTkw3idY7Hs8vD1lNJNZblb4Ge3X7NsdZ3UDxVQtp6hHjw
         33oA==
Content-Disposition: inline
In-Reply-To: <87r3av32g1.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Eric.

On Fri, Jul 15, 2016 at 12:17:18AM -0500, Eric W. Biederman wrote:
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c99b0bcd2647..01f34edceb6b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2209,12 +2209,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  		goto out_unlock;
>  	}
>  
> -	/*
> -	 * We know this subsystem has not yet been bound.  Users in a non-init
> -	 * user namespace may only mount hierarchies with no bound subsystems,
> -	 * i.e. 'none,name=user1'
> -	 */
> -	if (!opts.none && !capable(CAP_SYS_ADMIN)) {
> +	/* Hierarchies may only be created in the initial cgroup namespace. */
> +	if (ns != &init_cgroup_ns) {

Doesn't this allow any user in the init ns to create any hierarchies?

Thanks.

-- 
tejun
