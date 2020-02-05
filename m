From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 3/9] hugetlb_cgroup: add reservation accounting for
 private mappings
Date: Wed, 5 Feb 2020 15:26:56 -0800
Message-ID: <5480f0ea-0e5f-30c2-7635-43b8cbbb3a73@oracle.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-3-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vkChhDkW7adf/zI5HvGJVWc4OuaOabIDTSkYpTnwmPw=;
 b=eYIjGVGUVqV5tGfbL96DvEfbYv3qu0IIayzbrpUiOrBcqQUUuX5aGJuzTwR8F45cagPc
 K9PdXE713rljBTOIT3YXqyu+jjgQuPcsCpJShzg32/wD4tmugHCtG3iRVoxaXTFUL58Y
 g7P2ZZvbhac9rQXJ6GyPSZk8m7XEyvbrLliWbeuGBTWYVFvht2fPs8DJdMhX40bHzR3C
 N4yhSOJhTvzoJSI4RxzXEwXNVHTc/NhbyYfDoSQCRhkaGAqoQMMPZAkuVat13q+tP0SL
 /RM1TmaQxg5lx9y0Erht6ykSN9oG+/nWkJMocgOkMyDRr7VN0sBlPx7J5tOmfTFT7edN eQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vkChhDkW7adf/zI5HvGJVWc4OuaOabIDTSkYpTnwmPw=;
 b=ejok573A3qg8/03hB2x1meAni0sWpbmssJEut1MKvXKKRgGmOMqlQzCyEbGIw1rr5wPu
 MglGDJ0NxdPBMqQg/y1AKhOpHKFOMAOGFzqj5xZOMie8GqdYV45ACAAYWm0+v15l3STA
 ezg4yajpIRLxDHoG5tMQTv6W6m+aFORDLpzGitaOgMqBtrZ8IUvpGK0Qm9afwRz59XIQ
 mcQA1bdAT6lGv3q0Zi72XXBAKHdcF1QmHWq3xFfDbTNHaCQnnGB2K4Jo64QECF5xKlW3
 sxPYi4Y3sPyZIyz4FMT6pVTo9c20xyan6YmFsiJxo2ar86C6lPF/acPKzpmLivYNaWvq kw== 
In-Reply-To: <20200203232248.104733-3-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/3/20 3:22 PM, Mina Almasry wrote:
> Normally the pointer to the cgroup to uncharge hangs off the struct
> page, and gets queried when it's time to free the page. With
> hugetlb_cgroup reservations, this is not possible. Because it's possible
> for a page to be reserved by one task and actually faulted in by another
> task.
> 
> The best place to put the hugetlb_cgroup pointer to uncharge for
> reservations is in the resv_map. But, because the resv_map has different
> semantics for private and shared mappings, the code patch to
> charge/uncharge shared and private mappings is different. This patch
> implements charging and uncharging for private mappings.
> 
> For private mappings, the counter to uncharge is in
> resv_map->reservation_counter. On initializing the resv_map this is set
> to NULL. On reservation of a region in private mapping, the tasks
> hugetlb_cgroup is charged and the hugetlb_cgroup is placed is
> resv_map->reservation_counter.
> 
> On hugetlb_vm_op_close, we uncharge resv_map->reservation_counter.
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 
> Changes in v11:
> - Refactored hugetlb_cgroup_uncharge_conuter a bit to eliminate
> unnecessary #ifdefs.
> - Added resv_map_set_hugetlb_cgroup_uncharge_info() to eliminate #ifdefs
> in the middle of hugetlb logic.

Thanks.
Code looks better without the #ifdefs.
You can keep my Reviewed-by:

-- 
Mike Kravetz
