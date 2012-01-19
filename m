From: Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Thu, 19 Jan 2012 02:49:28 +0100
Message-ID: <20120119014928.GH29242@tango.0pointer.de>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <4F168266.3060205@cn.fujitsu.com>
 <20120118174732.GG30664@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120118174732.GG30664@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>

On Wed, 18.01.12 09:47, Tejun Heo (tj@kernel.org) wrote:

> 
> Hello,
> 
> On Wed, Jan 18, 2012 at 04:27:18PM +0800, Li Zefan wrote:
> > Furthermore, I noticed tmpfs also implemented xattr support, and we
> > should be able to share most of the code, which makes the cost for
> > having this feature smaller.
> 
> Yes, maybe, but tmpfs doesn't have any special semantics attached to
> files.  It's supposed to store opaque data from userland.  Regardless
> of code complexity, I just don't think this is a good idea.  What if
> we later want to attach certain config meaning to or export statistics
> via xattrs?  That would be quite unusual and require strong rationale
> but at least fall in the similar usage as with the rest of the fs.

If you plan to export kernel data to userspace via xattrs, then you
should probably place that in the system.xxx xattr namespace, not in
the user.xxx or trusted.xxx namespaces which are the only ones which can
be manipulated by userspace.

See attr(5) for more information about the four available xattr
namespaces.

In other words: kernel exported xattrs should never collide with xattrs
set by userspace.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
