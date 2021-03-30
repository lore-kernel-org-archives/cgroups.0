From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/11] cgroup: fix -Wzero-length-bounds warnings
Date: Tue, 30 Mar 2021 11:00:36 +0200
Message-ID: <CAK8P3a3nUCGwPpE+E820DniY8Haz1Xx72pA38P6s5MWsbi0iAQ@mail.gmail.com>
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-7-arnd@kernel.org>
 <YGLkPjSBdgpriC0E@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617094851;
        bh=7BKJpJRJJea7jWMl80W5EN9UAj8omc2Cs2r3GAQepzo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wsuslf1aShoCKyVO6hEvzEdZFMLQDIu2sbrH3x69Zj3fzv+Ssz4//dpuMEbWngOUq
         Zjq5v+sm416E8eDL5lOizTzEa7Erwc/f8fCuW75qsYfDXgJ3oE6b4i2kQYeYtPZd4I
         FK+fITjA3iXC63XWANkkhj4NvYlqDfeUjJbbuVDoJnM3Z/9egQRLEp8Koxo3BlExlm
         KJf0GkZPfII5XV5fPTrpbDnwtlOxinHOG65Ikgkmm49iP6nf4qHit/q0d/LnVY5qb5
         qa+2M5n3XKCJv1Wm+mrJgHL5nAHA2YFzyo0MHv0A+yCW12hqtwqifDnY1PrNFQltR4
         2Y+g7lZslykhg==
In-Reply-To: <YGLkPjSBdgpriC0E@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Intel Graphics <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, a

On Tue, Mar 30, 2021 at 10:41 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> On Mon, Mar 22, 2021 at 05:02:44PM +0100, Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>=
 wrote:
> > I'm not sure what is expected to happen for such a configuration,
> > presumably these functions are never calls in that case.
> Yes, the functions you patched would only be called from subsystems or
> there should be no way to obtain a struct cgroup_subsys reference
> anyway (hence it's ok to always branch as if ss=3D=3DNULL).
>
> I'd prefer a variant that wouldn't compile the affected codepaths when
> there are no subsystems registered, however, I couldn't come up with a
> way how to do it without some preprocessor ugliness.

Would it be possible to enclose most or all of kernel/cgroup/cgroup.c
in an #ifdef CGROUP_SUBSYS_COUNT block? I didn't try that
myself, but this might be a way to guarantee that there cannot
be any callers (it would cause a link error).

> Reviewed-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>

Thanks

        Arnd
