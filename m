From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: low memory killer
Date: Thu, 20 Nov 2014 10:58:02 +0100
Message-ID: <20141120095802.GA24575@dhcp22.suse.cz>
References: <AF7C0ADF1FEABA4DABABB97411952A2EC91E38@CN-MBX02.HTC.COM.TW>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AF7C0ADF1FEABA4DABABB97411952A2EC91E38-8rVIvgdQJd9DHKQVdE8rcdo2gmyxIgCH@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: zhiyuan_zhu-TYsT/PRPW1c@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Future_Zhou-TYsT/PRPW1c@public.gmane.org, Rachel_Zhang-TYsT/PRPW1c@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>

[Adding Greg to CC as the current maintainer of the staging and droppin=
g
majordomo]

I am not Johannes but,

On Thu 20-11-14 09:26:05, zhiyuan_zhu-TYsT/PRPW1c@public.gmane.org wrote:
> hi Johannes
>=20
> My name is Zhiyuan zhu, an android development engineer in htc.
> We encounter a lowmemorykiller=E2=80=99s problem.
> Coluld you help to kindly support? Thank you.

Please note that lowmemory killer is not part of Memory cgroup resource
controller. It is a staging driver which is supposed to be supported by
support by Android people. I am not sure about the current state but th=
e
implementation and some concepts used to be broken in many ways.
Anyway I think the driver should be dropped from the tree or try to get
promoted to the regular tree _after_ it passes a proper review.
=20
> Problem describtion:
> We noticed that gap of dumping cached value from =E2=80=9Clowmemoryki=
ller=E2=80=9D
> and =E2=80=9C/proc/meminfo/=E2=80=9D are different apparently. Like e=
xample below,
> lowmemorykiller showed cache only has 72460kB while launcher was
> killed, but /proc/meminfo showed cached still has 142448kB. Please
> check why the gap of cache value between lowmemorykill and
> /proc/meminfo are huge.

lowmem_scan prints:
other_file =3D global_page_state(NR_FILE_PAGES) - global_page_state(NR_=
SHMEM) - total_swapcache_pages();

as per meminfo_proc_show(), Cached value corresponds to:
        cached =3D global_page_state(NR_FILE_PAGES) - total_swapcache_p=
ages() - i.bufferram;

So those two values are quite different. E.g. lowmem killer ignores
shmem pages. This can be considerable amount of memory.

> kernel_e0058_0001_20141107_204711_LC4ABYA00200_htc_a31ul_0.54.999.1.t=
xt at LC4ABYA00200
>         6      161030.084144       2014-11-07 21:44:53.304        low=
memorykiller: Killing 'om.htc.launcher' (4486), adj 294,
> 6      161030.084144       2014-11-07 21:44:53.304           to free =
47856kB on behalf of 'kworker/u8:14' (20594) because
> 6      161030.084144       2014-11-07 21:44:53.304           cache 72=
460kB is below limit 73728kB for oom_score_adj 235
> 6      161030.084144       2014-11-07 21:44:53.304           Free mem=
ory is 51304kB above reserved
> 4      161030.084797       2014-11-07 21:44:53.304        MemFree:   =
        55676 kB
> 4      161030.084797       2014-11-07 21:44:53.304        Buffers:   =
         1240 kB
> 4      161030.084797       2014-11-07 21:44:53.304        Cached:    =
       142448 kB

I do not see any code in drivers/staging/android/lowmemorykiller.c that
would print such an information in the current tree.

> Lowmemorykiller calculated cache value is 72460kB, but the
> /proc/meminfo=E2=80=99s cached is 142448 kB
>=20
> After checked the code, I found that:
> Lowmemorykiller=E2=80=99s memory information is comes from /proc/zone=
info
> file=E2=80=99s nr_file_pages So I want to know how different the
> /proc/zoneinfo file=E2=80=99s nr_file_pages and /proc/meminfo file=E2=
=80=99s
> Cached ?

See the above.

--=20
Michal Hocko
SUSE Labs
