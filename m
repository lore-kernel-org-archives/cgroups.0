From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Thu, 09 Feb 2017 16:08:55 +0100
Message-ID: <1486652935.3787.5.camel@gmx.de>
References: <20170202200632.13992-1-tj@kernel.org>
         <CAPM31RKHsM1-iWb5B6jkOtLomLhiOARtgMOTWZ8p1yjEn-ZK0A@mail.gmail.com>
         <20170209144704.GD6515@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170209144704.GD6515@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, lvenanci@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Thu, 2017-02-09 at 15:47 +0100, Peter Zijlstra wrote:
> On Thu, Feb 09, 2017 at 05:07:16AM -0800, Paul Turner wrote:
> > The only case that this does not support vs ".threads" would be some
> > hybrid where we co-mingle threads from different processes (with the
> > processes belonging to the same node in the hierarchy).  I'm not aware
> > of any usage that looks like this.
> 
> If I understand you right; this is a fairly common thing with RT where
> we would stuff all the !rt threads of the various processes in a 'misc'
> bucket.
> 
> Similarly, it happens that we stuff the various rt threads of processes
> in a specific (shared) 'rt' bucket.
> 
> So I would certainly not like to exclude that setup.

Absolutely, you just described my daily bread performance setup.

	-Mike
