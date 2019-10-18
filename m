From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: memcontrol: fix NULL-ptr deref in percpu stats flush
Date: Fri, 18 Oct 2019 16:58:36 +0000
Message-ID: <20191018165831.GA6117@tower.DHCP.thefacebook.com>
References: <20191018165231.249872-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zwGtV2AIM2nK8eNn5DTM/iO2raHgtn3rF69mtVV4byc=;
 b=KiY8sJBlzeEZcJhTYxPnvv/S/ob4q6yz24XcZJXO7tlN/gyVq2kE9bM4dO1ECrEGlj6R
 Gv95xGF/iUilRNRTH7zvXlGJbBXm8FJn1LYuiLV88ZL7CRA1HOUbUlzDTMpk9Wxr4oP7
 Gj9aO8Vlsyo2xpvGLJV3gCTmmY08henC8fA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwGtV2AIM2nK8eNn5DTM/iO2raHgtn3rF69mtVV4byc=;
 b=WusQvJha6TKzkqrmdk5sZuXuFGlNqaCZ1V9MfbVT7Tba7T6yvaHBVMfWFzC88XhehcrKv3VnyC2QR+LRtS3DjKFLaLXBTwLMqZjdabHMcvXg6xR/KpLFvy/L9TkgFyBsLBM9J7HtT+nTztev9RJ90sflFIQY8fCHiUgFcbfZMsg=
In-Reply-To: <20191018165231.249872-1-shakeelb@google.com>
Content-Language: en-US
Content-ID: <63BAE348973C5A46A2584608C2AC3030@namprd15.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "syzbot+515d5bcfe179cdf049b2@syzkaller.appspotmail.com" <syzbot+515d5bcfe179cdf049b2@syzkaller.appspotmail.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Fri, Oct 18, 2019 at 09:52:31AM -0700, Shakeel Butt wrote:
> __mem_cgroup_free() can be called on the failure path in
> mem_cgroup_alloc(). However memcg_flush_percpu_vmstats() and
> memcg_flush_percpu_vmevents() which are called from __mem_cgroup_free()
> access the fields of memcg which can potentially be null if called from
> failure path from mem_cgroup_alloc(). Indeed syzbot has reported the
> following crash:
>=20
> 	R13: 00000000004bf27d R14: 00000000004db028 R15: 0000000000000003
> 	kasan: CONFIG_KASAN_INLINE enabled
> 	kasan: GPF could be caused by NULL-ptr deref or user memory access
> 	general protection fault: 0000 [#1] PREEMPT SMP KASAN
> 	CPU: 0 PID: 30393 Comm: syz-executor.1 Not tainted 5.4.0-rc2+ #0
> 	Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 01/01/2011
> 	RIP: 0010:memcg_flush_percpu_vmstats+0x4ae/0x930 mm/memcontrol.c:3436
> 	Code: 05 41 89 c0 41 0f b6 04 24 41 38 c7 7c 08 84 c0 0f 85 5d 03 00 00 =
44 3b 05 33 d5 12 08 0f 83 e2 00 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 0=
0 0f 85 91 03 00 00 48 8b 85 10 fe ff ff 48 8b b0 90
> 	RSP: 0018:ffff888095c27980 EFLAGS: 00010206
> 	RAX: 0000000000000012 RBX: ffff888095c27b28 RCX: ffffc90008192000
> 	RDX: 0000000000040000 RSI: ffffffff8340fae7 RDI: 0000000000000007
> 	RBP: ffff888095c27be0 R08: 0000000000000000 R09: ffffed1013f0da33
> 	R10: ffffed1013f0da32 R11: ffff88809f86d197 R12: fffffbfff138b760
> 	R13: dffffc0000000000 R14: 0000000000000090 R15: 0000000000000007
> 	FS:  00007f5027170700(0000) GS:ffff8880ae800000(0000) knlGS:000000000000=
0000
> 	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 	CR2: 0000000000710158 CR3: 00000000a7b18000 CR4: 00000000001406f0
> 	DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> 	DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 	Call Trace:
> 	__mem_cgroup_free+0x1a/0x190 mm/memcontrol.c:5021
> 	mem_cgroup_free mm/memcontrol.c:5033 [inline]
> 	mem_cgroup_css_alloc+0x3a1/0x1ae0 mm/memcontrol.c:5160
> 	css_create kernel/cgroup/cgroup.c:5156 [inline]
> 	cgroup_apply_control_enable+0x44d/0xc40 kernel/cgroup/cgroup.c:3119
> 	cgroup_mkdir+0x899/0x11b0 kernel/cgroup/cgroup.c:5401
> 	kernfs_iop_mkdir+0x14d/0x1d0 fs/kernfs/dir.c:1124
> 	vfs_mkdir+0x42e/0x670 fs/namei.c:3807
> 	do_mkdirat+0x234/0x2a0 fs/namei.c:3830
> 	__do_sys_mkdir fs/namei.c:3846 [inline]
> 	__se_sys_mkdir fs/namei.c:3844 [inline]
> 	__x64_sys_mkdir+0x5c/0x80 fs/namei.c:3844
> 	do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
> 	entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 	RIP: 0033:0x459a59
> 	Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> 	RSP: 002b:00007f502716fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
> 	RAX: ffffffffffffffda RBX: 00007f502716fc90 RCX: 0000000000459a59
> 	RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000180
> 	RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
> 	R10: 0000000000000000 R11: 0000000000000246 R12: 00007f50271706d4
> 	R13: 00000000004bf27d R14: 00000000004db028 R15: 0000000000000003
>=20
> Fixing this by moving the flush to mem_cgroup_free as there is no need
> to flush anything if we see failure in mem_cgroup_alloc().
>=20
> Reported-by: syzbot+515d5bcfe179cdf049b2@syzkaller.appspotmail.com
> Fixes: bb65f89b7d3d ("mm: memcontrol: flush percpu vmevents before releas=
ing memcg")
> Fixes: c350a99ea2b1 ("mm: memcontrol: flush percpu vmstats before releasi=
ng memcg")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: <stable@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
>=20
> ---
>  mm/memcontrol.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bdac56009a38..13cb4c1e9f2a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5014,12 +5014,6 @@ static void __mem_cgroup_free(struct mem_cgroup *m=
emcg)
>  {
>  	int node;
> =20
> -	/*
> -	 * Flush percpu vmstats and vmevents to guarantee the value correctness
> -	 * on parent's and all ancestor levels.
> -	 */
> -	memcg_flush_percpu_vmstats(memcg, false);
> -	memcg_flush_percpu_vmevents(memcg);
>  	for_each_node(node)
>  		free_mem_cgroup_per_node_info(memcg, node);
>  	free_percpu(memcg->vmstats_percpu);
> @@ -5030,6 +5024,12 @@ static void __mem_cgroup_free(struct mem_cgroup *m=
emcg)
>  static void mem_cgroup_free(struct mem_cgroup *memcg)
>  {
>  	memcg_wb_domain_exit(memcg);
> +	/*
> +	 * Flush percpu vmstats and vmevents to guarantee the value correctness
> +	 * on parent's and all ancestor levels.
> +	 */
> +	memcg_flush_percpu_vmstats(memcg, false);
> +	memcg_flush_percpu_vmevents(memcg);
>  	__mem_cgroup_free(memcg);
>  }

Good catch!

Reviewed-by: Roman Gushchin <guro@fb.com>

Thank you, Shakeel!
