From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] misc_cgroup: use a counter to count the number of
 failures
Date: Tue, 24 Aug 2021 09:08:49 -1000
Message-ID: <YSVDwc/1sEmXdOK9@slm.duckdns.org>
References: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu@tencent.com>
 <20210824164423.GA11859@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5v85tm4s0OVyrps1zXJuM/Q2kA3ef4+GfrXQL7ocGJo=;
        b=eTWbKzVS+hWBZeRV4rxr+xSLbNZizV0nGboZUx/ayYMgYbiorgrctYYHDhadFmbZ6j
         ta27nCsuAXS45M4Hjepp5eNSlYePNL+isUtTNjkiqXEh72tx089E1GZEtyuXb7SCM2Q5
         iVPQr9ONqTQ7ApxFfWgeXjYx0NiXkgad2MW2TFs4lglI00xLqY+sB/hjQ2MlZyXvIK7e
         61noAFQP4Cy8YqlDhsSx/O5BE2hxojhA5vib+QI4CX5QKb/cMgQzoytSSc500sHAiUzE
         gQj+df8XIAWM0EcfJNj7vYwD3sD4xEaA3KHZiaR9RujEAW+GdI/lK0RW+bpGaPl/FiV6
         qhvQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210824164423.GA11859-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Aug 24, 2021 at 06:44:23PM +0200, Michal Koutn=FD wrote:
> However, the non-hierarchical failcnt interface looks like v1ism to me
> (I think new features should come with v2 first in mind).
> What about exposing this in misc.events file with max.$res_name entries? =


Ah yeah, good point. misc.events sounds like a good spot to put these.

> Or if the hierarchical reporting is unnecessary now, there can be just
> misc.events.local for starters.

I'd prefer to stick with hierarchical counting as the first step at least.

> (That reminds me the forgotten pids.events[.local] rework [1], oops.)
>=20
> https://lore.kernel.org/lkml/20191128172612.10259-1-mkoutny-IBi9RG/b67k@p=
ublic.gmane.org/#t

I think both counters are useful - the number of failures due to this type
of limit in this subhierarchy, and the number of failures caused by this
particular limit in this subhierarchy. It's a pretty subtle difference to
encapsulate in a counter name tho.

Thanks.

--=20
tejun
