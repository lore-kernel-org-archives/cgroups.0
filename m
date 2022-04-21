From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 3/4] MAINTAINERS: add corresponding kselftests to cgroup entry
Date: Thu, 21 Apr 2022 13:16:54 -0700
Message-ID: <CCF18068-862D-4774-93B8-3DA6D487B94E@linux.dev>
References: <YmGvwPIAA1LqCcku@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650572217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Krrtc5iqhLr+EB3Tf4IiuGpydLgVWU6oPUZIW+tfTdQ=;
        b=CuR9SYzh063IpeWf/1rCjN8R7huXRX0Obf7z/4w6fEfb/n2My3rNnbrcwGJt2n03OG4+0v
        p5dEVDffQwBule/5bevmW98pSlEb0pz1fPg+g/y8IukfzUSxmgW7PTnylnq3zdqYm+nl5r
        8VIEDYPdziI5Bc5i/PGuQOKNmENsQhk=
In-Reply-To: <YmGvwPIAA1LqCcku-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>


> On Apr 21, 2022, at 12:25 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>=20
> =EF=BB=BFOn Thu, Apr 14, 2022 at 05:01:32PM -0700, Roman Gushchin wrote:
>> List cgroup kselftests in the cgroup MAINTAINERS entry.
>> These are tests covering core, freezer and cgroup.kill
>> functionality.
>>=20
>> Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
>> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>=20
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> I suppose this can go with the rest through -mm? Please let me know if I
> should pick it up.

Yep, Andrew picked it up already.

Thanks!
