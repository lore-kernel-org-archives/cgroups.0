From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Date: Mon, 20 Aug 2012 21:47:15 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1208202122470.1286@eggly.anvils>
References: <20120816174453.154143248@napanee.usersys.redhat.com> <20120816174453.507922179@napanee.usersys.redhat.com> <20120816195831.GF24861@google.com> <alpine.LSU.2.00.1208192356580.24824@eggly.anvils> <20120820190039.GR25353@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=FjEslgJcox6zhkPy+UGovsQYjEaJebN4MqgI0Qyd7U4=;
        b=VRhbi1m1K+L5VCUF8sP9wRRFQHn9uYSFoDiDe4N1qh3n5OteXZX44xUbdVEsksTetW
         kjJE8fIwKPZpNTYa8IG8L+Zot/ep4yvIoeIGCVFwDUtMvE4Y0AfA71Qx7hAkx90d8prM
         GD2X8FLJ82cV0HbTMJj2GkDO0J85VP/JQIPtxWEVLQQuk9TnEWZvZB5dz0U8M3YRj0E2
         Z2YF+rdTZ0SGaYP5Dy9YReRkWWCxtmAFb3XPLGYWNb3QlrLzYBbkG3A6OISqgoBgzql6
         WFCo/PBgzkeibx7zXGl79V2radj03vf1xzR2YTKgNluddMup2BRYBNHQV2oX+c2cKL61
         gCiQ==
In-Reply-To: <20120820190039.GR25353-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, 20 Aug 2012, Aristeu Rozanski wrote:
> On Mon, Aug 20, 2012 at 12:10:09AM -0700, Hugh Dickins wrote:
> > Yes, it looks nice to me.  I might have preferred more as inlines in
> > the header file to lower the slight init/evict overhead, and I don't
> > see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
> > same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
> > of that matters:
> > 
> > Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> I can submit additional patches to fix these. What functions you want
> inlined?

Oh, thank you.  I was thinking that it's uncommon for tmpfs files to
have xattrs (and the same probably true of other filesystems), so it's
best to minimize xattrs impact on shared paths.  If simple_xattrs_init()
and simple_xattrs_free() can be static inline functions in linux/xattr.h,
that would be nice.

Probably more important would be to remove spin_lock() and spin_unlock()
(and INIT_LIST_HEAD) from simple_xattrs_free() - those are unnecessary
in shmem_evict_inode(), and wouldn't they be unnecessary whenever
simple_xattrs_free() gets called?

Hugh

> 
> On why __simple_xattr_set() is not using simple_xattr_alloc(), there's
> no reason to be that way, I missed it.
> 
> Thanks for reviewing!
> 
> -- 
> Aristeu
> 
> 
