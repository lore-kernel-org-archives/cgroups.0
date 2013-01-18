From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 3/7] memcg: provide online test for memcg
Date: Fri, 18 Jan 2013 11:42:43 -0800
Message-ID: <50F9A5B3.8050203@parallels.com>
References: <1357897527-15479-1-git-send-email-glommer@parallels.com> <1357897527-15479-4-git-send-email-glommer@parallels.com> <20130118153715.GG10701@dhcp22.suse.cz> <20130118155621.GH10701@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130118155621.GH10701-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 01/18/2013 07:56 AM, Michal Hocko wrote:
> On Fri 18-01-13 16:37:15, Michal Hocko wrote:
>> On Fri 11-01-13 13:45:23, Glauber Costa wrote:
>>> Since we are now splitting the memcg creation in two parts, following
>>> the cgroup standard, it would be helpful to be able to determine if a
>>> created memcg is already online.
>>>
>>> We can do this by initially forcing the refcnt to 0, and waiting until
>>> the last minute to flip it to 1.
>>
>> Is this useful, though? What does it tell you? mem_cgroup_online can say
>> false even though half of the attributes have been already copied for
>> example. I think it should be vice versa. It should mark the point when
>> we _start_ copying values. mem_cgroup_online is not the best name then
>> of course. It depends what it is going to be used for...
> 
> And the later patch in the series shows that it is really not helpful on
> its own. You need to rely on other lock to be helpful.
No, no need not.

The lock is there to protect the other fields, specially the outer
iterator. Not this in particular

> This calls for
> troubles and I do not think the win you get is really worth it. All it
> gives you is basically that you can change an inheritable attribute
> while your child is between css_alloc and css_online and so your
> attribute change doesn't fail if the child creation fails between those
> two. Is this the case you want to handle? Does it really even matter?
> 

I think it matters a lot. Aside from the before vs after discussion to
which I've already conceded, without this protection we can't guarantee
that we won't end up with an inconsistent value of the tunables between
parent and child.

