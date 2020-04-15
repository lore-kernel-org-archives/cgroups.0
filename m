From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Wed, 15 Apr 2020 12:24:42 +0200
Message-ID: <20200415102442.GE4629@dhcp22.suse.cz>
References: <20200409094615.GE18386@dhcp22.suse.cz>
 <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
 <20200409103400.GF18386@dhcp22.suse.cz>
 <20200409170926.182354c3@hemera.lan.sysophe.eu>
 <20200409152540.GP18386@dhcp22.suse.cz>
 <20200410091525.287062fa@hemera.lan.sysophe.eu>
 <20200410104343.5bcde519@hemera.lan.sysophe.eu>
 <20200410115010.1d9f6a3f@hemera.lan.sysophe.eu>
 <20200414163134.GQ4629@dhcp22.suse.cz>
 <20200415121753.3c8d700b@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200415121753.3c8d700b-pDZhbqX7CfkoGc32E1+a2S4z1YicLaQ4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 15-04-20 12:17:53, Bruno Pr=E9mont wrote:
[...]
> > Anyway the following simply tracing patch should give a better clue.
> > The output will appear in the trace buffer (mount tracefs and read
> > trace_pipe file).
>=20
> This is the output I get on 5.6.4 with simple tar -zc call (max=3Dhigh+40=
96):
>   tar-16943 [000] ....  1098.796955: mem_cgroup_handle_over_high: memcg_n=
r_pages_over_high:1 penalty_jiffies:200 current:262122 high:262144
>   tar-16943 [000] ....  1100.876794: mem_cgroup_handle_over_high: memcg_n=
r_pages_over_high:1 penalty_jiffies:200 current:262122 high:262144
>   tar-16943 [000] ....  1102.956636: mem_cgroup_handle_over_high: memcg_n=
r_pages_over_high:1 penalty_jiffies:200 current:262120 high:262144
>   tar-16943 [000] ....  1105.037388: mem_cgroup_handle_over_high: memcg_n=
r_pages_over_high:1 penalty_jiffies:200 current:262121 high:262144
>   tar-16943 [000] ....  1107.117246: mem_cgroup_handle_over_high: memcg_n=
r_pages_over_high:1 penalty_jiffies:200 current:262122 high:262144

OK, that points to the underflow fix.

>=20
> With 5.7-rc1 it runs just fine, pressure remains zero and no output in tr=
ace_pipe or throttling.
>=20
> So the fixes that went in there do fix it.
> Now matter of cherry-picking the right ones... e26733e0d0ec and its fixe'=
s fix,
> maybe some others (will start with those tagged for stable).

I have seen Greg picking up this for stable trees so it should show up
there soon.

Thanks!
--=20
Michal Hocko
SUSE Labs
