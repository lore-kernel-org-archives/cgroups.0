From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Date: Mon, 20 Aug 2012 00:10:09 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
References: <20120816174453.154143248@napanee.usersys.redhat.com> <20120816174453.507922179@napanee.usersys.redhat.com> <20120816195831.GF24861@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=ntDbGfBi/k3Wh+hHWsFVGtHKp90/jIpy65XWUCTZisQ=;
        b=URtApDk8clhc1mpX3ykYaiFhe7+rLBhz89bNwXXUHwT1drit65O47FEJKmGl5FU9M3
         0lDHvAWa8SZtA/Dq3issNhHhdrCS72G1vqhiIFNZVhgnuDhsxyt0THX88YgIFMDkhHMw
         Yy24O5DViyk66CN25AaoP+/xf4NFHNQMnn5qPQB7rtSZFoJSJpUFohfgw6l5qK0pkqbc
         A65tw124rDvy5ypJPt4lscPtzZnioJf2oOSGcKSFi9ph3E0YhgCmy8YZ+/WIiKSJNAVH
         82rZwZXSsdQN1B0m/IYaGjCg/Hkpec8lMqxUIk1f7LOrUcETbQjL0WqFMN4QfhiB/Zm+
         rr0g==
In-Reply-To: <20120816195831.GF24861-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, 16 Aug 2012, Tejun Heo wrote:
> On Thu, Aug 16, 2012 at 01:44:54PM -0400, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > Extract in-memory xattr APIs from tmpfs. Will be used by cgroup.
> > 
> > $ size vmlinux.o
> >    text    data     bss     dec     hex filename
> > 4658782  880729 5195032 10734543         a3cbcf vmlinux.o
> > $ size vmlinux.o
> >    text    data     bss     dec     hex filename
> > 4658957  880729 5195032 10734718         a3cc7e vmlinux.o
> > 
> > v6:
> > - no changes
> > v5:
> > - no changes
> > v4:
> > - move simple_xattrs_free() to fs/xattr.c
> > v3:
> > - in kmem_xattrs_free(), reinitialize the list
> > - use simple_xattr_* prefix
> > - introduce simple_xattr_add() to prevent direct list usage
> > 
> > Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Hugh, can you please review and ack this one?

Yes, it looks nice to me.  I might have preferred more as inlines in
the header file to lower the slight init/evict overhead, and I don't
see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
of that matters:

Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
