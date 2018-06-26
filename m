From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 26 Jun 2018 12:07:57 -0700
Message-ID: <CALvZod5aEHcLs3j+AiuC1FppD-AakWhdZdQhzmTSSrktn2Gu0Q@mail.gmail.com>
References: <20180625230659.139822-1-shakeelb@google.com> <20180625230659.139822-2-shakeelb@google.com>
 <CAOQ4uxiV75+X3dMLS93iXqwmSU6eKPOUocdkXiR7MQZhEjotQg@mail.gmail.com>
 <CALvZod5ARMZL+eD8-mrxeBvxJcuVPXaCwWEgUyQw85xXWxHauA@mail.gmail.com> <20180626185724.GA3958@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vSXP8pr9YrZfpq32KDOcDU58bqTWUULMSUjOB+oqM8U=;
        b=ol3NKKwiDDF2Vuh1Ee5P0rIOzUz2O1+XA4fus5D89gbmWBRCpGqAK1oEBE+OFPj/wO
         nm99Sy4KsR7YMjLX6/ih53AFovWLIA8D5G0DgptNtgDHA9k0ZNeeCvKPP0uRURwdIkDh
         0BEUm3ulQx9di0TsIgqMyp9GuK82uTrJS6iq7d6CovudO+zLBHkOs8jQLoOFgrAbVMBd
         O9NV5c6SnXGKryc98FTCh6YsbmLf6UotIXGS4WM5wY3IN8gnJWk3nH/kPVa9E+CuS5Yp
         d/XiAU2TrqH1fiwIscDPp1YtZSrW5ypaeE2qL5D/NuX9Ie01rflKSSm7fr1oHm8vVD2z
         7sGA==
In-Reply-To: <20180626185724.GA3958@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>

On Tue, Jun 26, 2018 at 11:55 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Tue, Jun 26, 2018 at 11:00:53AM -0700, Shakeel Butt wrote:
> > On Mon, Jun 25, 2018 at 10:49 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > ...
> > >
> > > The verb 'unuse' takes an argument memcg and 'uses' it - too weird.
> > > You can use 'override'/'revert' verbs like override_creds or just call
> > > memalloc_use_memcg(old_memcg) since there is no reference taken
> > > anyway in use_memcg and no reference released in unuse_memcg.
> > >
> > > Otherwise looks good to me.
> > >
> >
> > Thanks for your feedback. Just using memalloc_use_memcg(old_memcg) and
> > ignoring the return seems more simple. I will wait for feedback from
> > other before changing anything.
>
> We're not nesting calls to memalloc_use_memcg(), right? So we don't
> have to return old_memcg and don't have to pass anything to unuse, it
> can always set current->active_memcg to NULL.

For buffer_head, the allocation is done with GFP_NOFS. So, I think
there is no chance of nesting. The fsnotify uses GFP_KERNEL but based
on my limited understanding of fsnotify, there should not be any
nesting i.e. the allocation triggering reclaim which trigger fsnotify
events. Though I would like Amir or Jan to confirm there is no nesting
possible.

thanks,
Shakeel
