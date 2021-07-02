From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v5.14-rc1
Date: Thu, 1 Jul 2021 17:25:59 -0700
Message-ID: <CAHk-=wgcyjLGcoRho5iw7b3Yx+R05rXwyJmP_LhOqsHgjiZugQ@mail.gmail.com>
References: <YN4rzCdUR+/2LgaP@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ojivLqIxhJFrg2mkQVdvq8a38GP5yVcK9noWQjWXjQ=;
        b=Gop1h/wC4k56lKH6v1PD4hX8fLfZIhG0emVypz0FX1ztp1MRpep9OiBfP/xoy8jwSL
         lMtYD7BdrUyrOBX7z2ZKXQRrJbheI/TgmVnT3A6NBpVzDnAYUMEC2D/UE+ySyLKwbIuw
         I7HKssIjEStPfibkfy0Zr8vq1CNcrB3092+I4=
In-Reply-To: <YN4rzCdUR+/2LgaP-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 1, 2021 at 1:55 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.14

I've pulled it, but let me vent about this history a bit.

Look at commit c2a11971549b ("Merge branch 'for-5.13-fixes' into for-5.14").

Now tell me how that commit explains why it exists.

Merge commits need commit messages too.

In particular, they need commit messages that *explain* why they exist
in the first place, not just a one-liner that says what it does (and
does so badly at that).

                    Linus
