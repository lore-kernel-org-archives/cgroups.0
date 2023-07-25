From: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] kernfs: attach uuid for every kernfs and report it in fsid
Date: Tue, 25 Jul 2023 16:58:47 -0700
Message-ID: <CABWYdi1k1gNwkWT8TH7kPv=tA8qaZbjaaogYoMRnFPtBqvR_Uw@mail.gmail.com>
References: <20230710183338.58531-1-ivan@cloudflare.com> <2023071039-negate-stalemate-6987@gregkh>
 <CABWYdi39+TJd1qV3nWs_eYc7XMC0RvxG22ihfq7rzuPaNvn1cQ@mail.gmail.com> <jy7ktvlb4tkg6pl2vll6u4gozfji7giddyseypj4w2d2ue4gvn@4tw7dmjy4hfv>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1690329538; x=1690934338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0V/EEMFzUDgOJY1HEZ2mzSgEOY/cF7JWrxdvLNmC4c=;
        b=HQmhRjdDvJ1uYczgxWnKD2vuEgMQ1C34U5qNTVu5bgQnwC4Bo65ZfziU37Xl9ReMuI
         ljgsg+zC1ZyZKpd6J4xCbFL7r/WFBlobzR0fNJHPHHsEVIs1APIzpwzPPIJWZ9biqp/R
         QfbRvQeOQiOMI8y/jOcru47WwYghRDHy+nC0Q=
In-Reply-To: <jy7ktvlb4tkg6pl2vll6u4gozfji7giddyseypj4w2d2ue4gvn@4tw7dmjy4hfv>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Jul 25, 2023 at 7:07=E2=80=AFAM Michal Koutn=C3=BD <mkoutny-WDPRK7U/wSs@public.gmane.org=
m> wrote:
>
> Hello.
>
> On Mon, Jul 10, 2023 at 02:21:10PM -0700, Ivan Babrou <ivan-lDpJ742SOEuslyEXuUq45g@public.gmane.org=
m> wrote:
> > I want to monitor cgroup changes, so that I can have an up to date map
> > of inode -> cgroup path, so that I can resolve the value returned from
> > bpf_get_current_cgroup_id() into something that a human can easily
> > grasp (think system.slice/nginx.service).
>
> Have you considered cgroup_path_from_kernfs_id()?

* It's not available from bpf from what I see (should I send a patch?)
* It turns short numeric keys into large string keys (you mention this belo=
w)
* It's a lot more work upfront for every event under a spinlock

> > Currently I do a full sweep to build a map, which doesn't work if a
> > cgroup is short lived, as it just disappears before I can resolve it.
> > Unfortunately, systemd recycles cgroups on restart, changing inode
> > number, so this is a very real issue.
>
> So, a historical map of cgroup id -> path is also useful for you, right?
> (IOW, cgroup_path_from_kernfs_id() is possible but it'd inflate log
> buffer size if full paths were stored instead of ids.)

For the most part the historical map would not be necessary if we had
cgroup paths (except for the points I mentioned above).

> (I think a similar map would be beneficial for SCM_CGROUP [1] idea too.)

Yes, it seems like it.

> > There's also this old wiki page from systemd:
> >
> > * https://freedesktop.org/wiki/Software/systemd/Optimizations
>
> The page also states:
>
> > Last edited Sat 18 May 2013 08:20:38 AM UTC
>
> Emptiness notifications via release_agent are so 2016 :-), unified
> hiearchy has more convenient API [2], this is FTR.

Sure, but these aren't arguments against having fanotify for cgroup filesys=
tem.
