From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/10] cgroup: don't print subsystems for the default
 hierarchy
Date: Tue, 18 Aug 2015 14:01:24 -0700
Message-ID: <20150818210124.GD15739@mtj.duckdns.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
 <1437763434-28699-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fGRTr0oQc7tRFWN/nT2Dxhh6P7IdMeyE5N+1kFi65bA=;
        b=xbYqY38/76O+dLP0cQ34VAXgJIp36yyc+caujIt8jH7EeAgZWHsdZnAa3pFTCHnAc7
         XZ0xz4ilgs0JuS94g71YyyvPBDRTEiyfIUtV9A1MVPW0d0xBvOTVQxTNZpCZ6VQ26jnD
         pSjhl06w6LpiK8nAvu3mFawCmy2ydK4k+5pjt72KIN/nskX/cXthPEfYk8fzsB/nenPG
         VhBfw6ph5eur34BdxQMl7zh8Cf4/2/I4Pv+rY4NobBksICXCKyRqjR859VtRSSvlhFGj
         HSldqH90tukSnieFlBJXZifRYbpOx7HiMyhJdX+E/fMJj5ehsRMrybptMyCD03b5Blo1
         mzkg==
Content-Disposition: inline
In-Reply-To: <1437763434-28699-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 24, 2015 at 02:43:45PM -0400, Tejun Heo wrote:
> It doesn't make sense to print subsystems on mount option or
> /proc/PID/cgroup for the default hierarchy.
> 
> * cgroup.controllers file at the root of the default hierarchy lists
>   the currently attached controllers.
> 
> * The default hierarchy is catch-all for unmounted subsystems.
> 
> * The default hierarchy doesn't accept any mount options.
> 
> Suppress subsystem printing on mount options and /proc/PID/cgroup for
> the default hierarchy.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applied to cgroup/for-4.3-unified-base.

Thanks.

-- 
tejun
