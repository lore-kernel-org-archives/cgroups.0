From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm/memcontrol:rewrite mem_cgroup_page_lruvec()
Date: Fri, 6 Nov 2020 08:44:26 -0800
Message-ID: <CALvZod7-FnQNqH-REJtrSuo+xfVMyv0os83-MvXS=ciGKZGA4g@mail.gmail.com>
References: <20201104142516.GA106571@rlk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFLzWInf7oW7bjGKiJqYb2/P1LPe/HLqYvjRIRLjv10=;
        b=RQjhXcPHc5TehIv2m28NXMCfMB8WOK9adl90A+M0wwX8PK6WMj5fVagX1y4Z5YeMsM
         /1FU5uFqyQmCBuHK0ikHPWvQrVgo1mHtafkOOO5k5CY7cpfLKoxGtKeLHpLb3lY/jJ9C
         RVOaNkFwUQJ/bhi8vvvNok/I/RDEDELO9MiyB2iPiBqfmvEnqBk71I2SRpv+Ban9L2fR
         bEjBtwl9BqqVM/kjUvFv7pNt0oKoD9siqOKBcd2O2cqn16cAH4ZoN6taKDYEzbOWoX10
         VtwXLYKrJU5/wPL353TmCD01vVcEl8/usm8BwvYiDbimiB+SodnlttN7tGoOfFR0PgPv
         XXdw==
In-Reply-To: <20201104142516.GA106571@rlk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Su <sh_def@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>, Chris Down <chris@chrisdown.name>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Wed, Nov 4, 2020 at 6:26 AM Hui Su <sh_def@163.com> wrote:
>
> mem_cgroup_page_lruvec() in memcontrol.c and
> mem_cgroup_lruvec() in memcontrol.h is very similar
> except for the param(page and memcg) which also can be
> convert to each other.
>
> So rewrite mem_cgroup_page_lruvec() with mem_cgroup_lruvec().
>
> Signed-off-by: Hui Su <sh_def@163.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
