From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cpuset: Allow setscheduler regardless of manipulated
 task
Date: Sat, 25 Jun 2022 13:20:30 +0900
Message-ID: <YraNDoxU9IZaP3RV@mtj.duckdns.org>
References: <20220623124944.2753-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=09kC7FfVcnhB78+kO9zvMGD0GWsTE99dXTGFN0iLY20=;
        b=lywM/YVuz2jiVdYhpE1DqEg7TT9H9+k1wZz9fS2lHRyGm3YUVbPQJjGT+t2fy4104y
         NCqeFYz2ODM1tIEnpXnd9f3DF0Ml89IVYPA86PVi7A84TMgKYiDUBp/IulGgETO7JhIU
         FOz/x8e5SZL4I1d7H9TvmGzoXl6zyXeHlF9ZmD7z0/6o9p5n/PeRYUZifTNz+dXB0x4r
         43ATRPnwIJ6L4ET+59ROCF1/f8DHmnXAzaDnSMQhGYZOdS1b7OjX4SUaoO0x1V3dGMd0
         D6/0/vaHCV3s0hvFjiYaqJknoaAY/XcQ0c/RWU3v8nyDjHm+jhBUvzMAeBYopx18bff0
         yQ2A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220623124944.2753-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Thu, Jun 23, 2022 at 02:49:44PM +0200, Michal Koutn=FD wrote:
> 1) The unified hierarchy attachment behavior -- is that the
>    right/consented model that migrated objects don't matter?

Yes.

> 2) If 1) is true, have I missed any danger in allowing cpuset'ing a
>    possibly privileged processes?

Given that the someone who has write perm on the cgroup or its
ancestors are allowed to change cpuset config itself, I have a hard
time imagining that check being all that useful as a security
mechanism.

> 2.2) cpuset may be in v2 mode even on v1 hierarchy with different
>    migration control rules (but checking migratee's creds in v1
>    eliminates effect of this patch).

Yeah, it should be fine to apply the change only to v2.

> 3) Alternative approach would be to allow cpuset migrations only when
>    nothing effectively changes (which is the case for parent->child
>    migration upon controller enablement).
>=20
> 4) This is just idea draft, not tested in the real case.

Unless I'm missing something obvious, I don't see a reason to keep the
check, so please feel free to test and send a SOB'd patch.

Thanks.

--=20
tejun
