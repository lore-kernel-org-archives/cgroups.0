From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
Date: Tue, 10 Dec 2013 16:05:27 +0400
Message-ID: <52A70387.40501@parallels.com>
References: <CAA6-i6rWsZNQmFY5L-=yc6TaTGyg4hP4qn9gMZVsu8wWJ=1ywg@mail.gmail.com> <529CDDB3.3090301@parallels.com> <CAA6-i6q+WooWMSbJwLS=ByVu=fgAQuep99iP7tAXiuLABu2gVA@mail.gmail.com> <529D9100.4070207@parallels.com> <CAA6-i6q2viRkbjYOHcoiCHgvdfbfo-4j0k9gj9AA4SH1YToqVg@mail.gmail.com> <529EDB41.8030505@parallels.com> <CAA6-i6o+ZuM_fq+PdQJZ40S0d7K35cBvbTELg49+SgLKP5F0xA@mail.gmail.com> <529F1883.3030907@parallels.com> <20131209152256.GD3597@dhcp22.suse.cz> <52A60FA3.20106@parallels.com> <20131210091312.GA20242@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131210091312.GA20242-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 12/10/2013 01:13 PM, Michal Hocko wrote:
> On Mon 09-12-13 22:44:51, Vladimir Davydov wrote:
>> On 12/09/2013 07:22 PM, Michal Hocko wrote:
>>> On Wed 04-12-13 15:56:51, Vladimir Davydov wrote:
>>>> On 12/04/2013 02:08 PM, Glauber Costa wrote:
>>>>>>> Could you do something clever with just one flag? Probably yes. But I
>>>>>>> doubt it would
>>>>>>> be that much cleaner, this is just the way that patching sites work.
>>>>>> Thank you for spending your time to listen to me.
>>>>>>
>>>>> Don't worry! I thank you for carrying this forward.
>>>>>
>>>>>> Let me try to explain what is bothering me.
>>>>>>
>>>>>> We have two state bits for each memcg, 'active' and 'activated'. There
>>>>>> are two scenarios where the bits can be modified:
>>>>>>
>>>>>> 1) The kmem limit is set on a memcg for the first time -
>>>>>> memcg_update_kmem_limit(). Here we call memcg_update_cache_sizes(),
>>>>>> which sets the 'activated' bit on success, then update static branching,
>>>>>> then set the 'active' bit. All three actions are done atomically in
>>>>>> respect to other tasks setting the limit due to the set_limit_mutex.
>>>>>> After both bits are set, they never get cleared for the memcg.
>>>>>>
>>>>> So far so good. But again, note how you yourself describe it:
>>>>> the cations are done atomically  *in respect to other tasks setting the limit*
>>>>>
>>>>> But there are also tasks that are running its courses naturally and
>>>>> just allocating
>>>>> memory. For those, some call sites will be on, some will be off. We need to make
>>>>> sure that *none* of them uses the patched site until *all* of them are patched.
>>>>> This has nothing to do with updates, this is all about the readers.
>>>>>
>>>>>> 2) When a subgroup of a kmem-active cgroup is created -
>>>>>> memcg_propagate_kmem(). Here we copy kmem_account_flags from the parent,
>>>>>> then increase static branching refcounter, then call
>>>>>> memcg_update_cache_sizes() for the new memcg, which may clear the
>>>>>> 'activated' bit on failure. After successful execution, the state bits
>>>>>> never get cleared for the new memcg.
>>>>>>
>>>>>> In scenario 2 there is no need bothering about the flags setting order,
>>>>>> because we don't have any tasks in the cgroup yet - the tasks can be
>>>>>> moved in only after css_online finishes when we have both of the bits
>>>>>> set and the static branching enabled. Actually, we already do not bother
>>>>>> about it, because we have both bits set before the cgroup is fully
>>>>>> initialized (memcg_update_cache_sizes() is called).
>>>>>>
>>>>> Yes, after the first cgroup is set none of that matters. But it is just easier
>>>>> and less error prone just to follow the same path every time. As I have said,
>>>>> if you can come up with a more clever way to deal with the problem above
>>>>> that doesn't involve the double flag - and you can prove it works - I
>>>>> am definitely
>>>>> fine with it. But this is subtle code, and in the past - Michal can
>>>>> attest this - we've
>>>>> changed this being sure it would work just to see it explode in our faces.
>>>>>
>>>>> So although I am willing to review every patch for correctness on that
>>>>> front (I never
>>>>> said I liked the 2-flags scheme...), unless you have a bug or real
>>>>> problem on it,
>>>>> I would advise against changing it if its just to make it more readable.
>>>>>
>>>>> But again, don't take me too seriously on this. If you and Michal think you can
>>>>> come up with something better, I'm all for it.
>>>> All right, I finally get you :-)
>>>>
>>>> Although I still don't think we need the second flag, I now understand
>>>> that it's better not to change the code that works fine especially the
>>>> change does not make it neither more readable nor more effective. Since
>>>> I can be mistaken about the flags usage (it's by far not unlikely), it's
>>>> better to leave it as is rather than being at risk of catching spurious
>>>> hangs that might be caused by this modification.
>>>>
>>>> Thanks for the detailed explanation!
>>> It would be really great if we could push some of that into the
>>> comments, please?
>>>
>>> Anyway, reading this thread again, I guess I finally got what you meant
>>> Vladimir.
>>> You are basically saying that the two stage enabling can be done
>>> by static_key_slow_inc in the first step and memcg_kmem_set_active
>>> in the second step without an additional flag.
>>> Assuming that the writers cannot race (they cannot currently because
>>> they are linearized by set_limit_mutex and memcg_create_mutex) and
>>> readers (charging paths) are _always_ checking the static key before
>>> checking active flags?
>> Right. There is no point in checking the static key after checking
>> active flags, because the benefit of using static branching would
>> disappear then. So IMHO the only thing we should bother is that the
>> static key refcounter is incremented *before* the active bit is set.
>> That assures all static branches have been patched if a charge path
>> succeeds, because a charge path cannot succeed if the active bit is not
>> set. That said we won't skip a commit or uncharge after a charge due to
>> an unpatched static branch. That's why I think the 'active' bit is enough.
>>
>> Currently we have two flags 'activated' and 'active', and their usage
>> looks strange to me. Throughout the code we only have the following checks:
>>     test_bit('active', state_mask)
>>     test_bit('active', state_mask)&&test_bit('activated', state_mask)
>> Since 'active' bit is always set after 'activated' and none of them gets
>> cleared, the latter check is equivalent to the former.
>> Since we never issue a check like this:
>>     test_bit('activated', state_mask)
>> we never actually check the 'activated' bit and do not need it - ???
> That is my current understanding. Care to send a patch with the whole
> reasoning?

I'll try.

Thanks.
