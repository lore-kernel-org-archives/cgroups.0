From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: iterate cgroup_subsys_states
 directly
Date: Fri, 16 May 2014 12:08:35 -0400
Message-ID: <20140516160835.GE5379@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=AyeEiNMP07cMgW8ZvUEumsn5dB/ZP8cyaSdf4+bXkCo=;
        b=Sf/dRoh9kKTpFwmckP+l8IXe+o6LsuUmKsPjeO/EboKJox6eOY7vgsl2aMGsRaTeVy
         RYFDWJGpyk4fAZwYjCgGcHTfyGLRiyYRll4sa3Vd6zg/B+3M78LNyYDaNq7XM11bZM3U
         Dr++w7t2UwKxVDkaANIzj7w1f/nM47zsIL7KKT8439lluD5syTrbsjFboHopDfycfkdz
         Vea2uYsUF4HWQ12rV8znE87wbYQTsBHWTXPjAjmfWd48cBmkkMPrlqR/34QNaWcDFiEX
         sJaQFD4p22rdIqN/jXZhFf+UYfWT5VzWIXIoUSk4gqtM2Ax+4eGG6lSozOWgWbytgaAN
         xJTQ==
Content-Disposition: inline
In-Reply-To: <1399671091-23867-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

On Fri, May 09, 2014 at 05:31:17PM -0400, Tejun Heo wrote:
> Hello,
> 
> Currently, while csses (cgroup_subsys_states) have ->parent linkage
> too, only cgroups form full tree through their ->children and
> ->sibling fields and css iterations naturally is implemented by
> iterating cgroups and then dereferencing the css for the specified
> subsystem.
> 
> There are now use cases where controllers need to iterate through
> csses regardless of their online state as long as they have positive
> reference.  This can't easily be achieved by iterating cgroups because
> its css pointer array needs to be cleared on offline and there may be
> multiple dying csses for a cgroup for the same subsystem and there's
> only one pointer per cgroup-subsystem pair.
> 
> This patchset moves ->children and ->sibling from cgroup to css and
> link all csses in proper trees and then make css iterators walk csses
> directly instead of going through cgroups.  This achieves iteration of
> all non-released csses while also simplifying the iteration
> implementation.  This is also in line with the general direction of
> using csses as the primary structural component.
> 
> This patchset contains the following fourteen patches.
> 
>  0001-cgroup-remove-css_parent.patch
>  0002-cgroup-remove-pointless-has-tasks-children-test-from.patch
>  0003-memcg-update-memcg_has_children-to-use-css_next_chil.patch
>  0004-device_cgroup-remove-direct-access-to-cgroup-childre.patch
>  0005-cgroup-remove-cgroup-parent.patch
>  0006-cgroup-move-cgroup-sibling-and-children-into-cgroup_.patch
>  0007-cgroup-link-all-cgroup_subsys_states-in-their-siblin.patch
>  0008-cgroup-move-cgroup-serial_nr-into-cgroup_subsys_stat.patch
>  0009-cgroup-introduce-CSS_RELEASED-and-reduce-css-iterati.patch
>  0010-cgroup-iterate-cgroup_subsys_states-directly.patch
>  0011-cgroup-use-CSS_ONLINE-instead-of-CGRP_DEAD.patch
>  0012-cgroup-convert-cgroup_has_live_children-into-css_has.patch
>  0013-device_cgroup-use-css_has_online_children-instead-of.patch
>  0014-cgroup-implement-css_tryget.patch

Applied to cgroup/for-3.16 with the minor updates to accomodate
CSS_NO_REF.

Thanks.

-- 
tejun
