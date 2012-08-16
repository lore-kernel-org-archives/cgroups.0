From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Date: Thu, 16 Aug 2012 12:58:31 -0700
Message-ID: <20120816195831.GF24861@google.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174453.507922179@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dPyq0ZtBHMwOawOlI/6L29XN/efGu4bu+8Q9vgYj4dQ=;
        b=dAm9XP+hvqEOtL7Ug9ryTa+BsuknJikwxP9ubzRNKKxRRwpWBEHBpzBJfs2PDsVHQU
         zuK/8r/5z/0Dk62+9TQvSczjWReGBqD2PmadhbPyc4Z1tdAaSPjVnE7yJfVPHI0ikcPm
         VvdbyM8/7CswUezCY4KnYLFprl0wvJayFD/qYUrVAeIih741Zz+VAK7WJtbJDdFDbFkj
         qDtgHByzCBxjPMpqYxnHQHjCU5boUPYq9yAMRgz7kl8Ob1LG6dOmpC/B1z0dOTQ9Iz3h
         GwJbG1OUQWMU+2VRweRJ+0047qGsmA6RTe92/wiG5LeuAO2JiIZ6oKX5rPIJzDFNpR06
         0jVA==
Content-Disposition: inline
In-Reply-To: <20120816174453.507922179-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Aug 16, 2012 at 01:44:54PM -0400, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
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

Hugh, can you please review and ack this one?

Thanks.

-- 
tejun
