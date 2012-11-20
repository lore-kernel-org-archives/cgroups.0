From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 1/8] cgroup: add cgroup->id
Date: Tue, 20 Nov 2012 12:20:19 +0400
Message-ID: <50AB3D43.2030005@parallels.com>
References: <1353093624-22608-1-git-send-email-tj@kernel.org> <1353093624-22608-2-git-send-email-tj@kernel.org> <50AB086E.70901@jp.fujitsu.com> <20121120053112.GE25790@mtj.dyndns.org> <50AB2BCF.2050204@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50AB2BCF.2050204@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, nhorman@tuxdriver.com, containers@lists.linux-foundation.org, daniel.wagner@bmw-carit.de, linux-kernel@vger.kernel.org, john.r.fastabend@intel.com, srivatsa.bhat@linux.vnet.ibm.com, cgroups@vger.kernel.org

On 11/20/2012 11:05 AM, Kamezawa Hiroyuki wrote:
> (2012/11/20 14:31), Tejun Heo wrote:
>> Hello, Kamezawa.
>>
>> On Tue, Nov 20, 2012 at 01:34:54PM +0900, Kamezawa Hiroyuki wrote:
>>> I'm sorry if I misunderstand ... current usage of css-id in
>>> memory/swap cgroup
>>> is for recording information of memory cgroup which may be destroyed.
>>> In some case,
>>> a memcg's cgroup is freed but a struct memcgroup and its css are
>>> available, swap_cgroup
>>> may contain id ot if.
>>> This patch puts cgroup's id at diput(), so, the id used in
>>> swap_cgroup can be
>>> reused while it's in use. Right ?
>>
>> CSSes hold onto cgroups, so if memcg is around, its cgroup doesn't go
>> away, so the right thing to do would be holding onto CSS whlie there
>> are remaining references, which IMHO is the way it should have been
>> implemented from the beginning.  The only reason memcg currently has
>> its own refcnt nested inside css refcnt is because cgroup used to
>> require css refs to be completely drained for cgroup_rmdir() to
>> proceed.  Now that that weirdity is gone, we should go back to sane
>> css based reference counting, right?
>>
> 
> Ah, hm, Maybe I missed new __css_put() implementation...
> 
>> void __css_put(struct cgroup_subsys_state *css)
>> {
>>         struct cgroup *cgrp = css->cgroup;
>>         int v;
>>
>>         rcu_read_lock();
>>         v = css_unbias_refcnt(atomic_dec_return(&css->refcnt));
>>
>>         switch (v) {
>>         case 1:
>>                 if (notify_on_release(cgrp)) {
>>                         set_bit(CGRP_RELEASABLE, &cgrp->flags);
>>                         check_for_release(cgrp);
>>                 }
>>                 break;
>>         case 0:
>>                 schedule_work(&css->dput_work);
>>                 break;
>>         }
>>         rcu_read_unlock();
>> }
> 
> If swap_cgroup holds css's refcnt instead of memcg's....
> final dput will be invoked when the last swap_cgroup release a reference.
> 
> It seems to work and we can drop memcg's refcnt (maybe).
> 
> BTW, css's ID was limited to 65535 to be encoded in 2bytes.
> If we use INT, this will increase size of swap_cgroup.
> (2bytes per page => 4bytes per page) It's preallocated at swapon()
> because allocating memory dynamically when we swap a memory is not good.
> 
> Do we really need 4bytes for ID ? If so, swap_cgroup should be totally
> re-designed.
> 

For the record, I've already came to the conclusion myself that
swap_cgroup should be redesigned for this very same reason. (I was
testing it a while ago). I haven't had much time to think about it,
though. But I was considering using the memcg address itself, in a
sparsely populated structure.


