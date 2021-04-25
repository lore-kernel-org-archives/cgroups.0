From: Odin Ugedal <odin-lVFEcm3hDZTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] docs/admin-guide/cgroup-v2: Add hugetlb rsvd files
Date: Sun, 25 Apr 2021 11:22:09 +0200
Message-ID: <CAFpoUr2+8aftSG0bok5--p+LaeoAPZ-kNGpk29LHsXp-T+AHBw@mail.gmail.com>
References: <20210416141146.542786-1-odin@uged.al> <YHn3cifQv1FUOqfU@slm.duckdns.org>
 <YH2Y9FucBW2GLLLQ@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rHqJw4XM6KNvFgd+6eDTbM0uYiK/qMr9nT+Gi0khnDA=;
        b=SAOjTqPoCFTcLZj5stQfJeMd/KGGLv5NxQXsZbWoxuvzKg6ZsmT9fWWd8MGgtBcvPu
         C746UW5yMeE1fk++7oSPbZBrLMjXIlZiBJn7Yogfhd0++JsS8iBnbvw4owZ+EKCr0dtd
         JzbX4TuLaaFDQ3R/KT3yyP9FtwgNgIQv7hGQde2hyYyHEhzZy++K+SpA4qerlNOhfFVB
         OmVkWixn8WHVbbUkDaGoJdRGGhas98j/koleU/Bg/7Sj7dtWFxGLOzlGAjP8gfZuP6h0
         RAkSiUEOSMZmSIwG8Hi5UeUxKFc6UgPv07ysBz2EMZ0XxdEtW4Ls2MKAEF72JeBswMjF
         DCTA==
In-Reply-To: <YH2Y9FucBW2GLLLQ-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> My preference would be to first try to write a version of the doc in
> cgroup2's briefer style, and then, depending on how that works out,
> see whether we can delete (replace with link) the cgroup1 text, or
> keep it for archiving purposes.

Thanks! That sounds like the best way to do it! Will take a look, and
post an updated patch.

Odin
