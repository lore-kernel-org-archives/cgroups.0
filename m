From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Tue, 17 Jan 2012 09:53:22 -0800
Message-ID: <20120117175322.GC6762@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2C0+CXFyoZsIZnNqThSHfo34Au+EPqCX7dRNr08NeSY=;
        b=eltc0d2PTcIzFOxcqqfal81GT49av/vpAZ8Rlhn2tKCGxdS+HsSb+s4Jt7ykmtS0Fm
         BwzJyf0sX0db3JvWrXpbDM49bfqFyF6xgWeuQ/ZzatTCgLc/lNPhsiWQBCJibSk6nJHH
         4bG79kjmJmFoGBvGVAuAYRvFJ2BkrH3H6hZfQ=
Content-Disposition: inline
In-Reply-To: <4F13DAA9.4070703-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

Hello,

On Mon, Jan 16, 2012 at 04:07:05PM +0800, Li Zefan wrote:
> This is one of the items in the plumber's wish list.
> 
> For use cases:
> 
> >> What would the use case be for this?
> >
> > Attaching meta information to services, in an easily discoverable
> > way. For example, in systemd we create one cgroup for each service, and
> > could then store data like the main pid of the specific service as an
> > xattr on the cgroup itself. That way we'd have almost all service state
> > in the cgroupfs, which would make it possible to terminate systemd and
> > later restart it without losing any state information. But there's more:
> > for example, some very peculiar services cannot be terminated on
> > shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
> > services in question could just mark that on their cgroup, by setting an
> > xattr. On the more desktopy side of things there are other
> > possibilities: for example there are plans defining what an application
> > is along the lines of a cgroup (i.e. an app being a collection of
> > processes). With xattrs one could then attach an icon or human readable
> > program name on the cgroup.
> >
> > The key idea is that this would allow attaching runtime meta information
> > to cgroups and everything they model (services, apps, vms), that doesn't
> > need any complex userspace infrastructure, has good access control
> > (i.e. because the file system enforces that anyway, and there's the
> > "trusted." xattr namespace), notifications (inotify), and can easily be
> > shared among applications.
> >
> > Lennart
> 
> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Ummm... I don't feel too good about this.  Why can't those extra
information be kept somewhere else?  Overloading cgroupfs as storage
for essentially opaque userland information doesn't seem like a good
idea to me.

Thanks.

-- 
tejun
