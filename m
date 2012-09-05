From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Wed, 5 Sep 2012 12:14:12 +0400
Message-ID: <504709D4.2010800@parallels.com>
References: <1346687211-31848-1-git-send-email-glommer@parallels.com> <20120903170806.GA21682@dhcp22.suse.cz> <5045BD25.10301@parallels.com> <20120904130905.GA15683@dhcp22.suse.cz> <504601B8.2050907@parallels.com> <20120904143552.GB15683@dhcp22.suse.cz> <50461241.5010300@parallels.com> <20120904145414.GC15683@dhcp22.suse.cz> <50461610.30305@parallels.com> <20120904162501.GE15683@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120904162501.GE15683-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 09/04/2012 08:25 PM, Michal Hocko wrote:
> On Tue 04-09-12 18:54:08, Glauber Costa wrote:
> [...]
>>>> I'd personally believe merging both our patches together would achieve a
>>>> good result.
>>>
>>> I am still not sure we want to add a config option for something that is
>>> meant to go away. But let's see what others think.
>>>
>>
>> So what you propose in the end is that we add a userspace tweak for
>> something that could go away, instead of a Kconfig for something that go
>> away.
> 
> The tweak is necessary only if you want to have use_hierarchy=1 for all
> cgroups without taking care about that (aka setting the attribute for
> the first level under the root). All the users that use only one level
> bellow root don't have to do anything at all.
> 
>> Way I see it, Kconfig is better because it is totally transparent, under
>> the hood, and will give us a single location to unpatch in case/when it
>> really goes away.
> 
> I guess that by the single location you mean that no other user space
> changes would have to be done, right? If yes then this is not true
> because there will be a lot of configurations setting this up already
> (either by cgconfig or by other scripts). All of them will have to be
> fixed some day.
> 

Some userspaces, not all. And the ones who set:

They are either explicitly setting to 0, and those are the ones we need
to find out, or they are setting to 1, which will be harmless. If they
were all mandated to do it, fine. But they are not everywhere, and much
many other exists that don't touch it at all. What you are proposing is
that *all* userspace tools that use it go flip it, instead of doing it
in the kernel.

As I've said before, distributions have lifecycles where changes in
behavior like this are tolerated. Some of those lifecycles are
incredibly long, in the 5+ years range. It could be really nice if they
would never see use_hierarchy=0 *at all*, which is much better
accomplished by a kernel-side switch. A Kconfig option is the choice
between carrying either an upstream patch or no patch at all (Depending
on timing), and carrying a non-standard patch.


