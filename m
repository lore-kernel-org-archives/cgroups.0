From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Date: Thu, 23 Aug 2012 15:58:26 -0400
Message-ID: <20120823195826.GB18688@redhat.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174454.087507415@napanee.usersys.redhat.com>
 <20120816200006.GG24861@google.com>
 <50340110.50607@redhat.com>
 <20120821214856.GC32596@google.com>
 <alpine.LSU.2.00.1208211606580.2383@eggly.anvils>
 <20120823194423.GC14962@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120823194423.GC14962-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Aug 23, 2012 at 12:44:23PM -0700, Tejun Heo wrote:
> Hello, Hugh.
> 
> On Tue, Aug 21, 2012 at 04:29:53PM -0700, Hugh Dickins wrote:
> > Are we expecting Aristeu+Zefan's simple_xattr patches to go into 3.7?
> 
> Yeah, probably.
> 
> > I don't have anything planned for shmem.c for 3.7 beyond a bugfix,
> > which shouldn't interact with the simple_xattr changes at all
> > (I could remove info->lock, but will not do so this time around,
> > precisely so as not to interfere with those patches).
> > 
> > So it should be perfectly workable for you to take Aristeu+Zefan's
> > shmem patches into your cgroup tree, then any further mods from
> > mmotm will get layered on top.
> 
> I think this approach would be simpler.  Once Aristeu posts the
> updated version, I'll route the whole series through cgroup/for-3.7.

I'm about to submit it, just doing last build and testing round. Merged
back the changes Hugh asked in patch 1.

Also found why the list reinitialization was needed in the past; one of
the old iterations had a bug in the remount code and was cleaning the
xattrs out of the cgroup directory but not actually removing the
directory, thus new xattrs got added to a list of freed xattrs.

So I believe we're good to go.

-- 
Aristeu
