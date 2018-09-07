From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Fri, 7 Sep 2018 09:46:42 +0200
Message-ID: <20180907074642.GN24106@hirez.programming.kicks-ass.net>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180905214303.GA30178@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IrCg6O00xZRMFaVwDmDS6t28bHlDyx1+bPOmmLA2wEQ=; b=UkTYU9pq6D3tYcNU1JPANxfmw
        8BGqo5HN0TOLbKq0qIXKkoIa7mohaADXtRJrXr80zw2chhl/ouYx/Efsphp6tMdPxaMqZUnT4gsGu
        Ec2HBDkVNlevi84GcG/Ce05ExJaGwwx2QkIhF3FZSND2kVbfwXs4WKeV+/V6+PJFMcZI6PijSikXP
        Z/gTElwjAEgf4toGfJYk4LeilVLPfjKybFwDSa1WX1OG0m6mgi1P+Y7iW6cRrW4W/BBUomCvlwoRU
        7Cf13TIZt31oO2UWrH6cG6ot52cXYVn2cutpLhfSB9/0VkBFZWBFd8jtNRttJZBqz6K92aaHviM3d
      
Content-Disposition: inline
In-Reply-To: <20180905214303.GA30178@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Sep 05, 2018 at 05:43:03PM -0400, Johannes Weiner wrote:
> On Tue, Aug 28, 2018 at 01:22:49PM -0400, Johannes Weiner wrote:
> > This version 4 of the PSI series incorporates feedback from Peter and
> > fixes two races in the lockless aggregator that Suren found in his
> > testing and which caused the sample calculation to sometimes underflow
> > and record bogusly large samples; details at the bottom of this email.
> 
> Peter, do the changes from v3 look sane to you?

I'll go have a look.
