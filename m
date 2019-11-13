From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH v2 6/8] mm/lru: remove rcu_read_lock to fix performance
 regression
Date: Wed, 13 Nov 2019 11:40:46 +0000
Message-ID: <20191113114045.GZ3016@techsingularity.net>
References: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573567588-47048-7-git-send-email-alex.shi@linux.alibaba.com>
 <20191112143844.GB7934@bombadil.infradead.org>
 <a6bb6739-cc00-cf9f-cd69-6016ce93e054@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a6bb6739-cc00-cf9f-cd69-6016ce93e054@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>

On Wed, Nov 13, 2019 at 10:40:58AM +0800, Alex Shi wrote:
> 
> 
> ?? 2019/11/12 ????10:38, Matthew Wilcox ????:
> > On Tue, Nov 12, 2019 at 10:06:26PM +0800, Alex Shi wrote:
> >> Intel 0day report there are performance regression on this patchset.
> >> The detailed info points to rcu_read_lock + PROVE_LOCKING which causes
> >> queued_spin_lock_slowpath waiting too long time to get lock.
> >> Remove rcu_read_lock is safe here since we had a spinlock hold.
> > Argh.  You have not sent these patches in a properly reviewable form!
> > I wasted all that time reviewing the earlier patch in this series only to
> > find out that you changed it here.  FIX THE PATCH, don't send a fix-patch
> > on top of it!
> > 
> 
> Hi Matthew,
> 
> Very sorry for your time! The main reasons I use a separate patch since a, Intel 0day asking me to credit their are founding, and I don't know how to give a clearly/elegant explanation for a non-exist regression in a fixed patch. b, this regression is kindly pretty tricky.  Maybe it's better saying thanks in version change log of cover-letter?
> 

Add something like this to the patch

[lkp@intel.com: Fix RCU-related regression reported by LKP robot]
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
...

-- 
Mel Gorman
SUSE Labs
