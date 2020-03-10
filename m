From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv2] memcg: fix NULL pointer dereference in
 __mem_cgroup_usage_unregister_event
Date: Tue, 10 Mar 2020 13:41:49 +0300
Message-ID: <20200310104149.5c3pc75y6ny5hixb@box>
References: <077a6f67-aefa-4591-efec-f2f3af2b0b02@gmail.com>
 <20200310094836.GD8447@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=0vZawaTqWCz2V8Z7mamXXKPhhUtkT0sw/sdFRGO2vlw=;
        b=rfN6Lx7BOmqQhhOcLZn74EbzqdvStmveWhgz/2wPqRS6Vsou7fptHHWEIrnS4TE5yp
         JTpNP9cVTh9+ScV8dItrwHNxAxXeH2M366CwIpOP/wfCYI8Lr6gWHzuSx2wtV3+CotGf
         vS8wvdPooB2/guIp7F2u9RYKDRt/5+8VJfG61EPWc1IiA6LEanZkA62sFK/IyPHDj3c4
         XISld2tme2+mLRcphKCh3phxQo89djJLpcsShu4ldtlDr+zRUmlW7K6sHnBNcoi5Waik
         td79ng96wZGYcrIub2d9UrMG4QLXkEFBlTDCdk8EaNGbiEKhTJBuuRRONadmzh/i9mG0
         Nigw==
