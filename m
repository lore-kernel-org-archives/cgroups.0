From: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: use mem_cgroup_is_root() helper
Date: Sun, 2 Oct 2022 11:45:19 +0800
Message-ID: <828C4B5A-7114-47AF-BA99-0920EA41C753@linux.dev>
References: <20220930134433.338103-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664682325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vc7/td9WozM5pVmB5K7uQM4nbJeJhzcm1HJ4XY9GakU=;
        b=lKPtg3cGoFY9Kpcu070SXiUX1GJwQaYBbfJzBQ4ZE15SZIv0jkZr0kPwUqy0BUAUPg//h5
        T9oOOROm3XM4Qi52/Z9EfdLCEUlWdP/UklihlzZf6I4ieJ2Y8BgEnxvNOnEHcyAiN5DTTA
        lEN6x8V2zTvhdvOaWB9XSVVAGJaJzTs=
In-Reply-To: <20220930134433.338103-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



> On Sep 30, 2022, at 21:44, Kamalesh Babulal =
<kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> Replace the checks for memcg is root memcg, with mem_cgroup_is_root()
> helper.
>=20
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.

