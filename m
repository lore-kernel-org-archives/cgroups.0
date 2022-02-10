From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/4] memcg: refactor mem_cgroup_oom
Date: Thu, 10 Feb 2022 14:23:37 -0800
Message-ID: <CALvZod4Ex+0q+4pDnR8q6bpV8Q5NKbt=5c6SDVUDVnKxTqUNRQ@mail.gmail.com>
References: <20220210081437.1884008-1-shakeelb@google.com> <20220210081437.1884008-2-shakeelb@google.com>
 <YgVtGhvXqqVzTy7M@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0hO66QIvus488NAq78feGEF3dBYxRKmF5DOdeN40y0E=;
        b=ifAyrepAz0/IittI3oOkEW3ly0MGafuEuH+Wv4mqyEk5J+wQSQK4XejFuQrRyABDxy
         cDqnh5/He67UFdvdqWpWkGAY/4DGX71VVGZtRxmYlXps/XzEIW0/YAK+lGR1Of8QoJhA
         dlcXq1Pjm6j94Eh2UzSeZtQSV1JIKru0Uq60Ossq66fC+6zhWOea8yR11tUdGHv33PQS
         QgWvXdGu9gDVM4ZDMwDCLedn7lb0suJH93kcg+bgyn+ulIlbOetxdtUDPDVAkqcwTwa4
         n4LLOEvLFf2EFgZfhIIv1t/7uc9WiFYkSNxY+AH74ofOtAAxydlupol0MB9qJiSbd0mY
         cn/A==
In-Reply-To: <YgVtGhvXqqVzTy7M@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Feb 10, 2022 at 11:53 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Feb 10, 2022 at 12:14:34AM -0800, Shakeel Butt wrote:
> > The function mem_cgroup_oom returns enum which has four possible values
> > but the caller does not care about such values and only care if the
> > return value is OOM_SUCCESS or not. So, remove the enum altogether and
> > make mem_cgroup_oom returns a simple bool.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
>
> Nice!
>
> Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks.
>
[...]
>
> The only thing, I'd add a small comment on the return value here. E.g.
> "returns true if one or more tasks have been successfully killed" or something
> like this.
>

Will do in the next version.
