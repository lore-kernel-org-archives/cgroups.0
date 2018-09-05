From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Wed, 5 Sep 2018 17:43:03 -0400
Message-ID: <20180905214303.GA30178@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qXZubM8MF/Lw3QDANhwRZtFYSjHznjc5hICQlHp7cko=;
        b=M+iAuvG3nZuE+iAp8SieNDJtUSc+tUkG89ZfAYtfxK5ugvz93f4eDUzpQ7mO511D0G
         WCpqluaGB+8oMV+TYwpyJ2M5HYjOyXj+FUw4KIu4/sOoHF7UBxwRPBAv4gKuS/jloHts
         Z2BH6dIP18ZJkH6qVow1nkgDBjejunAgC07Usz0O6ifZ7ORxO1orGcM/0bsfD271p6O4
         4j9oW1PFKRQi1pNd/kHU7+I8NPaCGcqe/KcMulVod/1ktFig4wloJUY4d47nGmPrPTxf
         DoHaZsx0U8+8WJF2ZFMdY4ypmPH+ibIUZkhdCItDdSOLd1hSVrkb7R3o6xwTQanZEWbe
         K2Gg==
Content-Disposition: inline
In-Reply-To: <20180828172258.3185-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Aug 28, 2018 at 01:22:49PM -0400, Johannes Weiner wrote:
> This version 4 of the PSI series incorporates feedback from Peter and
> fixes two races in the lockless aggregator that Suren found in his
> testing and which caused the sample calculation to sometimes underflow
> and record bogusly large samples; details at the bottom of this email.

Peter, do the changes from v3 look sane to you?

If there aren't any further objections, I was hoping we could get this
lined up for 4.20.
