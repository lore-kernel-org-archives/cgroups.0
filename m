From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Date: Tue, 12 Jan 2021 16:18:44 -0800
Message-ID: <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xDSBLu/dQ/DU7FQZj8b6YPh8lI8akCH+mH01uvaPees=;
        b=oKYBO4SPdgSBJUsDMIW5CP9v8Ehx9/bCarB8oGP/mHA4+sLd3xf01hYN8meRfn3Z/C
         VRExJAQITYqEfrJHkfEK/+BUy2bi9V125dcXdPXwnGIrz1gChJ8Eagc6sfu5NxDOsM7Q
         s4JHrGiTwBj0egpN48LNdJhwOkgrQljcrnDdfzV8s4tuYkxOP5J3ifDaVQItl+uBWKRi
         hjaQ04uwbDzWLPPYGOzdK8OrUuidnmRBgEslg8HxcWMOGc+R2HncERyeNHOejDUAcGLp
         U6ugLoGlBW/HnCUEp1wdREM2Q0knqc9CwXOGdVRuSBw5YniV+N1wwskoAEZ2xBEOuVvD
         3xUw==
In-Reply-To: <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arjun Roy <arjunroy@google.com>
Cc: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Eric Dumazet <edumazet@google.com>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
>
> On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> >
[snip]
> > Historically we have a corresponding vmstat counter to each charged page.
> > It helps with finding accounting/stastistics issues: we can check that
> > memory.current ~= anon + file + sock + slab + percpu + stack.
> > It would be nice to preserve such ability.
> >
>
> Perhaps one option would be to have it count as a file page, or have a
> new category.
>

Oh these are actually already accounted for in NR_FILE_MAPPED.
