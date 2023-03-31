From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [External] Re: [PATCH] blk-throttle: Fix io statistics for
 cgroup v1
Date: Thu, 30 Mar 2023 15:44:50 -1000
Message-ID: <ZCY7EoAUqfB0ac8S@slm.duckdns.org>
References: <20230328142309.73413-1-hanjinke.666@bytedance.com>
 <ZCSJaBO8i5jQFC10@slm.duckdns.org>
 <1a858cce-4d87-5e0a-9274-52cffde7dea6@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680227093; x=1682819093;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CS9Le6nsC17jU584Wp0Pdq9lmWcMPhHg9k+f1qFG9Ls=;
        b=jliIbNZkvX0tLViuNo+i79Ttgxeb9fED2/7a/M//MeXVK85etYsThHW7fGC1feC4vZ
         Go+yEPuxYOcaF5VBV6Ke0tTmio5hHs8DCIabQRCHVjtKLke5fe30pR1/67w3ny6t7cSe
         u5NPsdvN0XRvl04Wkq4Lma/qrhChh42F/OMxsGqMzgLezbHZJCHUBiU2Ku2KyqSTMMS4
         pnrGO76PL/yll+KWOG03l2uV3VYf8UD2PiWykpevBE6UMc/CV3anaSXdGkeAc4P7GG5M
         8D6jVFrnzJzuOXa/B3czUIVd0rUcMg/cUlELD955vSSCykHv6Nix3W7/9YD4sqGoodz3
         bZLA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1a858cce-4d87-5e0a-9274-52cffde7dea6-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Mar 30, 2023 at 11:44:04AM +0800, hanjinke wrote:
> 在 2023/3/30 上午2:54, Tejun Heo 写道:
> > On Tue, Mar 28, 2023 at 10:23:09PM +0800, Jinke Han wrote:
> > > From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > 
> > > Now the io statistics of cgroup v1 are no longer accurate. Although
> > > in the long run it's best that rstat is a good implementation of
> > > cgroup v1 io statistics. But before that, we'd better fix this issue.
> > 
> > Can you please expand on how the stats are wrong on v1 and how the patch
> > fixes it?
> > 
> > Thanks.
> > 
> Now blkio.throttle.io_serviced and blkio.throttle.io_serviced become the

"now" might be a bit too vague. Can you point to the commit which made the
change?

> only stable io stats interface of cgroup v1, and these statistics are done
> in the blk-throttle code. But the current code only counts the bios that are

Ah, okay, so the stats are now updated by blk-throtl itself but

> actually throttled. When the user does not add the throttle limit, the io
> stats for cgroup v1 has nothing. I fix it according to the statistical
> method of v2, and made it count all ios accurately.

updated only when limits are configured which can be confusing. Makes sense
to me. Can you please update the patch description accordingly?

Also, the following change:

@@ -2033,6 +2033,9 @@ void blk_cgroup_bio_start(struct bio *bio)
        struct blkg_iostat_set *bis;
        unsigned long flags;

+       if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
+               return;
+
        /* Root-level stats are sourced from system-wide IO stats */
        if (!cgroup_parent(blkcg->css.cgroup))
                return;

seems incomplete as there's an additional
cgroup_subsys_on_dfl(io_cgrp_subsys) test in the function. We probably wanna
remove that?

Thanks.

-- 
tejun
