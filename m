From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.5-fixes] cgroup: fix alloc_cgroup_ns() error
 handling in copy_cgroup_ns()
Date: Thu, 18 Feb 2016 08:57:54 -0800
Message-ID: <CAGr1F2GOrJy9BhhwC3Eq0M3RkqbGUuwDjofa69HcojAJx=F3Ew@mail.gmail.com>
References: <20160217185811.GA3472@mwanda> <20160218164658.GD13177@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=OSfnYqTru/ZDjCRyr5lxlAICJCtarH8rYKN+eOkxhNY=;
        b=mtx85W9n9jyhIxJE13zOMx0uC/CKa7IItmPm0qk+GFEGrMBhY+wuH5L4O3aE38pbRn
         laaWeXRsZ082Askt4W6IZT9yEoKEZ5GGsJ7sigGoDCeMhd0mvfTHnyqqrwhu8nRHILgy
         DI6yIk7UleeSHDz0yP5C4I/n2WRSY8Zs8u4+PCqHCtie062kJQTwEQhxT0Rykr/gKluk
         BSy27sGarF3GQMZi/Gz2Yj2rmmpx+mfYwrLKY20lJK8fQR1hAjiuKwdyOZf8IyBgPTUI
         RmBlFC1WpVafEBJyOaVMuammc5W3LgUDULyl/2h97fH956BRpJDReTZMKN9qM0pmSs0P
         Nf5g==
In-Reply-To: <20160218164658.GD13177-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks for catching.

On Thu, Feb 18, 2016 at 8:46 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From d22025570e2ebfc68819b35c5d457e53d9337217 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Thu, 18 Feb 2016 11:44:24 -0500
>
> alloc_cgroup_ns() returns an ERR_PTR value on error but
> copy_cgroup_ns() was checking for NULL for error.  Fix it.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Acked-by: Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org)

> ---
> Hello, Dan.
>
> Applied to cgroup/for-4.5-fixes.
>
> Thanks.
>
>  kernel/cgroup.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index afb1205..d92d91a 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -6083,10 +6083,11 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
>         spin_unlock_bh(&css_set_lock);
>         mutex_unlock(&cgroup_mutex);
>
> -       err = -ENOMEM;
>         new_ns = alloc_cgroup_ns();
> -       if (!new_ns)
> +       if (IS_ERR(new_ns)) {
> +               err = PTR_ERR(new_ns);
>                 goto err_out;
> +       }
>
>         new_ns->user_ns = get_user_ns(user_ns);
>         new_ns->root_cset = cset;
> --
> 2.5.0
>



-- 
Aditya
