From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 1/4] numa: introduce per-cgroup numa balancing locality,
 statistic
Date: Fri, 19 Jul 2019 18:47:11 +0200
Message-ID: <20190719164711.GB854@blackbody.suse.cz>
References: <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <3ac9b43a-cc80-01be-0079-df008a71ce4b@linux.alibaba.com>
 <20190711134754.GD3402@hirez.programming.kicks-ass.net>
 <b027f9cc-edd2-840c-3829-176a1e298446@linux.alibaba.com>
 <20190712075815.GN3402@hirez.programming.kicks-ass.net>
 <37474414-1a54-8e3a-60df-eb7e5e1cc1ed@linux.alibaba.com>
 <20190712094214.GR3402@hirez.programming.kicks-ass.net>
 <f8020f92-045e-d515-360b-faf9a149ab80@linux.alibaba.com>
 <20190715121025.GN9035@blackbody.suse.cz>
 <ecd21563-539c-06b1-92f2-26a111163174@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ecd21563-539c-06b1-92f2-26a111163174@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc: keescook@chromium.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, Peter Zijlstra <peterz@infradead.org>, mcgrof@kernel.org, mhocko@kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, riel@surriel.com, Mel Gorman <mgorman@suse.de>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 16, 2019 at 10:41:36AM +0800, 王贇  <yun.wang@linux.alibaba.com> wrote:
> Actually whatever the memory node sets or cpu allow sets is, it will
> take effect on task's behavior regarding memory location and cpu
> location, while the locality only care about the results rather than
> the sets.
My previous response missed much of the context, so it was a bit off.

I see what you mean by the locality now. Alas, I can't assess whether
it's the right thing to do regarding NUMA behavior that you try to
optimize (i.e. you need an answer from someone more familiar with NUMA
balancing).

Michal
