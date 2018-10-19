From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory,
 and IO v4
Date: Thu, 18 Oct 2018 19:07:10 -0700
Message-ID: <20181018190710.fcea1c5f9c3b0c15d37ee762@linux-foundation.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180828172258.3185-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, 28 Aug 2018 13:22:49 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> This version 4 of the PSI series incorporates feedback from Peter and
> fixes two races in the lockless aggregator that Suren found in his
> testing and which caused the sample calculation to sometimes underflow
> and record bogusly large samples; details at the bottom of this email.

We've had very little in the way of review activity for the PSI
patchset.  According to the changelog tags, anyway.

