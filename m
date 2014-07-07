From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.17] cgroup, blkcg, memcg: make blkcg
 depend on memcg on unified hierarchy
Date: Mon, 7 Jul 2014 14:33:29 -0400
Message-ID: <20140707183329.GC1149@cmpxchg.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=2rsC9Atn8wHHu5PENPmwXqRiw4I0HWj3poxIFLimLbY=;
	b=IkEDzZJc8qYWdc+r0aT2WulT556VIAMReOl6AWOLDjoL9c/h5uEyO6RJXGkHDjB0Yk3tz4hYzzVKlwaEGXrf/7r8DNOWAKA6ze6ancQ+UDbURQPxNGqJnR9J30rEj/r3jh/dLKY73wKZ7JXAbNTngI4eBbdafdTct/XG4ZmFMsI=;
Content-Disposition: inline
In-Reply-To: <1403917392-32555-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Fri, Jun 27, 2014 at 09:03:06PM -0400, Tejun Heo wrote:
> Hello, guys.
> 
> Currently, the blkio subsystem attributes all of writeback IOs to the
> root.  One of the issues is that there's no way to tell who originated
> a writeback IO from block layer.  Those IOs are usually issued
> asynchronously from a task which didn't have anything to do with
> actually generating the dirty pages.  The memory subsystem, when
> enabled, already keeps track of the ownership of each dirty page and
> it's desirable for blkio to piggyback instead of adding its own
> per-page tag.
> 
> This can be achieved on the unified hierarchy without too much
> difficulty.  This patchset implements a dependency mechanism in the
> cgroup such that a subsystem can depends on other subsystems.  If
> available, the depended-upon subsystems are enabled together
> implicitly when the subsystem is turned on.  Implicitly enabled
> subsystems are invisible and the dependencies are transparent to
> userland.
>
> This patchset implements the dependency mechanism in cgroup core and
> make blkcg depend on memcg.  This doesn't actually solve the writeback
> problem yet but is an important step.
> 
> This patchset contains the following six patches.
> 
>  0001-cgroup-reorganize-cgroup_subtree_control_write.patch
>  0002-cgroup-introduce-cgroup-subtree_control.patch
>  0003-cgroup-make-interface-files-visible-iff-enabled-on-c.patch
>  0004-cgroup-implement-cgroup_subsys-css_reset.patch
>  0005-cgroup-implement-cgroup_subsys-depends_on.patch
>  0006-blkcg-memcg-make-blkcg-depend-on-memcg-on-the-defaul.patch

These look good to me.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

We can update memcg's ->css_reset() as we re-populate the interface in
the default hierarchy.
