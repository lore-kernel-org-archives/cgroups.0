From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Date: Mon, 20 Aug 2012 15:00:39 -0400
Message-ID: <20120820190039.GR25353@redhat.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174453.507922179@napanee.usersys.redhat.com>
 <20120816195831.GF24861@google.com>
 <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208192356580.24824-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Aug 20, 2012 at 12:10:09AM -0700, Hugh Dickins wrote:
> Yes, it looks nice to me.  I might have preferred more as inlines in
> the header file to lower the slight init/evict overhead, and I don't
> see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
> same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
> of that matters:
> 
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I can submit additional patches to fix these. What functions you want
inlined?

On why __simple_xattr_set() is not using simple_xattr_alloc(), there's
no reason to be that way, I missed it.

Thanks for reviewing!

-- 
Aristeu
