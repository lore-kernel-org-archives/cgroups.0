From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cgroup: Reorganize css_set_lock and kernfs path
 processing
Date: Mon, 10 Oct 2022 10:24:03 -1000
Message-ID: <Y0R/Y/YlsynTla6m@slm.duckdns.org>
References: <Yz21I9UpXafWMU0K@slm.duckdns.org>
 <20221010082918.3821-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SWBKxcK5HE/3WshbW1q29xvyEiEvyFrYE2hY8YKFsLs=;
        b=KEYEbq/ly8DTkiYPCrGiR6KYBxqhyiZA26Fj+t0+nmZYWUozdenaY+VoU8pmLUc9ry
         OYmW4AJzZ9zZb9ACzz2x6+0Y+so2+IcnPsY5dEwJlHD9JFJQVEs2WbmLHhh4IcK3Ddy9
         QWqYnt/XqsFvRwGQ1tX2ZwRzLRJwB0C4xpMvYCaEG0ECzhQayHWXI6lDge1cYEHLDA/8
         ihOfFmF/w40sHx4RYXTIOrVRLItAuhUhgPUbQReNAD5AYi1eMzxK2HVFpdBK/eBJ3REV
         +1bDUqpz4l0lQsnB/1J3P+hNQ48giXMkuq6/1Y5ng0xXN8DgkEPIbNjsddWIK8blwo8Y
         hEmg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221010082918.3821-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Mon, Oct 10, 2022 at 10:29:18AM +0200, Michal Koutn=FD wrote:
> The commit 74e4b956eb1c incorrectly wrapped kernfs_walk_and_get
> (might_sleep) under css_set_lock (spinlock). css_set_lock is needed by
> __cset_cgroup_from_root to ensure stable cset->cgrp_links but not for
> kernfs_walk_and_get.
>=20
> We only need to make sure that the returned root_cgrp won't be freed
> under us. This is given in the case of global root because it is static
> (cgrp_dfl_root.cgrp). When the root_cgrp is lower in the hierarchy, it
> is pinned by cgroup_ns->root_cset (and `current` task cannot switch
> namespace asynchronously so ns_proxy pins cgroup_ns).
>=20
> Note this reasoning won't hold for root cgroups in v1 hierarchies,
> therefore create a special-cased helper function just for the default
> hierarchy.
>=20
> Fixes: 74e4b956eb1c ("cgroup: Honor caller's cgroup NS when resolving pat=
h")
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.g=
mane.org>
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

Applied to cgroup/for-6.1-fixes w/ trivial comment / line break adjustments.

Thanks.

--=20
tejun
