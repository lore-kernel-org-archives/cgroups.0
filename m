From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Tue, 23 Oct 2018 19:41:15 +0200
Message-ID: <20181023174115.GB3126@worktop.c.hoisthospitality.com>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20181018190710.fcea1c5f9c3b0c15d37ee762@linux-foundation.org>
 <20181023172937.GA21443@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Uog6eWWZwx7byoO4QTXFhNFrwph/6sU7PgE6Aph2Xh4=; b=AHDkosGoeBQzipN/52F55Iy6f
        R52Kw9Hj8ODg216rwYNcfbxJq+dSYo2gqsTpF7tkkF7sK/uRLXcwu7b2bLCi06x9l6pYF7MSeCX+n
        uKXflitnbhLmV99Se8UxIOcNAPlbbR17RnGFrnIYyLlxNYpcf122ZQqr1nxJF/DKwiSIw1Bh0MPq8
        BT999Z7RTHLYfZGXcBj8LRWEoGlsvhODfIqL2yCVqDYJBrjCN4xc12VMAYa+3qEKpZXot2HcTVeVa
        NjbrEZ3hY3wVdyjz+GoqtGZl92gJXogD+VsXCiZ/WQARbaX99s20vsP4IOa6K944ISd852KbjmX5r
    
Content-Disposition: inline
In-Reply-To: <20181023172937.GA21443@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Oct 23, 2018 at 01:29:37PM -0400, Johannes Weiner wrote:
> On Thu, Oct 18, 2018 at 07:07:10PM -0700, Andrew Morton wrote:
> > On Tue, 28 Aug 2018 13:22:49 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > This version 4 of the PSI series incorporates feedback from Peter and
> > > fixes two races in the lockless aggregator that Suren found in his
> > > testing and which caused the sample calculation to sometimes underflow
> > > and record bogusly large samples; details at the bottom of this email.
> > 
> > We've had very little in the way of review activity for the PSI
> > patchset.  According to the changelog tags, anyway.
> 
> Peter reviewed it quite extensively over all revisions, and acked the
> final version. Peter, can we add your acked-by or reviewed-by tag(s)?

I don't really do reviewed by; but yes, I thought I already did; lemme
find.

> The scheduler part accounts for 99% of the complexity in those
> patches. The mm bits, while somewhat sprawling, are mostly mechanical.

Ah, I now see my mistake;

  https://lkml.kernel.org/r/20180907110407.GQ24106@hirez.programming.kicks-ass.net

I forgot to include an actual tag therein. My bad.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
