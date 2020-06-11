From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Wed, 10 Jun 2020 20:02:42 -0700
Message-ID: <202006102001.E9779DFA5B@keescook>
References: <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <40d76a9a4525414a8c9809cd29a7ba8e@AcuMS.aculab.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j3OsXPGIwi3xsUIwRgQitia7+o3C2dniHB1RcDZH3GE=;
        b=fcp7RrfiW9uA4z+tTFPju9m2g0v7xg/w/6Yv3TKyJpkvVw3AHi9F9bI1FqyDu6Hl9w
         GyfBNHCOgQCZw4f0JowTFQTL7UPNRXy+GlzrF7F/cvWtwqH6sFM7IejbWJFtmM65xNQl
         wwbn9ttjXIWQ8BBcanAOUT3ilxezqyytZ8NSI=
Content-Disposition: inline
In-Reply-To: <40d76a9a4525414a8c9809cd29a7ba8e-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Cc: 'Sargun Dhillon' <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Palmer <palmer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Denton <mpdenton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

On Wed, Jun 10, 2020 at 08:48:45AM +0000, David Laight wrote:
> From: Sargun Dhillon
> > Sent: 10 June 2020 09:13
> In essence the 'copy_to_user' is done by the wrapper code.
> The code filling in the CMSG buffer can be considered to be
> writing a kernel buffer.
> 
> IIRC other kernels (eg NetBSD) do the copies for ioctl() requests
> in the ioctl syscall wrapper.
> The IOW/IOR/IOWR flags have to be right.

Yeah, this seems like it'd make a lot more sense (and would have easily
caught the IOR/IOW issue pointed out later in the thread). I wonder how
insane it would be to try to fix that globally in the kernel...

-- 
Kees Cook
