From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH-block v2 2/3] blk-cgroup: Don't flush a blkg if destroyed
Date: Mon, 12 Dec 2022 12:16:35 -1000
Message-ID: <Y5eoQ8UBN8Xpc+Wp@slm.duckdns.org>
References: <20221211222058.2946830-1-longman@redhat.com>
 <20221211222058.2946830-3-longman@redhat.com>
 <20221212125953.GE16456@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9jGpkSVyc4v+RFtLDSN/m3mYqOtryehMxfGYmcyBkvk=;
        b=EIqkfOYY6p1JIUWt70bGUX7mnzPNoEpOqH6QlCucGYlpM2VZNJQVGYtbLlK7ioSRCQ
         mfJNxsx8/Z0uIJ+1MGPDc+n85sDUAYrPQg+9CQbY1uZ1wqPQ28tQjPZt/lXPdc7R1+yn
         H2LDbOxp7Y5P7npUtry9kDHISuYFckwOEtgNqm3yDu6gx4QyMunYTEEc4U5aoIwB6sGk
         rhU2eswgT90dBBFW6CMnPwo5NvPpWy5WO7yzL8eY7yQ0WzmuPDZCNvHQKrsbLpjVzGFV
         J0vallyMWqqlSsk74jsQQsygRc88eAJrhSKw2CsRPMma/liL0dqbUZj3SFG0VQ2kQR1r
         otWw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221212125953.GE16456@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Waiman Long <longman@redhat.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

On Mon, Dec 12, 2022 at 01:59:53PM +0100, Michal Koutn=FD wrote:
> Hello.
>=20
> On Sun, Dec 11, 2022 at 05:20:57PM -0500, Waiman Long <longman@redhat.com=
> wrote:
> > Before commit 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()"),
> > blkg's stats is only flushed if they are online.
>=20
> I'm not sure I follow -- css_release_work_fn/cgroup_rstat_flush may be
> called on an offlined blkcg (offlined!=3Dreleased). There's no invariant
> ensuring offlined blkcg won't be flushed. (There is only current
> situation when there is no reader of io data that'd need them flushed
> [1].)
>=20
> > In addition, the stat flushing of blkgs in blkcg_rstat_flush()
> > includes propagating the rstat data to its parent. However, if a blkg
> > has been destroyed (offline), the validity of its parent may be
> > questionable.
>=20
> Parents won't be freed (neither offlined) before children (see
> css_killed_work_fn). It should be regularly OK to pass data into a
> parent of an offlined blkcg.
>=20
> > For safety, revert back to the old behavior by ignoring offline
> > blkg's.
>=20
> I don't know if this is a good reasoning. If you argue that offlined
> children needn't be taken into parent's account, then I think it's more
> efficient to exclude the offlined blkcgs from update. (With the caveat I
> have in [1].)

Yeah, I'm not sure about this patch either. Doesn't seem necessary.

Thanks.

--=20
tejun
