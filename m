From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/4] xattr: extract simple_xattr code from tmpfs
Date: Fri, 24 Aug 2012 09:14:35 -0400
Message-ID: <20120824131435.GC18688@redhat.com>
References: <20120823205327.237533518@napanee.usersys.redhat.com>
 <20120823205327.613311683@napanee.usersys.redhat.com>
 <alpine.LSU.2.00.1208231609240.5904@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208231609240.5904-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Aug 23, 2012 at 04:14:24PM -0700, Hugh Dickins wrote:
> I'm also happy to see that you're now using simple_xattr_alloc() in
> __simple_xattr_set() (but no need to respin to comment on that here).
> 
> It looks very nice: much better for this code to live in fs/xattr.c
> than in mm/shmem.c.

Thanks for the review and feedback!

-- 
Aristeu
