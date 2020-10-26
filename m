From: Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat
Date: Mon, 26 Oct 2020 20:24:50 +0000
Message-ID: <2A2CE07F-47DC-4B3B-82D3-F0CDD2C58B42@fb.com>
References: <20201022151844.489337-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SvtcLkE2YtFXPGaJJQrYm7/DO4OiLJiMHt9yRv60gtQ=;
 b=ZHkAB+z5qwRq7unhKO+/ZmmBK1Yo+hOmSxFViWHGvtly2wiC5ZQuzqC1/nIbyUNzenm3
 +7BLHpzd6pc4qSfPrwKFJHYR51FzEUMP07VcOR193pbBzeOoJHK9TpH8UFYpVSOke21+
 UJZsTz++jOhBCu6uvxMxG/lkcKTfDffqiDs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvtcLkE2YtFXPGaJJQrYm7/DO4OiLJiMHt9yRv60gtQ=;
 b=ZflQG0lll+zLtSCF1ub+laQVXcYsa85bpojrx1oz68eos6X5bQKj9VwFM4GMwmm9RIKIqkQ3pr6LEtvILa65CCi2GfA3ZZ2CHnfsL2P7qIAVPtvYyqZZzhrr59710YPCKuHkctj3k+nsVd/0k0H2tVJTBosyEKqOACFKu77Jqes=
In-Reply-To: <20201022151844.489337-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
Content-ID: <4BC5D6CB40312340849799477F37C04A-JGF9Izt3QrScE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <Kernel-team-b10kYP2dOMg@public.gmane.org>



> On Oct 22, 2020, at 8:18 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>=20
> As huge page usage in the page cache and for shmem files proliferates
> in our production environment, the performance monitoring team has
> asked for per-cgroup stats on those pages.
>=20
> We already track and export anon_thp per cgroup. We already track file
> THP and shmem THP per node, so making them per-cgroup is only a matter
> of switching from node to lruvec counters. All callsites are in places
> where the pages are charged and locked, so page->memcg is stable.
>=20
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>

Thanks!
