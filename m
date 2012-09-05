From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 13:31:56 +0400
Message-ID: <50471C0C.7050600@parallels.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>  <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>  <5047074D.1030104@parallels.com>  <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>  <50470A87.1040701@parallels.com>  <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>  <50470EBF.9070109@parallels.com>  <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>  <1346835993.2600.9.camel@twins>  <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>  <50471782.6060800@parallels.com> <1346837209.2600.14.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346837209.2600.14.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

On 09/05/2012 01:26 PM, Peter Zijlstra wrote:
> On Wed, 2012-09-05 at 13:12 +0400, Glauber Costa wrote:
>> On 09/05/2012 01:11 PM, Tejun Heo wrote:
>>> Hello, Peter.
>>>
>>> On Wed, Sep 05, 2012 at 11:06:33AM +0200, Peter Zijlstra wrote:
>>>> *confused* I always thought that was exactly what you meant with unified
>>>> hierarchy.
>>>
>>> No, I never counted out differing granularity.
>>>
>>
>> Can you elaborate on which interface do you envision to make it work?
>> They will clearly be mounted in the same hierarchy, or as said
>> alternatively, comounted.
>>
>> If you can turn them on/off on a per-subtree basis, which interface
>> exactly do you propose for that?
> 
> I wouldn't, screw that. That would result in the exact same problem
> we're trying to fix. I want a single hierarchy walk, that's expensive
> enough.
> 
>> Would a pair of cgroup core files like available_controllers and
>> current_controllers are a lot of drivers do, suffice?
> 
> No.. its not a 'feature' I care to support for 'my' controllers.
> 
> I simply don't want to have to do two (or more) hierarchy walks for
> accounting on every schedule event, all that pointer chasing is stupidly
> expensive.
> 

You wouldn't have to do more than one hierarchy walks for that. What
Tejun seems to want, is the ability to not have a particular controller
at some point in the tree. But if they exist, they are always together.

