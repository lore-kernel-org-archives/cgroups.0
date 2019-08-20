From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 00/14] per memcg lru_lock
Date: Tue, 20 Aug 2019 09:48:40 -0700
Message-ID: <CALvZod7-dL90jwd2pywpaD8NfUByVU9Y809+RfvJABGdRASYUg@mail.gmail.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com> <20190820104532.GP3111@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HfS/3YweTIcGGO2RRMlCPJRIxqMja+WwkZZpwCr9I0U=;
        b=K+mam5zvf/E3cU2LIDxXZWug/rqk3N2IZZ43MXOq44SNotDZn+byvLHrUFInHkDO7K
         krZMi68j2Wv9KleBJmISlXyAtf+AWs9TyWORM/Is9r/JWDOIisvRoaxJKLMa9X2+DkSD
         X8/9HsIrCN6cY1UKIUVTesBhBp4i3524bVcclEQ++s0bi/yh5/iX8yzTgk/KVOUmV0on
         7IlLZhBsYqtAIBE6vQRbijMnbR9VYedqBUFYnNM8Rbdx/bhjrOR+OtiJMEX84yYFHCtT
         KdyACLP9WpPoCaDmJFCRZjVP1xzZkn+G18umMyHY3eO4qR19pRTmM/TC8TB1C0CiILyZ
         TXzg==
In-Reply-To: <20190820104532.GP3111@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>

On Tue, Aug 20, 2019 at 3:45 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 20-08-19 17:48:23, Alex Shi wrote:
> > This patchset move lru_lock into lruvec, give a lru_lock for each of
> > lruvec, thus bring a lru_lock for each of memcg.
> >
> > Per memcg lru_lock would ease the lru_lock contention a lot in
> > this patch series.
> >
> > In some data center, containers are used widely to deploy different kind
> > of services, then multiple memcgs share per node pgdat->lru_lock which
> > cause heavy lock contentions when doing lru operation.
>
> Having some real world workloads numbers would be more than useful
> for a non trivial change like this. I believe googlers have tried
> something like this in the past but then didn't have really a good
> example of workloads that benefit. I might misremember though. Cc Hugh.
>

We, at Google, have been using per-memcg lru locks for more than 7
years. Per-memcg lru locks are really beneficial for providing
performance isolation if there are multiple distinct jobs/memcgs
running on large machines. We are planning to upstream our internal
implementation. I will let Hugh comment on that.

thanks,
Shakeel
