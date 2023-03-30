From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 7/9] workingset: memcg: sleep when flushing stats in
 workingset_refault()
Date: Thu, 30 Mar 2023 09:50:32 +0200
Message-ID: <ZCU/SMr5gC9C0U+R@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-8-yosryahmed@google.com>
 <ZCU8tjqzg8cDbobQ@dhcp22.suse.cz>
 <CAJD7tkZLBs=A8m5u=9jGtMeD0ptOgtCTYUoh2r4Ex+fCkvwAXg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680162633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oGBp2CerBGhZkbj2lQ/nRIhr24DsF/TKy5SuxGUse2s=;
        b=b3sVl6y3RurKw8ub7GVYytEfZjv5e7tMzMkxjEqStKlRW0eN196yPTxmsd1WQnppK3lR2a
        3NkEc1GikBqDkQ15fxo+RIJ32ywlsW/Ov47iO6zepuLhLcfl+ULGBtWgO2G+gx33rfB5vD
        g8jsOgtw5SluPqSGCIX1kHrMPP4REtI=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZLBs=A8m5u=9jGtMeD0ptOgtCTYUoh2r4Ex+fCkvwAXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 30-03-23 00:42:36, Yosry Ahmed wrote:
> On Thu, Mar 30, 2023 at 12:39=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k=
@public.gmane.org> wrote:
> >
> > On Tue 28-03-23 22:16:42, Yosry Ahmed wrote:
> > > In workingset_refault(), we call
> > > mem_cgroup_flush_stats_atomic_ratelimited() to flush stats within an
> > > RCU read section and with sleeping disallowed. Move the call above
> > > the RCU read section and allow sleeping to avoid unnecessarily
> > > performing a lot of work without sleeping.
> >
> > Could you say few words why the flushing is done before counters are
> > updated rather than after (the RCU section)?
>=20
> It's not about the counters that are updated, it's about the counters
> that we read. Stats readers do a flush first to read accurate stats.
> We flush before a read, not after an update.

Right you are, my bad I have misread the intention here.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

--=20
Michal Hocko
SUSE Labs
