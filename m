From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH V3 4/8] memcg: add per cgroup dirty pages accounting
Date: Mon, 07 Jan 2013 16:49:27 +0900
Message-ID: <50EA7E07.4070902@jp.fujitsu.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456367-14660-1-git-send-email-handai.szj@taobao.com> <20130102104421.GC22160@dhcp22.suse.cz> <CAFj3OHXKyMO3gwghiBAmbowvqko-JqLtKroX2kzin1rk=q9tZg@mail.gmail.com> <alpine.LNX.2.00.1301061135400.29149@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1301061135400.29149-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2013/01/07 5:02), Hugh Dickins wrote:
> On Sat, 5 Jan 2013, Sha Zhengju wrote:
>> On Wed, Jan 2, 2013 at 6:44 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
>>>
>>> Maybe I have missed some other locking which would prevent this from
>>> happening but the locking relations are really complicated in this area
>>> so if mem_cgroup_{begin,end}_update_page_stat might be called
>>> recursively then we need a fat comment which justifies that.
>>>
>>
>> Ohhh...good catching!  I didn't notice there is a recursive call of
>> mem_cgroup_{begin,end}_update_page_stat in page_remove_rmap().
>> The mem_cgroup_{begin,end}_update_page_stat() design has depressed
>> me a lot recently as the lock granularity is a little bigger than I thought.
>> Not only the resource but also some code logic is in the range of locking
>> which may be deadlock prone. The problem still exists if we are trying to
>> add stat account of other memcg page later, may I make bold to suggest
>> that we dig into the lock again...
>
> Forgive me, I must confess I'm no more than skimming this thread,
> and don't like dumping unsigned-off patches on people; but thought
> that on balance it might be more helpful than not if I offer you a
> patch I worked on around 3.6-rc2 (but have updated to 3.8-rc2 below).
>
> I too was getting depressed by the constraints imposed by
> mem_cgroup_{begin,end}_update_page_stat (good job though Kamezawa-san
> did to minimize them), and wanted to replace by something freer, more
> RCU-like.  In the end it seemed more effort than it was worth to go
> as far as I wanted, but I do think that this is some improvement over
> what we currently have, and should deal with your recursion issue.
>
In what case does this improve performance ?

> But if this does appear useful to memcg people, then we really ought
> to get it checked over by locking/barrier experts before going further.
> I think myself that I've over-barriered it, and could use a little
> lighter; but they (Paul McKenney, Peter Zijlstra, Oleg Nesterov come
> to mind) will see more clearly, and may just hate the whole thing,
> as yet another peculiar lockdep-avoiding hand-crafted locking scheme.
> I've not wanted to waste their time on reviewing it, if it's not even
> going to be useful to memcg people.
>
> It may be easier to understand if you just apply the patch and look
> at the result in mm/memcontrol.c, where I tried to gather the pieces
> together in one place and describe them ("These functions mediate...").
>
> Hugh
>

Hi, this patch seems interesting but...doesn't this make move_account() very
slow if the number of cpus increases because of scanning all cpus per a page ?
And this looks like reader-can-block-writer percpu rwlock..it's too heavy to
writers if there are many readers.


Thanks,
-Kame


  






