From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
 process in the same cgroup
Date: Tue, 12 Jul 2016 09:17:01 +0200
Message-ID: <20160712071701.GC14586@dhcp22.suse.cz>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
 <20160711064150.GB5284@dhcp22.suse.cz>
 <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shayan Pooya <shayan-UQzSddOuLosdnm+yROfE0A@public.gmane.org>
Cc: cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 11-07-16 10:40:55, Shayan Pooya wrote:
> >
> > Could you post the stack trace of the hung oom victim? Also could you
> > post the full kernel log?
> 
> Here is the stack of the process that lives (it is *not* the
> oom-victim) in a run with 100 processes and *without* strace:
> 
> # cat /proc/7688/stack
> [<ffffffff81100292>] futex_wait_queue_me+0xc2/0x120
> [<ffffffff811005a6>] futex_wait+0x116/0x280
> [<ffffffff81102d90>] do_futex+0x120/0x540
> [<ffffffff81103231>] SyS_futex+0x81/0x180
> [<ffffffff81825bf2>] entry_SYSCALL_64_fastpath+0x16/0x71
> [<ffffffffffffffff>] 0xffffffffffffffff

I am not sure I understand. Is this the hung task?
-- 
Michal Hocko
SUSE Labs
