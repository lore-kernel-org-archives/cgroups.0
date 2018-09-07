From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Fri, 7 Sep 2018 16:58:58 +0200
Message-ID: <20180907145858.GK24106@hirez.programming.kicks-ass.net>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180828172258.3185-9-hannes@cmpxchg.org>
 <20180907101634.GO24106@hirez.programming.kicks-ass.net>
 <20180907144422.GA11088@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/tt1x5V8vI/gV9w+n7YTsD4Ii6pVEeVAYF8srGCm1Oc=; b=Ho1hogiwokgGgRwrhJZXjxLqe
        oZ+Tk8wKHohXPn1cBsAtN0HbfNBlF5/kl1VCEqqLPTsIGVX9/YqgXck2os+w52wTbaukUfIchAEr7
        18LY7velP9yMnnMGONpht6/Ue5+C6IplKiJVcQZcPktE3JzceITt+yCHPsYEoBzj/8oFDpEBrF2R/
        7RdpufEjYTY088dr4POMSteThdYMHDkmSmvldcTLPAdWEcOt9Kq8IDAPHFKL35JatdeyGsT/t2j9z
        rHOz2cpI74Grds4Egz86OWAP9IYWNJ6ndrmCprt2GjKQUi107hVY2Lwkn0lGXqfRgGxIt/0DhygWo
      
Content-Disposition: inline
In-Reply-To: <20180907144422.GA11088@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Sep 07, 2018 at 10:44:22AM -0400, Johannes Weiner wrote:

> > This does the whole seqcount thing 6x, which is a bit of a waste.
> 
> [...]
> 
> > It's a bit cumbersome, but that's because of C.
> 
> I was actually debating exactly this with Suren before, but since this
> is a super cold path I went with readability. I was also thinking that
> restarts could happen quite regularly under heavy scheduler load, and
> so keeping the individual retry sections small could be helpful - but
> I didn't instrument this in any way.

I was hoping going over the whole thing once would reduce the time we
need to keep that line in shared mode and reduce traffic. And yes, this
path is cold, but I was thinking about reducing the interference on the
remote CPU.

Alternatively, we memcpy the whole line under the seqlock and then do
everything later.

Also, this only has a single cpu_clock() invocation.
