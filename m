From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
Date: Mon, 22 Mar 2021 23:49:53 +0100
Message-ID: <CAK8P3a0JW0AqQmHXaveD8za1np+W=Q3D4PuHnYKRd8UJqiwhsw@mail.gmail.com>
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com> <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616453410;
        bh=uswimGLXSixuyDNhbT1lz8xZrWttoUKDID8KyDH0WG0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=amyVtju7uIURiCWdHdQflKk1Uy5uaUl0jSM14IOTPFAohfgjX6aNW2KNuxCJtYCAo
         Iq3iv0T/Fse0yOGtClBFW9lSZE7aaq5x8nvOG96GevRCer6irU7c+80RceV8EVJ5kx
         MyABhKHnqgLkwgPjFUcsT9rt5Ch7AD6xkqPlfErTbnJ16VSW7CL/8voAWgmiYiZP+2
         FNG8ibSI2xKBl+QJzXjnar4dGoW1lmiY/KAWQjWwKmqPmSQ5aiKJPzyqeCBCT+W6FE
         laR6EilYtVT8DnV5kJgvUwfjeNkVR5uJLU421n3+vr2W/G1PBIgRrNWzYxZ4T75LGD
         pwIqz5PKV+08w==
In-Reply-To: <b944a853-0e4b-b767-0175-cc2c1edba759-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martin Sebor <msebor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Intel Graphics <intel-gfx-PD4FTy7X32lNgt0PjOBp9/rsn8yoX9R0@public.gmane.org>

On Mon, Mar 22, 2021 at 11:09 PM Martin Sebor <msebor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 3/22/21 2:29 PM, Ingo Molnar wrote:
> > * Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > I.e. the real workaround might be to turn off the -Wstringop-overread-warning,
> > until GCC-11 gets fixed?
>
> In GCC 10 -Wstringop-overread is a subset of -Wstringop-overflow.
> GCC 11 breaks it out as a separate warning to make it easier to
> control.  Both warnings have caught some real bugs but they both
> have a nonzero rate of false positives.  Other than bug reports
> we don't have enough data to say what their S/N ratio might be
> but my sense is that it's fairly high in general.
>
>    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overread
>    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overflow

Unfortunately, stringop-overflow is one of the warnings that is
completely disabled in the kernel at the moment, rather than
enabled at one of the user-selectable higher warning levels.

I have a patch series to change that and to pull some of these
into the lower W=1 or W=2 levels or even enable them by default.

To do this though, I first need to ensure that the actual output
is empty for the normal builds. I added -Wstringop-overflow to
the list of warnings I wanted to address because it is a new
warning and only has a dozen or so occurrences throughout the
kernel.

> In GCC 11, all access warnings expect objects to be either declared
> or allocated.  Pointers with constant values are taken to point to
> nothing valid (as Arnd mentioned above, this is to detect invalid
> accesses to members of structs at address zero).
>
> One possible solution to the known address problem is to extend GCC
> attributes address and io that pin an object to a hardwired address
> to all targets (at the moment they're supported on just one or two
> targets).  I'm not sure this can still happen before GCC 11 releases
> sometime in April or May.
>
> Until then, another workaround is to convert the fixed address to
> a volatile pointer before using it for the access, along the lines
> below.  It should have only a negligible effect on efficiency.
>
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index 4c09ba110204..76326b906010 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -67,7 +67,9 @@ void __init tboot_probe(void)
>          /* Map and check for tboot UUID. */
>          set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
>          tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
> -       if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
> +       if (memcmp(&tboot_uuid,
> +                  (*(struct tboot* volatile *)(&tboot))->uuid,
> +                  sizeof(tboot->uuid))) {
>                  pr_warn("tboot at 0x%llx is invalid\n",

I think a stray 'volatile' would raise too many red flags here, but
I checked that the RELOC_HIDE() macro has the same effect, e.g.

@@ -66,7 +67,8 @@ void __init tboot_probe(void)

        /* Map and check for tboot UUID. */
        set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
-       tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
+       /* RELOC_HIDE to prevent gcc warnings about NULL pointer */
+       tboot = RELOC_HIDE(NULL, fix_to_virt(FIX_TBOOT_BASE));
        if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
                pr_warn("tboot at 0x%llx is invalid\n", boot_params.tboot_addr);
                tboot = NULL;

     Arnd
