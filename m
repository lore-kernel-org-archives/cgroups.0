From: =?UTF-8?Q?Gra=C5=BEvydas_Ignotas?= <notasas@gmail.com>
Subject: Re: UDP rx packet loss in a cgroup with a memory limit
Date: Wed, 17 Aug 2022 23:12:33 +0300
Message-ID: <CANOLnONQaHXOp1z1rNum74N2b=Ub7t5NsGHqPdHUQL4+4YYEQg@mail.gmail.com>
References: <CANOLnON11vzvVdyJfW+QJ36siWR4-s=HJ2aRKpRy7CP=aRPoSw@mail.gmail.com>
 <CANOLnOPeOi0gxYwd5+ybdv5w=RZEh5JakJPE9xgrSL1cecZHbw@mail.gmail.com>
 <Yv0h1PFxmK7rVWpy@cmpxchg.org> <CALvZod5_LVkOkF+gmefnctmx+bRjykSARm2JA9eqKJx85NYBGQ@mail.gmail.com>
 <CAEA6p_BhAh6f_kAHEoEJ38nunY=c=4WqxhJQUjT+dCSAr_rm8g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=AMde7Yzl8mmvlqIunu6+T9Ocr3m9Ip7KzH42Q+pGJAc=;
        b=D1m+Xmnga/AgU/CL4ihU3qMGfrmtpQeV9FfQ2kfDyU8emY0rugHv/OgbWjgQdINtVu
         5uy0KyJjMS8pyt1qAQdE3/WL4zS15brolv7oMsCPLDt8mwY1Hrqea6iZMXlQzg4fP83m
         gGMTLcJClIQedXLzq9cgxYoSSwUd7v1Y64S95id/u3TA/Xb7aZIQt+qD5wEilawlJ8/T
         4by8HvmwytA5lQHl7VmR0akFS+42S1Q0zvQNeW8SPxuV7kaJFxbF9sjJuwRNNeW+nHtq
         8Uadm+/KpP0uyEOKawD3ObcGAC0xBbjGMKTjT1LijEN90qzcPo4JM2pJ4W0/n0Mu5/P+
         Y4VQ==
In-Reply-To: <CAEA6p_BhAh6f_kAHEoEJ38nunY=c=4WqxhJQUjT+dCSAr_rm8g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Wang <weiwan@google.com>
Cc: Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>

On Wed, Aug 17, 2022 at 9:16 PM Wei Wang <weiwan@google.com> wrote:
>
> On Wed, Aug 17, 2022 at 10:37 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > + Eric and netdev
> >
> > On Wed, Aug 17, 2022 at 10:13 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > >
> > > This is most likely a regression caused by this patch:
> > >
> > > commit 4b1327be9fe57443295ae86fe0fcf24a18469e9f
> > > Author: Wei Wang <weiwan@google.com>
> > > Date:   Tue Aug 17 12:40:03 2021 -0700
> > >
> > >     net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
> > >
> > >     Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
> > >     to give more control to the networking stack and enable it to change
> > >     memcg charging behavior. In the future, the networking stack may decide
> > >     to avoid oom-kills when fallbacks are more appropriate.
> > >
> > >     One behavior change in mem_cgroup_charge_skmem() by this patch is to
> > >     avoid force charging by default and let the caller decide when and if
> > >     force charging is needed through the presence or absence of
> > >     __GFP_NOFAIL.
> > >
> > >     Signed-off-by: Wei Wang <weiwan@google.com>
> > >     Reviewed-by: Shakeel Butt <shakeelb@google.com>
> > >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > >
> > > We never used to fail these allocations. Cgroups don't have a
> > > kswapd-style watermark reclaimer, so the network relied on
> > > force-charging and leaving reclaim to allocations that can block.
> > > Now it seems network packets could just fail indefinitely.
> > >
> > > The changelog is a bit terse given how drastic the behavior change
> > > is. Wei, Shakeel, can you fill in why this was changed? Can we revert
> > > this for the time being?
> >
> > Does reverting the patch fix the issue? However I don't think it will.
> >
> > Please note that we still have the force charging as before this
> > patch. Previously when mem_cgroup_charge_skmem() force charges, it
> > returns false and __sk_mem_raise_allocated takes suppress_allocation
> > code path. Based on some heuristics, it may allow it or it may
> > uncharge and return failure.
>
> The force charging logic in __sk_mem_raise_allocated only gets
> considered on tx path for STREAM socket. So it probably does not take
> effect on UDP path. And, that logic is NOT being altered in the above
> patch.
> So specifically for UDP receive path, what happens in
> __sk_mem_raise_allocated() BEFORE the above patch is:
> - mem_cgroup_charge_skmem() gets called:
>     - try_charge() with GFP_NOWAIT gets called and  failed
>     - try_charge() with __GFP_NOFAIL
>     - return false
> - goto suppress_allocation:
>     - mem_cgroup_uncharge_skmem() gets called
> - return 0 (which means failure)
>
> AFTER the above patch, what happens in __sk_mem_raise_allocated() is:
> - mem_cgroup_charge_skmem() gets called:
>     - try_charge() with GFP_NOWAIT gets called and failed
>     - return false
> - goto suppress_allocation:
>     - We no longer calls mem_cgroup_uncharge_skmem()
> - return 0
>
> So I agree with Shakeel, that this change shouldn't alter the behavior
> of the above call path in such a situation.
> But do let us know if reverting this change has any effect on your test.

The problem is still there (the kernel wasn't compiling after revert,
had to adjust another seemingly unrelated callsite). It's hard to tell
if it's better or worse since it happens so randomly.

>
> >
> > The given patch has not changed any heuristic. It has only changed
> > when forced charging happens. After the path the initial call
> > mem_cgroup_charge_skmem() can fail and we take suppress_allocation
> > code path and if heuristics allow, we force charge with __GFP_NOFAIL.
