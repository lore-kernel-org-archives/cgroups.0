From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/19] mm: Introduce a cgroup to limit the amount of
 locked and pinned memory
Date: Thu, 16 Feb 2023 12:01:43 +0100
Message-ID: <fdd3bd7d-526d-d441-00f1-e8321441174e@redhat.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676545307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RT3I0H8bP1HeewuPOTi34AMMwE+sGnWigdoFWwsEuUo=;
        b=FVn8S7/2Wj28Zj0Ty1m6tPXTbIeBn3wHG7D2mh1enYTMRiwyJi2XjzoySHrRVm1Nhpry4l
        GdNVwPDiRlv8FgHi+4sMWpow1yIzs+KVMgUR/1emLCZUbmmBUsempa9hnN7aut/o+D+YmR
        PLayxokyW78umRIko8Gc1ISqeAY8drk=
Content-Language: en-US
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 06.02.23 08:47, Alistair Popple wrote:
> Having large amounts of unmovable or unreclaimable memory in a system
> can lead to system instability due to increasing the likelihood of
> encountering out-of-memory conditions. Therefore it is desirable to
> limit the amount of memory users can lock or pin.
> 
>  From userspace such limits can be enforced by setting
> RLIMIT_MEMLOCK. However there is no standard method that drivers and
> other in-kernel users can use to check and enforce this limit.
> 
> This has lead to a large number of inconsistencies in how limits are
> enforced. For example some drivers will use mm->locked_mm while others
> will use mm->pinned_mm or user->locked_mm. It is therefore possible to
> have up to three times RLIMIT_MEMLOCKED pinned.
> 
> Having pinned memory limited per-task also makes it easy for users to
> exceed the limit. For example drivers that pin memory with
> pin_user_pages() it tends to remain pinned after fork. To deal with
> this and other issues this series introduces a cgroup for tracking and
> limiting the number of pages pinned or locked by tasks in the group.
> 
> However the existing behaviour with regards to the rlimit needs to be
> maintained. Therefore the lesser of the two limits is
> enforced. Furthermore having CAP_IPC_LOCK usually bypasses the rlimit,
> but this bypass is not allowed for the cgroup.
> 
> The first part of this series converts existing drivers which
> open-code the use of locked_mm/pinned_mm over to a common interface
> which manages the refcounts of the associated task/mm/user
> structs. This ensures accounting of pages is consistent and makes it
> easier to add charging of the cgroup.
> 
> The second part of the series adds the cgroup controller and converts
> core mm code such as mlock over to charging the cgroup before finally
> introducing some selftests.
> 
> Rather than adding onto an exisiting cgroup controller such as memcg
> we introduce a new controller. This is primarily because we wish to
> limit the total number of pages tasks within a cgroup may pin/lock.
> 
> As I don't have access to systems with all the various devices I
> haven't been able to test all driver changes. Any help there would be
> appreciated.
> 
> Note that this series is based on v6.2-rc5 and
> https://lore.kernel.org/linux-rdma/20230201115540.360353-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org/
> which makes updating the siw driver easier (thanks Bernard).
> 
> Changes from initial RFC:
> 
>   - Fixes to some driver error handling.
> 
>   - Pages charged with vm_account will always increment mm->pinned_vm
>     and enforce the limit against user->locked_vm or mm->pinned_vm
>     depending on initialisation flags.
> 
>   - Moved vm_account prototypes and struct definitions into a separate header.
> 
>   - Minor updates to commit messages and kernel docs (thanks to Jason,
>     Christoph, Yosry and T.J.).
> 
> Outstanding issues:
> 
>   - David H pointed out that the vm_account naming is potentially
>     confusing and I agree. However I have yet to come up with something
>     better so will rename this in a subsequent version of this series
>     (suggestions welcome).


vm_lockaccount ? vm_pinaccount ?

Less confusing than reusing VM_ACCOUNT which translates to "commit 
accounting".

Might also make sense to rename VM_ACCOUNT to VM_COMMIT or sth like that.

-- 
Thanks,

David / dhildenb

