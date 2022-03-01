From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive codepaths
Date: Tue, 1 Mar 2022 09:21:12 -0800
Message-ID: <CALvZod7aF9xRc+XvY7GPN7OnDyPitt1H6Q4yrwzAXTFzv1LzWQ@mail.gmail.com>
References: <20220226002412.113819-1-shakeelb@google.com> <Yh3h33W45+YaMo92@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bDu+y+f8JQYU3RGpZYFrasVkU7NMBDyxJALCa/zmka4=;
        b=fZDK1hgTtMcHNo/1P6qNEVs6yPXFW/deYvEker6YOPN/13zmSjk1YYcJXGviYMEHVE
         8E5wYMvxqyk9r+yvmbYSX6r1jorlcBKFdppXneLtzmArqDVTPbn4BjCzfdnEoQYkvwpC
         +1KPBbrEQXutzxvFKYDHODHzf6BNyzYGQyini1yAIT1q5rKocES28Miw5n8nRC4DsrUW
         95jHg8JdltfmO7jbciMVzAMSOll3yN75VkTePIEZC/jJNJdH+LM5DcXvo1Lu0SyJaJgb
         LvnaHbrHPb/kASBRMt331ZL1U+jq0zO09UlbhoWsibz9JmgWc/nM7dCtnLg2Pfsa+8HM
         kCQA==
In-Reply-To: <Yh3h33W45+YaMo92-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 1, 2022 at 1:05 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Fri 25-02-22 16:24:12, Shakeel Butt wrote:
> > Daniel Dao has reported [1] a regression on workloads that may trigger
> > a lot of refaults (anon and file). The underlying issue is that flushing
> > rstat is expensive. Although rstat flush are batched with (nr_cpus *
> > MEMCG_BATCH) stat updates, it seems like there are workloads which
> > genuinely do stat updates larger than batch value within short amount of
> > time. Since the rstat flush can happen in the performance critical
> > codepaths like page faults, such workload can suffer greatly.
> >
> > The easiest fix for now is for performance critical codepaths trigger
> > the rstat flush asynchronously. This patch converts the refault codepath
> > to use async rstat flush. In addition, this patch has premptively
> > converted mem_cgroup_wb_stats and shrink_node to also use the async
> > rstat flush as they may also similar performance regressions.
>
> Why do we need to trigger flushing in the first place from those paths.
> Later in the thread you are saying there is a regular flushing done
> every 2 seconds. What would happen if these paths didn't flush at all?
> Also please note that WQ context can be overwhelmed by other work so
> these flushes can happen much much later.
>
> So in other words why does async work (that can happen at any time
> without any control) make more sense than no flushing?
> --

Without flushing the worst that can happen in the refault path is
false (or missed) activations of the refaulted page. For reclaim code,
some heuristics (like deactivating active LRU or cache-trim) may act
on old information.

However I don't think these are too much concerning as the kernel can
already missed or do false activations on refault. For the reclaim
code, the kernel does force deactivation if it has skipped it in the
initial iterations, so, not much to worry.

Now, coming to your question, yes, we can remove the flushing from
these performance critical codepaths as the stats at most will be 2
second old due to periodic flush. Now for the worst case scenario
where that periodic flush (WQ) is not getting CPU, I think it is
reasonable to put a sync flush if periodic flush has not happened for,
let's say, 10 seconds.
