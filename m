From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2 4/5] selftests: memcg: Remove protection from top
 level memcg
Date: Wed, 18 May 2022 12:10:49 -0700
Message-ID: <YoVEuWwZACdfkEvF@carbon>
References: <20220518161859.21565-1-mkoutny@suse.com>
 <20220518161859.21565-5-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652901055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s+1S5oiqjwIZadYELmF2S/BTaDdI1LCNsMORIY21/xg=;
        b=r9WbttEwBv0H0Qu6kTFvKCuCzlTF2MayFPQ9OU3u+xq+tDhrrx0fqd5OCFasXFBZr0cVGG
        qaiN44KqD2ppXQVz4W15Y41FAlxyhv1zK0WR6L8x0EIHsTTmNQuAEUwAdPo8K4QYJ9+x9+
        QT8ltuHoGR95v/HO9gC4YFFD91XV+Ws=
Content-Disposition: inline
In-Reply-To: <20220518161859.21565-5-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

On Wed, May 18, 2022 at 06:18:58PM +0200, Michal Koutny wrote:
> The reclaim is triggered by memory limit in a subtree, therefore the
> testcase does not need configured protection against external reclaim.
>=20
> Also, correct respective comments
>=20
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gman=
e.org>
