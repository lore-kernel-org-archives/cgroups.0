From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 27/27] kernfs, sysfs, cgroup: Support fs_context [ver #5]
Date: Wed, 14 Jun 2017 13:54:26 -0400
Message-ID: <20170614175426.GA26229@htj.duckdns.org>
References: <149745330648.10897.9605870130502083184.stgit@warthog.procyon.org.uk>
 <149745355907.10897.10073768158664960494.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v280uzCBQT4/hoBaWNRELXt/nkL3dajzWTRs9hM5lH8=;
        b=KAt+uINqmffPmjFf7V0S2ENMl+qbDowvS28UFcO/kOiroGSIRwqTtru6FCnh5WS83a
         A/9DEPN1yVGm3vbl7d4Bo55fhEjetL1RspoCFti0KwA/9zO4uJSrOJzp/a1yEhKzJhLX
         TJMvpMwuYKI5/he0YicxqjOJdLG4Kga1JZjSC8Rou6RBUeOfkGPwxDmRH9kBMlW1xJx+
         /CdN+oxCtxbIkcI/LtASP1EbultJfdeGqK7duaFEEf5aejSDXCMeDP6kI1xWXOD2+nW0
         0DQsRDwbt+EbElxZ8pArRRdj/IrhLibnLIC7kI19DcKZO7cX4gZBrehJTuab/swxSfg7
         HODQ==
Content-Disposition: inline
In-Reply-To: <149745355907.10897.10073768158664960494.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, David.

On Wed, Jun 14, 2017 at 04:19:19PM +0100, David Howells wrote:
> Make kernfs support superblock creation/mount/remount with fs_context.
> 
> This requires that sysfs and cgroup, which are built on kernfs, be made to
> support fs_context also.

Can you please include a brief rationale for doing this and include a
pointer to the fuller description on what's going on?

> Weirdies:
> 
>  (*) cgroup_do_get_tree() calls cset_cgroup_from_root() with locks held,
>      but then uses the resulting pointer after dropping the locks.  I'm
>      told this is okay and needs commenting.

Yeah, will add the comment.

>  (*) The cgroup refcount web.  This really needs documenting.

If you're talking about the mount refcnt part, yeah, it's confusing to
me too and we definitely need to document it better.

>  (*) cgroup2 only has one root?

Yeap.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
