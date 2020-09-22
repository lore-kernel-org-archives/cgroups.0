From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Tue, 22 Sep 2020 11:56:13 -0700
Message-ID: <CALvZod6kfF_r5u2ydZ34Q+6QWvg11ZFwfRMHdiNUvi3NJnms=A@mail.gmail.com>
References: <20200909215752.1725525-1-shakeelb@google.com> <20200921163055.GQ12990@dhcp22.suse.cz>
 <CALvZod43VXKZ3StaGXK_EZG_fKcW3v3=cEYOWFwp4HNJpOOf8g@mail.gmail.com>
 <20200922114908.GZ12990@dhcp22.suse.cz> <CALvZod4FvE12o53BpeH5WB_McTdCkFTFXgc9gcT1CEHXzQLy_A@mail.gmail.com>
 <20200922165527.GD12990@dhcp22.suse.cz> <CALvZod7K9g9mi599c5+ayLeC4__kckv155QQGVMVy2rXXOY1Rw@mail.gmail.com>
 <20200922183125.GG12990@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ymw2XfYcqbrKxbh+VHjYTBZabPIEIeS/kxNNZK3Q7GE=;
        b=DV4EUlN276uVi19xQ/E+YB845hHum+zfsKpyj63GqwBiuV/FeabyS0GRc7fKnRLj2n
         El2H+Lui81CyaiWNLzdMPKDWLYLYwcx1t3Bl0cf+3L3WPo3DEuDxNQ32HUZUDZriBXaM
         MpWGnrUlGQSZRctkk3h9v7LtyueARTH7Zw6ACifO2t2eH/xXoieLo19WCHGh6emFW2HL
         GmTE8yAVvlKEsLZkzm01E/hInUAIwYjUtnkYA0EwlKOTTk4FrV1nf3ocHelxTfr1uAC7
         KyOW0HGEZ68aIlHfds/PzuFOpCRUeXZ9/wITZ9lIbqEi8gGIzTntzaPkj4b6fpNPQFBp
         MF5g==
In-Reply-To: <20200922183125.GG12990@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Greg Thelen <gthelen@google.com>, David Rientjes <rientjes@google.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Yang Shi <shy828301@gmail.com>

On Tue, Sep 22, 2020 at 11:31 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Tue 22-09-20 11:10:17, Shakeel Butt wrote:
> > On Tue, Sep 22, 2020 at 9:55 AM Michal Hocko <mhocko@suse.com> wrote:
> [...]
> > > So far I have learned that you are primarily working around an
> > > implementation detail in the zswap which is doing the swapout path
> > > directly in the pageout path.
> >
> > Wait how did you reach this conclusion? I have explicitly said that we
> > are not using uswapd like functionality in production. We are using
> > this interface for proactive reclaim and proactive reclaim is not a
> > workaround for implementation detail in the zswap.
>
> Hmm, I must have missed the distinction between the two you have
> mentioned. Correct me if I am wrong but "latency sensitive" workload is
> the one that cannot use the high limit, right.

Yes.

> For some reason I thought
> that your pro-active reclaim usecase is also not compatible with the
> throttling imposed by the high limit. Hence my conclusion above.
>

For proactive reclaim use-case, it is more about the weirdness of
using memory.high interface for proactive reclaim.

Let's suppose I want to reclaim 20 MiB from a job. To use memory.high,
I have to read memory.current and subtract 20MiB from it and then
write that to memory.high and once that is done, I have to set
memory.high to the previous value (job's original high limit).

There is a time window where the allocation of the target job can hit
the temporary memory.high which will cause uninteresting MEMCG_HIGH
event, PSI pressure and can potentially over reclaim. Also there is a
race between reading memory.current and setting the temporary
memory.high. There are many non-deterministic  variables added to the
request of reclaiming 20MiB from a job.

Shakeel
