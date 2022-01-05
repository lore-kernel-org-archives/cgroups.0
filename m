From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: rstat: explicitly put loop variant in while
Date: Wed, 5 Jan 2022 20:37:23 +0100
Message-ID: <20220105193723.GE6464@blackbody.suse.cz>
References: <20211225000932.7253-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641411444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5JmOpUhpXVC0+uTu4AYIod3/yPSRbR+83ed8IY4Vyq4=;
        b=ND+G8iAgFF63f4CjEqcd/k6dT/sQPOuPsEqXaF0MgKqHF+WJAsAPueoPtTj1cNyQZdPM7J
        ln/8CvZM+cVH+EBetoT14A72SixoGUFdGNcRanbyzu6x3dYgJB0zhs/KRnAHaFtd32EAXs
        YRQuj1D0ghiTT233x3WjZuXdbuSpdx8=
Content-Disposition: inline
In-Reply-To: <20211225000932.7253-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 25, 2021 at 12:09:31AM +0000, Wei Yang <richard.weiyang-Re5JQEe=
Qqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Instead of do while unconditionally, let's put the loop variant in
> while.
>=20
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gm=
ane.org>
> ---
>  kernel/cgroup/rstat.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Makes sense,
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

