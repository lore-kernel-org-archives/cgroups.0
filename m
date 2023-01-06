From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Fri, 6 Jan 2023 06:58:05 -1000
Message-ID: <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=snReoJ52ndOwVl0ihFne37Ntk/YfJwEwK939SBaIpCs=;
        b=Gx4xxHNFjIVJ/RowxB+wt373DC9fu+a85w9xTcZD8wARaeDbA3mxC/HyWuGb/ZeYqo
         PY68+XpwGGM2iTW5bU2vmHoqPKqEK2v7dDsrIAqu70HLSDIWC+Hwh5FC1NX6sSGpGCc6
         LSBdG8LBPd+JCFyu4atqv2TiZQgf8cZhOs9+Y/bAsdcJd7V81VxcIcfss1N8XLHv1djY
         CYx3y9m8FJNmh94zY/LasS6vhHg8gj5iyd2cs9kb1bL0G+TT/I94Dw0oiTJcZfzC1aFJ
         LLvbzhY/wziR1nvD96f2rXcMGCDchif+jWC5dAoOLWmEJYeJTz7BJc2GGA7rbSta4Bjt
         7+Fg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230106153813.4ttyuikzaagkk2sc@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

On Fri, Jan 06, 2023 at 04:38:13PM +0100, Jan Kara wrote:
> Generally, problems are this are taken care of by IO schedulers. E.g. BFQ
> has quite a lot of logic exactly to reduce problems like this. Sync and
> async queues are one part of this logic inside BFQ (but there's more).

With modern ssd's, even deadline's overhead is too high and a lot (but
clearly not all) of what the IO schedulers do are no longer necessary. I
don't see a good way back to elevators.

> But given current architecture of the block layer IO schedulers are below
> throttling frameworks such as blk-throtl so they have no chance of
> influencing problems like this. So we are bound to reinvent the scheduling
> logic IO schedulers are already doing. That being said I don't have a good
> solution for this or architecture suggestion. Because implementing various
> throttling frameworks within IO schedulers is cumbersome (complex
> interactions) and generally the perfomance is too slow for some usecases.
> We've been there (that's why there's cgroup support in BFQ) and really
> the current architecture is much easier to reason about.

Another layering problem w/ controlling from elevators is that that's after
request allocation and the issuer has already moved on. We used to have
per-cgroup rq pools but ripped that out, so it's pretty easy to cause severe
priority inversions by depleting the shared request pool, and the fact that
throttling takes place after the issuing task returned from issue path makes
propagating the throttling operation upwards more challenging too.

At least in terms of cgroup control, the new bio based behavior is a lot
better. In the fb fleet, iocost is deployed on most (virtually all) of the
machines and we don't see issues with severe priority inversions.
Cross-cgroup control is pretty well controlled. Inside each cgroup, sync
writes aren't prioritized but nobody seems to be troubled by that.

My bet is that inversion issues are a lot more severe with blk-throttle
because it's not work-conserving and not doing things like issue-as-root or
other measures to alleviate issues which can arise from inversions.

Jinke, is the case you described in the original email what you actually saw
in production or a simplified test case for demonstration? If the latter,
can you describe actual problems seen in production?

Thanks.

-- 
tejun
