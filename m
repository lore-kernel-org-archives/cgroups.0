From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 2/3] mm: memcg: add a helper for non-unified stats flushing
Date: Tue, 22 Aug 2023 09:48:54 -0700
Message-ID: <CAJD7tkagAie6otamEEVZb5ohp_QUGdTKUNJTTXYfVaaxhtNcAg@mail.gmail.com>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-3-yosryahmed@google.com> <y7vvyndehadwy5ouounm5oyo52bqhsysiizuphzki2h3bwpdpc@3hvaq6sp6f4k>
 <CAJD7tkaVuiMU-ifJiyH5d_W1hi9DnAymYJxzBxEKCVX+tU=OCA@mail.gmail.com> <5y3e32ek6owren3q5e3gzonzxzdhs53ihywj3mtbhz56hnizfy@fctafygsnfaq>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692722970; x=1693327770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJmDDFJoMLmcyBm51AyWwKm0mGOPqtKf1wtM4HOCd6M=;
        b=z/ZcE0oHwC3zR8NDp4bW3XqoSpzVbY2KmnrUawT1fecWeKXgItsUwmoERgBzAVcrXt
         OyqgwYNeGzzdww9YMqahsKQmONsJaB/JJngxFfXEnp7bUSHTUu9WUyrw2pwy0Xl+beCR
         xPfA24TB0vtuT/DvwxcACnNjjh/mXTjp8Fv/0seZQuHIE6sv3WmXI94PMt//cvRPkiN9
         8yqteKYSfo5q7OpO3Njcp0Pta5kxN8cxXNj+l5R7ZU0NrZdh++lNER4Y1IlEIp/OjzP7
         JKTgrCeaXakGNXdf/8RZsCTLbe/LhI8+SRwvH4b+DRYsBUUFWyLxKFrIQQG8RVPfVytN
         /Y1w==
In-Reply-To: <5y3e32ek6owren3q5e3gzonzxzdhs53ihywj3mtbhz56hnizfy@fctafygsnfaq>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 22, 2023 at 9:35=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Tue, Aug 22, 2023 at 09:00:06AM -0700, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > We can probably also kick FLUSH_TIME forward as well.
>
> True, they guard same work.
>
> > Perhaps I can move both into do_stats_flush() then. If I understand
> > correctly this is what you mean?
>
> Yes.
>
> > What do you think?
>
> The latter is certainly better looking code.
>
> I wasn't sure at first about moving stats_flush_threshold reset before
> actual flush but on second thought it should not be a significant change
> - readers: may skip flushing, the values that they read should still be
>   below the error threshold,

Unified readers will skip anyway as there's an ongoing flush,
non-unified readers don't check the threshold anyway (with this patch
series). So for readers it should not be a change.

> - writers: may be slowed down a bit (because of conditional atomic write
>   optimization in memcg_rstat_updates), presumably not on average
>   though.

Yeah writers will start doing atomic writes once a flush starts
instead of once it ends. I don't think it will matter in practice
though. The optimization is only effective if we manage to surpass the
threshold before the periodic flusher (or any unified flusher) kicks
in and resets it. If we start doing atomic writes earlier, then we
will also stop earlier; the number of atomic writes should stay the
same.

I think the only difference will be the scenario where we start atomic
writes early but the periodic flush happens before we reach the
threshold, in which case we aren't doing a lot of updates anyway.

I hope this makes _any_ sense :)

>
> So the latter should work too.
>

I will include that in v2. I will wait for a bit of further review
comments on this version first.

Thanks for taking a look!

> Michal
