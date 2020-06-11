From: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Thu, 11 Jun 2020 07:51:02 +0000
Message-ID: <5cb49301f8d8432eacdd0e9d914c14a3@AcuMS.aculab.com>
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
 <202006102001.E9779DFA5B@keescook>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <202006102001.E9779DFA5B@keescook>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Kees Cook' <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: 'Sargun Dhillon' <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Palmer <palmer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Denton <mpdenton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

From: Kees Cook
> Sent: 11 June 2020 04:03
...
> > IIRC other kernels (eg NetBSD) do the copies for ioctl() requests
> > in the ioctl syscall wrapper.
> > The IOW/IOR/IOWR flags have to be right.
> 
> Yeah, this seems like it'd make a lot more sense (and would have easily
> caught the IOR/IOW issue pointed out later in the thread). I wonder how
> insane it would be to try to fix that globally in the kernel...

Seems like a good idea to me.
(Even though I'll need to fix our 'out of tree' modules.)

Unlike [sg]etsockopt() at least the buffer is bounded to 1k.

But you'd really need to add new kernel_ioctl() entry points
before deprecating the existing ones a release or two later.

With a bit of luck there aren't any drivers ported from SYSV that
just treat the ioctl command as a 32bit transparent value and
the argument as an integer.

I actually suspect that BSD added IOW (etc) in the 16bit to 32bit port.
The kernel copies being moved to the syscall stub at the same time.
Since Linux has only ever been 32bit and uses IOW is it actually odd
that Linus didn't do the copies in the stub.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

