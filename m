From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory, and
 IO v2
Date: Thu, 12 Jul 2018 10:37:30 -0700
Message-ID: <CAADWXX_ADRyY+HDyw_2Ofa4b9g1fpCNe8xO3xMf20jfWsyCnQg@mail.gmail.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WBM2NblqMwSzoXHXighsXPUKbnETTHf8UrNOpUUqdRk=;
        b=BvmQu1+L+WHnvlSIWhO+1vGHQoR0cTTrEnzTrF/QvxBjZX9KiYQAgDMGuSAS1/hyJa
         mT0cfrfepHWe6bOeR3AmVI8eZl8xfgTWKYeMvqIRx7yMJjGgiMiAJ+8P68lFpFeeKoqj
         Zp2tcgj/adyR2Ag8SDk3cPkA/roag/jiafn6A=
In-Reply-To: <20180712172942.10094-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org
Cc: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org, surenb@google.com, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, shakeelb@google.com, linux-mm@kvack.org, cgroups@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, kernel-team@fb.com

On Thu, Jul 12, 2018 at 10:27 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> PSI aggregates and reports the overall wallclock time in which the
> tasks in a system (or cgroup) wait for contended hardware resources.

No comments on the patches themselves (the concept looks sane, and I'm
finding it more intriguing for non-oom uses than for oom), but just a
note to say that gmail hates you and marked every single patch as spam
for some reason.

I have no idea why. All the headers look fine, DKIM passes, nothing
bad stands out.

So it must be personal.

             Linus
