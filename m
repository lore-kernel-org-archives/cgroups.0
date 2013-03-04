From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: no need to check css refs for release
 notification
Date: Mon, 4 Mar 2013 10:05:08 -0800
Message-ID: <20130304180508.GF30413@htj.dyndns.org>
References: <5130535F.7060201@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=17aAn/3zS/Hz8ybl9jg2+WSJXY1jVO7yD5GMBF+e0W0=;
        b=UP9ogOkIZ1nxMRgQJPurk7fPWYBANpLzZtdG6QjYY6fui2wualx4/zAIUXC3DqOAz4
         8ueyRlxqgAt4umaUat5ld6IVi0md+hB23ZaSRn23dEu9NZ1lr+Oc5/w8ZiLRoEyKZ5Zk
         T3XCpxrhCGl/JSri6mBtdjHygIvwZ+wXbb/uzRuearPbeGDEG0JHSR6Z/ZpLdiN30z+T
         RZDh1Ez61bjpOnbhud3PT/SUMn9vYjx3Vi4NEpeWUhE1OpkMCQCbsj4LyhWL385zkxtM
         1RX1M7xgFsL1UrTC6l7ryeUj0mt2hAmC4x0gyGWxp5S8Xh2AMHYEeqcXqgFaCdY6rGm1
         EC/g==
Content-Disposition: inline
In-Reply-To: <5130535F.7060201-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Mar 01, 2013 at 03:06:07PM +0800, Li Zefan wrote:
> We no longer fail rmdir() when there're still css refs, so we don't
> need to check css refs in check_for_release().
> 
> This also voids a bug. cgroup_has_css_refs() accesses subsys[i]
> without cgroup_mutex, so it can race with cgroup_unload_subsys().
> 
> cgroup_has_css_refs()
> ...
>   if (ss == NULL || ss->root != cgrp->root)
> 
> if ss pointers to net_cls_subsys, and cls_cgroup module is unloaded
> right after the former check but before the latter, the memory that
> net_cls_subsys resides has become invalid.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.10.

Thanks.

-- 
tejun
