From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] potential hugetlb css refcounting issues
Date: Fri, 27 Aug 2021 15:22:08 -0700
Message-ID: <8a4f2fbc-76e8-b67b-f110-30beff2228f5@oracle.com>
References: <20210827151146.GA25472@bender.morinfr.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IZisUq9OmVACOelvRQP2TdK+QkYV0UHhrbNgXDD0zqc=;
 b=oqjXaPs/gI5kvOjNnPE9GwE1NxsYFNIU0kANtQBHCrBwo7sjtZ8Y/A7MSEKx6e81Z2SF
 hnjjA9tRWOhTYJAbiwYXLvOz6FoEdGG2wQ//nYF5ADdrDh7Bd4N3kjWIAIp8rlzgBURe
 lCkNi72dxNfm6+J9yjpWI1jS4qobfe73eBToWxV4DJhX+WqvAmLYuKUoa57Jl3r3ca+P
 mgHbe0EdgK1lczH+eP7GmnSqCzbSo+SyXm7EB9VR3M4/Ior1G6DjTfxW8k8j7Mc8d/LV
 i6CEYLwakOV+/XrziBWmLnIoe9Pxaxbk9h0fuj4NovbB7uIowFnm+uRlu4GxDeZy/3+i Cg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IZisUq9OmVACOelvRQP2TdK+QkYV0UHhrbNgXDD0zqc=;
 b=vYTRQzD4nIsMD6y0ymIDVQK/gQU9hpaytkhacE0BbInJPesgU+b9nDQ2ti/eba2BY8Nx
 Mfg17NyKZ2xM6RYycW5WoGqot2txQWZjlX6eOnVKk3neH6mBrZESO9cjqwMbu+44BAOL
 7rWL5s6qZcv0h3bva/L+exCOco8YXiroYvApDtnDXVDjaX3DGRuaQoEaqUBbPMLriBzq
 6gy0W0o78KKwYXJRF0hhuWhPG5zWvnKJf4b+RaipeA3K2xj+YinvdoNMuvWkn/FvZnoL
 fOraRRHDYdGdaXPCt5OY7TdLjLiTo53lqeIilH4H3Cq6vrAMatoOeizqy3qbfDZPaFHa JQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZisUq9OmVACOelvRQP2TdK+QkYV0UHhrbNgXDD0zqc=;
 b=GyZyfe8HYwkKV5GjWqRrbGfmTt9yfbc9RzZPpn0d2uVX18he/X2f8eo3d3om9qPw7zw5b6embDpVfQBhiWeeEQIGKR602GvCJGWTaB5r2oRBF5v6zu8Hs/yv5lSz/+9CiAGrUXyNvT4kN8TZwyQzmjvsKO6iSWYloG62RIJnJEk=
In-Reply-To: <20210827151146.GA25472-iHhE99jIcVYJQ5r9O9UB6R2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

CC'ing linux-mm 

On 8/27/21 8:11 AM, Guillaume Morin wrote:
> Hi,
> 
> After upgrading to 5.10 from 5.4 (though I believe that these issues are
> still present in 5.14), we noticed some refcount count warning
> pertaining a corrupted reference count of the hugetlb css, e.g
> 
> [  704.259734] percpu ref (css_release) <= 0 (-1) after switching to atomic
> [  704.259755] WARNING: CPU: 23 PID: 130 at lib/percpu-refcount.c:196 percpu_ref_switch_to_atomic_rcu+0x127/0x130
> [  704.259911] CPU: 23 PID: 130 Comm: ksoftirqd/23 Kdump: loaded Tainted: G           O      5.10.60 #1
> [  704.259916] RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x127/0x130
> [  704.259920] Code: eb b1 80 3d 37 4f 0a 01 00 0f 85 5d ff ff ff 49 8b 55 e0 48 c7 c7 38 57 0d 94 c6 05 1f 4f 0a 01 01 49 8b 75 e8 e8 a9 e5 c1 ff <0f> 0b e9 3b ff ff ff 66 90 55 48 89 e5 41 56 49 89 f6 41 55 49 89
> [  704.259922] RSP: 0000:ffffb19b4684bdd0 EFLAGS: 00010282
> [  704.259924] RAX: 0000000000000000 RBX: 7ffffffffffffffe RCX: 0000000000000027
> [  704.259926] RDX: 0000000000000000 RSI: ffff9a81ffb58b40 RDI: ffff9a81ffb58b48
> [  704.259927] RBP: ffffb19b4684bde8 R08: 0000000000000003 R09: 0000000000000001
> [  704.259929] R10: 0000000000000003 R11: ffffb19b4684bb70 R12: 0000370946a03b50
> [  704.259931] R13: ffff9a72c9ceb860 R14: 0000000000000000 R15: ffff9a72c42f4000
> [  704.259933] FS:  0000000000000000(0000) GS:ffff9a81ffb40000(0000) knlGS:0000000000000000
> [  704.259935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  704.259936] CR2: 0000000001416318 CR3: 000000011e1ac003 CR4: 00000000003706e0
> [  704.259938] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  704.259939] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  704.259941] Call Trace:
> [  704.259950]  rcu_core+0x30f/0x530
> [  704.259955]  rcu_core_si+0xe/0x10
> [  704.259959]  __do_softirq+0x103/0x2a2
> [  704.259964]  ? sort_range+0x30/0x30
> [  704.259968]  run_ksoftirqd+0x2b/0x40
> [  704.259971]  smpboot_thread_fn+0x11a/0x170
> [  704.259975]  kthread+0x10a/0x140
> [  704.259978]  ? kthread_create_worker_on_cpu+0x70/0x70
> [  704.259983]  ret_from_fork+0x22/0x30
> 
> The box would soon crash due to some GPF or NULL pointer deference
> either in cgroups_destroy or in the kill_css path. We confirmed the
> issue was specific to the hugetlb css by manually disabling its use and
> verifying that the box then stayed up and happy.

