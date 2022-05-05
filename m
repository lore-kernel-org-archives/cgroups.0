From: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2 memcg
Date: Thu, 5 May 2022 22:57:03 +0530
Message-ID: <CAPD3tpG1BeTOwTBxkXCxoJagvbn6n1aAEkt0P65g91N9gtK03w@mail.gmail.com>
References: <20220505121329.GA32827@us192.sjc.aristanetworks.com> <CALvZod5xiSuJaDjGb+NM18puejwhnPWweSj+N=0RGQrjpjfxbw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zsF+kn83mNqrMxbS9TzRocPMWDU65sPUevlcCkR0pr0=;
        b=QOOvGNSB2CcE2vA0mwKhSu3u77etXDnR3iIJvPwzvnl7ScQ+6VWb3TFM6EwGqlAPO0
         cYcV3gTjSab/nDBsg6safyBYjUDkSiH3Irz6oBZD1t0InszqFZtGfHilSGaW3cZHgljR
         1r7dIUPtTqBHfMPU2NhUZqkF22aV2GqjWTGAHW1+Gho1zOL6kr0J3SsYM84bfncvJi1I
         LVlc+VJCUdj9gDHyBNAE9zndwCzC58ikYSrPP/Rqv+uj84lCKpTA5qQ/PG2ogq9t53+q
         3faNtN41LW3s0tLWPEE65+itf70mt6NG2HRuqpv79OfYVXRJXuX+3NrWNtvix1xkWpL0
         kEkA==
In-Reply-To: <CALvZod5xiSuJaDjGb+NM18puejwhnPWweSj+N=0RGQrjpjfxbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, May 5, 2022 at 9:42 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, May 5, 2022 at 5:13 AM Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > v1 memcg exports memcg->watermark as "memory.mem_usage_in_bytes" in
>
> *max_usage_in_bytes

Oops, thanks for the correction.

> > sysfs. This is missing for v2 memcg though "memory.current" is exported.
> > There is no other easy way of getting this information in Linux.
> > getrsuage() returns ru_maxrss but that's the max RSS of a single process
> > instead of the aggregated max RSS of all the processes. Hence, expose
> > memcg->watermark as "memory.watermark" for v2 memcg.
> >
> > Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
>
> Can you please explain the use-case for which you need this metric?
> Also note that this is not really an aggregated RSS of all the
> processes in the cgroup. So, do you want max RSS or max charge and for
> what use-case?

We run a lot of automated tests when building our software and used to
run into OOM scenarios when the tests run unbounded. We use this metric
to heuristically limit how many tests can run in parallel using per test
historical data.

I understand this isn't really aggregated RSS, max charge works. We just
need some metric to account for the peak memory usage.  We don't need
it to be super accurate because there's significant variance between test
runs anyway. We conservatively use the historical max to limit parallelism.

Since this metric is not exposed in v2 memcg, the only alternative is to
poll "memory.current" which would be quite inefficient and grossly
inaccurate.

Ganesan
