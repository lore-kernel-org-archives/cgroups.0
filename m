From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should
 be atomic flags
Date: Wed, 24 Sep 2014 09:06:20 -0400
Message-ID: <20140924130620.GB16555@htj.dyndns.org>
References: <54210D3F.2090409@huawei.com>
 <54210DA5.4040606@huawei.com>
 <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
 <542233F0.1080402@huawei.com>
 <201409242044.GFJ81269.FJFVQOLSHtFMOO@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IyWy/AlTM0iQLsUYjwc+9k+4riZ4Czq+/tJpshKTbJo=;
        b=Kc0qfK9uhugqYQUGvbiFHj71LxS+rnPEwzvB+81xnvt4IPq6QpT8wPNqy8STXNFA12
         JiJ8EL0DLBS8CNLeYqUptGaewlvCj3TMVcGFrF4DtG68UZvLh1sYK8myMh+sa78JYz8l
         629UwtxQv3Kai+nit80BWDZYY9nbgjAdlO70ckJgHjn9nQiKawFHYSSPNTxb3JlBq1Zi
         SYFqXSrVG0sXLlt/BaQmmMOw8vJWs51QzKl0jOTI9Nf0jhoW83hppV0MUd8oRHevRE9Q
         TOhXfPI2VPz0PP4oFn03//KcTnm1wUni7HzXzBfKNLNBUb57ahhJi/xG4DZGBD0qTbI6
         KYKA==
Content-Disposition: inline
In-Reply-To: <201409242044.GFJ81269.FJFVQOLSHtFMOO-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

On Wed, Sep 24, 2014 at 08:44:43PM +0900, Tetsuo Handa wrote:
> Tejun Heo wrote:
> > All the patches look good to me.  I can't say I'm a big fan of
> > function defining macros but I don't have prettier alternatives
> > either.  Once Peter/Ingo acks the patches, I'll route them through
> > cgroup/for-3.17-fixes.
> 
> Peter and Ingo, are these patches OK for you?

Peter acked.  I'll apply the patches to cgroup/for-3.17-fixes.

Thanks.

-- 
tejun
