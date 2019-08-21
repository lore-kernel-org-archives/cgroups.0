From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 00/14] per memcg lru_lock
Date: Wed, 21 Aug 2019 09:21:18 +0800
Message-ID: <319c7a6c-6f1a-64c5-4920-e8279eb1e80b@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <20190820104532.GP3111@dhcp22.suse.cz>
 <CALvZod7-dL90jwd2pywpaD8NfUByVU9Y809+RfvJABGdRASYUg@mail.gmail.com>
 <alpine.LSU.2.11.1908201038260.1286@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.11.1908201038260.1286@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Shakeel Butt <shakeelb@google.com>, Yu Zhao <yuzhao@google.com>, Daniel Jordan <daniel.m.jordan@oracle.com>



> 
> Thanks for the Cc Michal.  As Shakeel says, Google prodkernel has been
> using our per-memcg lru locks for 7 years or so.  Yes, we did not come
> up with supporting performance data at the time of posting, nor since:
> I see Alex has done much better on that (though I haven't even glanced
> to see if +s are persuasive).
> 
> https://lkml.org/lkml/2012/2/20/434
> was how ours was back then; some parts of that went in, then attached
> lrulock417.tar is how it was the last time I rebased, to v4.17.
> 
> I'll set aside what I'm doing, and switch to rebasing ours to v5.3-rc
> and/or mmotm.  Then compare with what Alex has, to see if there's any
> good reason to prefer one to the other: if no good reason to prefer ours,
> I doubt we shall bother to repost, but just use it as basis for helping
> to review or improve Alex's.
> 

Thanks for you all! Very glad to see we are trying on same point. :)
Not only on per memcg lru_lock, there are much room on lru and page replacement
tunings. Anyway Hope to see your update and more review comments soon.

Thanks
Alex
