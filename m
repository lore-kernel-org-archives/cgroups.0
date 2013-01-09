From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Date: Wed, 9 Jan 2013 06:41:48 -0800
Message-ID: <20130109144148.GH3926@htj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=S50ClZ7Tvi4NrOQ64DbhUVqz6RF+0Bn0NEiJKjynxWw=;
        b=ZZJfpb3M6GFD+TuwZvhDYRQ34LOYdP+lJONhSxf4hal8Y7WLQQ778WT74JqmvATmEj
         +EBtSILqhMQjIdN7801zOkySA/EqZ/X9WR87SHfOTPpH3uq23oiMSMnLjERhh6IHZ3ay
         gJNaBZjfVCUMHFmUqIK8saoSGGSg0vTyLNa1tNXOrL5xn/aGRVmyuKzuaDHzGsXERKzX
         GZj1QFwjZas5k9WModWp265CZLyir99XuGTeL1FwhlE8b31tDfunz1WLKrmc4pgdAvs+
         8Ml6xYR01a872L+dT4qMyOcg5C7wLl2dJQehFP+gjw+bR3BDrfFx/EJlrK02ZALw5hqR
         d46g==
Content-Disposition: inline
In-Reply-To: <1357731938-8417-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Glauber.

On Wed, Jan 09, 2013 at 03:45:27PM +0400, Glauber Costa wrote:
> [ update: I thought I posted this already before leaving for holidays. However,
>   now that I am checking for replies, I can't find nor replies nor the original
>   mail in my boxes or archives. I am posting again for safety sake, but sorry
>   you are getting this twice by any chance ]

I think I saw the series a while back.

> This is an attempt to provide userspace with enough information to reconstruct
> per-container version of files like "/proc/stat". In particular, we are
> interested in knowing the per-cgroup slices of user time, system time, wait
> time, number of processes, and a variety of statistics.
> 
> This task is made more complicated by the fact that multiple controllers are
> involved in collecting those statistics: cpu and cpuacct. So the first thing I
> am doing here, is ressurecting Tejun's patches that aim at deprecating cpuacct.
> 
> This is one of the major differences from earlier attempts: all data is provided
> by the cpu controller, resulting in greater simplicity.
> 
> This also tries to hook into the existing scheduler hierarchy walks instead of
> providing new ones.

The cgroup part looks good to me.

Thanks.

-- 
tejun
