From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v2 6/8] mm/lru: remove rcu_read_lock to fix performance
 regression
Date: Thu, 14 Nov 2019 14:02:20 +0800
Message-ID: <e286a02f-f377-34a9-a195-b827c54b969d@linux.alibaba.com>
References: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573567588-47048-7-git-send-email-alex.shi@linux.alibaba.com>
 <20191112143844.GB7934@bombadil.infradead.org>
 <a6bb6739-cc00-cf9f-cd69-6016ce93e054@linux.alibaba.com>
 <20191113114045.GZ3016@techsingularity.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191113114045.GZ3016@techsingularity.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>



在 2019/11/13 下午7:40, Mel Gorman 写道:
>> Hi Matthew,
>>
>> Very sorry for your time! The main reasons I use a separate patch since a, Intel 0day asking me to credit their are founding, and I don't know how to give a clearly/elegant explanation for a non-exist regression in a fixed patch. b, this regression is kindly pretty tricky.  Maybe it's better saying thanks in version change log of cover-letter?
>>
> Add something like this to the patch
> 
> [lkp@intel.com: Fix RCU-related regression reported by LKP robot]
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>

It's a good idea! Thanks a lot, Mel!
