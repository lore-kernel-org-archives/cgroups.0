From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 12:55:21 +0400
Message-ID: <50471379.3060603@parallels.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com> <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com> <5047074D.1030104@parallels.com> <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com> <50470A87.1040701@parallels.com> <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com> <50470EBF.9070109@parallels.com> <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120905084740.GE3195-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

On 09/05/2012 12:47 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Wed, Sep 05, 2012 at 12:35:11PM +0400, Glauber Costa wrote:
>>> As long as cpuacct and cpu are separate, I think it makes sense to
>>> assume that they at least could be at different granularity.  
>>
>> If they are comounted, and more: forceably comounted, I don't see how to
>> call them separate. At the very best, they are this way for
>> compatibility purposes only, to lay a path that would allow us to get
>> rid of the separation eventually.
> 
> I think this is where we disagree.  I didn't mean that all controllers
> should be using exactly the same hierarchy when I was talking about
> unified hierarchy.  I do think it's useful and maybe even essential to
> allow differing levels of granularity.  cpu and cpuacct could be a
> valid example for this.  Likely blkcg and memcg too.
> 
> So, I think it's desirable for all controllers to be able to handle
> hierarchies the same way and to have the ability to tag something as
> belonging to certain group in the hierarchy for all controllers but I
> don't think it's desirable or feasible to require all of them to
> follow exactly the same grouping at all levels.
> 

By "different levels of granularity" do you mean having just a subset of
them turned on at a particular place?

If yes, having them guaranteed to be comounted is still perceived by me
as a good first step. A natural following would be to turn them on/off
on a per-group basis.



