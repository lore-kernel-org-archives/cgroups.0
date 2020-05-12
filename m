From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH 12/19] mm: memcontrol: convert anon and file-thp to new
 mem_cgroup_charge() API
Date: Tue, 12 May 2020 19:58:14 -0400
Message-ID: <25270BAD-CB7E-4E92-96BA-740690744DBA@lca.pw>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200508183105.225460-13-hannes@cmpxchg.org>
 <45AA36A9-0C4D-49C2-BA3C-08753BBC30FB@lca.pw>
 <20200512215813.GA487759@cmpxchg.org>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yD3a12+euav5lEzQ2eD5g0W71Fdr+4HWLSF5wAq+Di4=;
        b=NCtjCiXdpUxrD3bLzlXKjxlXGtB+pIewyDmhQ6NgTrKvEBiiAO3l064DUq0chV8UqU
         3wB2OBgRQ9Iht75ymMDaei3StnLtfND5OXchaakbk/r7q/N8ILNzEior35O7K8va4vj+
         BMOiB9k3rO9/RspupD8JjBww3kCaa3IQrVCaRw2F0BIkSgdnctCS9PhcekAiHzOzBLkr
         nEry2gYpIjfwV5M6ajTLYZLme6Jsn+kCR4KMcN0MXVdjQ+LvwvTXQ0r55weM0847xzkz
         Mheh2jC4iUU31tpYcrbMBSe8SsSJO3QT5fBSmT+HjN6JfSS/rHlRsDS7n8JNyjTZLX8L
         ZRdg==
In-Reply-To: <20200512215813.GA487759-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>



> On May 12, 2020, at 5:58 PM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> =
wrote:
>=20
> On Tue, May 12, 2020 at 10:38:54AM -0400, Qian Cai wrote:
>>> On May 8, 2020, at 2:30 PM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> =
wrote:
>>>=20
>>> With the page->mapping requirement gone from memcg, we can charge =
anon
>>> and file-thp pages in one single step, right after they're =
allocated.
>>>=20
>>> This removes two out of three API calls - especially the tricky =
commit
>>> step that needed to happen at just the right time between when the
>>> page is "set up" and when it's "published" - somewhat vague and =
fluid
>>> concepts that varied by page type. All we need is a freshly =
allocated
>>> page and a memcg context to charge.
>>>=20
>>> v2: prevent double charges on pre-allocated hugepages in khugepaged
>>>=20
>>> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>>> Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
>>> ---
>>> include/linux/mm.h      |  4 +---
>>> kernel/events/uprobes.c | 11 +++--------
>>> mm/filemap.c            |  2 +-
>>> mm/huge_memory.c        |  9 +++------
>>> mm/khugepaged.c         | 35 ++++++++++-------------------------
>>> mm/memory.c             | 36 ++++++++++--------------------------
>>> mm/migrate.c            |  5 +----
>>> mm/swapfile.c           |  6 +-----
>>> mm/userfaultfd.c        |  5 +----
>>> 9 files changed, 31 insertions(+), 82 deletions(-)
>> []
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>=20
>>> @@ -1198,10 +1193,11 @@ static void collapse_huge_page(struct =
mm_struct *mm,
>>> out_up_write:
>>> 	up_write(&mm->mmap_sem);
>>> out_nolock:
>>> +	if (*hpage)
>>> +		mem_cgroup_uncharge(*hpage);
>>> 	trace_mm_collapse_huge_page(mm, isolated, result);
>>> 	return;
>>> out:
>>> -	mem_cgroup_cancel_charge(new_page, memcg);
>>> 	goto out_up_write;
>>> }
>> []
>>=20
>> Some memory pressure will crash this new code. It looks like somewhat =
racy.
>>=20
>> if (!page->mem_cgroup)
>>=20
>> where page =3D=3D NULL in mem_cgroup_uncharge().
>=20
> Thanks for the report, sorry about the inconvenience.
>=20
> Hm, the page is exclusive at this point, nobody else should be
> touching it. After all, khugepaged might reuse the preallocated page
> for another pmd if this one fails to collapse.
>=20
> Looking at the code, I think it's page itself that's garbage, not
> page->mem_cgroup changing. If you have CONFIG_NUMA and the allocation
> fails, *hpage could contain an ERR_PTR instead of being NULL.
>=20
> I think we need the following fixlet:

Yes, I have NUMA here.

Stephen, can you pick this up for first before Andrew has a chance to =
push out the next mmotm hopefully contain this fix?

https://lore.kernel.org/lkml/20200512215813.GA487759-druUgvl0LCNAfugRpC6u6w@public.gmane.org/

>=20
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f2e0a5e5cfbb..f6161e17da26 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1193,7 +1193,7 @@ static void collapse_huge_page(struct mm_struct =
*mm,
> out_up_write:
> 	up_write(&mm->mmap_sem);
> out_nolock:
> -	if (*hpage)
> +	if (!IS_ERR_OR_NULL(*hpage))
> 		mem_cgroup_uncharge(*hpage);
> 	trace_mm_collapse_huge_page(mm, isolated, result);
> 	return;
> @@ -1928,7 +1928,7 @@ static void collapse_file(struct mm_struct *mm,
> 	unlock_page(new_page);
> out:
> 	VM_BUG_ON(!list_empty(&pagelist));
> -	if (*hpage)
> +	if (!IS_ERR_OR_NULL(*hpage))
> 		mem_cgroup_uncharge(*hpage);
> 	/* TODO: tracepoints */
> }

