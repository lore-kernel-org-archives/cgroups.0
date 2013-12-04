From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
Date: Wed, 4 Dec 2013 11:35:29 +0400
Message-ID: <529EDB41.8030505@parallels.com>
References: <1385989693-28788-1-git-send-email-vdavydov@parallels.com> <20131202181501.GA5524@dhcp22.suse.cz> <CAA6-i6rWsZNQmFY5L-=yc6TaTGyg4hP4qn9gMZVsu8wWJ=1ywg@mail.gmail.com> <529CDDB3.3090301@parallels.com> <CAA6-i6q+WooWMSbJwLS=ByVu=fgAQuep99iP7tAXiuLABu2gVA@mail.gmail.com> <529D9100.4070207@parallels.com> <CAA6-i6q2viRkbjYOHcoiCHgvdfbfo-4j0k9gj9AA4SH1YToqVg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA6-i6q2viRkbjYOHcoiCHgvdfbfo-4j0k9gj9AA4SH1YToqVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 12/04/2013 02:38 AM, Glauber Costa wrote:
>> In memcg_update_kmem_limit() we do the whole process of limit
>> initialization under a mutex so the situation we need protection from in
>> tcp_update_limit() is impossible. BTW once set, the 'activated' flag is
>> never cleared and never checked alone, only along with the 'active'
>> flag, that's why I doubt we need it at all.
> The updates are protected by a mutex, but the readers are not, and should not.
> So we can still be patching the readers, and the double-flag was
> initially used so
> we can make sure that both flags are only set after the static branches are in.
>
> Note that one of the flags is set inside memcg_update_cache_sizes(). After that,
> we call static_key_slow_inc(). At this point, someone whose code is
> patched in could
> start accounting, but it shouldn't - because not all sites are patched in.
>
> So after the update is done, we set the other flag, and now everybody
> will start going
> through.
>
> Could you do something clever with just one flag? Probably yes. But I
> doubt it would
> be that much cleaner, this is just the way that patching sites work.

Thank you for spending your time to listen to me.

Let me try to explain what is bothering me.

We have two state bits for each memcg, 'active' and 'activated'. There
are two scenarios where the bits can be modified:

1) The kmem limit is set on a memcg for the first time -
memcg_update_kmem_limit(). Here we call memcg_update_cache_sizes(),
which sets the 'activated' bit on success, then update static branching,
then set the 'active' bit. All three actions are done atomically in
respect to other tasks setting the limit due to the set_limit_mutex.
After both bits are set, they never get cleared for the memcg.

2) When a subgroup of a kmem-active cgroup is created -
memcg_propagate_kmem(). Here we copy kmem_account_flags from the parent,
then increase static branching refcounter, then call
memcg_update_cache_sizes() for the new memcg, which may clear the
'activated' bit on failure. After successful execution, the state bits
never get cleared for the new memcg.

In scenario 2 there is no need bothering about the flags setting order,
because we don't have any tasks in the cgroup yet - the tasks can be
moved in only after css_online finishes when we have both of the bits
set and the static branching enabled. Actually, we already do not bother
about it, because we have both bits set before the cgroup is fully
initialized (memcg_update_cache_sizes() is called).

Let's look at scenario 1. There we have two bits - 'activated' and
'active' - the latter is always set after the former and after the
static branching is enabled. Moreover, none of the bits is cleared once
it's set. That said checking if both bits are set - I mean
memcg_can_account_kmem() - is equivalent to checking if the 'acitve' bit
is set. Next, the 'activated' bit is never checked alone, only along
with the 'active' bit in memcg_can_account_kmem() - I do not count
(!memcg->kmem_account_flags) check in memcg_update_kmem_limit(), because
it is done under the set_limit_mutex. What's the deal having it then?

Thanks and sorry for disturbing you.
