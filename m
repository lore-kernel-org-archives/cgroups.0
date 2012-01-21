From: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Sat, 21 Jan 2012 04:02:04 +0100
Message-ID: <20120121030204.GE2100@tango.0pointer.de>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
 <20120118213638.GA21533@google.com>
 <20120119014727.GG29242@tango.0pointer.de>
 <20120119022005.GG21533@google.com>
 <20120119024021.GI21533@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120119024021.GI21533-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, 18.01.12 18:40, Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:

> 
> On Wed, Jan 18, 2012 at 06:20:05PM -0800, Tejun Heo wrote:
> > Hello, Lennart, Li.
> > 
> > Two things.
> > 
> > * Probably I'm missing something but isn't the systemd cgroup
> >   hierarchy already managed by systemd?  If so, I don't see how
> >   managing tmpfs on the side would noticeably make things more
> >   fragile.  It would take a bit more care after, for example, restart
> >   but it shouldn't be too complex, no?
> > 
> > * FS attributes already being used for userland information seems like
> >   a good argument, but we shouldn't add separate specialized xattr
> >   implementation to different pseudo filesystems.  For it to be
> >   acceptable, it should be a libfs thing easily applicable to any
> >   pseudo FS and definitely shouldn't be using kmem for storage.
> 
> Also note that tmpfs also implies size limit.  We definitely need some
> form of control over the amount of memory xattr may consume.

Good point. But then again we don't even have anything resembling for
tmpfs either, where it would be much more important... :-(

Given that cgroupfs is probably mostly read-only for normal users, the
requirement for quotas on it is probably much less important than for tmpfs
though.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
