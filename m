From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Tue, 22 Sep 2020 21:08:59 +0200
Message-ID: <20200922190859.GH12990@dhcp22.suse.cz>
References: <20200909215752.1725525-1-shakeelb@google.com>
 <20200921163055.GQ12990@dhcp22.suse.cz>
 <CALvZod43VXKZ3StaGXK_EZG_fKcW3v3=cEYOWFwp4HNJpOOf8g@mail.gmail.com>
 <20200922114908.GZ12990@dhcp22.suse.cz>
 <CALvZod4FvE12o53BpeH5WB_McTdCkFTFXgc9gcT1CEHXzQLy_A@mail.gmail.com>
 <20200922165527.GD12990@dhcp22.suse.cz>
 <CALvZod7K9g9mi599c5+ayLeC4__kckv155QQGVMVy2rXXOY1Rw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600801740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CW9QWqJ7q2Kodf4xbjqeZQdYjMsmJi312d4fCh2gG6g=;
        b=am3UrXxd1MkIUqFBP8aN0slqcWO/Bw63BGSak3pgn1ZPDR8+wNqHKX9srRcZzat4AJ+akz
        SCCnb2Z4J5dh68Go3WrUZxK/OxrQkwsnTsPrRVAYgMYIFcV2MEkhUwEVgvF23+89DXxAHS
        Q9tXE/PSUecByYAItejjA5fw1Q82EHg=
Content-Disposition: inline
In-Reply-To: <CALvZod7K9g9mi599c5+ayLeC4__kckv155QQGVMVy2rXXOY1Rw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue 22-09-20 11:10:17, Shakeel Butt wrote:
> On Tue, Sep 22, 2020 at 9:55 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
[...]
> > Last but not least the memcg
> > background reclaim is something that should be possible without a new
> > interface.
> 
> So, it comes down to adding more functionality/semantics to
> memory.high or introducing a new simple interface. I am fine with
> either of one but IMO convoluted memory.high might have a higher
> maintenance cost.

One idea would be to schedule a background worker (which work on behalf
on the memcg) to do the high limit reclaim with high limit target as
soon as the high limit is reached. There would be one work item for each
memcg. Userspace would recheck the high limit on return to the userspace
and do the reclaim if the excess is larger than a threshold, and sleep
as the fallback.

Excessive consumers would get throttled if the background work cannot
keep up with the charge pace and most of them would return without doing
any reclaim because there is somebody working on their behalf - and is
accounted for that.

The semantic of high limit would be preserved IMHO because high limit is
actively throttled. Where that work is done shouldn't matter as long as
it is accounted properly and memcg cannot outsource all the work to the
rest of the system.

Would something like that (with many details to be sorted out of course)
be feasible?

If we do not want to change the existing semantic of high and want a new
api then I think having another limit for the background reclaim then
that would make more sense to me. It would resemble the global reclaim
and kswapd model and something that would be easier to reason about.
Comparing to echo $N > reclaim which might mean to reclaim any number
pages around N.
-- 
Michal Hocko
SUSE Labs
