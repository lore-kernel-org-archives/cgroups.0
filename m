From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 7/9] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Thu, 30 Mar 2023 00:42:36 -0700
Message-ID: <CAJD7tkZLBs=A8m5u=9jGtMeD0ptOgtCTYUoh2r4Ex+fCkvwAXg@mail.gmail.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-8-yosryahmed@google.com> <ZCU8tjqzg8cDbobQ@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680162192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Qxb+z0M56kXGKsGqUzmde7aSXJSNER5bkDSqRNFsW8=;
        b=UJBukVFEt5dB7HsMZhm8rpG6GkSrR6oamn4AyWhd8ZQPOX1GhBV/ZV16dR83JU1y/X
         N30JaFrz+2vGq5ca63TxcCERgT6qek7mqtmN81N5//AscM6N8cflImnSD/ZahG+4q0Xn
         9qp/XyM4ZMQRj7L0H7/4AehjvjsguULR7WeiMPvo+WNkpMojlq5AXSO5o21krpYdZ7B3
         PB9AZFZMuLkAAEJQVYvz3QY9bGxfNFE34InRWkd4v45XrEk3Mww05p5yDkBJhramLr+a
         T7lX9urUThW1psrr/JFE2xLVVKoi0OfuM7xGQ2KkdeGHTHhVMnrIjKr3CZ5s/MVVlIAH
         QpSA==
In-Reply-To: <ZCU8tjqzg8cDbobQ@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Thu, Mar 30, 2023 at 12:39=E2=80=AFAM Michal Hocko <mhocko@suse.com> wro=
te:
>
> On Tue 28-03-23 22:16:42, Yosry Ahmed wrote:
> > In workingset_refault(), we call
> > mem_cgroup_flush_stats_atomic_ratelimited() to flush stats within an
> > RCU read section and with sleeping disallowed. Move the call above
> > the RCU read section and allow sleeping to avoid unnecessarily
> > performing a lot of work without sleeping.
>
> Could you say few words why the flushing is done before counters are
> updated rather than after (the RCU section)?

It's not about the counters that are updated, it's about the counters
that we read. Stats readers do a flush first to read accurate stats.
We flush before a read, not after an update.

> --
> Michal Hocko
> SUSE Labs
