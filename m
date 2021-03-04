From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] memcg: charge before adding to swapcache on swapin
Date: Thu, 4 Mar 2021 09:12:57 -0800
Message-ID: <CALvZod5TjuOjLN6FWvMvwFHC2BaGg=3+yuaCdnp-DfabUioQVg@mail.gmail.com>
References: <20210304014229.521351-1-shakeelb@google.com> <YEEBTm/NIugjQWG5@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UFk60/R93j/Ir+3OsIDPm87BVki6b+umgOzaexWfu9Y=;
        b=ipdNXv2W0+m0TzGiGZv/k4LwVFCEWWmyFxoH/AYPwJo5e7snO6Lo6WhFIf4StYPudv
         GF9t8QFsvY8w/m8QsKaAe0JtnyI0ZJu5wRBt06IVJepz0mdCB+sbU1pTGeIhTSV3Uo3t
         vhbPl5N0Dsl+fvA8jy4KGdhnFFRyfHlAlW2C1NycxnBBiNxtGh0trXgrjheABWbzzsof
         3fXEIY1DSd9tR61ancM308v6eKm7y1ZzOTwT5dxGaUcNRgiJ+JsA96KnOafSct7wzL/n
         C5xuzppV407zHw2hxKpg8PpdWFTC+RdKXnxOam+nmXN1eVa6X7ttbeaX6q8YdcGBMNos
         aotw==
In-Reply-To: <YEEBTm/NIugjQWG5-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Mar 4, 2021 at 7:48 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Wed, Mar 03, 2021 at 05:42:29PM -0800, Shakeel Butt wrote:
> > Currently the kernel adds the page, allocated for swapin, to the
> > swapcache before charging the page. This is fine but now we want a
> > per-memcg swapcache stat which is essential for folks who wants to
> > transparently migrate from cgroup v1's memsw to cgroup v2's memory and
> > swap counters. In addition charging a page before exposing it to other
> > parts of the kernel is a step in the right direction.
> >
> > To correctly maintain the per-memcg swapcache stat, this patch has
> > adopted to charge the page before adding it to swapcache. One
> > challenge in this option is the failure case of add_to_swap_cache() on
> > which we need to undo the mem_cgroup_charge(). Specifically undoing
> > mem_cgroup_uncharge_swap() is not simple.
> >
> > To resolve the issue, this patch introduces transaction like interface
> > to charge a page for swapin. The function mem_cgroup_charge_swapin_page()
> > initiates the charging of the page and mem_cgroup_finish_swapin_page()
> > completes the charging process. So, the kernel starts the charging
> > process of the page for swapin with mem_cgroup_charge_swapin_page(),
> > adds the page to the swapcache and on success completes the charging
> > process with mem_cgroup_finish_swapin_page().
> >
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> The patch looks good to me, I have just a minor documentation nit
> below. But with that addressed, please add:
>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thanks.

>
[...]
>
> It's possible somebody later needs to change things around in the
> swapin path and it's not immediately obvious when exactly these two
> functions need to be called in the swapin sequence.
>
> Maybe add here and above that charge_swapin_page needs to be called
> before we try adding the page to the swapcache, and finish_swapin_page
> needs to be called when swapcache insertion has been successful?

I will update the comments and send v4 after a day or so to see if
someone else has any comments.
