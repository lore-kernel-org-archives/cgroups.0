From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcg: expose mem_cgroup_put API
Date: Thu, 8 Mar 2018 15:48:14 -0800
Message-ID: <CALvZod5gy8iw-Va7-Gzyqv1xVkTGhU3k4UysktXb7bfbbtUt9Q@mail.gmail.com>
References: <20180308024850.39737-1-shakeelb@google.com> <20180308154501.a42bb22af0da6ccd727773c8@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=iUqJuQl329RltQTJRxIXUbSbDWN5yPWWfBSCKmkqJKc=;
        b=eWNuusHz0HQt931VPgN6CuYGGvwYsapd+AVGQ1SlAWK8XKDbmDYWdhTtRcrzhUXF00
         HWamIupf07JEWa6VQSWwabqH+R+jFcRy/chjsWVNBuNv8F+alZdydDfKpxqcefIOU0pF
         WlTR0xVeuajVzaRyILD32L84hFWvtJVs8Jf/EOEEJPPcqtvQ02GsG7lwMiSYX6UtJ8Vj
         O7e+ss8QywTDhxRBPt8vKNgWTFeEoZBRQqeMpgLQLbTTMl3Q2UCyuGGApbOOfoinCkML
         drnCy23YvckbVgKLlMvBg4GyifZPGrSraQMX274ZA/57Ax3Ggx3aOvz5LZwdRNZ0oyoM
         tDlw==
In-Reply-To: <20180308154501.a42bb22af0da6ccd727773c8@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, David Rientjes <rientjes@google.com>

On Thu, Mar 8, 2018 at 3:45 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed,  7 Mar 2018 18:48:50 -0800 Shakeel Butt <shakeelb@google.com> wrote:
>
>> This patch exports mem_cgroup_put API to put the refcnt of the memory
>> cgroup.
>
> OK, I remember now.  This is intended to make
> fs-fsnotify-account-fsnotify-metadata-to-kmemcg.patch independent of
> mm-oom-cgroup-aware-oom-killer.patch by extracting mem_cgroup_put()
> from mm-oom-cgroup-aware-oom-killer.patch.

Yes, you are right, it is needed by the above fsnotify patch.

> However it will not permit me to stage
> fs-fsnotify-account-fsnotify-metadata-to-kmemcg.patch ahead of
> mm-oom-cgroup-aware-oom-killer.patch because there are quite a lot of
> syntactic clashes.
>
> I can resolve those if needed, but am keenly hoping that the
> mm-oom-cgroup-aware-oom-killer.patch issues are resolved soon so there
> isn't a need to do this.
>

Sounds good to me.
