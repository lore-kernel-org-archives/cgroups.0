From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Wed, 10 Jun 2020 10:10:33 -0700
Message-ID: <202006101005.D1D19EE@keescook>
References: <20200604012452.vh33nufblowuxfed@wittgenstein>
 <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wu1KxK3oWDaDyFouCR1IJCWRCCZuOnfSKhmf+rK5Zxw=;
        b=oMmr18e2vlsUwaIbxh6CowxNZ5fXzjfgmkFL2R2jM2RUlcV/0jnVTduaVrPaFnDGs9
         QDuR/bYJP+8NCw01k5v6u7s7UrHLS9i8UYMPU93hCzQfrKP3xRzfjAw0OBDtnOAgcdtQ
         7KVFiv3APJf/AYGrTCrcwRMVTg4Dwe/DNZI54=
Content-Disposition: inline
In-Reply-To: <20200610081237.GA23425-du9IEJ8oIxHXYT48pCVpJ3c7ZZ+wIVaZYkHkVr5ML8kVGlcevz2xqA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Palmer <palmer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Denton <mpdenton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> On Tue, Jun 09, 2020 at 10:27:54PM -0700, Kees Cook wrote:
> > On Tue, Jun 09, 2020 at 11:27:30PM +0200, Christian Brauner wrote:
> > > On June 9, 2020 10:55:42 PM GMT+02:00, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> > > >LOL. And while we were debating this, hch just went and cleaned stuff up:
> > > >
> > > >2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> > > >
> > > >So, um, yeah, now my proposal is actually even closer to what we already
> > > >have there. We just add the replace_fd() logic to __scm_install_fd() and
> > > >we're done with it.
> > > 
> > > Cool, you have a link? :)
> > 
> > How about this:
> > 
> Thank you.
> > https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=devel/seccomp/addfd/v3.1&id=bb94586b9e7cc88e915536c2e9fb991a97b62416
> > 
> > -- 
> > Kees Cook
> 
> +		if (ufd) {
> +			error = put_user(new_fd, ufd);
> +			if (error) {
> +				put_unused_fd(new_fd);
> +				return error;
> +			}
> + 		}
> I'm fairly sure this introduces a bug[1] if the user does:

Ah, sorry, I missed this before I posted my "v3.2" tree link.

> 
> struct msghdr msg = {};
> struct cmsghdr *cmsg;
> struct iovec io = {
> 	.iov_base = &c,
> 	.iov_len = 1,
> };
> 
> msg.msg_iov = &io;
> msg.msg_iovlen = 1;
> msg.msg_control = NULL;
> msg.msg_controllen = sizeof(buf);
> 
> recvmsg(sock, &msg, 0);
> 
> They will have the FD installed, no error message, but FD number wont be written 
> to memory AFAICT. If two FDs are passed, you will get an efault. They will both
> be installed, but memory wont be written to. Maybe instead of 0, make it a
> poison pointer, or -1 instead?

Hmmm. I see what you mean -- SCM_RIGHTS effectively _requires_ a valid
__user pointer, so we can't use NULL to indicate "we don't want this".
I'm not sure I can pass this through directly at all, though.

> -----
> As an aside, all of this junk should be dropped:
> +	ret = get_user(size, &uaddfd->size);
> +	if (ret)
> +		return ret;
> +
> +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> +	if (ret)
> +		return ret;
> 
> and the size member of the seccomp_notif_addfd struct. I brought this up 
> off-list with Tycho that ioctls have the size of the struct embedded in them. We 
> should just use that. The ioctl definition is based on this[2]:
> #define _IOC(dir,type,nr,size) \
> 	(((dir)  << _IOC_DIRSHIFT) | \
> 	 ((type) << _IOC_TYPESHIFT) | \
> 	 ((nr)   << _IOC_NRSHIFT) | \
> 	 ((size) << _IOC_SIZESHIFT))
> 
> 
> We should just use copy_from_user for now. In the future, we can either 
> introduce new ioctl names for new structs, or extract the size dynamically from 
> the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.

Okay, sounds good.

> ----
> +#define SECCOMP_IOCTL_NOTIF_ADDFD	SECCOMP_IOR(3,	\
> +						struct seccomp_notif_addfd)
> 
> Lastly, what I believe to be a small mistake, it should be SECCOMP_IOW, based on 
> the documentation in ioctl.h -- "_IOW means userland is writing and kernel is 
> reading."

Okay, let me tweak things and get a "v3.3". ;)

-- 
Kees Cook
