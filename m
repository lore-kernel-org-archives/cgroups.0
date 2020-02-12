From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Make cpuset hotplug synchronous
Date: Wed, 12 Feb 2020 16:36:23 -0500
Message-ID: <20200212213623.GF80993@mtj.thefacebook.com>
References: <1579878449-10164-1-git-send-email-prsood@codeaurora.org>
 <ee889f30-cb81-e0a8-6068-715ca3399fdd@codeaurora.org>
 <20200212211832.GC80993@mtj.thefacebook.com>
 <20200212213248.GE14897@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iBeSTprJEgkhPZLCbVo2vH4gD47fVWZXk0D/63E7q/E=;
        b=u2vGyuPYOVf8Rmx/bD+nZrJPyKgzpcQAucV+E89I+0VbBjaC7JDsg0R4oL58eiXRBR
         5NFyvjgdJp2dQzi72IL804HQKAbZY2dthM9WC+S8A70Re9ACGey4VMBJdtdOLZLFUma2
         EHTF+mgfQBIBphP0j9VAHOXSIpM8g6mtelcIVcE5ysde1cdsZ9vn7L1QBhaWSTAUB3UM
         5WD48B7NO6e/gZ00uVbN97wTwk1BzLNutcmJ41frW4YrMMFr1h8ZRIffu1BrPIF1BZSM
         sM7jpW836/Ff8sufIQfRsa9fH1sgH3jX2PXLUZJc4Xl2CnPCL+VELD0vNx3yHzyRQBtv
         y3AQ==
Content-Disposition: inline
In-Reply-To: <20200212213248.GE14897-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Peter.

On Wed, Feb 12, 2020 at 10:32:48PM +0100, Peter Zijlstra wrote:
> I think I have a similar patch in one of the many in-progress series I
> keep around; IIRC it is the one where I add per-cpu support to
> SCHED_DEADLINE. The hotplug accounting becomes easier if we do this.
> 
> Sadly this series is fairly low on the todo list atm though :/ I have no
> problems keeping it around until such a time though.

I see. I don't have anything against the change except that there
doesn't seem to be a good reason right now. If it's something which
can be useful for planned changes, might as well apply it and let it
cook upstream. Will apply to for-5.7.

Thanks.

-- 
tejun
