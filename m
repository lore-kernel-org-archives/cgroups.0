From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v1 1/9] cgroup: rename cgroup_rstat_flush_"irqsafe" to "atomic"
Date: Tue, 28 Mar 2023 06:24:36 -0700
Message-ID: <CALvZod7st5ZFZ317fJxV05Wa4yLYC53s6MwFS557ULEZx6EW=g@mail.gmail.com>
References: <20230328061638.203420-1-yosryahmed@google.com> <20230328061638.203420-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680009888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntULfQJggmdaqbZLqK7ncFbPSNSEXt5TzQS/aFU/5Pc=;
        b=iLIlR3VysUqN2n+K7Rz9WKfCcJLSTSx4NXO9I1yXLrlfhLgH5+IkJOW/OExv+tAp2p
         KLwmq425It8H20dpM0ac09a+vLFQBsaodZP50nnSdn4NPSgU/FnP4IoWbe2linipSeqz
         gXPndO8BQ9boGvc7auVZsdo8oEo2nNNubeOewSk0lDqJmSYfpk9BL0NvDdeBZ/+eYbYt
         vCoep2rw0xDCxlAUelFlpn+OMs11ce2T2shwo+AdP9qIAH/gH8oGDJNKaJLz4JCsPJcy
         3O/lx+x7RQmoTNPuwkKIytNaDqU/QTxCL4tT2Daz/Dep3lWyEoL5WhB/cC0yuxcgmIG1
         Cdkg==
In-Reply-To: <20230328061638.203420-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Mon, Mar 27, 2023 at 11:16=E2=80=AFPM Yosry Ahmed <yosryahmed@google.com=
> wrote:
>
> cgroup_rstat_flush_irqsafe() can be a confusing name. It may read as
> "irqs are disabled throughout", which is what the current implementation
> does (currently under discussion [1]), but is not the intention. The
> intention is that this function is safe to call from atomic contexts.
> Name it as such.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Shakeel Butt <shakeelb@google.com>
