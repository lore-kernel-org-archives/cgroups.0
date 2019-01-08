From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: schedule high reclaim for remote memcgs on high_work
Date: Tue, 8 Jan 2019 09:24:18 -0800
Message-ID: <CALvZod6sx6tA2EvnXZ_h=qZu6xtcL14uSMyp-gqxedy8T0L6qg@mail.gmail.com>
References: <20190103015638.205424-1-shakeelb@google.com> <20190108145942.GZ31793@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GL7wYni0pGBI7aKT681Y9wbnQ+0L1OweM8XEjJxZKZE=;
        b=uRA9FLk3Ovq2/XZxEHM2QLRek+WzIngFkYCX3CdbfBujIgMjYlURKFJTkCqMKnlg44
         HcTyBZPM9hapyuyfqpFkC7th4LT/bgZ5Z1pLcrMinIB/7XaM91dypigXQH8QNmpDekRr
         l5NYpZKQHiJXK+rRER9tN7yyPJf4hkW13NfxncUnNHR5/B3GePIGssO5C0QNI2ncf/Lu
         COusA3Q5IxD60f5GjhqRawqlo496Ct8CEFgiLoiiDa5U99tvWPew1CYtIU/KCXc3E1fY
         26LJa1uvTNSITIUauX+AUKpWxqWckosoZSoHybTkAWs9UrLKb6fEh+Dx4hdPthl7TqKM
         uleQ==
In-Reply-To: <20190108145942.GZ31793@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Jan 8, 2019 at 6:59 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Wed 02-01-19 17:56:38, Shakeel Butt wrote:
> > If a memcg is over high limit, memory reclaim is scheduled to run on
> > return-to-userland. However it is assumed that the memcg is the current
> > process's memcg. With remote memcg charging for kmem or swapping in a
> > page charged to remote memcg, current process can trigger reclaim on
> > remote memcg. So, schduling reclaim on return-to-userland for remote
> > memcgs will ignore the high reclaim altogether. So, punt the high
> > reclaim of remote memcgs to high_work.
>
> Have you seen this happening in real life workloads?

No, just during code review.

> And is this offloading what we really want to do?

That's the question I am brainstorming nowadays. More generally how
memcg-oom-kill should work in the remote memcg charging case.

> I mean it is clearly the current
> task that has triggered the remote charge so why should we offload that
> work to a system? Is there any reason we cannot reclaim on the remote
> memcg from the return-to-userland path?
>

The only reason I did this was the code was much simpler but I see
that the current is charging the given memcg and maybe even
reclaiming, so, why not do the high reclaim as well. I will update the
patch.

thanks,
Shakeel
