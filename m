From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Date: Wed, 22 Aug 2012 16:55:57 -0400
Message-ID: <20120822205556.GE16951@redhat.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174453.507922179@napanee.usersys.redhat.com>
 <20120816195831.GF24861@google.com>
 <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
 <20120820190039.GR25353@redhat.com>
 <alpine.LSU.2.00.1208202122470.1286@eggly.anvils>
 <20120822200746.GD16951@redhat.com>
 <alpine.LSU.2.00.1208221312540.1909@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208221312540.1909-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Aug 22, 2012 at 01:25:06PM -0700, Hugh Dickins wrote:
> > > Probably more important would be to remove spin_lock() and spin_unlock()
> > > (and INIT_LIST_HEAD) from simple_xattrs_free() - those are unnecessary
> > > in shmem_evict_inode(), and wouldn't they be unnecessary whenever
> > > simple_xattrs_free() gets called?
> > 
> > Removing INIT_LIST_HEAD() it's possible by actually unlinking each xattr
> > inside the loop before freeing them. still, it'll have to check if the list is
> > empty or not, which might end up being the same?
> > 
> > About the locking, I'm not sure, I'm investigating it.
> 
> I think we have a misunderstanding.
> 
> INIT_LIST_HEAD() is not expensive, I just meant to remove it because
> I thought it unnecessary by that point.

ah, I see.

> Do you envisage anywhere that would call simple_xattrs_free() except
> a filesystem's evict_inode()?

cgroup does it differently and it's called in d_iput() path (see cgroup_diput),
because it needs to selectively remove files upon remount.

> By that point, the inode is on its way out of the system: nothing
> much (yes, I am being a bit vague there ;) can get to it any more,
> there's no need to reinitialize the list head and there's no need for
> locking, because nothing else can be playing with those xattrs now.

I agree with you. That's why I'm looking into it because I'm pretty sure
I removed it at some point in the past and decided to put it back after
investigating the easily reproducible oops. Sadly I managed to forget
the analisys I did at the time.

-- 
Aristeu
