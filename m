From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Export memcg->watermark via sysfs for v2 memcg
Date: Fri, 6 May 2022 08:58:09 -0700
Message-ID: <CALvZod5OK=6Pmf3-iQ_ERE56-C0u6R0SCRcT6axk28kLxRy_RQ@mail.gmail.com>
References: <20220505121329.GA32827@us192.sjc.aristanetworks.com>
 <CALvZod5xiSuJaDjGb+NM18puejwhnPWweSj+N=0RGQrjpjfxbw@mail.gmail.com> <CAPD3tpG1BeTOwTBxkXCxoJagvbn6n1aAEkt0P65g91N9gtK03w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VHy+wusyPADBOcjPYMIU3GWI4e85gM3jZeodGyJVQhA=;
        b=YGRbRScUA8LR419d9cSOfjxmPI30qASgatv9LYfKxT1s7ZO5i8WQkqAVMm0P3oJ4nk
         pBy3k6/8jLxgJSVy7MuL4DUxNA0WmvQ8gnfUfHudyju0I6slP1Mp0HLBuo7jjUPXvoc1
         +2ppp9aeS4CY2viyRJUfAC2jdWa9UL/LWVB3lmNlPkBvpy+G+NMd9SazdehqRdbxwrXH
         edI8bgPLYjrN3G/mKqxCdQimCdKP4M6VVivakQcXQ6nYR6xoLOwI1tp+SrxtmQ4MRnQT
         ApUDsqAx5WIGKy18Lb7Oir3iBhYA4ONUJGRhDTeizI26JCjF/olW7Vs2VyIXz2JNtXnY
         rwDQ==
In-Reply-To: <CAPD3tpG1BeTOwTBxkXCxoJagvbn6n1aAEkt0P65g91N9gtK03w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, May 5, 2022 at 10:27 AM Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, May 5, 2022 at 9:42 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Thu, May 5, 2022 at 5:13 AM Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > v1 memcg exports memcg->watermark as "memory.mem_usage_in_bytes" in
> >
> > *max_usage_in_bytes
>
> Oops, thanks for the correction.
>
> > > sysfs. This is missing for v2 memcg though "memory.current" is exported.
> > > There is no other easy way of getting this information in Linux.
> > > getrsuage() returns ru_maxrss but that's the max RSS of a single process
> > > instead of the aggregated max RSS of all the processes. Hence, expose
> > > memcg->watermark as "memory.watermark" for v2 memcg.
> > >
> > > Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
> >
> > Can you please explain the use-case for which you need this metric?
> > Also note that this is not really an aggregated RSS of all the
> > processes in the cgroup. So, do you want max RSS or max charge and for
> > what use-case?
>
> We run a lot of automated tests when building our software and used to
> run into OOM scenarios when the tests run unbounded. We use this metric
> to heuristically limit how many tests can run in parallel using per test
> historical data.
>
> I understand this isn't really aggregated RSS, max charge works. We just
> need some metric to account for the peak memory usage.  We don't need
> it to be super accurate because there's significant variance between test
> runs anyway. We conservatively use the historical max to limit parallelism.
>
> Since this metric is not exposed in v2 memcg, the only alternative is to
> poll "memory.current" which would be quite inefficient and grossly
> inaccurate.
>

Oh also include the details you explained here in your commit message.
