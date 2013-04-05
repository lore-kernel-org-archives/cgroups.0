From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC][PATCH 1/7] memcg: use css_get in sock_update_memcg()
Date: Fri, 5 Apr 2013 12:08:40 +0400
Message-ID: <515E8688.3000504@parallels.com>
References: <515BF233.6070308@huawei.com> <515BF249.50607@huawei.com> <515C2788.90907@parallels.com> <20130403152934.GL16471@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130403152934.GL16471-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 04/03/2013 07:29 PM, Michal Hocko wrote:
> On Wed 03-04-13 16:58:48, Glauber Costa wrote:
>> On 04/03/2013 01:11 PM, Li Zefan wrote:
>>> Use css_get/css_put instead of mem_cgroup_get/put.
>>>
>>> Note, if at the same time someone is moving @current to a different
>>> cgroup and removing the old cgroup, css_tryget() may return false,
>>> and sock->sk_cgrp won't be initialized.
>>>
>>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  mm/memcontrol.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 23d0f6e..43ca91d 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -536,15 +536,15 @@ void sock_update_memcg(struct sock *sk)
>>>  		 */
>>>  		if (sk->sk_cgrp) {
>>>  			BUG_ON(mem_cgroup_is_root(sk->sk_cgrp->memcg));
>>> -			mem_cgroup_get(sk->sk_cgrp->memcg);
>>> +			css_get(&sk->sk_cgrp->memcg->css);
> 
> I am not sure I understand this one. So we have a goup here (which means
> that somebody already took a reference on it, right?) and we are taking
> another reference. If this is released by sock_release_memcg then who
> releases the previous one? It is not directly related to the patch
> because this has been done previously already. Could you clarify
> Glauber, please?

This should be documented in the commit that introduced this, and it was
one of the first bugs I've handled with this code.

Bottom line, we can create sockets normally, and those will have process
context. But we also can create sockets by cloning existing sockets. To
the best of my knowledge, this is done by things like accept().

Because those sockets are a clone of their ancestors, they also belong
to a workload that should be limited. Also note that because they have
cgroup context, we will eventually try to put them. So we need to grab
an extra reference.

socket_update_cgroup is always called at socket creation, and the
original structures are filled with zeroes. Therefore cloning is the
*only* path that takes us here with sk->sk_cgroup filled.

My comment right above this excerpt states:

                /* Socket cloning can throw us here with sk_cgrp already
                 * filled. It won't however, necessarily happen from
                 * process context. So the test for root memcg given
                 * the current task's memcg won't help us in this case.
                 *
                 * Respecting the original socket's memcg is a better
                 * decision in this case.
                 */

> 
>>>  			return;
>>>  		}
>>>  
>>>  		rcu_read_lock();
>>>  		memcg = mem_cgroup_from_task(current);
>>>  		cg_proto = sk->sk_prot->proto_cgroup(memcg);
>>> -		if (!mem_cgroup_is_root(memcg) && memcg_proto_active(cg_proto)) {
>>> -			mem_cgroup_get(memcg);
>>> +		if (!mem_cgroup_is_root(memcg) &&
>>> +		    memcg_proto_active(cg_proto) && css_tryget(&memcg->css)) {
>>>  			sk->sk_cgrp = cg_proto;
>>>  		}
>>
>> What happens if this tryget fails ? Won't we leak a reference here? We
>> will put regardless when the socket is released, and this may go
>> negative. No?
>  
> AFAICS sock_release_memcg releases the reference only if sk->sk_cgrp and
> that one wouldn't be set if css_tryget fails.
> 

Yes, this is totally fine. I was actually thinking of the same socket
cloning I mentioned above. We cannot fail that path because we already
have an "implicit" reference, we just need to officially mark it.

Failing here is indeed fine. Future cloned sockets from this socket will
have NULL cgroup context as well.

