From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Tue, 24 Jan 2012 09:17:27 +0200
Message-ID: <20120124071727.GA22292@shutemov.name>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
 <20120123211218.GF23916@ZenIV.linux.org.uk>
 <20120123230457.GA14347@shutemov.name>
 <20120123231239.GH23916@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120123231239.GH23916@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, serge@hallyn.com, daniel.lezcano@free.fr, pjt@google.com, mzxreary@0pointer.de, xemul@parallels.com, James.Bottomley@HansenPartnership.com, tj@kernel.org, eric.dumazet@gmail.com

On Mon, Jan 23, 2012 at 11:12:39PM +0000, Al Viro wrote:
> On Tue, Jan 24, 2012 at 01:04:57AM +0200, Kirill A. Shutemov wrote:
> > On Mon, Jan 23, 2012 at 09:12:19PM +0000, Al Viro wrote:
> > > This is bloody ridiculous; if you want to prevent a luser adming playing with
> > > the set of mounts you've given it, the right way to go is not to mess with the
> > > "which fs types are allowed" but to add a per-namespace "immutable" flag.
> > > And add a new clone(2)/unshare(2) flag, used only along with the CLONE_NEWNS
> > > and setting the "immutable" on the copied namespace.
> > 
> > How will it work if we want to allow namespaced environment to mount block
> > devices, but not, let say, debugfs?
> > 
> > Differentiation between filesystem type and source is one of broken things
> > in Unix API.
> 
> Translation, please?

mount(2) should take a file descriptor and mount it to a mountpoint. File
descriptor provides known interface at that point (9p?). It doesn't matter
here what's the actual type of filesystem or what's the source (no fake
names for sources of pseudo-fs).

> > I don't see an easy way to fix it. Only plan9. :)
> 
> Huh?  Plan 9 does *not* contain anything of that kind. And their '#<letter>'
> convention for in-kernel filesystems is one of the uglier things about their
> API, IMO...

Yes, it's ugly. But in plan9 it can be fixed quite straight forward:
- kernel provides a way to boot to an early userspace environment without
  access to any media (initrd);
- kernel provides *one* '#<letter>' fs which contains handles to create
  any other in-kernel filesystems. This special fs can be mounted only
  once. After that you have (about) all resources as files and can
  construct any other environment using mount and bind.

In fact, list of available (pseudo-)filesystems is yet another resource
namespace. With approach above we can get rid of it in plan9.

-- 
 Kirill A. Shutemov
