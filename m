From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: use rstat for non-hierarchical stats
Date: Wed, 2 Aug 2023 09:40:16 +0200
Message-ID: <ZMoIYLwITUZzXp4C@dhcp22.suse.cz>
References: <20230726153223.821757-1-yosryahmed@google.com>
 <20230726153223.821757-2-yosryahmed@google.com>
 <ZMkXDuwD8RFRKnNQ@dhcp22.suse.cz>
 <CAJD7tkbb8AWR-duWb+at-S9MMz48b0JqnM+b5ok83TzvXvPb+A@mail.gmail.com>
 <CAJD7tkbZi16w4mYngVK8qA84FMijmHvwzMjHfrJiCsV=WjixOA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1690962017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6e6GiqmpyVCzOwvyGHqSNXCNxBFa7aDIzwYUNSYMUSM=;
        b=J+S11sgO6aiS75myCJ8iLCSy282SRXv1ywdO5YwOTHEIVWLCWo+CmZolywZvDiekiULT7E
        vWy7yPZAHd+/5e7nl5xlTRsvC9Ke8RqcIZJSFGjS/fxw80Gp6IoVhZvIX5Ru4mir/H7nD1
        u3KKzJjm5zGmBVBQNz63u0Wcjp13FkY=
Content-Disposition: inline
In-Reply-To: <CAJD7tkbZi16w4mYngVK8qA84FMijmHvwzMjHfrJiCsV=WjixOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 01-08-23 10:29:39, Yosry Ahmed wrote:
> On Tue, Aug 1, 2023 at 9:39=E2=80=AFAM Yosry Ahmed <yosryahmed-hpIqsD4AKl=
fQT0dZR+AlfA@public.gmane.org> wrote:
[...]
> > > Have you measured any potential regression for cgroup v2 which collec=
ts
> > > all this data without ever using it (AFAICS)?
> >
> > I did not. I did not expect noticeable regressions given that all the
> > extra work is done during flushing, which should mostly be done by the
> > asynchronous worker, but can also happen in the stats reading context.
> > Let me run the same script on cgroup v2 just in case and report back.
>=20
> A few runs on mm-unstable with this patch:
>=20
> # time cat /sys/fs/cgroup/cg*/memory.stat > /dev/null

Is this really representative test to make? I would have expected the
overhead would be mostly in mem_cgroup_css_rstat_flush (if it is visible
at all of course). This would be more likely visible in all cpus busy
situation (you can try heavy parallel kernel build from tmpfs for
example).
[...]

> It looks like there are no regressions on cgroup v2 when reading the
> stats. Please let me know if you want me to send a new version with
> the cgroup v2 results as well in the commit log -- or I can just send
> a new commit log. Whatever is easier for Andrew.

Updating the changelog should be good enough.
--=20
Michal Hocko
SUSE Labs
