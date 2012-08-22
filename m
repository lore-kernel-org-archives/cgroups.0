From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Date: Wed, 22 Aug 2012 13:25:06 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1208221312540.1909@eggly.anvils>
References: <20120816174453.154143248@napanee.usersys.redhat.com> <20120816174453.507922179@napanee.usersys.redhat.com> <20120816195831.GF24861@google.com> <alpine.LSU.2.00.1208192356580.24824@eggly.anvils> <20120820190039.GR25353@redhat.com>
 <alpine.LSU.2.00.1208202122470.1286@eggly.anvils> <20120822200746.GD16951@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=x3wR7NmHzpk2ADtJtyFap04+ArOjcqLk8JImsEr5qTg=;
        b=nnw4dFqO18f5+WgN+EP4YHRPztYbGo6d4Uhu/We//DYW9ha+w7SotFp/HIVAXgGiZB
         U2/Nv7d5FDaYx/s86vAJW2WNVATXaItQ8EmsnC51lib279hydRgzI2Mk46b8w6LcBjrR
         5ZeyylKSVU4MBnjTRLT/rj+rbTcPVI7vbNnFyX7BaCF5svaMC0+E0Y6cBkyXqavIz6ca
         oqC06kzYcnTIGnUO7jqjPq9oQADnAv6GoM6uQRYEbXA4YKyNqT9fnLvmvtZiImJzShqS
         ylubyv4mVUJx6ksrnVHRKCzwyrQFP5OJ+xA8cFBe6gSVvkF8FWyNV0tB956T68pqGZi/
         WpvA==
In-Reply-To: <20120822200746.GD16951-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, 22 Aug 2012, Aristeu Rozanski wrote:
> On Mon, Aug 20, 2012 at 09:47:15PM -0700, Hugh Dickins wrote:
> > On Mon, 20 Aug 2012, Aristeu Rozanski wrote:
> > > On Mon, Aug 20, 2012 at 12:10:09AM -0700, Hugh Dickins wrote:
> > > > Yes, it looks nice to me.  I might have preferred more as inlines in
> > > > the header file to lower the slight init/evict overhead, and I don't
> > > > see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
> > > > same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
> > > > of that matters:
> > > > 
> > > > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > 
> > > I can submit additional patches to fix these. What functions you want
> > > inlined?
> > 
> > Oh, thank you.  I was thinking that it's uncommon for tmpfs files to
> > have xattrs (and the same probably true of other filesystems), so it's
> > best to minimize xattrs impact on shared paths.  If simple_xattrs_init()
> > and simple_xattrs_free() can be static inline functions in linux/xattr.h,
> > that would be nice.
> 
> ok, done. and since Tejun is waiting for those before integrating, I'll
> merge them in the original patches and resubmit everything.

Thanks.

> 
> > Probably more important would be to remove spin_lock() and spin_unlock()
> > (and INIT_LIST_HEAD) from simple_xattrs_free() - those are unnecessary
> > in shmem_evict_inode(), and wouldn't they be unnecessary whenever
> > simple_xattrs_free() gets called?
> 
> Removing INIT_LIST_HEAD() it's possible by actually unlinking each xattr
> inside the loop before freeing them. still, it'll have to check if the list is
> empty or not, which might end up being the same?
> 
> About the locking, I'm not sure, I'm investigating it.

I think we have a misunderstanding.

INIT_LIST_HEAD() is not expensive, I just meant to remove it because
I thought it unnecessary by that point.

Do you envisage anywhere that would call simple_xattrs_free() except
a filesystem's evict_inode()?

By that point, the inode is on its way out of the system: nothing
much (yes, I am being a bit vague there ;) can get to it any more,
there's no need to reinitialize the list head and there's no need for
locking, because nothing else can be playing with those xattrs now.

If I'm wrong, then the current shmem_evict_inode() is already wrong
not to be locking there.

Would renaming simple_xattrs_free() to simple_xattrs_evict() help?

Hugh
