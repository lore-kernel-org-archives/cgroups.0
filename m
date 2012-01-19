From: Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Thu, 19 Jan 2012 02:47:27 +0100
Message-ID: <20120119014727.GG29242@tango.0pointer.de>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
 <20120118213638.GA21533@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120118213638.GA21533@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Wed, 18.01.12 13:36, Tejun Heo (tj@kernel.org) wrote:

> 
> Hello,
> 
> On Wed, Jan 18, 2012 at 10:28:42PM +0100, Kay Sievers wrote:
> > The idea with the cgroup fs xattrs was to be able to attach some
> > general useful attributes to the 'service container' itself, instead
> > of keeping them in the memory of the managing process or store them on
> > disk which can get out-of-sync much easier.
> 
> Hmmm.... I can see the attraction but there really is nothing which
> binds that information to cgroup.  The same information might as well
> live in /proc/PID/userland_data or whatever.  It may be convenient now
> but I'm pretty skeptical it's a good idea in the long run.
> 
> Given that cgroups themselves need to be explicitly created and
> destroyed, maintaining a parallel tmpfs hierarchy for metadata, if
> necessary, shouldn't be too bothersome, right?

Well, the interesting bit here is that to make things robust we'd like
to attach the meta information userspace needs to the object itself, so
that it follows the same lifecycle, and we can detect changes to it with
the usual APIs such as inotify, without any complex logic in userspace
that tries to ensure that meta data stored elsewhere is always kept in
sync with what cgroups are currently around.

I mean, certainly, it's possible to store this data elsewhere, and
that's what all current cgroup client code does, including systemd for
example. But ultimately that is very fragile and cumbersome, since it
requires us to proxy all cgroup events to this meta information,
emulating in userspace that we align the lifecycles of cgroups with the
lifecycle of its metadata. It also makes it necessary to define new
userspace APIs if we want different userspace components to share meta
data on cgroups (and we do want to share metadata!), which is always
difficult, and would look an awful lot like xattrs without actually
being xattrs, but just suck as they'd be a userspace emulation of the
real thing with all the complexities and problems it creates, for
example the fact that they'd userspace emulated xattrs can only
asynchronously follow the lifecycle of their cgroup, thus creating races
one has to deal with and so on. Also, proper xattrs can distuingish
"trusted.xxx" and "user.xxx" namespaces which influences access control
on the xattr. Something like that is very useful but really hard to
emulate without kernel support.

In summary: we want to be able to hook into the lifecycle of the cgroup
right to make things robust. We want the xattrs to synchronously follow
the lifecycle. We want a simple API that's already used for the same
purpose on files. We don't want to to have to intrdouce fragile
userspace code, that deals with races, and robustness, if we can
trivially benefit from code that mostly already exists in the kernel.

Note that there already are a couple of attributes of cgroups userspace
manipulates to encode meta data about services, for example via the
mode/uid/gid of the cgroup dir and the tasks file. And people are
actually already encoding information into those which better should be
stored elsewhere, i.e. in my opinion the best place would be xattrs.

But yeah, to clarify this: this feature can be emulated in userspace, so
this is not about making things possible that previously weren't. It's
mostly about making things clean, safe, and robust which they previously
weren't, without introducing non-trivial additional userspace components
and interfaces.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
