From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 0/4] fix depvpts in user namespaces
Date: Sun, 17 Mar 2013 22:20:52 -0500
Message-ID: <20130318032052.GA5958@sergelap>
References: <1363338823-25292-1-git-send-email-glommer@parallels.com>
 <87boalt0vi.fsf@xmission.com>
 <20130315140040.GB3782@sergelap>
 <5143333E.1040100@parallels.com>
 <20130315152133.GB24305@sergelap>
 <51433DBE.9020109@parallels.com>
 <87txoce5qy.fsf@xmission.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87txoce5qy.fsf@xmission.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com, Serge Hallyn <serge.hallyn@canonical.com>, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Glauber Costa <glommer@parallels.com> writes:
...
> > What it a /dev/ptmx already exist? will it use it? That would be bad,
> > since that /dev/ptmx could be a host-side one. I actually believe
> > linking to $rootfs/dev/pts/ptmx is more robust than my solution against
> > remounts. So provided it can guarantee that the ptmx is not ever the
> > root ptmx, I would ack that.
> 
> For those playing with udev, especially older udev where udev is still
> udev and creates devices you can use the following udev rule to create
> the pts/ptmx symlink.
> 
> KERNEL=="ptmx" NAME:="pts/ptmx" SYMLINK="ptmx"
> 
> Before we do anything clever in the kernel it is definitely worth seeing
> how far we can take that little udev rule.

Before it was decided that it was ok to modify core packages to
accomodate containers, we had to install (non-standard) init jobs to
detect it was in a container and if so modify some behavior - for
instance to bind-mount a smaller /lib/init/fstab so that mountall
wouldn't try to mount some things.  That way the rootfs had to be
updated to run in a container, but could then still be used as a
rootfs for non-containers.

...

> As much as I hate the notion I suspect for most of device management
> what we want is to act like devtmpfs, and run all of the device node
> creation etc outside of the container (possibly even with bind mounts).

So you mean a task which is unprivileged on the host, privileged wrt the
container, and on host fs namespace, which bind mounts the host /dev
files into the container?

> Acting like devtmpfs should be something that is possible with no kernel
> changes.   Whereas allowing unprivileged processes to create device
> nodes probably has issues I haven't thought of yet.

Not sure what 'acting like devtmpfs' means (especially in contrast to
acting like udev) - maybe i need to go look at the code.

-serge
