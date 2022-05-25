From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v3 2/5] selftests: memcg: Expect no low events in
 unprotected sibling
Date: Tue, 24 May 2022 19:27:14 -0700
Message-ID: <Yo2UArXnJ3YsVicX@carbon>
References: <20220524162955.8635-1-mkoutny@suse.com>
 <20220524162955.8635-3-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653445639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x4066BGZ8t4evPhN+kvOPiP4ga7qn2RnpU+mzq2WHHA=;
        b=ExVRcGzrJWaKWhcD0ImJnXvrBDLjziAH68cY6nCdV5SjH+A2LeFR9fbfB8Eays4nF1EQfj
        lCPNnubliAFrIL/aBIrdvLa3jrFmO3f/Dt20FvV6NnMy84+E8syKARZcAIapqXIkbzwdQs
        /LChnQJ04QdOtK4KdVJWAh9tCQR8JJU=
Content-Disposition: inline
In-Reply-To: <20220524162955.8635-3-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>, Muhammad Usama Anjum <usama.anjum-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>

On Tue, May 24, 2022 at 06:29:52PM +0200, Michal Koutny wrote:
> This is effectively a revert of commit cdc69458a5f3 ("cgroup: account
> for memory_recursiveprot in test_memcg_low()"). The case test_memcg_low
> will fail with memory_recursiveprot until resolved in reclaim
> code.
> However, this patch preserves the existing helpers and variables for
> later uses.
>=20
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Reviewed-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gman=
e.org>
