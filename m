From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
Date: Fri, 9 May 2014 15:50:59 -0400
Message-ID: <20140509195059.GE4486@htj.dyndns.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TFZ1II5+b0+9TsFrTRGHfi5a02ycMSuLouFCWKsqGH8=;
        b=N0rOUJTTfDTP29+2UY01cTgbPLd20xyjdEEqnEmunQgmzRvjqkWjP6WJO7XZkKALpS
         mgQNF8REnvFurIntpaRratuZYzWxlDi2heEG91fRh/00ctgEG7LNvVGuijLqh6+z53Ty
         R7uG+RJ1cu8Z9N6b2oi5cObRCgSbAEVMoaPPlJWxQWcQ7ilGt0KHk9BIsYYfr1ol8iv+
         IST8pLVLtkAjPhF2bMfB1fZ+2h870FkCLtDmPif2Xj2Yahx2MU61u+Ec227i3Q1wnEuo
         ITeOsIKHqq8ZaxzyfLjn9wNThS99W+GPR6OrT9xo8Pdma9x9nYiNCV1N9W6cYatzJF/e
         KFAA==
Content-Disposition: inline
In-Reply-To: <1399380266-3324-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 06, 2014 at 08:44:21AM -0400, Tejun Heo wrote:
> This patchset is on top of
> 
>   cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
> + [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates
> 
> and available on the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates

Refreshed without content change on top of

  b9a63d0116e8 ("Merge branch 'for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu into for-3.16")
+ [1] [PATCHSET v2 cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates

and available on the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates-v2

-- 
tejun

[1] http://lkml.kernel.org/g/1399663975-315-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
