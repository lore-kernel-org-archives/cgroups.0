From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 1/4] numa: introduce per-cgroup numa balancing locality,
 statistic
Date: Mon, 15 Jul 2019 14:10:25 +0200
Message-ID: <20190715121025.GN9035@blackbody.suse.cz>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <3ac9b43a-cc80-01be-0079-df008a71ce4b@linux.alibaba.com>
 <20190711134754.GD3402@hirez.programming.kicks-ass.net>
 <b027f9cc-edd2-840c-3829-176a1e298446@linux.alibaba.com>
 <20190712075815.GN3402@hirez.programming.kicks-ass.net>
 <37474414-1a54-8e3a-60df-eb7e5e1cc1ed@linux.alibaba.com>
 <20190712094214.GR3402@hirez.programming.kicks-ass.net>
 <f8020f92-045e-d515-360b-faf9a149ab80@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f8020f92-045e-d515-360b-faf9a149ab80@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc: Peter Zijlstra <peterz@infradead.org>, keescook@chromium.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, mcgrof@kernel.org, mhocko@kernel.org, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, riel@surriel.com, Mel Gorman <mgorman@suse.de>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hello Yun.

On Fri, Jul 12, 2019 at 06:10:24PM +0800, 王贇  <yun.wang@linux.alibaba.com> wrote:
> Forgive me but I have no idea on how to combined this
> with memory cgroup's locality hierarchical update...
> parent memory cgroup do not have influence on mems_allowed
> to it's children, correct?
I'd recommend to look at the v2 of the cpuset controller that implements
the hierarchical behavior among configured memory node sets.

(My comment would better fit to 
    [PATCH 3/4] numa: introduce numa group per task group
IIUC, you could use cpuset controller to constraint memory nodes.)

For the second part (accessing numa statistics, i.e. this patch), I
wonder wheter this information wouldn't be better presented under the
cpuset controller too.

HTH,
Michal
