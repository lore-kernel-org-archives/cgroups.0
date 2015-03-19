From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 3/4] cpusets,isolcpus: add file to show isolated cpus
 in cpuset
Date: Thu, 19 Mar 2015 09:50:04 +0800
Message-ID: <550A2B4C.5030705@huawei.com>
References: <1425917530-1771-1-git-send-email-riel@redhat.com> <1425917530-1771-4-git-send-email-riel@redhat.com> <20150318164745.GA21564@htj.duckdns.org> <550A0CDF.1060709@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <550A0CDF.1060709@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Rik van Riel <riel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>

On 2015/3/19 7:40, Rik van Riel wrote:
> On 03/18/2015 12:47 PM, Tejun Heo wrote:
>> On Mon, Mar 09, 2015 at 12:12:09PM -0400, riel@redhat.com wrote:
>>> From: Rik van Riel <riel@redhat.com>
>>>
>>> The previous patch makes it so the code skips over isolcpus when
>>> building scheduler load balancing domains. This makes it hard to
>>> see for a user which of the CPUs in a cpuset are participating in
>>> load balancing, and which ones are isolated cpus.
>>>
>>> Add a cpuset.isolcpus file with info on which cpus in a cpuset are
>>> isolated CPUs.
>>>
>>> This file is read-only for now. In the future we could extend things
>>> so isolcpus can be changed at run time, for the root (system wide)
>>> cpuset only.
>>
>> Didn't Li say that this is trivially computable from userland?  I'm
>> not sure this knob actually belongs to cpuset.
> 
> I don't know whether the information to compute this is
> always visible from userland.  I am happy to drop this
> patch if Li prefers things that way, though.
> 

What I proposed is adding /sys/devices/system/cpu/isolated. Sysfs is
visible in containers, unless specially configured not so.
