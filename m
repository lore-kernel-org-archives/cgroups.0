From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: simplify lock of memcg page stat accounting
Date: Tue, 29 Jan 2013 16:19:15 +0100
Message-ID: <20130129151915.GJ29574@dhcp22.suse.cz>
References: <1359198756-3752-1-git-send-email-handai.szj@taobao.com>
 <20130128141010.GD14241@dhcp22.suse.cz>
 <CAFj3OHUE_grS-Syg+ZhYK-W-TksXpqPjQRZC4Ti4+=zSJUEGMA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFj3OHUE_grS-Syg+ZhYK-W-TksXpqPjQRZC4Ti4+=zSJUEGMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue 29-01-13 21:44:44, Sha Zhengju wrote:
> On Mon, Jan 28, 2013 at 10:10 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
[...]
> >> But CPU-B may do "moving" in advance that
> >> "old_memcg->nr_dirty --" will make old_memcg->nr_dirty incorrect but
> >> soon CPU-A will do "memcg->nr_dirty ++" finally that amend the stats.
> >
> > The counter is per-cpu so we are safe wrt. atomic increments and we can
> > probably tolerate off-by 1 temporal errors (mem_cgroup_read_stat would
> > need val = min(val, 0);).
> 
> Sorry, I cannot catch the 'min(val, 0)' part.. or do you mean max?

Ohh, yeah. Head was telling max, fingers disagreed.
 
-- 
Michal Hocko
SUSE Labs