Content-Disposition: inline
In-Reply-To: <20200310094836.GD8447@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko@kernel.org>
Cc: brookxu <brookxu.cn@gmail.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Mar 10, 2020 at 10:48:36AM +0100, Michal Hocko wrote:
> [Cc Kirill, I didn't realize he has implemented this code]

My first non-trivial mm contribution :P

> On Fri 06-03-20 09:02:02, brookxu wrote:
> > From: Chunguang Xu <brookxu@tencent.com>
> >=20
> > An eventfd monitors multiple memory thresholds of the cgroup, closes th=
em,
> > the kernel deletes all events related to this eventfd. Before all events
> > are deleted, another eventfd monitors the memory threshold of this cgro=
up,
> > leading to a crash:
> >=20
> > [=A0 135.675108] BUG: kernel NULL pointer dereference, address: 0000000=
000000004
> > [=A0 135.675350] #PF: supervisor write access in kernel mode
> > [=A0 135.675579] #PF: error_code(0x0002) - not-present page
> > [=A0 135.675816] PGD 800000033058e067 P4D 800000033058e067 PUD 3355ce06=
7 PMD 0
> > [=A0 135.676080] Oops: 0002 [#1] SMP PTI
> > [=A0 135.676332] CPU: 2 PID: 14012 Comm: kworker/2:6 Kdump: loaded Not =
tainted 5.6.0-rc4 #3
> > [=A0 135.676610] Hardware name: LENOVO 20AWS01K00/20AWS01K00, BIOS GLET=
70WW (2.24 ) 05/21/2014
> > [=A0 135.676909] Workqueue: events memcg_event_remove
> > [=A0 135.677192] RIP: 0010:__mem_cgroup_usage_unregister_event+0xb3/0x1=
90
> > [=A0 135.677825] RSP: 0018:ffffb47e01c4fe18 EFLAGS: 00010202
> > [=A0 135.678186] RAX: 0000000000000001 RBX: ffff8bb223a8a000 RCX: 00000=
00000000001
> > [=A0 135.678548] RDX: 0000000000000001 RSI: ffff8bb22fb83540 RDI: 00000=
00000000001
> > [=A0 135.678912] RBP: ffffb47e01c4fe48 R08: 0000000000000000 R09: 00000=
00000000010
> > [=A0 135.679287] R10: 000000000000000c R11: 071c71c71c71c71c R12: ffff8=
bb226aba880
> > [=A0 135.679670] R13: ffff8bb223a8a480 R14: 0000000000000000 R15: 00000=
00000000000
> > [=A0 135.680066] FS:=A0 0000000000000000(0000) GS:ffff8bb242680000(0000=
) knlGS:0000000000000000
> > [=A0 135.680475] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [=A0 135.680894] CR2: 0000000000000004 CR3: 000000032c29c003 CR4: 00000=
000001606e0
> > [=A0 135.681325] Call Trace:
> > [=A0 135.681763]=A0 memcg_event_remove+0x32/0x90
> > [=A0 135.682209]=A0 process_one_work+0x172/0x380
> > [=A0 135.682657]=A0 worker_thread+0x49/0x3f0
> > [=A0 135.683111]=A0 kthread+0xf8/0x130
> > [=A0 135.683570]=A0 ? max_active_store+0x80/0x80
> > [=A0 135.684034]=A0 ? kthread_bind+0x10/0x10
> > [=A0 135.684506]=A0 ret_from_fork+0x35/0x40
> > [=A0 135.689733] CR2: 0000000000000004
> >=20
> > We can reproduce this problem in the following ways:
> > =A0
> > 1. We create a new cgroup subdirectory and a new eventfd, and then we
> > =A0=A0 monitor multiple memory thresholds of the cgroup through this ev=
entfd.
> > 2. closing this eventfd, and __mem_cgroup_usage_unregister_event () wil=
l be
> > =A0=A0 called multiple times to delete all events related to this event=
fd.
> >=20
> > The first time __mem_cgroup_usage_unregister_event() is called, the ker=
nel
> > will clear all items related to this eventfd in thresholds-> primary.Si=
nce
> > there is currently only one eventfd, thresholds-> primary becomes empty,
> > so the kernel will set thresholds-> primary and hresholds-> spare to NU=
LL.

						    ^ typo

> > If at this time, the user creates a new eventfd and monitor the memory
> > threshold of this cgroup, kernel will re-initialize thresholds-> primar=
y.
> > Then when __mem_cgroup_usage_unregister_event () is called for the seco=
nd
> > time, because thresholds-> primary is not empty, the system will access
> > thresholds-> spare, but thresholds-> spare is NULL, which will trigger a
> > crash.
> >=20
> > In general, the longer it takes to delete all events related to this
> > eventfd, the easier it is to trigger this problem.
> >=20
> > The solution is to check whether the thresholds associated with the eve=
ntfd
> > has been cleared when deleting the event. If so, we do nothing.
> >=20
> > Signed-off-by: Chunguang Xu <brookxu@tencent.com>
>=20
> The fix looks reasonable to me
> Acked-by: Michal Hocko <mhocko@suse.com>

Agreed. Two typos have to be addressed.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

> It seems that the code has been broken since 2c488db27b61 ("memcg: clean
> up memory thresholds"). We've had 371528caec55 ("mm: memcg: Correct
> unregistring of events attached to the same eventfd") but it didn't
> catch this case for some reason. Unless I am missing something the code
> was broken back then already. Kirill please double check after me.

I think the issue exitsted before 2c488db27b61. The fields had different
names back then.

The logic to make unregister never-fail is added in 907860ed381a
("cgroups: make cftype.unregister_event() void-returning"). I believe the
Fixes should point there.

>=20
> So if I am not wrong then we want
> Fixes: 2c488db27b61 ("memcg: clean up memory thresholds")
> Cc: stable
>=20
> sounds appropriate because this seems to be user trigerable.
>=20
> Thanks for preparing the patch!
>=20
> Btw. you should double check your email sender because it seemed to
> whitespace damaged the patch (\t -> spaces). Please use git send-email
> instead.
>=20
> > ---
> > =A0mm/memcontrol.c | 10 ++++++++--
> > =A01 file changed, 8 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d09776c..4575a58 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4027,7 +4027,7 @@ static void __mem_cgroup_usage_unregister_event(s=
truct mem_cgroup *memcg,
> > =A0=A0=A0=A0 struct mem_cgroup_thresholds *thresholds;
> > =A0=A0=A0=A0 struct mem_cgroup_threshold_ary *new;
> > =A0=A0=A0=A0 unsigned long usage;
> > -=A0=A0=A0 int i, j, size;
> > +=A0=A0=A0 int i, j, size, entries;
> > =A0
> > =A0=A0=A0=A0 mutex_lock(&memcg->thresholds_lock);
> > =A0
> > @@ -4047,12 +4047,18 @@ static void __mem_cgroup_usage_unregister_event=
(struct mem_cgroup *memcg,
> > =A0=A0=A0=A0 __mem_cgroup_threshold(memcg, type =3D=3D _MEMSWAP);
> > =A0
> > =A0=A0=A0=A0 /* Calculate new number of threshold */
> > -=A0=A0=A0 size =3D 0;
> > +=A0=A0=A0 size =3D entries =3D 0;
> > =A0=A0=A0=A0 for (i =3D 0; i < thresholds->primary->size; i++) {
> > =A0=A0=A0=A0 =A0=A0=A0 if (thresholds->primary->entries[i].eventfd !=3D=
 eventfd)
> > =A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 size++;
> > +=A0=A0=A0 =A0=A0=A0 else
> > +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 entries++;
> > =A0=A0=A0=A0 }
> > =A0
> > +=A0=A0=A0 /* If items related to eventfd have been cleared, nothing to=
 do */

	       ^ "no items" ?

> > +=A0=A0=A0 if (!entries)
> > +=A0=A0=A0 =A0=A0=A0 goto unlock;
> > +
> > =A0=A0=A0=A0 new =3D thresholds->spare;
> > =A0
> > =A0=A0=A0=A0 /* Set thresholds array to NULL if we don't have threshold=
s */
> > --=20
> > 1.8.3.1
>=20
> --=20
> Michal Hocko
> SUSE Labs

--=20
 Kirill A. Shutemov
