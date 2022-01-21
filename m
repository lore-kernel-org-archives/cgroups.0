From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and
 cpu hotplug
Date: Fri, 21 Jan 2022 16:57:05 +0100
Message-ID: <20220121155705.GA2394@blackbody.suse.cz>
References: <20220121101210.84926-1-zhangqiao22@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642780626; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iC6HlJNGkj7g2fm9s+Lr372ZTXnke169KUBr6T9jAO8=;
        b=ZNv1nepTtadpjK+r7+JhnENvQ6TcqTpdwfnTtrIiHTVFtTqy4jVVmzuSRhdWIUpSZSa8aA
        +4PPzQVCBYGQ/Eate+TkuHoSkREYhXKdrjqDMHkAvQWcvteVPpx0svJ2Zj40GDAwoytb8k
        MBO/d/1QMWW39ZUAiejRHNbYnRApeao=
Content-Disposition: inline
In-Reply-To: <20220121101210.84926-1-zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, bblum-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Jan 21, 2022 at 06:12:10PM +0800, Zhang Qiao <zhangqiao22-hv44wF8Li=
93QT0dZR+AlfA@public.gmane.org> wrote:
> Fixes: be367d099270 ("cgroups: let ss->can_attach and ss->attach do whole=
 threadgroups at a time")

What a deep stratigraphy (not sure if it's this one but anything else
would likely come from eras ago too).

> Reported-by: Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.=
org>
> Signed-off-by: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gman=
e.org>
> ---
>  kernel/cgroup/cpuset.c | 2 ++
>  1 file changed, 2 insertions(+)

Feel free to include
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

