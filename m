From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Mon, 13 Feb 2017 06:28:50 +0100
Message-ID: <1486963730.5912.89.camel@gmx.de>
References: <20170202200632.13992-1-tj@kernel.org>
         <CAPM31RKHsM1-iWb5B6jkOtLomLhiOARtgMOTWZ8p1yjEn-ZK0A@mail.gmail.com>
         <20170209144704.GD6515@twins.programming.kicks-ass.net>
         <CAPM31RJaJjFwenC36Abij+EdzO3KBm-DEjQ_crSmzrtrrn2N2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPM31RJaJjFwenC36Abij+EdzO3KBm-DEjQ_crSmzrtrrn2N2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, "lvenanci@redhat.com" <lvenanci@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Sun, 2017-02-12 at 13:16 -0800, Paul Turner wrote:
> 
> 
> On Thursday, February 9, 2017, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, Feb 09, 2017 at 05:07:16AM -0800, Paul Turner wrote:
> > > The only case that this does not support vs ".threads" would be some
> > > hybrid where we co-mingle threads from different processes (with the
> > > processes belonging to the same node in the hierarchy).  I'm not aware
> > > of any usage that looks like this.
> > 
> > If I understand you right; this is a fairly common thing with RT where
> > we would stuff all the !rt threads of the various processes in a 'misc'
> > bucket.
> > 
> > Similarly, it happens that we stuff the various rt threads of processes
> > in a specific (shared) 'rt' bucket.
> > 
> > So I would certainly not like to exclude that setup.
> > 
> 
> Unless you're using rt groups I'm not sure this one really changes.  
> Whether the "misc" threads exist at the parent level or one below
> should not matter.

(with exclusive cpusets, a mask can exist at one and only one location)
