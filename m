From: Honglei Wang <wanghonglei@didichuxing.com>
Subject: Re: [RESEND PATCH RFC] cgroup: support numabalancing disable in
 cgroup level
Date: Tue, 14 Dec 2021 14:13:18 +0800
Message-ID: <21e7bb02-1d02-21f2-159d-71ca6529bb66@didichuxing.com>
References: <a6aa93b2-cb28-6d79-10ef-7b18bae11231@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <a6aa93b2-cb28-6d79-10ef-7b18bae11231@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Gang Li <ligang.bdlg@bytedance.com>, tj@kernel.org
Cc: bristot@redhat.com, bsegall@google.com, cgroups@vger.kernel.org, dietmar.eggemann@arm.com, hannes@cmpxchg.org, jameshongleiwang@126.com, juri.lelli@redhat.com, linux-kernel@vger.kernel.org, lizefan.x@bytedance.com, mgorman@suse.de, mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, vincent.guittot@linaro.org



On 2021/12/14 10:50, Gang Li wrote:
> Hi,
> How about my per-process numa balancning patch;)
> 
> https://lore.kernel.org/all/20211206024530.11336-1-ligang.bdlg@bytedance.com/ 
>
Thanks, I believe both patches are base on the same reason. I did a 
quick search after reading tejun's message. Seems numactl with 
interleave option helps on the case, you can have a test to see if it's 
what you want.

Thanks,
Honglei
