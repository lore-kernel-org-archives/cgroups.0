From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/5] cgroup: Account for memory_recursiveprot in
 test_memcg_low()
Date: Wed, 11 May 2022 13:53:05 -0400
Message-ID: <Ynv4AdjeVjptnjrH@cmpxchg.org>
References: <20220423155619.3669555-1-void@manifault.com>
 <20220423155619.3669555-3-void@manifault.com>
 <20220427140928.GD9823@blackbody.suse.cz>
 <20220429010333.5rt2jwpiumnbuapf@dev0025.ash9.facebook.com>
 <20220429092620.GA23621@blackbody.suse.cz>
 <20220506164015.fsdsuv226nhllos5@dev0025.ash9.facebook.com>
 <Ynkum8DeJIAtGi9y@cmpxchg.org>
 <20220509174424.e43e695ffe0f7333c187fba8@linux-foundation.org>
 <20220510174341.GC24172@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+98S328gIXASjWyIOnT/blA4Tt4P6OykWVYnviKs3ME=;
        b=ZdCacF6byBtXl0QQmIVcjdBoxeabZgc7+C/W2V36nSNHaMGPgCqRtaTvGz6pJBRZow
         iblsDw9rPzOZJH00cABZEDopiWvSeJIFXA7B6daZ038Ke4gPcoy+14pjwEKB8l9WOdk2
         r22vYuPanMwnpackRyxW8GWj08pIuMQlFcJyBYnVFdw4GmG9s1dslt7Igfa9SzYVHoyn
         h4qjQE4G07yKMl0JjI3iY7EUCMUkFG1IHeT6azlmb0L53M8Y/katJirJbyC74MrmXVsY
         Sk8boCp6GYKLKRZUT1BdYQVu6Yy5uWLMBFWqw508lYzne1rA3Cewns5YAGuxR9CWY6yb
         Ol1w==
Content-Disposition: inline
In-Reply-To: <20220510174341.GC24172-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Richard Palethorpe <rpalethorpe-IBi9RG/b67k@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

Hi Michal,

On Tue, May 10, 2022 at 07:43:41PM +0200, Michal Koutn=FD wrote:
> On Mon, May 09, 2022 at 05:44:24PM -0700, Andrew Morton <akpm-de/tnXTf+JL=
sfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > So I think we're OK with [2/5] now.  Unless there be objections, I'll
> > be looking to get this series into mm-stable later this week.
>=20
> I'm sorry, I think the current form of the test reveals an unexpected
> behavior of reclaim and silencing the test is not the way to go.
> Although, I may be convinced that my understanding is wrong.

Looking through your demo results again, I agree with you. It's a tiny
error, but it compounds and systematically robs the protected group
over and over, to the point where its protection becomes worthless -
at least in idle groups, which isn't super common but does happen.

Let's keep the test as-is and fix reclaim to make it pass ;)

> The obvious fix is at the end of this message, it resolves the case I
> posted earlier (with memory_recursiveprot), however, it "breaks"
> memory.events:low accounting inside recursive children, hence I'm not
> considering it finished. (I may elaborate on the breaking case if
> interested, I also need to look more into that myself).

Can you indeed elaborate on the problem you see with low events?

> @@ -2798,13 +2798,6 @@ static void get_scan_count(struct lruvec *lruvec, =
struct scan_control *sc,
> =20
>  			scan =3D lruvec_size - lruvec_size * protection /
>  				(cgroup_size + 1);
> -
> -			/*
> -			 * Minimally target SWAP_CLUSTER_MAX pages to keep
> -			 * reclaim moving forwards, avoiding decrementing
> -			 * sc->priority further than desirable.
> -			 */
> -			scan =3D max(scan, SWAP_CLUSTER_MAX);

IIRC this was added due to premature OOMs in synthetic testing (Chris
may remember more details).

However, in practice it wasn't enough anyway, and was followed up by
f56ce412a59d ("mm: memcontrol: fix occasional OOMs due to proportional
memory.low reclaim"). Now, reclaim retries the whole cycle if
proportional protection was in place and it didn't manage to make
progress. The rounding for progress doesn't seem to matter anymore.

So your proposed patch looks like the right thing to do to me. And I
would ack it, but please do explain your concerns around low event
reporting after it.

Thanks!
