From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v5.19-rc1
Date: Wed, 25 May 2022 12:47:48 -0700
Message-ID: <CAHk-=wj4Q2++KfQ4NhMtjmJF_1bjC-573U61o1acuHfqmsvCKA@mail.gmail.com>
References: <Yowcc/ZOBIIs2JtZ@slm.duckdns.org> <CAHk-=wiGsJgFTJ=yqYwWA2vcTWQy=2QQ6to6vd3ETutaE0cDxQ@mail.gmail.com>
 <Yo6HMpEodz36o4Dc@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZmLANCeR2PBZsVZiqw/kJbDCZhiOaUsRlXizangKGuM=;
        b=W45I5obeEI7ajyNaRmK7F98XyvnL8ynngJufR193cH3zV4BNBFW72hd3mnApPZbBnt
         kaniX920OyLHOWeWWyqIfxJ7GWqgvbMCQfrbEypEXciUjKaar6UHJbFV360LJ1SNoEVQ
         cCGkVRoYGALQzapuYDw2sIu/qrzwgxaG0bO1w=
In-Reply-To: <Yo6HMpEodz36o4Dc-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, May 25, 2022 at 12:44 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hahaha, yeah, I lost my private key many years ago, so gotta get that sorted
> out first. Will do the signed pull from now on.

You have a pgp key for your kernel.org account, you can just use that. No?

(That way I'll also be able to just pick it up from the pgp key repo
that Konstantin maintains).

                Linus
