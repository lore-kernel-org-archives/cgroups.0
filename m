From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug invariant
 on legacy hierarchy
Date: Thu, 16 Apr 2015 17:27:40 +0530
Message-ID: <552FA3B4.6080905@linux.vnet.ibm.com>
References: <20150413070117.GX24151@twins.programming.kicks-ass.net> <552BB3A5.9060905@linux.vnet.ibm.com> <20150413144311.GF5029@twins.programming.kicks-ass.net> <552E4E41.3030008@linux.vnet.ibm.com> <20150415150302.GA25089@mail.hallyn.com> <20150415151926.GS23123@twins.programming.kicks-ass.net> <20150415153035.GA25390@mail.hallyn.com> <20150415154802.GB30337@htj.duckdns.org> <20150415161534.GA25776@mail.hallyn.com> <20150415161811.GD30337@htj.duckdns.org> <20150415163617.GA26177@mail.hallyn.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150415163617.GA26177@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Serge E. Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, svaidy@linux.vnet.ibm.com, nacc@linux.vnet.ibm.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, lizefan@huawei.com, anton@samba.org, bharata@linux.vnet.ibm.com, cgroups@vger.kernel.org, paulmck@linux.vnet.ibm.com, mingo@kernel.org

On 04/15/2015 10:06 PM, Serge E. Hallyn wrote:
> On Wed, Apr 15, 2015 at 12:18:11PM -0400, Tejun Heo wrote:
>> On Wed, Apr 15, 2015 at 11:15:35AM -0500, Serge E. Hallyn wrote:
>>> The reason would be because it breaks "legacy" software.  So that
>>> would only matter if Preeti needs to run such software.
>>
>> Sure, I get that argument but this is changing how the contorller
>> behaves in a major way.
> 
> It is.  My main counter to that would be that it is how cpusets
> should always have worked :)
> 
>>   There are specifics which may make this
>> particular case more justifiable but overall the combination of
>> arguments is pretty weird.
> 
> And becomes harder to reason about and review/maintain.  I agree
> there.
> 
> From userspace, I suppose one approach (though note it is racy) to
> solving this would be to have udev rules which
> 
> . On cpu unplug, record all cgroups which were using that cpu
> . on cpu plug, re-add the cpu to all recorded cgroups for that
> cpu (if any), as well as to any cgroups marked (in some /etc
> file) as using "all" or a percentage of all cpus.

Yes this is the best way to move forward. But the stacks in userspace
that manage cgroups need to each have such a daemon managing the cpusets
like is pointed above. It would have been fair to expect them to do this
except that this is one issue that userspace is expecting the kernel to
handle. The side effects of this behavior of the legacy hierarchy is
showing up in weird ways.

Another approach as Tejun pointed is to switch over to the unified
hierarchy. I can test this out (How do we mount specific controllers in
the unified hierarchy Tejun? It does not allow any mount options today),
but I don't think I can exhaustively test this out by myself across
distros. So I am not confident of this approach.

The last approach would be as Peter pointed, mimick the entire unified
hierarchy through a mount option, similar to the SANE_BEHAVIOR option
that was present earlier and was removed. Tejun ? Can we bring back that
mount option ?

Regards
Preeti U Murthy
> 
> -serge
> 
