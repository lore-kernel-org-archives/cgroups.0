From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] memcg: charge before adding to swapcache on swapin
Date: Fri, 5 Mar 2021 15:20:48 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2103051519460.1856@eggly.anvils>
References: <20210305212639.775498-1-shakeelb@google.com> <CALvZod5oPTj8r6vKXVGgtKoXVaRWbRX9S2mLVtSnyysqtzr_ng@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=r0cTPvXdPd9aXoIuTSiB+0BptUG2HNyX6VD0hnKItjg=;
        b=IbW9BqWseyXJunfwk6vypcVhPM+2f00lqu+yPIf3i41yBB3U5kG6VJwHyyyzipvUcp
         Jdclyo7xbJuBiOMrpb+Xx8T4Y8lg73KtuHhrAZcbWI8SKiUkS61MweoA31Psyv9zholn
         qSagH5RJmp3v8GEPtNkbIfOC2ukMr68AEhnOeuR+z9ftl9I/2ghIBnJxLPNhlEAh7+vk
         JSKIdRV1Pmp+08NC0NUfZ/EnxiirZfHnuEsdaiUqDTT6qqJPzWnBtUuDCT/s4UZn/TeD
         47KfBlUwFBGH+ZLQ47DM7ivUbE88YHaKoQXHKYxF5Kodqils0+P4mK4R1D5nnRjkLRRJ
         uqBQ==
In-Reply-To: <CALvZod5oPTj8r6vKXVGgtKoXVaRWbRX9S2mLVtSnyysqtzr_ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, 5 Mar 2021, Shakeel Butt wrote:
> On Fri, Mar 5, 2021 at 1:26 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Currently the kernel adds the page, allocated for swapin, to the
> > swapcache before charging the page. This is fine but now we want a
> > per-memcg swapcache stat which is essential for folks who wants to
> > transparently migrate from cgroup v1's memsw to cgroup v2's memory and
> > swap counters. In addition charging a page before exposing it to other
> > parts of the kernel is a step in the right direction.
> >
> > To correctly maintain the per-memcg swapcache stat, this patch has
> > adopted to charge the page before adding it to swapcache. One
> > challenge in this option is the failure case of add_to_swap_cache() on
> > which we need to undo the mem_cgroup_charge(). Specifically undoing
> > mem_cgroup_uncharge_swap() is not simple.
> >
> > To resolve the issue, this patch introduces transaction like interface
> > to charge a page for swapin. The function mem_cgroup_charge_swapin_page()
> > initiates the charging of the page and mem_cgroup_finish_swapin_page()
> > completes the charging process. So, the kernel starts the charging
> > process of the page for swapin with mem_cgroup_charge_swapin_page(),
> > adds the page to the swapcache and on success completes the charging
> > process with mem_cgroup_finish_swapin_page().
> 
> And of course I forgot to update the commit message.
> 
> Andrew, please replace the third paragraph with the following para:
> 
> To resolve the issue, this patch decouples the charging for swapin pages from
> mem_cgroup_charge(). Two new functions are introduced,
> mem_cgroup_swapin_charge_page() for just charging the swapin page and
> mem_cgroup_swapin_uncharge_swap() for uncharging the swap slot once the
> page has been successfully added to the swapcache.

Lgtm
Hugh
