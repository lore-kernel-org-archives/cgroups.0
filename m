From: Michal Hocko <mhocko@suse.cz>
Subject: [PATCH] Makefiles: Disable unused-variable warning (was: Re: [PATCH
 1/6] memcg: fix unused variable warning)
Date: Tue, 27 Dec 2011 14:57:52 +0100
Message-ID: <20111227135752.GK5344@tiehlicka.suse.cz>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
Sender: linux-kbuild-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org

On Sat 24-12-11 05:00:14, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
>=20
> mm/memcontrol.c: In function =E2=80=98memcg_check_events=E2=80=99:
> mm/memcontrol.c:784:22: warning: unused variable =E2=80=98do_numainfo=
=E2=80=99 [-Wunused-variable]
>=20
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d643bd6..a5e92bd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -781,14 +781,15 @@ static void memcg_check_events(struct mem_cgrou=
p *memcg, struct page *page)
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> +		bool do_softlimit;
> =20
> -		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_SOFTLIMIT);
>  #if MAX_NUMNODES > 1
> +		bool do_numainfo;
>  		do_numainfo =3D mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_NUMAINFO);
>  #endif
> +		do_softlimit =3D mem_cgroup_event_ratelimit(memcg,
> +						MEM_CGROUP_TARGET_SOFTLIMIT);

I don't like this very much. Maybe we should get rid of both do_* and
do it with flags? But maybe it is not worth the additional code at
all...

Anyway, I am wondering why unused-but-set-variable is disabled while
unused-variable is enabled. Shouldn't we just disable it as well rather
than workaround this in the code? The warning is just pure noise in thi=
s
case.
What about something like:
---
=46rom e1136891fe86eacf9212b2144f80ff6b75b10194 Mon Sep 17 00:00:00 200=
1
=46rom: Michal Hocko <mhocko@suse.cz>
Date: Tue, 27 Dec 2011 14:53:06 +0100
Subject: [PATCH] Makefiles: Disable unused-variable warning

We are already disabling unused-but-set-variable and Wunused-variable
produces some noise as well.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index ea51081..25c76f3 100644
--- a/Makefile
+++ b/Makefile
@@ -578,6 +578,7 @@ endif
 # This warning generated too much noise in a regular build.
 # Use make W=3D1 to enable this warning (see scripts/Makefile.build)
 KBUILD_CFLAGS +=3D $(call cc-disable-warning, unused-but-set-variable)
+KBUILD_CFLAGS +=3D $(call cc-disable-warning, unused-variable)
=20
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+=3D -fno-omit-frame-pointer -fno-optimize-sibling-calls
--=20
1.7.7.3



--=20
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9   =20
Czech Republic
--
To unsubscribe from this list: send the line "unsubscribe linux-kbuild"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
