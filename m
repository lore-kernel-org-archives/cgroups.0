From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Date: Wed, 16 Mar 2022 09:26:55 -0700
Message-ID: <CALvZod4Mfcqt4DvYzSxSX=C9sVWfrMpva9rrMc91_DQ_jReXbA@mail.gmail.com>
References: <20220304184040.1304781-1-shakeelb@google.com> <20220311160051.GA24796@blackbody.suse.cz>
 <20220312190715.cx4aznnzf6zdp7wv@google.com> <20220314125709.GA12347@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LOz30deJcjhjIyXrEXiDnvgZ+SlnXxBb7kUkmufCFCs=;
        b=euiuCzfqGkYwgdoQmNRDghuuPrAiXcUV401r/vjPV6N4ydFbIk4O/ZZos55iCYihiJ
         1B2Rdtk2zITgdDZnW4fAcsQkznCDbtClCUyNsp3+wGQqZhtsZcavfxaZO4uc39FbFK5c
         DPNGY6oCGwYL2dtnywRcf3II37L/WfRmydceUYcMRp7yEXaaDpJwqw0cdTtA7oUmf99K
         L3r2N2Ro8VNPJE16xuaG4MaBJbyvbNiaNwRSY0Eyjwppc6RxiTgg9+8s5wDbscVHjrjn
         S/F6K4GdPfbGbLMp3h+Y+rNlIC4IvgqTUFpV8l+loRNejQDA4QjoTkD9Bx4o+eQmBScb
         t/ow==
In-Reply-To: <20220314125709.GA12347-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Frank Hofmann <fhofmann-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Dao <dqminh-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Mar 14, 2022 at 5:57 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> Hi 2.
>
> On Sat, Mar 12, 2022 at 07:07:15PM +0000, Shakeel Butt <shakeelb@google.c=
om> wrote:
> > It is (b) that I am aiming for in this patch. At least (a) was not
> > happening in the cloudflare experiments. Are you suggesting having a
> > dedicated high priority wq would solve both (a) and (b)?
> > [...]
> > > We can't argue what's the effect of periodic only flushing so this
> > > newly introduced factor would inherit that too. I find it superfluous=
.
> >
> >
> > Sorry I didn't get your point. What is superfluous?
>
> Let me retell my understanding.
> The current implementation flushes based on cumulated error and time.
> Your patch proposes conditioning the former with another time-based
> flushing, whose duration can be up to 2 times longer than the existing
> periodic flush.
>
> Assuming the periodic flush is working, the reader won't see data older
> than 2 seconds, so the additional sync-flush after (possible) 4 seconds
> seems superfluous.
>
> (In the case of periodic flush being stuck, I thought the factor 2=3D4s/2=
s
> was superfluous, another magic parameter.)
>
> I'm comparing here your proposal vs no synchronous flushing in
> workingset_refault().
>
> > Do you have any strong concerns with the currect patch?
>
> Does that clarify?
>
> (I agree with your initial thesis this can be iterated before it evolves
> to everyone's satisfaction.)
>

Thanks Michal for the explanation. For the long term, I think all
these batching can be made part of core rstat infrastructure and as
generic as you have described. Also there is interest in using rstat
from BPF, so generic batching would be needed there as well.
