From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove bind() method from cgroup_subsys.
Date: Fri, 12 Apr 2013 10:24:34 -0700
Message-ID: <20130412172434.GE11956@mtj.dyndns.org>
References: <1365594077-17655-1-git-send-email-ramirose@gmail.com>
 <20130410175035.GA17641@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=lNDsRpSQFPT9NcUbabi6DoLGETINvnfQ3eSA69EaEGc=;
        b=PEtA4+RhgDLMdfm2drLoy/TvG+Tlp/nIJSMKKDU1/jJUTlEM1vKeROW/rvfdl+JKNT
         lmTjPQue/DzSQ7jHMiXePLfeGLvF4DIOt+XjxYWS03c47EGUH+eaKTd3i4xN8HIwbutY
         DGLhwc3XhBXnxp4LkDlkfQTh9SpxfgUMYAZbmXRPTCoGW41uNCdqJw+Eqx4WgkDcrGnc
         R4F4i7OpL0//8TbtJKWKC8V1bJPT9bWsrRL7wJkZnXArRZDQQVylV3ZOGGcD77m+Aa5H
         TYbE6DE8eztHfR/ACQQlSaFM0oSFa4FjKLwrkbEcONOa0QLEuyW+8soqgz6O4cP2wxGq
         /6hA==
Content-Disposition: inline
In-Reply-To: <20130410175035.GA17641-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Apr 10, 2013 at 10:50:35AM -0700, Tejun Heo wrote:
> From 84cfb6ab484b442d5115eb3baf9db7d74a3ea626 Mon Sep 17 00:00:00 2001
> From: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Wed, 10 Apr 2013 14:41:17 +0300
> 
> The bind() method of cgroup_subsys is not used in any of the
> controllers (cpuset, freezer, blkio, net_cls, memcg, net_prio,
> devices, perf, hugetlb, cpu and cpuacct)
> 
> tj: Removed the entry on ->bind() from
>     Documentation/cgroups/cgroups.txt.  Also updated a couple
>     paragraphs which were suggesting that dynamic re-binding may be
>     implemented.  It's not gonna.
> 
> Signed-off-by: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> Applied to cgroup/for-3.10 with documentation updated.

I'm reverting this patch for now as it's getting a new usage.  Maybe
we can try later.

Thanks.

-- 
tejun
