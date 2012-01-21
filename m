From: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Sat, 21 Jan 2012 03:59:46 +0100
Message-ID: <20120121025946.GD2100@tango.0pointer.de>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
 <20120118213638.GA21533@google.com>
 <20120119014727.GG29242@tango.0pointer.de>
 <20120119022005.GG21533@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120119022005.GG21533-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, 18.01.12 18:20, Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:

Heya,

> * Probably I'm missing something but isn't the systemd cgroup
>   hierarchy already managed by systemd?  If so, I don't see how
>   managing tmpfs on the side would noticeably make things more
>   fragile.  It would take a bit more care after, for example, restart
>   but it shouldn't be too complex, no?

Well, it becomes more complex, for example, if we miss a cgroups event,
or we go away and come back (i.e. systemd can reexecute itself for
upgrades), and as soon as it isn't just systemd anymore which needs meta
data attached to a cgroup, but we need something shared. For example,
the logic described in
http://www.freedesktop.org/wiki/Software/systemd/PaxControlGroups
regarding "persistant" cgroups would be much nicer using xattrs (it
currently misuses the sticky bit as flag instead).

It's just much nicer if meta data doesn't get stale just because the
process owning it goes awol. And if process want to share meta data, too.
 
> * FS attributes already being used for userland information seems like
>   a good argument, but we shouldn't add separate specialized xattr
>   implementation to different pseudo filesystems.  For it to be
>   acceptable, it should be a libfs thing easily applicable to any
>   pseudo FS and definitely shouldn't be using kmem for storage.

I think the code that was recently added to tmpfs for the same purposes
was supposed to be reusable on other virtual file systems. Might be
worth looking into that.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
