From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug invariant
 on legacy hierarchy
Date: Mon, 20 Apr 2015 11:28:09 +0800
Message-ID: <55347249.1050301@huawei.com>
References: <20150413070117.GX24151@twins.programming.kicks-ass.net> <552BB3A5.9060905@linux.vnet.ibm.com> <20150413144311.GF5029@twins.programming.kicks-ass.net> <552E4E41.3030008@linux.vnet.ibm.com> <20150415150302.GA25089@mail.hallyn.com> <20150415151926.GS23123@twins.programming.kicks-ass.net> <20150415153035.GA25390@mail.hallyn.com> <20150415154802.GB30337@htj.duckdns.org> <20150415161534.GA25776@mail.hallyn.com> <20150415161811.GD30337@htj.duckdns.org> <20150415163617.GA26177@mail.hallyn.com> <552FA3B4.6080905@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FA3B4.6080905-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On 2015/4/16 19:57, Preeti U Murthy wrote:
> On 04/15/2015 10:06 PM, Serge E. Hallyn wrote:
>> On Wed, Apr 15, 2015 at 12:18:11PM -0400, Tejun Heo wrote:
>>> On Wed, Apr 15, 2015 at 11:15:35AM -0500, Serge E. Hallyn wrote:
>>>> The reason would be because it breaks "legacy" software.  So that
>>>> would only matter if Preeti needs to run such software.
>>>
>>> Sure, I get that argument but this is changing how the contorller
>>> behaves in a major way.
>>
>> It is.  My main counter to that would be that it is how cpusets
>> should always have worked :)
>>
>>>   There are specifics which may make this
>>> particular case more justifiable but overall the combination of
>>> arguments is pretty weird.
>>
>> And becomes harder to reason about and review/maintain.  I agree
>> there.
>>
>> From userspace, I suppose one approach (though note it is racy) to
>> solving this would be to have udev rules which
>>
>> . On cpu unplug, record all cgroups which were using that cpu
>> . on cpu plug, re-add the cpu to all recorded cgroups for that
>> cpu (if any), as well as to any cgroups marked (in some /etc
>> file) as using "all" or a percentage of all cpus.
> 
> Yes this is the best way to move forward. But the stacks in userspace
> that manage cgroups need to each have such a daemon managing the cpusets
> like is pointed above. It would have been fair to expect them to do this
> except that this is one issue that userspace is expecting the kernel to
> handle. The side effects of this behavior of the legacy hierarchy is
> showing up in weird ways.
> 
> Another approach as Tejun pointed is to switch over to the unified
> hierarchy. I can test this out (How do we mount specific controllers in
> the unified hierarchy Tejun? It does not allow any mount options today),

You just can't. All controllers are bound to unified hierarchy, except those
already mounted in the old way. That said, in the unified hierarchy you're able
to use cpuset only, so other controllers can still be mounted seperated.

Here is an example:

  # use blkio cgroup in legacy hierachy
  mount -t cgroup -o blkio xxx old/

  # now mount the unified hierarchy
  mount -t cgroup -o __DEVEL__sane_behavior xxx unified/

  # use cpuset only
  mkdir unified/cpuset
  echo +cpuset > cgroup.subtree_control 

  # use memory cgroup in another legacy hierarchy
  mount -t cgroup -o memory xxx old2/

You may refer to Documentation/cgroups/unified-hierarchy.txt

> but I don't think I can exhaustively test this out by myself across
> distros. So I am not confident of this approach.
> 
> The last approach would be as Peter pointed, mimick the entire unified
> hierarchy through a mount option, similar to the SANE_BEHAVIOR option
> that was present earlier and was removed. Tejun ? Can we bring back that
> mount option ?
> 

I don't think it's an option. We want users move to unified hierarchy.
