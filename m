From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH V3 4/8] memcg: add per cgroup dirty pages accounting
Date: Wed, 09 Jan 2013 16:24:34 +0900
Message-ID: <50ED1B32.2030007@jp.fujitsu.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456367-14660-1-git-send-email-handai.szj@taobao.com> <20130102104421.GC22160@dhcp22.suse.cz> <CAFj3OHXKyMO3gwghiBAmbowvqko-JqLtKroX2kzin1rk=q9tZg@mail.gmail.com> <alpine.LNX.2.00.1301061135400.29149@eggly.anvils> <50EA7E07.4070902@jp.fujitsu.com> <alpine.LNX.2.00.1301082030100.5319@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1301082030100.5319-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2013/01/09 14:15), Hugh Dickins wrote:
> On Mon, 7 Jan 2013, Kamezawa Hiroyuki wrote:
>> (2013/01/07 5:02), Hugh Dickins wrote:
>>>
>>> Forgive me, I must confess I'm no more than skimming this thread,
>>> and don't like dumping unsigned-off patches on people; but thought
>>> that on balance it might be more helpful than not if I offer you a
>>> patch I worked on around 3.6-rc2 (but have updated to 3.8-rc2 below).
>>>
>>> I too was getting depressed by the constraints imposed by
>>> mem_cgroup_{begin,end}_update_page_stat (good job though Kamezawa-san
>>> did to minimize them), and wanted to replace by something freer, more
>>> RCU-like.  In the end it seemed more effort than it was worth to go
>>> as far as I wanted, but I do think that this is some improvement over
>>> what we currently have, and should deal with your recursion issue.
>>>
>> In what case does this improve performance ?
>
> Perhaps none.  I was aiming to not degrade performance at the stats
> update end, and make it more flexible, so new stats can be updated which
> would be problematic today (for lock ordering and recursion reasons).
>
> I've not done any performance measurement on it, and don't have enough
> cpus for an interesting report; but if someone thinks it might solve a
> problem for them, and has plenty of cpus to test with, please go ahead,
> we'd be glad to hear the results.
>
>> Hi, this patch seems interesting but...doesn't this make move_account() very
>> slow if the number of cpus increases because of scanning all cpus per a page
>> ?
>> And this looks like reader-can-block-writer percpu rwlock..it's too heavy to
>> writers if there are many readers.
>
> I was happy to make the relatively rare move_account end considerably
> heavier.  I'll be disappointed if it turns out to be prohibitively
> heavy at that end - if we're going to make move_account impossible,
> there are much easier ways to achieve that! - but it is a possibility.
>

move_account at task-move has been required feature for NEC and Nishimura-san
did good job. I'd like to keep that available as much as possible.

> Something you might have missed when considering many readers (stats
> updaters): the move_account end does not wait for a moment when there
> are no readers, that would indeed be a losing strategy; it just waits
> for each cpu that's updating page stats to leave that section, so every
> cpu is sure to notice and hold off if it then tries to update the page
> which is to be moved.  (I may not be explaining that very well!)
>

Hmm, yeah, maybe I miss somehing.

BTW, if nesting, mem_cgroup_end_update_page_stat() seems to make counter minus.

Thanks,
-Kame

