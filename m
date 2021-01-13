From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
Date: Wed, 13 Jan 2021 11:55:11 -0800
Message-ID: <CALvZod4Ncf4H8VWgetWoRnOWPT4h+QDK_CY+oK11Q4akcs4Eqw@mail.gmail.com>
References: <20210112214105.1440932-1-shakeelb@google.com> <20210112233108.GD99586@carbon.dhcp.thefacebook.com>
 <CAOFY-A3=mCvfvMYBJvDL1LfjgYgc3kzebRNgeg0F+e=E1hMPXA@mail.gmail.com>
 <20210112234822.GA134064@carbon.dhcp.thefacebook.com> <CAOFY-A2YbE3_GGq-QpVOHTmd=35Lt-rxi8gpXBcNVKvUzrzSNg@mail.gmail.com>
 <CALvZod4am_dNcj2+YZmraCj0+BYHB9PnQqKcrhiOnV8gzd+S3w@mail.gmail.com>
 <20210113184302.GA355124@carbon.dhcp.thefacebook.com> <CALvZod4V3M=P8_Z14asBG8bKa=mYic4_OPLeoz5M7J5tsx=Gug@mail.gmail.com>
 <CAHbLzkrqX9mJb0E_Y4Q76x=bZpg3RNxKa3k8cG_NiU+++1LWsQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V0bs1fi/eE8isvmmJjMQkUZIf1rb+BYIcBHJLO1oqcE=;
        b=fU8xQWv0qAos49JfkFhq/SvSl9DKk4R3hCOQ4ZYyfA3JjIvM9fSyygUqQVtmaCvUzT
         O02v3DcrsaONKGxXgfUbBgPNgmFjvw9UrWHP+BT4AjzOrGrt/vGx+rxIEnYp/JjOFSsf
         8cCMDfNLPbBE4L6R+FHyQBO4n/+akvzeZSp1rYbjjaAfNWmetJ+OPJz40voyNp+rxEKM
         YNd5erKC9LZ3UfjpbuWOFRFIy1I4p9ki2KTunusZzgU6DEAyjCNvmyMOi3ZKUyHVswc0
         rSPFYJd779xIcQOtVoL5Cp0NZZZK9bK59dRQ9lBsm0masjFs4u3FVlh2SUw7SCXNb3Ox
         0jcA==
In-Reply-To: <CAHbLzkrqX9mJb0E_Y4Q76x=bZpg3RNxKa3k8cG_NiU+++1LWsQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <shy828301@gmail.com>
Cc: Roman Gushchin <guro@fb.com>, Arjun Roy <arjunroy@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Eric Dumazet <edumazet@google.com>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, Jan 13, 2021 at 11:49 AM Yang Shi <shy828301@gmail.com> wrote:
>
> On Wed, Jan 13, 2021 at 11:13 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Wed, Jan 13, 2021 at 10:43 AM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 04:18:44PM -0800, Shakeel Butt wrote:
> > > > On Tue, Jan 12, 2021 at 4:12 PM Arjun Roy <arjunroy@google.com> wrote:
> > > > >
> > > > > On Tue, Jan 12, 2021 at 3:48 PM Roman Gushchin <guro@fb.com> wrote:
> > > > > >
> > > > [snip]
> > > > > > Historically we have a corresponding vmstat counter to each charged page.
> > > > > > It helps with finding accounting/stastistics issues: we can check that
> > > > > > memory.current ~= anon + file + sock + slab + percpu + stack.
> > > > > > It would be nice to preserve such ability.
> > > > > >
> > > > >
> > > > > Perhaps one option would be to have it count as a file page, or have a
> > > > > new category.
> > > > >
> > > >
> > > > Oh these are actually already accounted for in NR_FILE_MAPPED.
> > >
> > > Well, it's confusing. Can't we fix this by looking at the new page memcg flag?
> >
> > Yes we can. I am inclined more towards just using NR_FILE_PAGES (as
> > Arjun suggested) instead of adding a new metric.
>
> IMHO I tend to agree with Roman, it sounds confusing. I'm not sure how
> people relies on the counter to have ballpark estimation about the
> amount of reclaimable memory for specific memcg, but they are
> unreclaimable. And, I don't think they are accounted to
> NR_ACTIVE_FILE/NR_INACTIVE_FILE, right? So, the disparity between
> NR_FILE_PAGES and NR_{IN}ACTIVE_FILE may be confusing either.
>

Please note that due to shmem/tmpfs there is already disparity between
NR_FILE_PAGES and NR_{IN}ACTIVE_FILE.

BTW I don't have a strong opinion against adding a new metric. If
there is consensus we can add one.
