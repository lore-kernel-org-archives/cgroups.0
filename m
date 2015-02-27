From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 08:52:04 -0500
Message-ID: <20150227135204.GI3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F07525.4050100@nod.at>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FRbqn8X09w18Ymj5NFukXQkP6tHuGZvZMNphqJtbAcQ=;
        b=enqIXiDmSCT791sR5PddkhJv93lgEuNgwO/+4oKqcun0WD3s+OT2vE9JIT1s4BiFi2
         RWmXOFga5FfynwlykvlCi3IB0P89+z37o9klT4PtJ2bnFQxajDYfFaMzuLcJHyABv21N
         Id7oaJGfg2ixkjrB552aa09iFcYajyiNEnHb1NQU7X5fulePeLejS2IBekaptVkCiiTR
         y5vCDXlCvFyMyDzENbAqOoI0Sd2oymegM4nmsBFY9Aj0cySIYg2qNeosFA2RIs8Pp+6Q
         Wp32qljyOR6mQYkauGAcxFAxaDiohPZk5rscDM4PXEqHNhvOdD9/8fNwgoDSHfrZyB1f
         lVLQ==
Content-Disposition: inline
In-Reply-To: <54F07525.4050100-/L3Ra7n9ekc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Feb 27, 2015 at 02:46:13PM +0100, Richard Weinberger wrote:
> just to make sure that I understand the big picture.
> The plan is to limit kernel memory per cgroup such that fork bombs and
> stuff cannot harm other groups of processes?

Yes, the kmem part of memcg hasn't really been functional because the
reclaim part was broken and (partially conseqently) kmem config being
siloed from the rest but we're very close to solving that at this
point.

Thanks.

-- 
tejun
