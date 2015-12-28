From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Fix uninitialized variable warning
Date: Mon, 28 Dec 2015 10:45:03 -0500
Message-ID: <20151228154503.GP5003@mtj.duckdns.org>
References: <1450907607-5060-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=KuoEu0TukXvAcjvh5mMnVQvrXsUCl0bvQWCYT+EhHSw=;
        b=ZokVd2SmatVQgg2DnlGjidVIIB+dUv79WGmPnzcOy8DFYsRGl5rfGAdrZD0ilfTZYA
         zNvd9tliztodehhNdLAt7Az879FKJmNOBeCY9lrcL9ROcF/kBGBDGWoyrsnylshkNoIj
         dVN0qO6KzmQmjOw/fw3afLmp/QGhCXrwR/r0CiI9r9RfDvchD6Fz2sWFy6bJVfQoMOJM
         oksty/6cus7s0q5mvqsMQXYMP+a/dT0PbfFIROeyfYK23fM+34cHNmQUh/68RGsd15xH
         1vns+IDB8Nt1Qv5YOPmgcvP25I3l2CTXcGqCKtRrsWjYqEOHE+VaJu704DKqgoyDfza9
         grVQ==
Content-Disposition: inline
In-Reply-To: <1450907607-5060-1-git-send-email-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Wed, Dec 23, 2015 at 02:53:27PM -0700, Ross Zwisler wrote:
> Commit 1f7dd3e5a6e4 ("cgroup: fix handling of multi-destination migra=
tion
> from subtree_control enabling") introduced the following compiler war=
ning:
>=20
> mm/memcontrol.c: In function =E2=80=98mem_cgroup_can_attach=E2=80=99:
> mm/memcontrol.c:4790:9: warning: =E2=80=98memcg=E2=80=99 may be used =
uninitialized in this function [-Wmaybe-uninitialized]
>    mc.to =3D memcg;
>          ^
>=20
> Fix this by initializing 'memcg' to NULL.
>=20
> This was found using gcc (GCC) 4.9.2 20150212 (Red Hat 4.9.2-6).
>=20
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Applied to cgroup/for-4.5.

Thanks.

--=20
tejun
