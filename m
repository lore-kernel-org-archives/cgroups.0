From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 26 Jun 2018 14:57:24 -0400
Message-ID: <20180626185724.GA3958@cmpxchg.org>
References: <20180625230659.139822-1-shakeelb@google.com>
 <20180625230659.139822-2-shakeelb@google.com>
 <CAOQ4uxiV75+X3dMLS93iXqwmSU6eKPOUocdkXiR7MQZhEjotQg@mail.gmail.com>
 <CALvZod5ARMZL+eD8-mrxeBvxJcuVPXaCwWEgUyQw85xXWxHauA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6RXfo9Kz4LSycVlaA8XOUYuoUVPIG7oEWJvgtAmRMVA=; b=y9mlVq4sr/GfrJF40qjMR6tfmx
        614mC32Bb3mMUn/UsCE9qvs5K3XoRsgQzYS0eoAtj2kjwxmRgpRKP0dLSg0tswdRmFLHv2Mhc+N9k
        WCccwZGi3UYNCWDqeGLZShOxV7ww1QXm2UWQ4kk0264mmo4FB1PyE04OZSodzoYT3nNY=;
Content-Disposition: inline
In-Reply-To: <CALvZod5ARMZL+eD8-mrxeBvxJcuVPXaCwWEgUyQw85xXWxHauA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>

On Tue, Jun 26, 2018 at 11:00:53AM -0700, Shakeel Butt wrote:
> On Mon, Jun 25, 2018 at 10:49 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> ...
> >
> > The verb 'unuse' takes an argument memcg and 'uses' it - too weird.
> > You can use 'override'/'revert' verbs like override_creds or just call
> > memalloc_use_memcg(old_memcg) since there is no reference taken
> > anyway in use_memcg and no reference released in unuse_memcg.
> >
> > Otherwise looks good to me.
> >
> 
> Thanks for your feedback. Just using memalloc_use_memcg(old_memcg) and
> ignoring the return seems more simple. I will wait for feedback from
> other before changing anything.

We're not nesting calls to memalloc_use_memcg(), right? So we don't
have to return old_memcg and don't have to pass anything to unuse, it
can always set current->active_memcg to NULL.
