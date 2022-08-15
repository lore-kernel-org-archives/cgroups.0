From: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH linux-next] mm: memcontrol: Fix typos in comment Fix a
 spelling mistake in comment.
Date: Mon, 15 Aug 2022 14:45:27 +0800
Message-ID: <163DC765-D629-4BF5-8A3C-9146BEC6748D@linux.dev>
References: <20220815061208.65945-1-xu.panda@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660545943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qBCWO3lIwWMGpb/gijq8ucNqW63ks472vIwnDJtW+J0=;
        b=ELwW0r/CQ2nOs1I8nSNLZ9BeOE68kOpgaXhZuIZEC2ubQ/6/bFT/x1Exk3nONz4uJosbg1
        iHz9UF/cSI/z7ScjXCnupqYT7f3mQ6Rg4XjN76W1xTR3LN3OHKQQs+vW7CtYnIZXAZfdyZ
        vZ7SN2/simx1lOSk1BgnBuWRdc1dX94=
In-Reply-To: <20220815061208.65945-1-xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealic-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>



> On Aug 15, 2022, at 14:12, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>=20
> From: xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

1. Your subject seems to have redundant description.
   =E2=80=9CFix typos in comment=E2=80=9D vs =E2=80=9CFix a spelling =
mistake in comment"
2. It is better to clarify what you have changed here. Like:

Fix a spelling mistake on =E2=80=9Ccgruop1=E2=80=9D.

With this:

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.=
