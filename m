From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC bpf-next] Hierarchical Cgroup Stats Collection Using BPF
Date: Mon, 28 Mar 2022 02:22:06 -0700
Message-ID: <CAJD7tkYK7A1Vn+LRo9xZA+K7BuRmWeUyLX6XE-g-MBf8myLn6Q@mail.gmail.com>
References: <CAJD7tkbQNpeX8MGw9dXa5gi6am=VNXwgwUoTd6+K=foixEm1fw@mail.gmail.com>
 <Yi7ULpR70HatVP/8@slm.duckdns.org> <CAJD7tkYGUaeeFMJSWNbdgaoEq=kFTkZzx8Jy1fwWBvt2WEfqAA@mail.gmail.com>
 <f049c2f6-499b-ff7a-3910-38487878606a@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tH6vHR9kCH+NPukJnjAaBd+mpjJ8sCuBLDfcwcVYg4I=;
        b=Gomwsgqcc5G4y4sCHxDYeBsL0kU62rY/xNhOxwhAcqftO8/kCgQ5J57BFSIgnhQiGf
         ubMotdKqupuh5Hzae+8D7+mnC+/IdK+hfC8qgCZkggge0kLvPM9ebDt8Yj22oguNZdQ9
         N6xNkTeXk0uFjLWtc7v8+UVuym6t96OzehARRawtd4H8hmQ9ctBNvjcgJc1T7hFlOLGC
         CMWEVKiehCtlseLN/+E+Hf3/4U+ho3QOgIdFR03zUb757cTkMPVui+WdgyVO1UL+mugy
         jRue3rN1i5bcrnohe8NFKWShUw9VGbbEJcuJSdOwfi250k4QUQsJXeWf/WJYwWg9vb8/
         j1bQ==
In-Reply-To: <f049c2f6-499b-ff7a-3910-38487878606a-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, Mar 22, 2022 at 11:09 AM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>
>
>
> On 3/16/22 9:35 AM, Yosry Ahmed wrote:
> > Hi Tejun,
> >
> > Thanks for taking the time to read my proposal! Sorry for the late
> > reply. This email skipped my inbox for some reason.
> >
> > On Sun, Mar 13, 2022 at 10:35 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >>
> >> Hello,
> >>
> >> On Wed, Mar 09, 2022 at 12:27:15PM -0800, Yosry Ahmed wrote:
> >> ...
> >>> These problems are already addressed by the rstat aggregation
> >>> mechanism in the kernel, which is primarily used for memcg stats. We
> >>
> >> Not that it matters all that much but I don't think the above statement is
> >> true given that sched stats are an integrated part of the rstat
> >> implementation and io was converted before memcg.
> >>
> >
> > Excuse my ignorance, I am new to kernel development. I only saw calls
> > to cgroup_rstat_updated() in memcg and io and assumed they were the
> > only users. Now I found cpu_account_cputime() :)
> >
> >>> - For every cgroup, we will either use flags to distinguish BPF stats
> >>> updates from normal stats updates, or flush both anyway (memcg stats
> >>> are periodically flushed anyway).
> >>
> >> I'd just keep them together. Usually most activities tend to happen
> >> together, so it's cheaper to aggregate all of them in one go in most cases.
> >
> > This makes sense to me, thanks.
> >
> >>
> >>> - Provide flags to enable/disable using per-cpu arrays (for stats that
> >>> are not updated frequently), and enable/disable hierarchical
> >>> aggregation (for non-hierarchical stats, they can still make benefit
> >>> of the automatic entries creation & deletion).
> >>> - Provide different hierarchical aggregation operations : SUM, MAX, MIN, etc.
> >>> - Instead of an array as the map value, use a struct, and let the user
> >>> provide an aggregator function in the form of a BPF program.
> >>
> >> I'm more partial to the last option. It does make the usage a bit more
> >> compilcated but hopefully it shouldn't be too bad with good examples.
> >>
> >> I don't have strong opinions on the bpf side of things but it'd be great to
> >> be able to use rstat from bpf.
> >
> > It indeed gives more flexibility but is more complicated. Also, I am
> > not sure about the overhead to make calls to BPF programs in every
> > aggregation step. Looking forward to get feedback on the bpf side of
> > things.
>
> Hi, Yosry, I heard this was discussed in bpf office hour which I
> didn't attend. Could you summarize the conclusion and what is the
> step forward? We also have an internal tool which collects cgroup
> stats and this might help us as well. Thanks!
>
> >
> >>
> >> Thanks.
> >>
> >> --
> >> tejun

Hi Yonghong,

Hao has already done an excellent job summarizing the outcome of the meeting.

The idea I have is basically to introduce "rstat flushing" BPF
programs. BPF programs that collect and display stats would use
helpers to call cgroup_rstat_flush() and cgroup_rstat_updated() (or
similar). rstat would then make calls to the "rstat flushing" BPF
programs during flushes, similar to calls to css_rstat_flush().

I will work on an RFC patch(es) for this soon. Let me know if you have
any comments/suggestions/feedback.

Thanks!
