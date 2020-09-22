From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Tue, 22 Sep 2020 20:31:25 +0200
Message-ID: <20200922183125.GG12990@dhcp22.suse.cz>
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
        t=1600799486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6V2DffdTKL8UOfFVJCLTmEpEQRVobEw0bM3wzRvskX0=;
        b=aAJ+/aBcg20EvZdS+X29DSgXibh2SuIV4rOW6CMaDZ+Pit8vIFgMiebbhfGFBvuHU1MhE9
        XQSfFShMcnDvylbwIJQzl7c27qOoZ/XLFVHf0Jxk6XBU8RUccqPBukgHgD+OWuaC4DQNZQ
        5eYSTdekQh3y/lAM57xb6g9ELjrWCoM=
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
> > So far I have learned that you are primarily working around an
> > implementation detail in the zswap which is doing the swapout path
> > directly in the pageout path.
> 
> Wait how did you reach this conclusion? I have explicitly said that we
> are not using uswapd like functionality in production. We are using
> this interface for proactive reclaim and proactive reclaim is not a
> workaround for implementation detail in the zswap.

Hmm, I must have missed the distinction between the two you have
mentioned. Correct me if I am wrong but "latency sensitive" workload is
the one that cannot use the high limit, right. For some reason I thought
that your pro-active reclaim usecase is also not compatible with the
throttling imposed by the high limit. Hence my conclusion above.
-- 
Michal Hocko
SUSE Labs
