From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 6/6] memcg: avoid dangling reference count in creation
 failure.
Date: Mon, 21 Jan 2013 17:26:21 +0400
Message-ID: <50FD41FD.2010007@parallels.com>
References: <1358766813-15095-1-git-send-email-glommer@parallels.com> <1358766813-15095-7-git-send-email-glommer@parallels.com> <20130121123057.GH7798@dhcp22.suse.cz> <50FD3DD4.5050309@parallels.com> <20130121131921.GK7798@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130121131921.GK7798-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On 01/21/2013 05:19 PM, Michal Hocko wrote:
> On Mon 21-01-13 17:08:36, Glauber Costa wrote:
>> On 01/21/2013 04:30 PM, Michal Hocko wrote:
>>> On Mon 21-01-13 15:13:33, Glauber Costa wrote:
>>>> When use_hierarchy is enabled, we acquire an extra reference count
>>>> in our parent during cgroup creation. We don't release it, though,
>>>> if any failure exist in the creation process.
>>>>
>>>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>>> Reported-by: Michal Hocko <mhocko@suse>
>>>
>>> If you put this one to the head of the series we can backport it to
>>> stable which is preferred, although nobody have seen this as a problem.
>>>
>> If I have to send again, I might. But I see no reason to do so otherwise.
> 
> The question is whether this is worth backporting to stable. If yes then
> it makes to move it up the series. Keep it here otherwise. I think the
> failure is quite improbable and nobody complained so far. On the other
> hand this is an obvious bug fix so it should qualify for stable.
> 
> I would wait for others for what they think and do the shuffling after
> all other patches are settled. I would rather be safe and push the fix
> pro-actively.
> 

As improbable as it is, what if we have one of those
bugs-turned-feature, that end up working by accident just because the
refcnt is not flushed? We should fix it, of course, but who knows how
hard it could be?

Of course it is all handwaving, but given that the trigger of this bug
is an unlikely condition, and the effect is a couple of wasted kbs -
even directory removal can proceed all right - and in the most common
use case of children-at-parent-level-only the increased reference will
be in the root memcg anyway... I wouldn't backport it.


