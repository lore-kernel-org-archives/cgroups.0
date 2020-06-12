From: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Date: Fri, 12 Jun 2020 08:36:03 +0000
Message-ID: <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
References: <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <202006111634.8237E6A5C6@keescook>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Kees Cook' <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: 'Sargun Dhillon' <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Palmer <palmer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Denton <mpdenton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From: Kees Cook
> Sent: 12 June 2020 00:50
> > From: Sargun Dhillon
> > > Sent: 11 June 2020 12:07
> > > Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to move fds across
> processes
> > >
> > > On Thu, Jun 11, 2020 at 12:01:14PM +0200, Christian Brauner wrote:
> > > > On Wed, Jun 10, 2020 at 07:59:55PM -0700, Kees Cook wrote:
> > > > > On Wed, Jun 10, 2020 at 08:12:38AM +0000, Sargun Dhillon wrote:
> > > > > > As an aside, all of this junk should be dropped:
> > > > > > +	ret = get_user(size, &uaddfd->size);
> > > > > > +	if (ret)
> > > > > > +		return ret;
> > > > > > +
> > > > > > +	ret = copy_struct_from_user(&addfd, sizeof(addfd), uaddfd, size);
> > > > > > +	if (ret)
> > > > > > +		return ret;
> > > > > >
> > > > > > and the size member of the seccomp_notif_addfd struct. I brought this up
> > > > > > off-list with Tycho that ioctls have the size of the struct embedded in them. We
> > > > > > should just use that. The ioctl definition is based on this[2]:
> > > > > > #define _IOC(dir,type,nr,size) \
> > > > > > 	(((dir)  << _IOC_DIRSHIFT) | \
> > > > > > 	 ((type) << _IOC_TYPESHIFT) | \
> > > > > > 	 ((nr)   << _IOC_NRSHIFT) | \
> > > > > > 	 ((size) << _IOC_SIZESHIFT))
> > > > > >
> > > > > >
> > > > > > We should just use copy_from_user for now. In the future, we can either
> > > > > > introduce new ioctl names for new structs, or extract the size dynamically from
> > > > > > the ioctl (and mask it out on the switch statement in seccomp_notify_ioctl.
> > > > >
> > > > > Yeah, that seems reasonable. Here's the diff for that part:
> > > >
> > > > Why does it matter that the ioctl() has the size of the struct embedded
> > > > within? Afaik, the kernel itself doesn't do anything with that size. It
> > > > merely checks that the size is not pathological and it does so at
> > > > compile time.
> > > >
> > > > #ifdef __CHECKER__
> > > > #define _IOC_TYPECHECK(t) (sizeof(t))
> > > > #else
> > > > /* provoke compile error for invalid uses of size argument */
> > > > extern unsigned int __invalid_size_argument_for_IOC;
> > > > #define _IOC_TYPECHECK(t) \
> > > > 	((sizeof(t) == sizeof(t[1]) && \
> > > > 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
> > > > 	  sizeof(t) : __invalid_size_argument_for_IOC)
> > > > #endif
> > > >
> > > > The size itself is not verified at runtime. copy_struct_from_user()
> > > > still makes sense at least if we're going to allow expanding the struct
> > > > in the future.
> > > Right, but if we simply change our headers and extend the struct, it will break
> > > all existing programs compiled against those headers. In order to avoid that, if
> > > we intend on extending this struct by appending to it, we need to have a
> > > backwards compatibility mechanism. Just having copy_struct_from_user isn't
> > > enough. The data structure either must be fixed size, or we need a way to handle
> > > multiple ioctl numbers derived from headers with different sized struct arguments
> > >
> > > The two approaches I see are:
> > > 1. use more indirection. This has previous art in drm[1]. That's look
> > > something like this:
> > >
> > > struct seccomp_notif_addfd_ptr {
> > > 	__u64 size;
> > > 	__u64 addr;
> > > }
> > >
> > > ... And then it'd be up to us to dereference the addr and copy struct from user.
> >
> > Do not go down that route. It isn't worth the pain.
> >
> > You should also assume that userspace might have a compile-time check
> > on the buffer length (I've written one - not hard) and that the kernel
> > might (in the future - or on a BSD kernel) be doing the user copies
> > for you.
> >
> > Also, if you change the structure you almost certainly need to
> > change the name of the ioctl cmd as well as its value.
> > Otherwise a recompiled program will pass the new cmd value (and
> > hopefully the right sized buffer) but it won't have initialised
> > the buffer properly.
> > This is likely to lead to unexpected behaviour.
> 
> Hmmm.
> 
> So, while initially I thought Sargun's observation about ioctl's fixed
> struct size was right, I think I've been swayed to Christian's view
> (which is supported by the long tail of struct size pain we've seen in
> other APIs).
> 
> Doing a separate ioctl for each structure version seems like the "old
> solution" now that we've got EA syscalls. So, I'd like to keep the size
> and copy_struct_from_user().

If the size is variable then why not get the application to fill
in the size of the structure it is sending at the time of the ioctl.

So you'd have:
#define xxx_IOCTL_17(param) _IOCW('X', 17, sizeof *(param))

The application code would then do:
	ioctl(fd, xxx_IOCTL_17(arg), arg);

The kernel code can either choose to have specific 'case'
for each size, or mask off the length bits and do the
length check later.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

