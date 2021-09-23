From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: flush lruvec stats in the refault
Date: Thu, 23 Sep 2021 10:12:00 -0700
Message-ID: <CAHk-=whgL6H0fYt9o2qOVwExZJy_nmZ9=_hTcBUKf=YHXDJVxQ@mail.gmail.com>
References: <20210922224906.676151-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i/CxnIoh9vGI3IXe2n3zSyhD1ELxDhirk2SHmfQlOLQ=;
        b=RMG/Scp8QfSxAZON5Uq51XOAc0XNXVcBG2GnnrniXglTgraSBvZ9RTKockwhPH4mGf
         WeyPErky+FsOoPedYN2c7qDYCZw5WhZNubXkskDS/lKdYEHUbPqNnam84t6nOFdacy7a
         Ly9YiJwUacU0hCuahpkwUe3ElAzj5gwsY1c2E=
In-Reply-To: <20210922224906.676151-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michael Larabel <michael-qNzh9OVzCMllHob0Tl0JvNBPR1lH4CV8@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Sep 22, 2021 at 3:50 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> From the above result, it seems like the option-2 not only solves the
> regression but also improves the performance for at least these
> benchmarks.
>
> Feng Tang (intel) ran the aim7 benchmark with these two options and
> confirms that option-1 reduces the regression but option-2 removes the
> regression.
>
> Michael Larabel (phoronix) ran multiple benchmarks with these options
> and reported the results at [3] and it shows for most benchmarks
> option-2 removes the regression introduced by the commit aa48e47e3906
> ("memcg: infrastructure to flush memcg stats").

Ok, I've applied this just to close the issue.

If somebody comes up with more data and the delayed flushing or
something is problematic, we'll revisit, but this looks all sane to me
and fixes the regression.

Thanks,
              Linus
