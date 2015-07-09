From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 block/for-4.3] blkcg: blkcg_policy methods cleanup
Date: Thu, 9 Jul 2015 17:13:46 -0400
Message-ID: <20150709211346.GA18734@mtj.duckdns.org>
References: <1436284293-4666-1-git-send-email-tj@kernel.org>
 <20150707200047.GC23362@mtj.duckdns.org>
 <559C3712.7040505@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fz65KShqPLZ5//wIf73TiY6w0zQ3l24CzPUfg3rBFWY=;
        b=aY4JhJWO8z4liFlyFjNp7Iv/r9xEXm4fDe9gy9NaOfUl8cwWYcVRF1u5KyIdhtrZ9B
         zhgl5j7KZ4TydEScKNY7fQW/ezD9HxptZymtOGErBb4E+7pkPWVr5+ATsqMUs5Beprsp
         UPWfnD1iP1Y+UiF+vlyGoehNr+dgXTMuRGzZlE66hBQgmruSD/wrWEIOxL4BD+UfwJlb
         Mr8p+Gl/tyhCBLKgFZeMq+BVD2IKdHmkfQV+1aH1h3uuh7gpvU1APrR2x7yyHLVM8f++
         2Nsb7UTKixfzx4m6ENdcENJ/l7kjePKUnHBqasIR/P+L5qNFIuc6MSdtmLFeEOUHwRp0
         GkHQ==
Content-Disposition: inline
In-Reply-To: <559C3712.7040505-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello, Arianna.

On Tue, Jul 07, 2015 at 10:31:14PM +0200, Arianna Avanzini wrote:
> I think Jens just applied a bugfix for per-blkcg policy data handling.
> Please have a look at https://lkml.org/lkml/2015/7/6/950. Should have Cc'd
> you, sorry for that.

Yeah, that too but there were a couple more.  Just posted patches to
fix them.  It'd be great if you can go over those.

Thanks!

-- 
tejun
