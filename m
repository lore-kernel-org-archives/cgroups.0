From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2] memcg: fix NULL pointer dereference in
 __mem_cgroup_usage_unregister_event
Date: Tue, 10 Mar 2020 10:48:36 +0100
Message-ID: <20200310094836.GD8447@dhcp22.suse.cz>
References: <077a6f67-aefa-4591-efec-f2f3af2b0b02@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <077a6f67-aefa-4591-efec-f2f3af2b0b02-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[Cc Kirill, I didn't realize he has implemented this code]

On Fri 06-03-20 09:02:02, brookxu wrote:
> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>=20
> An eventfd monitors multiple memory thresholds of the cgroup, closes them,
> the kernel deletes all events related to this eventfd. Before all events
> are deleted, another eventfd monitors the memory threshold of this cgroup,
> leading to a crash:
>=20
> [=A0 135.675108] BUG: kernel NULL pointer dereference, address: 000000000=
0000004
> [=A0 135.675350] #PF: supervisor write access in kernel mode
> [=A0 135.675579] #PF: error_code(0x0002) - not-present page
> [=A0 135.675816] PGD 800000033058e067 P4D 800000033058e067 PUD 3355ce067 =
PMD 0
> [=A0 135.676080] Oops: 0002 [#1] SMP PTI
> [=A0 135.676332] CPU: 2 PID: 14012 Comm: kworker/2:6 Kdump: loaded Not ta=
inted 5.6.0-rc4 #3
> [=A0 135.676610] Hardware name: LENOVO 20AWS01K00/20AWS01K00, BIOS GLET70=
WW (2.24 ) 05/21/2014
> [=A0 135.676909] Workqueue: events memcg_event_remove
> [=A0 135.677192] RIP: 0010:__mem_cgroup_usage_unregister_event+0xb3/0x190
> [=A0 135.677825] RSP: 0018:ffffb47e01c4fe18 EFLAGS: 00010202
> [=A0 135.678186] RAX: 0000000000000001 RBX: ffff8bb223a8a000 RCX: 0000000=
000000001
> [=A0 135.678548] RDX: 0000000000000001 RSI: ffff8bb22fb83540 RDI: 0000000=
000000001
> [=A0 135.678912] RBP: ffffb47e01c4fe48 R08: 0000000000000000 R09: 0000000=
000000010
> [=A0 135.679287] R10: 000000000000000c R11: 071c71c71c71c71c R12: ffff8bb=
226aba880
> [=A0 135.679670] R13: ffff8bb223a8a480 R14: 0000000000000000 R15: 0000000=
000000000
> [=A0 135.680066] FS:=A0 0000000000000000(0000) GS:ffff8bb242680000(0000) =
knlGS:0000000000000000
> [=A0 135.680475] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [=A0 135.680894] CR2: 0000000000000004 CR3: 000000032c29c003 CR4: 0000000=
0001606e0
> [=A0 135.681325] Call Trace:
> [=A0 135.681763]=A0 memcg_event_remove+0x32/0x90
> [=A0 135.682209]=A0 process_one_work+0x172/0x380
> [=A0 135.682657]=A0 worker_thread+0x49/0x3f0
> [=A0 135.683111]=A0 kthread+0xf8/0x130
> [=A0 135.683570]=A0 ? max_active_store+0x80/0x80
> [=A0 135.684034]=A0 ? kthread_bind+0x10/0x10
> [=A0 135.684506]=A0 ret_from_fork+0x35/0x40
> [=A0 135.689733] CR2: 0000000000000004
>=20
> We can reproduce this problem in the following ways:
> =A0
> 1. We create a new cgroup subdirectory and a new eventfd, and then we
> =A0=A0 monitor multiple memory thresholds of the cgroup through this even=
tfd.
> 2. closing this eventfd, and __mem_cgroup_usage_unregister_event () will =
be
> =A0=A0 called multiple times to delete all events related to this eventfd.
>=20
> The first time __mem_cgroup_usage_unregister_event() is called, the kernel
> will clear all items related to this eventfd in thresholds-> primary.Since
> there is currently only one eventfd, thresholds-> primary becomes empty,
> so the kernel will set thresholds-> primary and hresholds-> spare to NULL.
> If at this time, the user creates a new eventfd and monitor the memory
> threshold of this cgroup, kernel will re-initialize thresholds-> primary.
> Then when __mem_cgroup_usage_unregister_event () is called for the second
> time, because thresholds-> primary is not empty, the system will access
> thresholds-> spare, but thresholds-> spare is NULL, which will trigger a
> crash.
>=20
> In general, the longer it takes to delete all events related to this
> eventfd, the easier it is to trigger this problem.
>=20
> The solution is to check whether the thresholds associated with the event=
fd
> has been cleared when deleting the event. If so, we do nothing.
>=20
> Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.=
org>

The fix looks reasonable to me
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

It seems that the code has been broken since 2c488db27b61 ("memcg: clean
up memory thresholds"). We've had 371528caec55 ("mm: memcg: Correct
unregistring of events attached to the same eventfd") but it didn't
catch this case for some reason. Unless I am missing something the code
was broken back then already. Kirill please double check after me.

So if I am not wrong then we want
Fixes: 2c488db27b61 ("memcg: clean up memory thresholds")
Cc: stable

sounds appropriate because this seems to be user trigerable.

Thanks for preparing the patch!

Btw. you should double check your email sender because it seemed to
whitespace damaged the patch (\t -> spaces). Please use git send-email
instead.

> ---
> =A0mm/memcontrol.c | 10 ++++++++--
> =A01 file changed, 8 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d09776c..4575a58 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4027,7 +4027,7 @@ static void __mem_cgroup_usage_unregister_event(str=
uct mem_cgroup *memcg,
> =A0=A0=A0=A0 struct mem_cgroup_thresholds *thresholds;
> =A0=A0=A0=A0 struct mem_cgroup_threshold_ary *new;
> =A0=A0=A0=A0 unsigned long usage;
> -=A0=A0=A0 int i, j, size;
> +=A0=A0=A0 int i, j, size, entries;
> =A0
> =A0=A0=A0=A0 mutex_lock(&memcg->thresholds_lock);
> =A0
> @@ -4047,12 +4047,18 @@ static void __mem_cgroup_usage_unregister_event(s=
truct mem_cgroup *memcg,
> =A0=A0=A0=A0 __mem_cgroup_threshold(memcg, type =3D=3D _MEMSWAP);
> =A0
> =A0=A0=A0=A0 /* Calculate new number of threshold */
> -=A0=A0=A0 size =3D 0;
> +=A0=A0=A0 size =3D entries =3D 0;
> =A0=A0=A0=A0 for (i =3D 0; i < thresholds->primary->size; i++) {
> =A0=A0=A0=A0 =A0=A0=A0 if (thresholds->primary->entries[i].eventfd !=3D e=
ventfd)
> =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 size++;
> +=A0=A0=A0 =A0=A0=A0 else
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 entries++;
> =A0=A0=A0=A0 }
> =A0
> +=A0=A0=A0 /* If items related to eventfd have been cleared, nothing to d=
o */
> +=A0=A0=A0 if (!entries)
> +=A0=A0=A0 =A0=A0=A0 goto unlock;
> +
> =A0=A0=A0=A0 new =3D thresholds->spare;
> =A0
> =A0=A0=A0=A0 /* Set thresholds array to NULL if we don't have thresholds =
*/
> --=20
> 1.8.3.1

--=20
Michal Hocko
SUSE Labs
