From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date: Wed, 24 Mar 2021 11:25:47 -0700
Message-ID: <CALvZod527EgYmkqWdoLCARj2BD2=YWVCC9Dk87gfQRG8NViX_A@mail.gmail.com>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
 <YFCH8vzFGmfFRCvV@cmpxchg.org> <CAOFY-A23NBpJQ=mVQuvFib+cREAZ_wC5=FOMzv3YCO69E4qRxw@mail.gmail.com>
 <YFJ+5+NBOBiUbGWS@cmpxchg.org> <CAOFY-A17g-Aq_TsSX8=mD7ZaSAqx3gzUuCJT8K0xwrSuYdP4Kw@mail.gmail.com>
 <YFoe8BO0JsbXTHHF@cmpxchg.org> <CAOFY-A2dfWS91b10R9Pu-5T-uT2qF9h9Lm8GaJfV9shfjP4Wbg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T4N8DBRr0y3pnQ+GYU6PHDcjxPfiucyRsdqMiT4zgqA=;
        b=G6Mpzu8Fe8xOBs6JczHBtn8H0S8SCoL1f8ofwhnllztiurQZdtRKZfp9fQh5HV+Zha
         u8r+/u2f70a05QIFYREh/+taoxH++OKNA425bEESIlpfmAPzzV5mU2NydGChVd/0LHxY
         XEUViqaaHmjCHFqeIrZDAqfMHH8MMp0dHbZE7EKo00GjFbl8Bdqgyja6/NxSJdNGVYBp
         p4NJfhzdfQ9irpzalC4O5NRVp6DG1A3wZIOSxd0RZ0EMqHYYjg2haX0i1RyhustM4tnU
         C6LDzJlJpcs47PgnI0rbDzEzYUarNvEY9LvK/4MffNmBCPBazyFFVsd3/7ZhxAiY1+Nh
         a6OA==
In-Reply-To: <CAOFY-A2dfWS91b10R9Pu-5T-uT2qF9h9Lm8GaJfV9shfjP4Wbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Arjun Roy <arjunroy.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Tue, Mar 23, 2021 at 11:42 AM Arjun Roy <arjunroy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
[...]
>
> To summarize then, it seems to me that we're on the same page now.
> I'll put together a tentative v3 such that:
> 1. It uses pre-charging, as previously discussed.
> 2. It uses a page flag to delineate pages of a certain networking sort
> (ie. this mechanism).
> 3. It avails itself of up to 4 words of data inside struct page,
> inside the networking specific struct.
> 4. And it sets up this opt-in lifecycle notification for drivers that
> choose to use it, falling back to existing behaviour without.
>

Arjun, if you don't mind, can you explain how the lifetime of such a
page will look like?

For example:

Driver:
page = dev_alloc_page()
/* page has 1 ref */
dev_map_page(page)
/* I don't think dev_map_page() takes a ref on page, so the ref remains 1. */

On incoming traffic the page goes to skb and which then gets assigned
to a struct sock. Does the kernel increase refcnt of the page on these
operations?

The page gets mapped into user space which increments its refcnt.

After processing the data, the application unmaps the page and its
refcnt will be decremented.

__put_page() will be called when refcnt reaches 0, so, the initial
refcnt which the driver has acquired, has to be transferred to the
next layer. So, I am trying to understand how that will work?
