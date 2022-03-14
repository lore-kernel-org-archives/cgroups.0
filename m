From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Date: Mon, 14 Mar 2022 13:57:03 +0100
Message-ID: <20220314125703.GA11645@blackbody.suse.cz>
References: <20220304184040.1304781-1-shakeelb@google.com>
 <20220311160051.GA24796@blackbody.suse.cz>
 <20220312190715.cx4aznnzf6zdp7wv@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647262624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TaLNlzXGwgt3rIVBhMb8m6A+9RFUlVGbRu4EdMRGlyg=;
        b=eFmcNQFmrNsywdOeFr5SEDup6JsmNK0K+YScoACNqR2qy1LHFFYhq1WsNq+LI5EPmA8/2Q
        bQCv7UfngnJKKpainDF0pEVNMNsKVuHf3pi0c/ifsViuOWtm9nfJR/G4o6naP5tiL4+IiB
        27UYnqde9XPDx7asXLRv5oXrc/eu6lc=
Content-Disposition: inline
In-Reply-To: <20220312190715.cx4aznnzf6zdp7wv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Frank Hofmann <fhofmann-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi.

On Sat, Mar 12, 2022 at 07:07:15PM +0000, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> So, I will focus on the error rate in this email.

(OK, I'll stick to error estimate (for long-term) in this message and
will send another about the current patch.)

> [...]
> 
> > The benefit this was traded for was the greater accuracy, the possible
> > error is:
> > - before
> >    - O(nr_cpus * nr_cgroups(subtree) * MEMCG_CHARGE_BATCH)	(1)
> 
> Please note that (1) is the possible error for each stat item and
> without any time bound.

I agree (forgot to highlight this can stuck forever).

> 
> > - after
> >      O(nr_cpus * MEMCG_CHARGE_BATCH) // sync. flush
> 
> The above is across all the stat items.

Can it be used to argue about the error?
E.g.
    nr_cpus * MEMCG_CHARGE_BATCH / nr_counters
looks appealing but that's IMO too optimistic.

The individual item updates are correlated so in practice a single item
would see a lower error than my first relation but without delving too
much into correlations the upper bound is nr_counters independent.


> I don't get the reason of breaking 'cr' into individual stat item or
> counter. What is the benefit? We want to keep the error rate decoupled
> from the number of counters (or stat items).

It's just a model, it should capture that every stat item (change)
contributes to the common error estimate. (So it moves more towards the 
  nr_cpus * MEMCG_CHARGE_BATCH / nr_counters
per-item error (but here we're asking about processing time.))

[...]

> My main reason behind trying NR_MEMCG_EVENTS was to reduce flush_work by
> reducing nr_counters and I don't think nr_counters should have an impact
> on Δt.

The higher number of items is changing, the sooner they accumulate the
target error, no?

(Δt is not the periodic flush period, it's variable time between two
sync flushes.)

Michal
