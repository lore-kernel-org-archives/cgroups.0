From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
Date: Mon, 22 Mar 2021 22:39:47 +0100
Message-ID: <CAK8P3a10d8hgBiO5W=34oLqw8m22=Xi4C=MxVSY_fGnXZUJ3iA@mail.gmail.com>
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
Mime-Version: 1.0
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616449204;
        bh=ZjEe7Re0RKu002ndI22T8BlfDJ+aY+HHY+t9XvQS7Q8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bJZCpZ5EEGZerp3UrSyvokIM6nH3GPNLIsyJMJB5nyc4Sgnjtzn+OMtjUL2ZBSie+
         Fi83eey5HsMSKc/9qaD2RuZEeUeUwoE2M6qwk7wrSCjkj4ws8OGv18z8EyYcukmWHT
         jM35+ir6/srZfSH78DCRwpRXtTCanNR0ouNRk+r0zZqC9uicwbh5Vl6qVN2J0nC7fg
         yAR8A/u0nDcj41ohiNdL688eDQ2opEHdctaDOmgytVvpFgfvzBz92vFYBp5Nn21+zL
         vtNIUbcaOAFjelvCYqZ6uXvufN0DecSq4tETddYi+zxgAsQXGrS7YO4xRruhTqWyYj
         CraMDT8xmXxbw==
In-Reply-To: <20210322202958.GA1955909-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Intel Graphics <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, dri-devel <dri-devel@lists>

On Mon, Mar 22, 2021 at 9:29 PM Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> * Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

> This is indeed rather ugly - and the other patch that removes a debug
> check seems counterproductive as well.
>
> Do we know how many genuine bugs -Wstringop-overread-warning has
> caught or is about to catch?
>
> I.e. the real workaround might be to turn off the -Wstringop-overread-warning,
> until GCC-11 gets fixed?

See the [PATCH 0/11] message. The last two patches in the series are for
code that I suspect may be broken, the others are basically all false positives.

As gcc-11 is not released yet, I don't think we have to apply any of the
patches or disable the warning at the moment, but I posted all the patches
to get a better understanding on which of them should be addressed in
the kernel vs gcc.

       Arnd
