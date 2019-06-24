From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: fix page cache convergence regression
Date: Mon, 24 Jun 2019 11:19:23 -0400
Message-ID: <20190624151923.GA10572@cmpxchg.org>
References: <20190524153148.18481-1-hannes@cmpxchg.org>
 <20190524160417.GB1075@bombadil.infradead.org>
 <20190524173900.GA11702@cmpxchg.org>
 <20190530161548.GA8415@cmpxchg.org>
 <20190530171356.GA19630@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xk9Y9/4d1P0hhiRulYC6/59GayfnrTydVvyulmj2MA0=;
        b=gJlLLhHaj6Jvm1bCaUN3ZW2zumf00y0LQxCLkUqwaGzxFCYZiFYQ8rTczXQpCRZDpw
         NtK5q/uM6I5V76gghSg5fmbJ43CHbwtS081cohfzOJ6io4WFLGOcoXgaTyWCbMrjkAsj
         xY9qHxrZFwQHzIVemFHx4ljFg0oGqYce6edkh2yeRRpwJiU/trCjsIhFgezWhFJcCgqe
         H4Scl/FXgMov4Q2yD8FeFxw798h6RqiToCrKV5Bs2iobxW0/QAamUc9TkSldXFyswImI
         Apxtk2c/8886Fs7QUpgFAYPFhvHX896Nq/69H5XW37lFOXvRa0xmPRdWgvt7Lc42nHf+
         rPsw==
Content-Disposition: inline
In-Reply-To: <20190530171356.GA19630@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, May 30, 2019 at 10:13:56AM -0700, Matthew Wilcox wrote:
> On Thu, May 30, 2019 at 12:15:48PM -0400, Johannes Weiner wrote:
> > Are there any objections or feedback on the proposed fix below? This
> > is kind of a serious regression.
> 
> I'll drop it into the xarray tree for merging in a week, if that's ok
> with you?

Hey, it's three weeks later and we're about to miss 5.2.

This sucks, Matthew. You introduced a serious regression to the MM
subsystem, whose process and patch routing you largely bypassed. When
I encountered the problem and provided a reproducer and a fix, you
gave me a hard time on cosmetic grounds. I incorporated all your
feedback, and still you show no urgency to get this patch or a fix of
your own into mainline. It's your bug, please fix it.
