From: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Thu, 11 Jun 2020 04:41:02 +0000
Message-ID: <20200611044101.GA5909@ircssh-2.c.rugged-nimbus-611.internal>
References: <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2MxSp8mta6jBvTYFbwackP1K8RxAUSlCcOAqiVie0bw=;
        b=MDFxEkZa/5Mq83/7d4Lt1ekQ/A34Ql3/RJa0V/k91Bitp1BGn1pGrE5jsgisPEKudC
         ziTuoTflNCIgLqaGfObN9cM0O3+H7vttsX5p49I0bc6789Aqd4GoUlwnjngvGDnCyTUv
         hG9UYF5UpUQOH3TtUilPJ1w3Uo+AMjPgKfOa4=
Content-Disposition: inline
In-Reply-To: <202006101953.899EFB53@keescook>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Palmer <palmer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Denton <mpdenton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> 
> Yeah, that seems reasonable. Here's the diff for that part:
> 
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 7b6028b399d8..98bf19b4e086 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -118,7 +118,6 @@ struct seccomp_notif_resp {
>  
>  /**
>   * struct seccomp_notif_addfd
> - * @size: The size of the seccomp_notif_addfd datastructure
>   * @id: The ID of the seccomp notification
>   * @flags: SECCOMP_ADDFD_FLAG_*
>   * @srcfd: The local fd number
> @@ -126,7 +125,6 @@ struct seccomp_notif_resp {
>   * @newfd_flags: The O_* flags the remote FD should have applied
>   */
>  struct seccomp_notif_addfd {
> -	__u64 size;
>  	__u64 id;
>  	__u32 flags;
>  	__u32 srcfd;
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 3c913f3b8451..00cbdad6c480 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1297,14 +1297,9 @@ static long seccomp_notify_addfd(struct seccomp_filter *filter,
>  	struct seccomp_notif_addfd addfd;
>  	struct seccomp_knotif *knotif;
>  	struct seccomp_kaddfd kaddfd;
> -	u64 size;
>  	int ret;
>  
> -	ret = get_user(size, &uaddfd->size);
> -	if (ret)
> -		return ret;
> -
> -	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> +	ret = copy_from_user(&addfd, uaddfd, sizeof(addfd));
>  	if (ret)
>  		return ret;
>  
> 
Looks good to me. If we ever change the size of this struct, we can do the work 
then to copy_struct_from_user.

> > 
> > ----
> > +#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
> > +						struct seccomp_notif_addfd)
> > 
> > Lastly, what I believe to be a small mistake, it should be SECCOMP_IOW, based on 
> > the documentation in ioctl.h -- "_IOW means userland is writing and kernel is 
> > reading."
> 
> Oooooh. Yeah; good catch. Uhm, that means SECCOMP_IOCTL_NOTIF_ID_VALID
> is wrong too, yes? Tycho, Christian, how disruptive would this be to
> fix? (Perhaps support both and deprecate the IOR version at some point
> in the future?)
I think at a minimum we should change the uapi, and accept both (for now). Maybe 
a pr_warn_once telling people not to use the old one.

I can do the patch, if you want. 
> 
> Diff for just addfd's change:
> 
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 7b6028b399d8..98bf19b4e086 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -146,7 +144,7 @@ struct seccomp_notif_addfd {
>  						struct seccomp_notif_resp)
>  #define SECCOMP_IOCTL_NOTIF_ID_VALID	SECCOMP_IOR(2, __u64)
>  /* On success, the return value is the remote process's added fd number */
> -#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
> +#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOW(3,	\
>  						struct seccomp_notif_addfd)
>  
>  #endif /* _UAPI_LINUX_SECCOMP_H */
> 
> -- 
> Kees Cook
Looks good. Thank you.
