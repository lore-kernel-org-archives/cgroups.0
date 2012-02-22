From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 5/7] shrink support for memcg kmem controller
Date: Wed, 22 Feb 2012 18:00:00 +0400
Message-ID: <4F44F4E0.7060003@parallels.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com> <1329824079-14449-6-git-send-email-glommer@parallels.com> <CABCjUKCcGWsSqUnN-9g77bTLQdZ0HF3ryLz+2PyLK1VucqPjSg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKCcGWsSqUnN-9g77bTLQdZ0HF3ryLz+2PyLK1VucqPjSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hiroyouki Kamezawa <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

On 02/22/2012 03:35 AM, Suleiman Souhlal wrote:
> On Tue, Feb 21, 2012 at 3:34 AM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>
>> @@ -5055,8 +5117,21 @@ int memcg_kmem_newpage(struct mem_cgroup *memcg, struct page *page, unsigned lon
>>   {
>>         unsigned long size = pages<<  PAGE_SHIFT;
>>         struct res_counter *fail;
>> +       int ret;
>> +       bool do_softlimit;
>> +
>> +       ret = res_counter_charge(memcg_kmem(memcg), size,&fail);
>> +       if (unlikely(mem_cgroup_event_ratelimit(memcg,
>> +                                               MEM_CGROUP_TARGET_THRESH))) {
>> +
>> +               do_softlimit = mem_cgroup_event_ratelimit(memcg,
>> +                                               MEM_CGROUP_TARGET_SOFTLIMIT);
>> +               mem_cgroup_threshold(memcg);
>> +               if (unlikely(do_softlimit))
>> +                       mem_cgroup_update_tree(memcg, page);
>> +       }
>>
>> -       return res_counter_charge(memcg_kmem(memcg), size,&fail);
>> +       return ret;
>>   }
>
> It seems like this might cause a lot of kernel memory allocations to
> fail whenever we are at the limit, even if we have a lot of
> reclaimable memory, when we don't have independent accounting.
>
> Would it be better to use __mem_cgroup_try_charge() here, when we
> don't have independent accounting, in order to deal with this
> situation?
>

Yes, it would.
I'll work on that.

