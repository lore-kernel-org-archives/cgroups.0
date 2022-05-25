From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v5.19-rc1
Date: Wed, 25 May 2022 12:43:09 -0700
Message-ID: <CAHk-=wiGsJgFTJ=yqYwWA2vcTWQy=2QQ6to6vd3ETutaE0cDxQ@mail.gmail.com>
References: <Yowcc/ZOBIIs2JtZ@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2so5Mzc6/Anj+eAb5PeB2pn0wQd0Ui5hrmZSPShUJSk=;
        b=ClAeyv25erXN5fpKcHwk4B8YWpXUehQeunEBVPSwb07wr0kbkKr02a6OwiYbxyOabm
         tHJtW2HEqZbHj1o2OTY/PAcEDKegqBNws8JTasC+43LHXgY1lRrN3DzuoPvJ/sxSloCD
         J+MDtDglojRRImuuzXr14wwumcd5JskHn5378=
In-Reply-To: <Yowcc/ZOBIIs2JtZ-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 23, 2022 at 4:44 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.19

Your two pulls sadly broke the perfect signed tag streak that we had
this merge window up until just now.

I'm very happy to see how people have started doing signed tags for
everything, but that only makes your pull requests stand out even
more.

So yeah, despite not requiring it for kernel.org pulls, I'd _really_
like to make using signed tags just be the standard behavior for all
the kernel pull requests.

Can we try to aim for that next time? Please?

               Linus
