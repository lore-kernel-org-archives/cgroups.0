From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Fri, 25 Aug 2023 20:17:25 +0200
Message-ID: <ZOjwNR2wv5mOdWv0@dhcp22.suse.cz>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
 <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
 <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692987446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ujuMMocBltnOMhznVm766I5QPcNC5qT9zu3nsGMBN7k=;
        b=M4FFeikAxZfvdQpVl5oyAbEUXrkd22eQQW0u3Q3anuDTciGLnuliGADRpNoIGawDN1ZmMY
        6fAymp2LCV4dgFGDtXNjsddXL0o3f+R+xKxtTKxVi40aMLSo8p7XCC5kHcMte/K+8dKowN
        dLGqToSCjHoMOQ+TElfmbfSRoxpUA+E=
Content-Disposition: inline
In-Reply-To: <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 25-08-23 08:14:54, Yosry Ahmed wrote:
> On Fri, Aug 25, 2023 at 12:05=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k=
@public.gmane.org> wrote:
[...]
> > I might be wrong but the whole discussion so far suggests that the
> > global rstat lock should be reconsidered. From my personal experience
> > global locks easily triggerable from the userspace are just a receip for
> > problems. Stats reading shouldn't be interfering with the system runtime
> > as much as possible and they should be deterministic wrt runtime as
> > well.
>=20
> The problem is that the global lock also serializes the global
> counters that we flush to. I will talk from the memcg flushing
> perspective as that's what I am familiar with. I am not sure how much
> this is transferable to other flushers.
>=20
> On the memcg side (see mem_cgroup_css_rstat_flush()), the global lock
> synchronizes access to multiple counters, for this discussion what's
> most important are:
> - The global stat counters of the memcg being flushed (e.g.
> memcg->vmstats->state).
> - The pending stat counters of the parent being flushed (e.g.
> parent->vmstats->state_pending).

I haven't digested the rest of the email yet (Friday brain, sorry) but I
do not think you are adressing this particular part so let me ask before
I dive more into the following. I really do not follow the serialization
requirement here because the lock doesn't really serialize the flushing,
does it? At least not in a sense of a single caller to do the flushing
atomicaly from other flushers. It is possible that the current flusher
simply drops the lock midway and another one retakes the lock and
performs the operation again. So what additional flushing
synchronization does it provide and why cannot parallel flushers simply
compete over pcp spinlocks?

So what am I missing?
--=20
Michal Hocko
SUSE Labs
