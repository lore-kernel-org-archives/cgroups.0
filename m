From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix a comment in function cgroup_wq_init()
Date: Mon, 21 Sep 2020 10:45:32 -0400
Message-ID: <20200921144532.GC4268@mtj.duckdns.org>
References: <1600419292-191248-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7XeqDDDTvxoO0phl/l7TPArLS/GQrVR71HL2ig1yhj0=;
        b=hVlYdOp4benE9VRDbPc+x/gBMtmVxF8MFQ1JBc8Xwu/skl4abBBUJi+IMgsYipD0Nr
         Naq9BfXnqMIrqTKldyflN6hl7n13RXAop7nlnMWFNjCmThbupZx9QeSTXqcjSdNzPiDM
         6dnLuzqGi5Ov+Wai2qXOd1jEvAemHlFjY9eqmsZZaMAOYaMjpwOWisF73EaRBnOLbBR1
         /0MJFeh15yPvWUb25JjpzP1g21cJQAuU/EL+wxd6aiEaBCkVaMG4Bf81ItE+1kCJGl+j
         +bQd6ceNbzbA5XLu5vE1iIkTVcehr5KVQLFayWhXBXAzuU3ghLylVaLE7WH507YB6ZwV
         XXtA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1600419292-191248-1-git-send-email-chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chenxiang <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Sep 18, 2020 at 04:54:52PM +0800, chenxiang wrote:
> From: Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> 
> Use function workqueue_init() instead of init_workqueues() which
> is not used in kernel.
> 
> Signed-off-by: Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>

I don't have any other cgroup changes queued for this cycle and it's a bit
awkward to start one for this one. Do you mind re-sending your patch to
trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org? Please feel free to add my Acked-by.

Thanks.

-- 
tejun
