From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 08:41:11 -0700
Message-ID: <CALvZod7TSQ2RdL4iKx5egYOtDvZdGY--T90As_guZK+BoBvAOw@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkXkA+Oh1Bx33PrU@carbon.dhcp.thefacebook.com> <CAJD7tkZxqWg2NRi=83wSWLiykZBfrP8Kx_C5JWy48=rZoBWoHw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqJWbvvbg0qdWklwqs2qhrfKKi69liUYvCt62FUbnWk=;
        b=Fn5jpMZAmMPReAvL0Tyf7tj5rAcmThNhnq1xKoKFkJI0vR0fJhwRbtqFchPRvfX4q1
         ONoUm1fDJi9X/SdotI5xdBPmgeBbrWo8/YaW2ybUubSt1izJy97NcFaxs+dJxWC0WBMf
         6z+iwlN+sbK2nfsp4T5xwzKsl3sE9+883flPy03nnksy67+Yj2ZYN4oSkYQiIHtJaUUH
         6+GoJw85rhIbSF3mvBhZg+VFZFkJaWhhkPhJhHoJqg/NLIlaGVi7lJF460tom7CJNf71
         QLXswXjH3yWTPwjM8DWIfiObLitVJeSiXu0UH1DAOa8qNyI5WVPl/7tgONlEth6eYrLf
         Uwag==
In-Reply-To: <CAJD7tkZxqWg2NRi=83wSWLiykZBfrP8Kx_C5JWy48=rZoBWoHw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Fri, Apr 1, 2022 at 2:16 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>
[...]
> > > +     {
> > > +             .name = "reclaim",
> > > +             .flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
> > > +             .write = memory_reclaim,
> >
> > Btw, why not on root?
>
> I missed the root question in my first reply. I think this was
> originally modeled after the memory.high interface, but I don't know
> if there are other reasons. Shakeel would know better.
>
> AFAIK this should work naturally on root as well, but I think it makes
> more sense then to use a global interface (hopefully introduced soon)?
> I don't have an opinion here let me know what you prefer for v2.

We will follow the psi example which is exposed for root as well as
for system level in procfs but both of these (for memory.reclaim) are
planned as the followup feature.
