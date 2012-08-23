From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/4] xattr: extract simple_xattr code from tmpfs
Date: Thu, 23 Aug 2012 16:14:24 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1208231609240.5904@eggly.anvils>
References: <20120823205327.237533518@napanee.usersys.redhat.com> <20120823205327.613311683@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=MqFCEVzY7gvFYMT0aO6EGFJZldyV69+HRUPeq5O4VZI=;
        b=OdAhC6g0qUifzwnbHb551XG1m1X9p0sWBOFCVY1ycDmV9x49IdrjEDfIdICwibK40j
         id7euvDxsci+ED+EUQRpJ5CPdQYa1ePnG7d+m90hmzPefYzyvW552sCkJFQp8czoW4Wt
         luhBSMpNukf9hVmfIQRYJBFGcZEkJrKJF953W84uEoyEK2+wfyMVbc1HeffTFf+he/MO
         1H0SE9qKrtNXfYG8ItdT7kEBySDOQHfWcBndNcKaSlCo/fjwPtcakz9V6x+fcAmx7U8Y
         zhYsOH+cJBY/A/VX9HIj4Fhqn/q79d+WlRnKYcepGEYyjnh3zOO5dRuCwVe5EYh7oasw
         oqKQ==
In-Reply-To: <20120823205327.613311683-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, 23 Aug 2012, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Extract in-memory xattr APIs from tmpfs. Will be used by cgroup.
> 
> $ size vmlinux.o
>    text    data     bss     dec     hex filename
> 4658782  880729 5195032 10734543         a3cbcf vmlinux.o
> $ size vmlinux.o
>    text    data     bss     dec     hex filename
> 4658957  880729 5195032 10734718         a3cc7e vmlinux.o
> 
> v7:
> - checkpatch warnings fixed
> - Implement the changes requested by Hugh Dickins:
> 	- make simple_xattrs_init and simple_xattrs_free inline
> 	- get rid of locking and list reinitialization in simple_xattrs_free,
> 	  they're not needed

Thanks for doing those.

I'm also happy to see that you're now using simple_xattr_alloc() in
__simple_xattr_set() (but no need to respin to comment on that here).

It looks very nice: much better for this code to live in fs/xattr.c
than in mm/shmem.c.

> v6:
> - no changes
> v5:
> - no changes
> v4:
> - move simple_xattrs_free() to fs/xattr.c
> v3:
> - in kmem_xattrs_free(), reinitialize the list
> - use simple_xattr_* prefix
> - introduce simple_xattr_add() to prevent direct list usage
> 
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> Cc: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
