From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] memcg: unify memcg stat flushing
Date: Wed, 13 Oct 2021 12:24:31 -0700
Message-ID: <CALvZod6dN5Ub-r9+evXYCaeNuzrDs1byPLY1DAyn=R7rqHoqKg@mail.gmail.com>
References: <20211001190040.48086-1-shakeelb@google.com> <20211001190040.48086-2-shakeelb@google.com>
 <20211013180122.GA1007@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OcVw8ovBCZVOoCHV49LU9UJr7n1pv24bvXfSbF9CliM=;
        b=spTehBDgwgxtAT5s4zEyEzdavxm/I/DtmCIdVIVhZeouKvynu2a3SSRGv2kSQLqT1K
         I39IIC9a59bpOtvUMiPw5D8FnlNU8xvsp+JppFy07dv5mRlOnsqU87Al5n8LybTZHcDD
         vSFYTHwK5kNMRUcSvts5fuPzG2AUMWSuCMG52e8mGTwyYBDx1rAJi+kZhIu0AS20m4mW
         EHLfDzWt2InVuusPhroF1IGYYVVqy1VJrL4walMelIL/ih2NPNGT9u5/BNXIJFWDYwiH
         V6z0GrBuZYx+hHxo+7M84CzO9P9HEU79eMisNKW6ORHFm9Biu8v/RlbVgm+ODvHFINk+
         rN1Q==
In-Reply-To: <20211013180122.GA1007-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Oct 13, 2021 at 11:01 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrot=
e:
>
> Hello Shakeel.
>
> (Sorry for taking so long getting down to this.)
>
> On Fri, Oct 01, 2021 at 12:00:40PM -0700, Shakeel Butt <shakeelb@google.c=
om> wrote:
> > There is no need for that.  We just need one flusher and everyone else
> > can benefit.
>
> I imagine a cgroup with an intricate deep hiearchy with many updates and
> a separate (simpler) sibling/independent cgroup that would need to pay
> the costs of the first hierarchy updates [1] when it asks just for its
> own stats (bound by the amount that's leftover from the periodic
> updates).
>
> The stats files (or wb stats) are likely not that time sensitive and the
> reclaim (that can be local only but is slow path anyway) already uses
> the global flushing.
>
> I wonder whether the bigger benefit would be to retain the global
> stats_flush_threshold counter but flush only local subtree.

I did contemplate on this (i.e. a stat read paying the flushing price
for everyone else) but decided to keep as is based on:

1) The periodic async flush will keep the update tree small and will
keep infrequent readers cheap.
2) Keep things simple for now and come back if someone complains for
very frequent stats readers.

Shakeel
