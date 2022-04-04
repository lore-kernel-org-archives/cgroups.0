From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Mon, 4 Apr 2022 10:08:43 -0700
Message-ID: <CALvZod4-fKfv6vbZPZ3nCE=Bue4FUnC+9t27wsznmyd+JKgDbg@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <CAAPL-u8g2qkhdTQtFtBS3GNYz0WnyahWEXvR4g_OSaKv+7EozA@mail.gmail.com>
 <YkcYq8F6MYlMi+yS@cmpxchg.org> <CAAPL-u-za-TTyyC5uMVev9eQyhxZS7q3pVqaUxCFjqk+Sv9+ig@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EXYG3Ps4LgSyecmtEkjB7IBmEX/53r1BKcEWnhV4WlY=;
        b=s4CMrkgH7my/reT6boSS8yl+kfuqsyuW+f1JH/k+5yIXMdHslsChfPbL4NUMHPqZix
         KdR9ph2X7IYOncO9Nplztcf1q9mtEgJP1Y6UsMxgR1beJRzUvrBp6ANO369YovHpmVdq
         2BGBW1PuagDvNO8qY4jV7AGNNT87QsO97aWQbHXwie/ZqjowUI/d2ISWG22WhANZxVeQ
         lT04QY1g8hr2moiJ3B2tVGObcfy9yn+vkPuRXQ98mGwLgRFQo4pjIN60/lEFGGD6loMc
         UNTzU7wMtCvSSt4SZE313BRItgkLW6uEcEnQtikscmC8CTKTE20RUhwAVqAYjKbwVVAM
         vgfA==
In-Reply-To: <CAAPL-u-za-TTyyC5uMVev9eQyhxZS7q3pVqaUxCFjqk+Sv9+ig@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Xu <weixugc@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, Cgroups <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Greg Thelen <gthelen@google.com>

On Fri, Apr 1, 2022 at 1:14 PM Wei Xu <weixugc@google.com> wrote:
>
[...]
>
> -EAGAIN sounds good, too.  Given that the userspace requests to
> reclaim a specified number of bytes, I think it is generally better to
> tell the userspace whether the request has been successfully
> fulfilled. Ideally, it would be even better to return how many bytes
> that have been reclaimed, though that is not easy to do through the
> cgroup interface.

What would be the challenge on returning the number of bytes reclaimed
through cgroup interface?
