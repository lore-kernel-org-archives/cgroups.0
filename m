From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH V3 4/8] memcg: add per cgroup dirty pages accounting
Date: Thu, 10 Jan 2013 14:03:00 +0900
Message-ID: <50EE4B84.5080205@jp.fujitsu.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456367-14660-1-git-send-email-handai.szj@taobao.com> <20130102104421.GC22160@dhcp22.suse.cz> <CAFj3OHXKyMO3gwghiBAmbowvqko-JqLtKroX2kzin1rk=q9tZg@mail.gmail.com> <50EA7860.6030300@jp.fujitsu.com> <CAFj3OHXMgRG6u2YoM7y5WuPo2ZNA1yPmKRV29FYj9B6Wj_c6Lw@mail.gmail.com> <50EE247B.6090405@jp.fujitsu.com> <CAFj3OHW=n22veXzR27qfc+10t-nETU=B78NULPXrEDT1S-KsOw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFj3OHW=n22veXzR27qfc+10t-nETU=B78NULPXrEDT1S-KsOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2013/01/10 13:26), Sha Zhengju wrote:

> But this method also has its pros and cons(e.g. need lock nesting). So
> I doubt whether the following is able to deal with these issues all
> together:
> (CPU-A does "page stat accounting" and CPU-B does "move")
>
>               CPU-A                            CPU-B
>
> move_lock_mem_cgroup()
> memcg = pc->mem_cgroup
> SetPageDirty(page)
> move_unlock_mem_cgroup()
>                                        move_lock_mem_cgroup()
>                                        if (PageDirty) {
>                                                 old_memcg->nr_dirty --;
>                                                 new_memcg->nr_dirty ++;
>                                         }
>                                         pc->mem_cgroup = new_memcg
>                                         move_unlock_mem_cgroup()
>
> memcg->nr_dirty ++
>
>
> For CPU-A, we save pc->mem_cgroup in a temporary variable just before
> SetPageDirty inside move_lock and then update stats if the page is set
> PG_dirty successfully. But CPU-B may do "moving" in advance that
> "old_memcg->nr_dirty --" will make old_memcg->nr_dirty incorrect but
> soon CPU-A will do "memcg->nr_dirty ++" at the heels that amend the
> stats.
> However, there is a potential problem that old_memcg->nr_dirty  may be
> minus in a very short period but not a big issue IMHO.
>

IMHO, this will work. Please take care of that the recorded memcg will not
be invalid pointer when you update the nr_dirty later.
(Maybe RCU will protect it.)

_If_ this method can handle "nesting" problem clearer and make implementation
simpler, please go ahead. To be honest, I'm not sure how the code will be until
seeing the patch. Hmm, why you write SetPageDirty() here rather than
TestSetPageDirty()....

Thanks,
-Kame



