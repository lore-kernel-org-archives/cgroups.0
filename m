From: Muhammad Usama Anjum <usama.anjum-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH v2 1/5] selftests: memcg: Fix compilation
Date: Sat, 21 May 2022 19:11:01 +0500
Message-ID: <5242b7ab-d6b6-55d4-c211-ec27293be795@collabora.com>
References: <20220518161859.21565-1-mkoutny@suse.com>
 <20220518161859.21565-2-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1653142268;
        bh=RDsDMjrHSRLHyJKnvADs831SvV0UdrfBeeTlvj8a10A=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=gEIIZW9x52qLWyJAJicELkBZ/pVegfBArBv1xXiTVsC4HCzRLC1XXaWVd75WtBwtE
         28l2Qg/rQMHz7tSmEadoaq0lJGVgkJZZ3d0LutBOEuwX1FujikjEguKbjHuU2XVoX2
         1ZgZvvVaZMZI4sWLrm1iEi+g99YJb6qzve7plDCT+Ppga9Bdy/O1N+rfUTMWenvg2Z
         gG4lgrMoKwTAEP1o7InyvQi/muAeAxKrVgEHJWAuk+/2V7Q54i/r7m/bLji+OY7aNV
         Aq9+K4ABKOjBGWHileB2ERmD7Y/XqHVHmWcGWs5KwNyWFtfEcIHS4J/y1HB9ayyk79
         lDkqcP/S2R9yg==
Content-Language: en-US
In-Reply-To: <20220518161859.21565-2-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: usama.anjum-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On 5/18/22 9:18 PM, Michal Koutn=C3=BD wrote:
> This fixes mis-applied changes from commit 72b1e03aa725 ("cgroup:
> account for memory_localevents in test_memcg_oom_group_leaf_events()").
Shouldn't the Fixes tag be added here and in 2/5 patch?

--=20
Muhammad Usama Anjum
