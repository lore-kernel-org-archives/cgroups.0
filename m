From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 2 Oct 2017 13:24:25 -0700
Message-ID: <CALvZod5qiF_7k=D7uiF=GwQEgc7Vztn-DNYMxsnmKGrk3DaYBQ@mail.gmail.com>
References: <CAAAKZws88uF2dVrXwRV0V6AH5X68rWy7AfJxTxYjpuiyiNJFWA@mail.gmail.com>
 <20170927074319.o3k26kja43rfqmvb@dhcp22.suse.cz> <CAAAKZws2CFExeg6A9AzrGjiHnFHU1h2xdk6J5Jw2kqxy=V+_YQ@mail.gmail.com>
 <20170927162300.GA5623@castle.DHCP.thefacebook.com> <CAAAKZwtApj-FgRc2V77nEb3BUd97Rwhgf-b-k0zhf1u+Y4fqxA@mail.gmail.com>
 <CALvZod7iaOEeGmDJA0cZvJWpuzc-hMRn3PG2cfzcMniJtAjKqA@mail.gmail.com>
 <20171002122434.llbaarb6yw3o3mx3@dhcp22.suse.cz> <CALvZod65LYZZYy6uE=DQaQRPXYAhAci=NMG_w=ZANPGATgRwfg@mail.gmail.com>
 <20171002192814.sad75tqklp3nmr4m@dhcp22.suse.cz> <CALvZod4=+GVg+hrT4ubp9P4b+LUZ+q9mz4ztC=Fc_cmTZmvpcw@mail.gmail.com>
 <20171002195601.3jeocmmzyf2jl3dw@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Kos/GI0RH7mriHozrov8VNRNFXSOdnYXEqG9DHIXXo0=;
        b=a+NmGAbktYRL3yBoK5N9w0Zaqxf/yAPVLvKJZFxyY8QJY+0O5uKFlhFpzJAdqrEjNm
         LIiERUFESzttOtKdwoF8zmmWkyfTAuzac0RvM9h0oIOzyOKuWILLTmJcWA2KrvoD7p9G
         ByIxYRsWNVg0XFwVozoaFrMKQSOSaqUr9YRj0MYD4VKoVvqh9D8Jzi7rpfdWfsVI9g4c
         X0zniHC25uccVodjFTpC129F/U0nAFmef19RE7ZteEkse0+am2fYq6FfAx94X3pkOvXm
         zOjF5MXO4cFrtBry69LyYtVK2vRuh4lzd3Y7uIpvJMQ0F/vlS8wB4nYZn18LAWGYyZ9f
         CXXQ==
In-Reply-To: <20171002195601.3jeocmmzyf2jl3dw@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tim Hockin <thockin@hockin.org>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Oct 2, 2017 at 12:56 PM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 02-10-17 12:45:18, Shakeel Butt wrote:
>> > I am sorry to cut the rest of your proposal because it simply goes over
>> > the scope of the proposed solution while the usecase you are mentioning
>> > is still possible. If we want to compare intermediate nodes (which seems
>> > to be the case) then we can always provide a knob to opt-in - be it your
>> > oom_gang or others.
>>
>> In the Roman's proposed solution we can already force the comparison
>> of intermediate nodes using 'oom_group', I am just requesting to
>> separate the killall semantics from it.
>
> oom_group _is_ about killall semantic.  And comparing killable entities
> is just a natural thing to do. So I am not sure what you mean
>

I am saying decouple the notion of comparable entities and killable entities.
