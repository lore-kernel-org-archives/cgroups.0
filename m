From: peter enderborg <peter.enderborg@sony.com>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Mon, 17 Sep 2018 15:29:41 +0200
Message-ID: <29f0bb2c-31d4-0b2e-d816-68076b90e9d3@sony.com>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180905214303.GA30178@cmpxchg.org>
 <20180907110407.GQ24106@hirez.programming.kicks-ass.net>
 <20180907150955.GC11088@cmpxchg.org>
 <CAJuCfpG1=pXOg=1GwC33Uy0BcXNq-BsR6dO0JJq4Jnm5TyNENQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJuCfpG1=pXOg=1GwC33Uy0BcXNq-BsR6dO0JJq4Jnm5TyNENQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm <linux-mm@kvack.org>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com

Will it be part of the backport to 4.9 google android or is it for test only?
I guess that this patch is to big for the LTS tree.

On 09/07/2018 05:58 PM, Suren Baghdasaryan wrote:
> Thanks for the new patchset! Backported to 4.9 and retested on ARMv8 8
> code system running Android. Signals behave as expected reacting to
> memory pressure, no jumps in "total" counters that would indicate an
> overflow/underflow issues. Nicely done!
>
> Tested-by: Suren Baghdasaryan <surenb@google.com>
>
> On Fri, Sep 7, 2018 at 8:09 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> On Fri, Sep 07, 2018 at 01:04:07PM +0200, Peter Zijlstra wrote:
>>> So yeah, grudingly acked. Did you want me to pick this up through the
>>> scheduler tree since most of this lives there?
>> Thanks for the ack.
>>
>> As for routing it, I'll leave that decision to you and Andrew. It
>> touches stuff all over, so it could result in quite a few conflicts
>> between trees (although I don't expect any of them to be non-trivial).


