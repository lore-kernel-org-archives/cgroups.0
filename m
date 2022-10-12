From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-6.1-fixes] mm: cgroup: fix comments for get
 from fd/file helpers
Date: Tue, 11 Oct 2022 22:06:13 -1000
Message-ID: <Y0Z1deLeePrNmdeu@slm.duckdns.org>
References: <20221011225155.4055415-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SBrtNGgiKc64ZJ37zUKu7nEMj/WdDGr4Yyp+sxihhTY=;
        b=K/T1u6SXP48sf76E+Em0jrB8E2jrFWVkXe5K4LWyyfdjCJGnBFHi9HpGgcAkW0dY26
         epUvWm7/I/Ec5Z4SIadzKcUySRzlhdF0e5pNtAwvEtt054Y1ZK8W/x1C/Z3rNoygrrii
         3gyEMWZ54SwI/DDueHBXXJkw1GkqDSZVmFGNtvhFBAuBPpO1oi+X/gvBFH2YeEDgpOaO
         XwrA3NhdNK1EBYcsU8vPCB83nkTlBVW+y/ADuBGG+HeZVzKwGdzbn8X8bQW3QqoC/Srd
         um5pWBqHwAN9O5lqa8bMOZiwHBuaa8qWKp5oO1CmbUoqB4F1Kq24Bvtnnvcg4K5mLREz
         WIkQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221011225155.4055415-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Oct 11, 2022 at 10:51:55PM +0000, Yosry Ahmed wrote:
> Fix the documentation comments for cgroup_[v1v2_]get_from_[fd/file]().
> 
> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> I cannot reproduce the warning so I cannot make sure it's fixed by this.
> 
> Again, apologies for missing updating the comment in the first place.

No worries at all. Thanks for fixing it. Applied to cgroup/for-6.1-fixes.

-- 
tejun
