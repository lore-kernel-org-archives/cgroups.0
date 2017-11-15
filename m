From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 15 Nov 2017 11:37:42 +0100
Message-ID: <20171115103742.xt7muaq2dfrs2cyd@hirez.programming.kicks-ass.net>
References: <45cdac2f-4462-e5b5-d724-8cca58e3932a@codeaurora.org>
 <1509347805-23491-1-git-send-email-prsood@codeaurora.org>
 <6f8b194f-05ec-05d4-3df6-e9eadc7f68bf@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fPBtVvRISg48Llnu1MvKQJlujaQ+7n0VUFE1W/o/Aeg=; b=nXAAqiJMoNLulptm7UDRkSifs
        vFQXQgZ6TxBf61tdNjKx1NWEvaab+KQLC3rw1N4BrV3ZFrqAS9V/S8d9Jmt3pB/qR9yQCcxOc221m
        KaS0P18i07fjTLuRpHiwdQuqtTY3IycDB4eQDoRAhk74km85117ZKdg+l+dwzUX0oedSIpjev+Eik
        Dv/HC1plr+N2VUaootsGo8qVYC0ZvDoinyAymmKKRoPwmYhmO2g00+FkI5iCG5JjqAjkT/5KQWE5l
        1pOVo8QvwX/8AmF11g4xPSoslU0u2YDJgUEAmfkbBrfg3jBtcYmibPfK7GCHBUtnhE6SsTSOLk2Nm
    
Content-Disposition: inline
In-Reply-To: <6f8b194f-05ec-05d4-3df6-e9eadc7f68bf-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 15, 2017 at 03:56:26PM +0530, Prateek Sood wrote:
> Any improvement/suggestion for this patch?

I would have done 2 patches, the first one solving the locking issue,
the second removing the then redundant async rebuild stuff.

Other than that this looks OK I suppose, but I was expecting this to go
through the cgroup tree, TJ?
