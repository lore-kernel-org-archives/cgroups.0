From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: Export memcg->watermark via sysfs for
 v2 memcg
Date: Wed, 11 May 2022 19:49:54 +0200
Message-ID: <20220511174953.GC31592@blackbody.suse.cz>
References: <20220507050916.GA13577@us192.sjc.aristanetworks.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652291395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hybTl5KXVmOatuBKIZ1j2DSZPawKaxXgyyz91XdUDuE=;
        b=G2bilHY0B/+vLx83jRgBB8ceum/Xr8F2UCoGFzvV/mo+XEiTGAAMpYAd2AhTxSY08pdrPp
        U4m58yO/rWjGFseMxnSsTzChDwtKo1EgEw2EgP72eymTewrYpBFvVPE7f1l89TA5jchVXT
        1HvBpkMoA9W/gjRqjz5I3aT3F035XDE=
Content-Disposition: inline
In-Reply-To: <20220507050916.GA13577-pF7uKtACKh3GmWBmRUYTj5O0Dwfk+90YVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi.

On Fri, May 06, 2022 at 10:09:16PM -0700, Ganesan Rajagopal <rganesan-nzgTg=
zXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
> We run a lot of automated tests when building our software and run into
> OOM scenarios when the tests run unbounded. v1 memcg exports
> memcg->watermark as "memory.max_usage_in_bytes" in sysfs. We use this
> metric to heuristically limit the number of tests that can run in
> parallel based on per test historical data.
>=20
> This metric is currently not exported for v2 memcg and there is no
> other easy way of getting this information. getrusage() syscall returns
> "ru_maxrss" which can be used as an approximation but that's the max
> RSS of a single child process across all children instead of the
> aggregated max for all child processes. The only work around is to
> periodically poll "memory.current" but that's not practical for
> short-lived one-off cgroups.
>=20
> Hence, expose memcg->watermark as "memory.peak" for v2 memcg.

It'll save some future indirections if the commit messages includes the
argument about multiple readers and purposeful irresetability.

>=20
> Signed-off-by: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.=
gmane.org>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
>  mm/memcontrol.c                         | 13 +++++++++++++
>  2 files changed, 20 insertions(+)

Besides that it looks useful and correct, feel free to add
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
