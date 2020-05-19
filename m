From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v4 3/4] mm: move cgroup high memory limit setting into
 struct page_counter
Date: Tue, 19 May 2020 15:15:41 -0700
Message-ID: <CALvZod4i2sBWcbKe3MHMuSMV3ywWwQx1Xr-abEqPS6n8vioC7w@mail.gmail.com>
References: <20200519171938.3569605-1-kuba@kernel.org> <20200519171938.3569605-4-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rxz1rZqNlsCeuSR9curwxPKa4W3jWsGY4pCm9jvZnw4=;
        b=R1QBH9j9Pfl17Bi+U8Qt2VYdio0ibXZeuPzMFPRICYI09H3qud7ZA4YhliJOOAHMyI
         XnH/PDsy9mOHrzltFj/g3AaYFFgEuvacpT69/ZdVP0CmwhSkE9FOGeflb/LncvcAMaQQ
         +4lUtF5q19jT0bHX4DRT+eOQ5YTpWKhQZ8bm+b+shDMlZqKFhNTIOeEy79zvtgcc2CzO
         KfRdFtFBkugMp4EWpLIDt3RTCpPwBGqumGzd2kdRK1EPcqv2mp4hIONURpKdHrAgaL5n
         H8TnZuYXMvUbkTnG7vvm4ZHQWUxN7FYYU28AaK4RP+IGyHFAfrwQwpwbQJeWzkiP9dAa
         JN8A==
In-Reply-To: <20200519171938.3569605-4-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, May 19, 2020 at 10:19 AM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> High memory limit is currently recorded directly in
> struct mem_cgroup. We are about to add a high limit
> for swap, move the field to struct page_counter and
> add some helpers.
>
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
...
[snip]
...
>
> +static inline bool page_counter_is_above_high(struct page_counter *counter)
> +{
> +       return page_counter_read(counter) > READ_ONCE(counter->high);
> +}
> +
...
[snip]
...
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -198,6 +198,11 @@ int page_counter_set_max(struct page_counter *counter, unsigned long nr_pages)
>         }
>  }
>
> +void page_counter_set_high(struct page_counter *counter, unsigned long nr_pages)
> +{
> +       WRITE_ONCE(counter->high, nr_pages);
> +}
> +

Any reason not to make this static inline like
page_counter_is_above_high() and in page_counter.h?
