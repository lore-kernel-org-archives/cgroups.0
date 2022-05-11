From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 6/6] zswap: memcg accounting
Date: Wed, 11 May 2022 15:06:56 -0400
Message-ID: <YnwJUL90fuoHs3YW@cmpxchg.org>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
 <20220510152847.230957-7-hannes@cmpxchg.org>
 <20220511173218.GB31592@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RFcLVWiWlqjohwWrz8ZmNxS2c0JbCUFp6Lb1Ilp7lsM=;
        b=Wqi934csibhv/mpquejGDXyoEtv7L4by8ZdjiC8Vt5xc0YCHBzZJVfZphSsZTUFtlk
         BWN+uBN6xJN4vfk6rYwpgxP0+Hto8wWvFVtfTc81X66yFGK+cH1Z1HReUfrgi+Yk1g8h
         vWplRp9WFeeKoSsIxxqRrUkTH0jt2TDkk/gNd00645n46RTD+bg1mhWdv97mtH3aF0HF
         yhMdAMiB2NXXE93IjVJ7yPGxLJnM429NTCqFxnYtxNrKudFgsM3k8cVwAAYJk1fp+qp5
         X/r/ZbGqcqzfvRKub5gm3w23S19pd4l2vLznyNBwE9dbtRWA6EbSBXEb7cMd6sqpbwND
         H4/w==
Content-Disposition: inline
In-Reply-To: <20220511173218.GB31592-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, May 11, 2022 at 07:32:18PM +0200, Michal Koutn=FD wrote:
> Hello.
>=20
> On Tue, May 10, 2022 at 11:28:47AM -0400, Johannes Weiner <hannes-druUgvl=
0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > +void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
> > +{
> > +	struct mem_cgroup *memcg;
> > +
> > +	VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > +
> > +	/* PF_MEMALLOC context, charging must succeed */
> > +	if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> > +		VM_WARN_ON_ONCE(1);
>=20
> IIUC, the objcg is derived from the compressed page, i.e. same memcg
> (reparenting neglected for now). This memcg's memory.current is then
> charged with the compressed object size.

Correct. After which the uncompressed page is reclaimed and uncharged.
So the zswapout process will reduce the charge bottom line.

> Do I get it right that memory.zswap.current is a subset of memory.current?
>
> (And that zswap is limited both by memory.max and memory.zswap.max?)

Yes. Zswap is a memory consumer, and we want the compressed part of a
workload's memory to show up in the total memory footprint.

memory.zswap.* are there to configure zswap policy, within the
boundaries of available memory - it's by definition a subset.
