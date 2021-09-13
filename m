From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2 1/3] misc_cgroup: introduce misc.events and misc_events.local
Date: Mon, 13 Sep 2021 09:51:44 -0700
Message-ID: <CAHVum0dmTULvzD6dhr4Jzow-M1ATi-ubDkO5wQR=RQmWtt_78w@mail.gmail.com>
References: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7Yl//dy5tlfXJpNjGw/RwytM2u2c4Gl1NK7VqTyQik=;
        b=KNPJ8GcEHSQYCyweuG+VxPhO+NQJEAV5rGoLEtdlZyPcGARXJQ4RTZmYrXPQfJq0v+
         JanZlPaQbOkPRxSWiNI7mgttz1ig7R1UWK98/qdxhmYcIdlNdL9m9uVRXNb+ON8CCUur
         Vi9ROjD9c/UG3PSZEYPWnZvIs+mpSkp1gAPlYOOV1lg1vbFVacUc2xpLTvh/AmsP+JgO
         4CrYqxGaCg/pOU8W4zn7fgOltRuocCUBGyxISE3mCIfbIKI1U3Q4O+bntohv6KwRgW+T
         qOJmtLwKuZdVpRejUHOK+0Qj6SFpB03AyU99MOkQ/8LtIFscGQ+9aG4sMtPZh+ra5Rex
         hqhw==
In-Reply-To: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn@gmail.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Sun, Sep 12, 2021 at 10:01 PM brookxu <brookxu.cn@gmail.com> wrote:
>
> From: Chunguang Xu <brookxu@tencent.com>
>
> Introduce misc.events and misc.events.local to make it easier for

I thought Tejun only gave go ahead for misc.events and not for
misc.events.local.

> us to understand the pressure of resources. The main idea comes
> from mem_cgroup. Currently only the 'max' event is implemented,
> which indicates the times the resource exceeds the limit.
>

For future emails, please provide the links to previous discussions
like [1], [2],...

> @@ -36,6 +41,8 @@ enum misc_res_type {
>  struct misc_res {
>         unsigned long max;
>         atomic_long_t usage;
> +       atomic_long_t events[MISC_CG_EVENT_TYPES];

Since there is only one event type for now, my recommendation is to
not use the array and just use a single atomic_long_t.

>
> +static const char *const misc_event_name[] = {
> +       "max"
> +};
> +

We will not need it if you remove the array in struct misc_res.

Thanks
Vipin