Thanks for reporting this Guillaume!

There have been other hugetlb cgroup fixes since 5.10.  I do not believe
they are related to the underflow issue you have seen.  Just FYI.

I do hope Mina is taking a look as well.  His recent/ongoing mremap work
is also touching these areas of the code.

> I believe there might be 2 distinct bugs leading to this. I am not
> familiar with the cgroup code so I might be off base here. I did my best
> to track this and understand the logic. Any feedback will be welcome.
> 
> I have not provided patches because if I am correct, they're fairly
> trivial and since I am unfamiliar with this code, I am afraid they could
> not be that helpful.  But I could provide them if anybody is interested.
> 
> 1. Since e9fe92ae0cd2, hugetlb_vm_op_close() decreases the refcount of
> the css (if present) through the hugetlb_cgroup_uncharge_counter() call
> if a resv map is set on the vma and the owner flag is present (i.e
> private mapping).  In the most basic case, the corresponding refcount
> increase is done in hugetlb_reserve_pages().
> However when sibling vmas are opened, hugetlb_vm_op_open() is called,
> the resv map reference count is increased (if vma_resv_map(vma) is not
> NULL for private mappings), but not for a potential resv->css (i.e if
> resv->css != NULL).
> When these siblings vmas are closed, the refcount will still be
> decreased once per such vma, leading to an underflow and premature
> release (potentially use after free) of the hugetlb css.  The fix would
> be to call css_get() if resv->css != NULL in hugetlb_vm_op_open()

That does appear to be a real issue.  In the 'common' fork case, a vma
is duplicated but reset_vma_resv_huge_pages() is called to clear the
pointer to the reserve map for private mappings before calling
hugetlb_vm_op_open.  However, when a vma is split both resulting vmas
would be 'owners' of private mapping reserves without incrementing the
refcount which would lead to the underflow you describe.

> 2. After 08cf9faf75580, __free_huge_page() decrements the css refcount
> for _each_ page unconditionally by calling
> hugetlb_cgroup_uncharge_page_rsvd().
> But a per-page reference count is only taken *per page* outside the
> reserve case in alloc_huge_page() (i.e
> hugetlb_cgroup_charge_cgroup_rsvd() is called only if deferred_reserve
> is true).  In the reserve case, there is only one css reference linked
> to the resv map (taken in hugetlb_reserve_pages()).
> This also leads to an underflow of the counter.  A similar scheme to
> HPageRestoreReserve can be used to track which pages were allocated in
> the deferred_reserve case and call hugetlb_cgroup_uncharge_page_rsvd()
> only for these during freeing.

I am not sure about the above analysis.  It is true that
hugetlb_cgroup_uncharge_page_rsvd is called unconditionally in
free_huge_page.  However, IIUC hugetlb_cgroup_uncharge_page_rsvd will
only decrement the css refcount if there is a non-NULL hugetlb_cgroup
pointer in the page.  And, the pointer in the page would only be set in
the 'deferred_reserve' path of alloc_huge_page.  Unless I am missing
something, they seem to balance.

In any case I will look closer at the code with an eye on underflows.
Thanks for the report and help!
-- 
Mike Kravetz
