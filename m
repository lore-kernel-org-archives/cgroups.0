From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Wed, 15 Apr 2020 12:17:53 +0200
Message-ID: <20200415121753.3c8d700b@hemera.lan.sysophe.eu>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
        <20200409094615.GE18386@dhcp22.suse.cz>
        <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
        <20200409103400.GF18386@dhcp22.suse.cz>
        <20200409170926.182354c3@hemera.lan.sysophe.eu>
        <20200409152540.GP18386@dhcp22.suse.cz>
        <20200410091525.287062fa@hemera.lan.sysophe.eu>
        <20200410104343.5bcde519@hemera.lan.sysophe.eu>
        <20200410115010.1d9f6a3f@hemera.lan.sysophe.eu>
        <20200414163134.GQ4629@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200414163134.GQ4629-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Michal,

On Tue, 14 Apr 2020 18:31:34 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@pu=
blic.gmane.org> wrote:
> On Fri 10-04-20 11:50:10, Bruno Pr=C3=A9mont wrote:
> > Hi Michal, Chris,
> >=20
> > Sending ephemeral link to (now properly) captured cgroup details off-li=
st.

Re-adding the list and other readers.

> > It contains:
> >   snapshots of the cgroup contents at 1s interval
> > backup was running through the full captured period.
> >=20
> > You can see memory.max changes at
> >   26-21  (to high + 128M)
> > and
> >   30-24  (back to high) =20
>=20
> OK, so you have started with high =3D max and do not see any stalls. As
> soon as you activate the high limit reclaim by increasing the max limit
> you get your stalls because those tasks are put into sleep. There are
> only 3 tasks in the cgroup and it seems to be shell, tar and some
> subshell or is there anything else that could charge any memory?

On production system it's just backup software (3-4 processes)

On basic reproducer it's bash, tar and tar's gzip subprocess.

> Let's just focus on the time prior to switch and after
> * prior
> $ for i in $(seq -w 21); do cat 26-$i/memory.current ; done | calc_min_ma=
x.awk
> min: 2371895296.00 max: 2415874048.00 avg: 2404059136.00 std: 13469809.78=
 nr: 20
