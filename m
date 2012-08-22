From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Date: Wed, 22 Aug 2012 16:07:46 -0400
Message-ID: <20120822200746.GD16951@redhat.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174453.507922179@napanee.usersys.redhat.com>
 <20120816195831.GF24861@google.com>
 <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
 <20120820190039.GR25353@redhat.com>
 <alpine.LSU.2.00.1208202122470.1286@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208202122470.1286-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Aug 20, 2012 at 09:47:15PM -0700, Hugh Dickins wrote:
> On Mon, 20 Aug 2012, Aristeu Rozanski wrote:
> > On Mon, Aug 20, 2012 at 12:10:09AM -0700, Hugh Dickins wrote:
> > > Yes, it looks nice to me.  I might have preferred more as inlines in
> > > the header file to lower the slight init/evict overhead, and I don't
> > > see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
> > > same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
> > > of that matters:
> > > 
> > > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > I can submit additional patches to fix these. What functions you want
> > inlined?
> 
> Oh, thank you.  I was thinking that it's uncommon for tmpfs files to
> have xattrs (and the same probably true of other filesystems), so it's
> best to minimize xattrs impact on shared paths.  If simple_xattrs_init()
> and simple_xattrs_free() can be static inline functions in linux/xattr.h,
> that would be nice.

ok, done. and since Tejun is waiting for those before integrating, I'll
merge them in the original patches and resubmit everything.

> Probably more important would be to remove spin_lock() and spin_unlock()
> (and INIT_LIST_HEAD) from simple_xattrs_free() - those are unnecessary
> in shmem_evict_inode(), and wouldn't they be unnecessary whenever
> simple_xattrs_free() gets called?

Removing INIT_LIST_HEAD() it's possible by actually unlinking each xattr
inside the loop before freeing them. still, it'll have to check if the list is
empty or not, which might end up being the same?

About the locking, I'm not sure, I'm investigating it.

-- 
Aristeu
