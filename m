From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Thu, 5 Jan 2023 11:39:27 -1000
Message-ID: <Y7dDjyT1Gl5Mt3fl@slm.duckdns.org>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <Y7cKf7IH+FJ/6IyV@slm.duckdns.org>
 <20230105192247.GB16920@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2B/6xg54aJ7idENEindVKE0XwrAKLTxScGdP8EUbfT4=;
        b=ZkNdyUzEpnyBd0OlCkttYyZAG/3I+W6QG3eMejUnJp8CrNHDsyjvOt9clDf0vayE2i
         r6lkarY5scvvcjm/rCs+97/cb8gqnaQAyMmK3VSY0WyGE8IlHrmP+m2hv6sg2w9Hc7Fj
         oYJ+KVy30yL4L97vccgDToFnVKpG2sQ9Ip0kAUHayWMzIMzCVKcCkw/30gSAWKVx/ibj
         VQPPP3O/BeKowqjHlsVjOEGUI1eb+l6qP37gQQoSu+PFjSgNwn7pF8Nk2hVOW4m+375W
         JFPztt3e6nOUrCAXynvNsPVdzbNfSJw4YG57GZ8mO8YbvQ343sLQ7vMFYumsPmD5GZfz
         ZXaw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230105192247.GB16920-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org

Hello, Michal.

On Thu, Jan 05, 2023 at 08:22:47PM +0100, Michal Koutn=FD wrote:
> On Thu, Jan 05, 2023 at 07:35:59AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yR=
OfE0A@public.gmane.org> wrote:
> > Hard limits tend to make this sort of problems a lot more pronounced be=
cause
> > the existing mechanisms tend to break down for the users which are seve=
rely
> > throttled down even while the device as a whole is fairly idle. cpu.max
> > often triggers severe priority inversions too, so it isn't too surprisi=
ng
> > that people hit severe priority inversion issues w/ io.max.
>=20
> To be on the same page:
> 1) severe PI =3D=3D priority inversion across cgroups (progated e.g. via
>    global locks (as with cpu.max) or FS journal (as with io.max)),

Another important inversion vector is memory reclaim as writeback operations
get trapped in blk-throttle and the system can pile on waiting for clean
pages.

> 2) ordinary PI =3D=3D priority inversion contained within a single cgroup,
>    i.e. no different from an under-provisioned system.

I didn't use the term in a precise manner but yeah both can be problematic.
The former a lot more so.

> The reported issue sounds like 2) but even with the separated queues 1)
> is still possible :-/

Yeah, definitely.

> > Another problem with blk-throttle is that it doesn't prioritize shared =
IOs
> > identified by bio_issue_as_root_blkg() like iolatency and iocost do, so
> > there can be very severe priority inversions when e.g. journal commit g=
ets
> > trapped in a low priority cgroup further exacerbating issues like this.
>=20
> Thanks for the broader view. So the separated queues are certainly an
> improvement but ultimately a mechanism based on bio_issue_as_root_blkg()
> predicate and deferred throttling would be better? Or is permanent limit
> enforcement more important?

Generally true but the specific scenario raised by Jinke is rather unusual
and isn't covered by issue_as_root mechanism as it doesn't promote REQ_SYNC
data writes. Then again, this usually isn't a problem as in most cases dirty
throttling through writeback should stave off severe starvations.

blk-throttle is pretty outdated and kinda broken and separating out sync
writes isn't gonna solve most of its problems. However, it will help in some
cases like the one described by Jinke and can sometimes lessen wider scope
inversions too. Given the partial nature, I don't feel too enthusiastic but
at the same time can't find good reasons to reject either. I don't know. I
don't feel too strong either way.

On a tangential note, I've been thinking about implementing io.max on top of
iocost so that each cgroup can just configure the max % of total device IO
capacity that's allowed for it, which should be a lot easier to use and has
many of the problems already solved.

Thanks.

--=20
tejun