>=20
> high =3D hard limit =3D 2415919104
>=20
> * after
> $ for i in $(seq -w 22 59); do cat 26-$i/memory.current ; done | calc_min=
_max.awk
> min: 2409172992.00 max: 2415828992.00 avg: 2415420793.26 std: 1475181.24 =
nr: 38
>=20
> high limit =3D 2415919104
> hard limit =3D 2550136832
>=20
> Nothing interesting here. The charged memory stays below the high limit.
> This might be a matter of timing of course because your snapshot might
> hit the window when the situation was ok. But 90K is a larger margin
> than I would expect in such a case.
>=20
> $ cat 27-*/memory.current | calc_min_max.awk=20
> min: 2408161280.00 max: 2415910912.00 avg: 2415709583.19 std: 993983.28 n=
r: 59
>=20
> Still under the high limit but closer 8K so this looks much more like
> seeing high limit reclaim in action.
>=20
> $ cat 28-*/memory.current | calc_min_max.awk
> min: 2409123840.00 max: 2415910912.00 avg: 2415633019.59 std: 870311.11 n=
r: 58
>=20
> same here.
>=20
> $ cat 29-*/memory.current | calc_min_max.awk
> min: 2400464896.00 max: 2415828992.00 avg: 2414819015.59 std: 3133978.89 =
nr: 59
>=20
> quite below high limit.
>=20
> So I do not see any large high limit excess here but it could be a
> matter of timing as mentioned above. Let's have a look at the reclaim
> activity.
>=20
> 27-00/memory.stat:pgscan 82811883
> 27-00/memory.stat:pgsteal 80223813
> 27-01/memory.stat:pgscan 82811883
> 27-01/memory.stat:pgsteal 80223813
>=20
> No scanning=20
>=20
> 27-02/memory.stat:pgscan 82811947
> 27-02/memory.stat:pgsteal 80223877
>=20
> 64 pages scanned and reclaimed
>=20
> 27-03/memory.stat:pgscan 82811947
> 27-03/memory.stat:pgsteal 80223877
> 27-04/memory.stat:pgscan 82811947
> 27-04/memory.stat:pgsteal 80223877
> 27-05/memory.stat:pgscan 82811947
> 27-05/memory.stat:pgsteal 80223877
>=20
> No scanning
>=20
> 27-06/memory.stat:pgscan 82812011
> 27-06/memory.stat:pgsteal 80223941
>=20
> 64 pages scanned and reclaimed
>=20
> 27-07/memory.stat:pgscan 82812011
> 27-07/memory.stat:pgsteal 80223941
> 27-08/memory.stat:pgscan 82812011
> 27-08/memory.stat:pgsteal 80223941
> 27-09/memory.stat:pgscan 82812011
> 27-09/memory.stat:pgsteal 80223941
>=20
> No scanning
>=20
> 27-11/memory.stat:pgscan 82812075
> 27-11/memory.stat:pgsteal 80224005
>=20
> 64 pages scanned
>=20
> 27-12/memory.stat:pgscan 82812075
> 27-12/memory.stat:pgsteal 80224005
> 27-13/memory.stat:pgscan 82812075
> 27-13/memory.stat:pgsteal 80224005
> 27-14/memory.stat:pgscan 82812075
> 27-14/memory.stat:pgsteal 80224005
>=20
> No scanning. etc...
>=20
> So it seems there were two rounds of scanning (we usually do 32pages per
> batch and the reclaim was really effective at reclaiming that memory but
> then the task is put into sleep for 2-3s. This is quite unexpected
> because collected stats do not show the high limit excess during the
> sleeping time.
>=20
> It would be interesting to see more detailed information on the
> throttling itself. Which kernel version are you testing this on?
> 5.6+ kernel needs http://lkml.kernel.org/r/20200331152424.GA1019937-6Bi15=
50iOqEnzZ6mRAm98g@public.gmane.org
> but please note that e26733e0d0ec ("mm, memcg: throttle allocators based
> on ancestral memory.high") has been marked for stable so 5.4+ kernels
> might have it as well and you would need the same fix for them as well.
> I wouldn't be really surprised if this was the actual problem that you
> are hitting because the reclaim could simply made usage < high and the
> math in calculate_high_delay doesn't work properly.

I'm on 5.6.2. Seems neither e26733e0d0ec nor the fix hit 5.6.2 (nor
current 5.6.4).

> Anyway the following simply tracing patch should give a better clue.
> The output will appear in the trace buffer (mount tracefs and read
> trace_pipe file).

This is the output I get on 5.6.4 with simple tar -zc call (max=3Dhigh+4096=
):
  tar-16943 [000] ....  1098.796955: mem_cgroup_handle_over_high: memcg_nr_=
pages_over_high:1 penalty_jiffies:200 current:262122 high:262144
  tar-16943 [000] ....  1100.876794: mem_cgroup_handle_over_high: memcg_nr_=
pages_over_high:1 penalty_jiffies:200 current:262122 high:262144
  tar-16943 [000] ....  1102.956636: mem_cgroup_handle_over_high: memcg_nr_=
pages_over_high:1 penalty_jiffies:200 current:262120 high:262144
  tar-16943 [000] ....  1105.037388: mem_cgroup_handle_over_high: memcg_nr_=
pages_over_high:1 penalty_jiffies:200 current:262121 high:262144
  tar-16943 [000] ....  1107.117246: mem_cgroup_handle_over_high: memcg_nr_=
pages_over_high:1 penalty_jiffies:200 current:262122 high:262144

With 5.7-rc1 it runs just fine, pressure remains zero and no output in trac=
e_pipe or throttling.

So the fixes that went in there do fix it.
Now matter of cherry-picking the right ones... e26733e0d0ec and its fixe's =
fix,
maybe some others (will start with those tagged for stable).


Thanks,
Bruno

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 05b4ec2c6499..dcee3030309d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2417,6 +2417,10 @@ void mem_cgroup_handle_over_high(void)
>  	if (penalty_jiffies <=3D HZ / 100)
>  		goto out;
> =20
> +	trace_printk("memcg_nr_pages_over_high:%d penalty_jiffies:%ld current:%=
lu high:%lu\n",
> +			nr_pages, penalty_jiffies,
> +			page_counter_read(&memcg->memory), READ_ONCE(memcg->high));
> +
>  	/*
>  	 * If we exit early, we're guaranteed to die (since
>  	 * schedule_timeout_killable sets TASK_KILLABLE). This means we don't

