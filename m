From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: Re: [PATCH v2 2/4] numa: append per-node execution time in
 cpu.numa_stat
Date: Mon, 22 Jul 2019 10:36:45 +0800
Message-ID: <08280b56-edc1-288a-d38d-1c8bf8b988a7@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <65c1987f-bcce-2165-8c30-cf8cf3454591@linux.alibaba.com>
 <6973a1bf-88f2-b54e-726d-8b7d95d80197@linux.alibaba.com>
 <20190719163930.GA854@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190719163930.GA854@blackbody.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, Peter Zijlstra <peterz@infradead.org>, mhocko@kernel.org, Ingo Molnar <mingo@redhat.com>, keescook@chromium.org, mcgrof@kernel.org, linux-mm@kvack.org, Hillf Danton <hdanton@sina.com>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org



On 2019/7/20 上午12:39, Michal Koutný wrote:
> On Tue, Jul 16, 2019 at 11:40:35AM +0800, 王贇  <yun.wang@linux.alibaba.com> wrote:
>> By doing 'cat /sys/fs/cgroup/cpu/CGROUP_PATH/cpu.numa_stat', we see new
>> output line heading with 'exectime', like:
>>
>>   exectime 311900 407166
> What you present are times aggregated over CPUs in the NUMA nodes, this
> seems a bit lossy interface. 
> 
> Despite you the aggregated information is sufficient for your
> monitoring, I think it's worth providing the information with the
> original granularity.

As Peter suggested previously, kernel do not report jiffies to user anymore
and 'ms' could be better, I guess usually we care about how much the percentage
is on a particular node?

> 
> Note that cpuacct v1 controller used to report such percpu runtime
> stats. The v2 implementation would rather build upon the rstat API.

Support cgroup v2 is on the plan :-) let's mark this as todo currently,
i suppose they may not share the same piece of code.

Regards,
Michael Wang

> 
> Michal
> 
