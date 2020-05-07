From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: effective memory.high reclaim for remote charging
Date: Thu, 7 May 2020 10:00:07 -0700
Message-ID: <CALvZod5TmAnDoueej1nu5_VV9rQa6VYVRXqCYuh63P5HN-o9Sw@mail.gmail.com>
References: <20200507163301.229070-1-shakeelb@google.com> <20200507164653.GM6345@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9a51Q0KJvE3zrPblIKzTSl+tjTR3Bde3DH99HzeKLKI=;
        b=ibg8qmwWjVbS3FUiaxBOHr54QL17/uXAfjcKOSAWUMg75VnfQ93AsgVqCEi9PMtWa9
         HLbY16J7t69k2RWxnYhd/nFAHBX8h3Z1/xTqVnT0oYVo74D17A5Y3MTeNlGz7fBMpBG+
         gIkD5dglHn0fGdlGpiGoATeuiRXrUnkhRv3NyDPc1iSW2Qf4f/L7pnSVxV7/3Jf6IesD
         QsrAE1xP8S7h0EEY6/UjSupjkRjY7AKKm3ZQRAphuMi58y8g3fwNHfqtC76KvN2c5JHo
         J8kqfHofQwpOmg+u3p8lOMam4gk5lYN/2zzv/jGpP+lwgauKVKvj70nyhy4XNmrlLN6i
         QWAQ==
In-Reply-To: <20200507164653.GM6345@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, May 7, 2020 at 9:47 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Thu 07-05-20 09:33:01, Shakeel Butt wrote:
> [...]
> > @@ -2600,8 +2596,23 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >                               schedule_work(&memcg->high_work);
> >                               break;
> >                       }
> > -                     current->memcg_nr_pages_over_high += batch;
> > -                     set_notify_resume(current);
> > +
> > +                     if (gfpflags_allow_blocking(gfp_mask))
> > +                             reclaim_over_high(memcg, gfp_mask, batch);
> > +
> > +                     if (page_counter_read(&memcg->memory) <=
> > +                         READ_ONCE(memcg->high))
> > +                             break;
>
> I am half way to a long weekend so bear with me. Shouldn't this be continue? The
> parent memcg might be still in excess even the child got reclaimed,
> right?
>

The reclaim_high() actually already does this walk up to the root and
reclaim from ones who are still over their high limit. Though having
'continue' here is correct too.

> > +                     /*
> > +                      * The above reclaim might not be able to do much. Punt
> > +                      * the high reclaim to return to userland if the current
> > +                      * task shares the hierarchy.
> > +                      */
> > +                     if (current->mm && mm_match_cgroup(current->mm, memcg)) {
> > +                             current->memcg_nr_pages_over_high += batch;
> > +                             set_notify_resume(current);
> > +                     } else
> > +                             schedule_work(&memcg->high_work);
> >                       break;
> >               }
> >       } while ((memcg = parent_mem_cgroup(memcg)));
> > --
> > 2.26.2.526.g744177e7f7-goog
> >
>
> --
> Michal Hocko
> SUSE Labs
