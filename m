From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2 2/4] numa: append per-node execution time in
 cpu.numa_stat
Date: Fri, 19 Jul 2019 18:39:31 +0200
Message-ID: <20190719163930.GA854@blackbody.suse.cz>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <65c1987f-bcce-2165-8c30-cf8cf3454591@linux.alibaba.com>
 <6973a1bf-88f2-b54e-726d-8b7d95d80197@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6973a1bf-88f2-b54e-726d-8b7d95d80197@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, Peter Zijlstra <peterz@infradead.org>, mhocko@kernel.org, Ingo Molnar <mingo@redhat.com>, keescook@chromium.org, mcgrof@kernel.org, linux-mm@kvack.org, Hillf Danton <hdanton@sina.com>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 16, 2019 at 11:40:35AM +0800, 王贇  <yun.wang@linux.alibaba.com> wrote:
> By doing 'cat /sys/fs/cgroup/cpu/CGROUP_PATH/cpu.numa_stat', we see new
> output line heading with 'exectime', like:
> 
>   exectime 311900 407166
What you present are times aggregated over CPUs in the NUMA nodes, this
seems a bit lossy interface. 

Despite you the aggregated information is sufficient for your
monitoring, I think it's worth providing the information with the
original granularity.

Note that cpuacct v1 controller used to report such percpu runtime
stats. The v2 implementation would rather build upon the rstat API.

Michal

