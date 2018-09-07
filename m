From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Fri, 7 Sep 2018 08:58:36 -0700
Message-ID: <CAJuCfpG1=pXOg=1GwC33Uy0BcXNq-BsR6dO0JJq4Jnm5TyNENQ@mail.gmail.com>
References: <20180828172258.3185-1-hannes@cmpxchg.org> <20180905214303.GA30178@cmpxchg.org>
 <20180907110407.GQ24106@hirez.programming.kicks-ass.net> <20180907150955.GC11088@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=+ZR6++p5OdDfOouBlBByaH8T5wkcBYztRaDPUIqWl30=;
        b=Cl9hYHLKbDzl8/8QI4LvxG/FYitkB3fY+o0ANcw26CfrfvJPstA+lpMItWuQyh8f+W
         U38F3ebYgI9l6/fa5UV9x7K3/nrfzqI+uKgv+tZWvfVMlO9K+q/ZoOoqf3AyxnNB2tl4
         mu6PFFH2Zhgl8BjOZ66CTNRfJOPnuk7LIKnp2PWUeu5tIAl91gBLUVwDMxTsl6S62mfy
         +sP7/q/Da6XIKZtw7nS8VRAEYFSf2Alg52sofUQabfcsxTd5mCGcrvxGO3ARAjz48kyM
         NFDqlRG4LUwsW3RUqqsYlengmWCiWS6XfjUrC75O/8Fd6WF5z3DvTxld6tUxttF45wI7
         EzDQ==
In-Reply-To: <20180907150955.GC11088@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com

Thanks for the new patchset! Backported to 4.9 and retested on ARMv8 8
code system running Android. Signals behave as expected reacting to
memory pressure, no jumps in "total" counters that would indicate an
overflow/underflow issues. Nicely done!

Tested-by: Suren Baghdasaryan <surenb@google.com>

On Fri, Sep 7, 2018 at 8:09 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Fri, Sep 07, 2018 at 01:04:07PM +0200, Peter Zijlstra wrote:
>> So yeah, grudingly acked. Did you want me to pick this up through the
>> scheduler tree since most of this lives there?
>
> Thanks for the ack.
>
> As for routing it, I'll leave that decision to you and Andrew. It
> touches stuff all over, so it could result in quite a few conflicts
> between trees (although I don't expect any of them to be non-trivial).
