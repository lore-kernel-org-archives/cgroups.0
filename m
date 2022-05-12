From: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: Export memcg->watermark via sysfs for
 v2 memcg
Date: Thu, 12 May 2022 08:18:01 +0530
Message-ID: <CAPD3tpG_mDq+zpKnFTKgWCuW9_wCfsHMu2ndzOEBsLaqZp-KWA@mail.gmail.com>
References: <20220507050916.GA13577@us192.sjc.aristanetworks.com> <20220511174953.GC31592@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xtNpsVsaVZqX+nLgswyUb5xinkvrzu2jSXspDWuy6ao=;
        b=IsD81cUQTxFLLiCf8ZUh17UC4XEeB4YvQSbZCBminUMBlEwBgG1pdELuzADA6mkmtO
         bN1VjOS1G4iq0pPoFUuCdL01CJPbcWU/jtZw/r/Iw/TWW2O2sT/2DBYeDEPg6REYgnrx
         YiCvy2OBG7mUbOCxCwSOXiZdIZ70fNYpvxx8gsQb92k4LR86sHH8dW4LgzPXNe4UYBHh
         WQvvU2HywxJjxSnkQv86Z36xEoxTmZsLGF6pfr8mdrPMu72RHi7UYdQ9kJmIf66MC7M/
         T7aFNuI8/YhJogcUESiT9cTOYQR7Z5pg2ExCQ17zeq3NYowpC/JW6BdAXop6h+lPNa2e
         d0Kw==
In-Reply-To: <20220511174953.GC31592-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, May 11, 2022 at 11:19 PM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> Hi.
>
> On Fri, May 06, 2022 at 10:09:16PM -0700, Ganesan Rajagopal <rganesan@ari=
sta.com> wrote:
> > We run a lot of automated tests when building our software and run into
> > OOM scenarios when the tests run unbounded. v1 memcg exports
> > memcg->watermark as "memory.max_usage_in_bytes" in sysfs. We use this
> > metric to heuristically limit the number of tests that can run in
> > parallel based on per test historical data.
> >
> > This metric is currently not exported for v2 memcg and there is no
> > other easy way of getting this information. getrusage() syscall returns
> > "ru_maxrss" which can be used as an approximation but that's the max
> > RSS of a single child process across all children instead of the
> > aggregated max for all child processes. The only work around is to
> > periodically poll "memory.current" but that's not practical for
> > short-lived one-off cgroups.
> >
> > Hence, expose memcg->watermark as "memory.peak" for v2 memcg.
>
> It'll save some future indirections if the commit messages includes the
> argument about multiple readers and purposeful irresetability.

Good point. The patch has already been picked up for mm-unstable. I don't
know what's the process in this situation. Should I post a "[PATCH v3]"
with an updated commit message?

>
> >
> > Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
> >  mm/memcontrol.c                         | 13 +++++++++++++
> >  2 files changed, 20 insertions(+)
>
> Besides that it looks useful and correct, feel free to add
> Reviewed-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>

Thank you.

Ganesan
