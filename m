From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup fixes for v5.6-rc5
Date: Tue, 10 Mar 2020 15:14:13 -0700
Message-ID: <CAHk-=wi=5p6s_BmPAg5EF8Joe5d-6iAjQq6-Le7+xf5Gq-ZTfw@mail.gmail.com>
References: <20200310144107.GC79873@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0DJ1QWaOzdShQUNy+Xq2LWv3cgxACTM1sGjd/lAyrQ=;
        b=PE12SCsWX0jtdXlLC7s8SBu/WbwEPg5yee5goR2A9E7eXbONG+zY2j3g8MU5gMY4cI
         gpQVYpf4gr8akr8301HuU4d0RZVExceNqTnoiuhQMQQ+S4LimrjudwbtXD7qVESq+I3Y
         YunNWg0f3xQ13/vVv6+VaMcob/DyVA/vCVF3c=
In-Reply-To: <20200310144107.GC79873-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Mar 10, 2020 at 7:41 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Empty release_agent handling fix.

Pulled. However, I gagged a bit when I saw the code:

        if (!pathbuf || !agentbuf || !strlen(agentbuf))

yeah, I really hope that the compiler is smart enough to just optimize
that, but we shouldn't assume that the compiler is that smart.

The proper way to test for "empty string" is to just check the first
character for NUL:

        if (!pathbuf || !agentbuf || !*agentbuf)

which doesn't require the compiler to have a pattern for "oh, I can
test for a zero strlen without actually calling strlen".

Also, wouldn't it be nice to test for the empty string before you even
bother to kstrdup() it? Even before you

Finally, shouldn't we technically hold the release_agent_path_lock
while looking at it?

Small details, and I've taken the pull, but the lack of locking does
seem to be an actual (if perhaps fairly theoretical) bug, no?

                 Linus
