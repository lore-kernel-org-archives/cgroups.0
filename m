From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Relax restrictions on kernel threads moving out
 of root cpu cgroup
Date: Tue, 6 Apr 2021 12:15:24 -0400
Message-ID: <YGyJHAlLKqng2WeS@slm.duckdns.org>
References: <1617714261-18111-1-git-send-email-pkondeti@codeaurora.org>
 <YGxjwKbec68sCcqo@slm.duckdns.org>
 <20210406152715.GB21941@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FH0gnE912P3ws0Ef1o02PZUZDtCA2hsCwBkvlqrhqr8=;
        b=RvNzrXJsEBRv4/QkFT7ccs9FMS2KM2Xyywtg7PWDOWn7jMBbsyZXO/k7WRgMaanGPN
         rv4m+Wv9iIfIUS3Peaosb0BctfUnrdEv8eV21o1jufNd71pyz4wr0Bqxrcnk6Simu+0p
         wZRUykd08TqGTZozklIkK0DOPXv8HzYlzgogV96QJSgudJNM+KrF+85QdrMuuZyl7Crd
         qznc+SXXfZWsxgML+LvnXpj3PM+0IXxtJylpXCSCzaYrstIvtuNfnwROH1hqoWwib4FM
         P91SFGXp6SrumY5usXE8ocFHq4HQ65aK+2oKXyPqmKbet/12Wt7rPmV7PI94NgYFjZfk
         lv1w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210406152715.GB21941-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pavan Kondeti <pkondeti-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Tue, Apr 06, 2021 at 08:57:15PM +0530, Pavan Kondeti wrote:
> Yeah. The workqueue attrs comes in handy to reduce the nice/prio of a
> background workqueue if we identify that it is cpu intensive. However, this
> needs case by case analysis, tweaking etc. If there is no other alternative,
> we might end up chasing the background workers and reduce their nice value.

There shouldn't be that many workqueues that consume a lot of cpu cycles.
The usual culprit is kswapd, IO related stuff (writeback, encryption), so it
shouldn't be a long list and we want them identified anyway.

> The problem at our hand (which you might be knowing already) is that, lets say
> we have 2 cgroups in our setup and we want to prioritize UX over background.
> IOW, reduce the cpu.shares of background cgroup. This helps in prioritizing
> Task-A and Task-B over Task-X and Task-Y. However, each individual kworker
> can potentially have CPU share equal to the entire UX cgroup.
> 
> -kworker/0:0
> -kworker/1:0
> - UX
> ----Task-A
> ----Task-B
> - background
> ----Task-X
> ----Task-Y
> Hence we want to move all kernel threads to another cgroup so that this cgroup
> will have CPU share equal to UX.
> 
> The patch presented here allows us to create the above setup. Any other
> alternative approaches to achieve the same without impacting any future
> designs/requirements?

Not quite the same but we already have
/sys/devices/virtual/workqueue/cpumask which affects all unbound workqueues,
so maybe a global default priority knob would help here?

Thanks.

-- 
tejun
