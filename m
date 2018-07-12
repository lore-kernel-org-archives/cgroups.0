From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/10] psi: pressure stall information for CPU, memory,
 and IO v2
Date: Thu, 12 Jul 2018 16:44:22 -0700
Message-ID: <20180712164422.a53cc0f9c26b078dbc7e5731@linux-foundation.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712172942.10094-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, 12 Jul 2018 13:29:32 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

>
> ...
>
> The io file is similar to memory. Because the block layer doesn't have
> a concept of hardware contention right now (how much longer is my IO
> request taking due to other tasks?), it reports CPU potential lost on
> all IO delays, not just the potential lost due to competition.

Probably dumb question: disks aren't the only form of IO.  Does it make
sense to accumulate PSI for other forms of IO?  Networking comes to
mind...

