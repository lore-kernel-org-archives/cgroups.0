From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: fix NULL pointer dereference in
 __mem_cgroup_usage_unregister_event
Date: Thu, 5 Mar 2020 10:24:47 +0100
Message-ID: <20200305092447.GQ16139@dhcp22.suse.cz>
References: <5ee35fe7-2a90-ae71-9100-3f2833cbf252@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5ee35fe7-2a90-ae71-9100-3f2833cbf252-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thank you for the report!

On Thu 05-03-20 13:52:03, brookxu wrote:
> One eventfd monitors multiple memory thresholds of cgroup, closing it, the
> system will delete related events. Before all events are deleted, another
> eventfd monitors the cgroup's memory threshold.

Could you describe the race scenario please? Ideally=20
>=20
> As a result, thresholds->primary[] is not empty, but thresholds->sparse[]
> is NULL, __mem_cgroup_usage_unregister_event() leading to a crash:
>=20
> [=A0 138.925809] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000004
> [=A0 138.926817] IP: [<ffffffff8116c9b7>] mem_cgroup_usage_unregister_eve=
nt+0xd7/0x1f0
> [=A0 138.927701] PGD 73bce067 PUD 76ff3067 PMD 0
> [=A0 138.928384] Oops: 0002 [#1] SMP
> [=A0 138.935218] CPU: 1 PID: 14 Comm: kworker/1:0 Not tainted 3.10.107-1-=
tlinux2-0047 #1

Also you seem to be running a very old kernel. Does the problem exist in
the current Vanilla kernel?
--=20
Michal Hocko
SUSE Labs
