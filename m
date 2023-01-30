From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 05/19] RMDA/siw: Convert to use vm_account
Date: Mon, 30 Jan 2023 22:34:50 +1100
Message-ID: <87lelkz23e.fsf@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <4f8b1d54ab5d6909c46ba5470065f8326f9fcc62.1674538665.git-series.apopple@nvidia.com>
 <Y8/tGIeg5mI9bDOa@nvidia.com>
 <SA0PR15MB3919F0CCF1D878DE8B243B0199C99@SA0PR15MB3919.namprd15.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIiPdkfZ/fZE2PAtlhpufWZGeI6OlvxeJR6i/u8E6ZE=;
 b=IKmcfYZIzTzE+FOa9C3ZcvcOQ5+xrQCUSqHncijXIwvBmirsKytj0A7M/kwsE7d/H/D19ZWtknuMw8Zcn6PeNfD4aQOeqkZVRtX/5fxpsayNRTWOq3QcRb4abf3aI7FogIC0ECl984cN6FLW06FSxKS1A53E6zVpuPRFfOV2f5TblTaswez8dsHlGu2Z8JeSVOc+pyQynxbv2BVY0xQnqq8qN9xrx2lz+SqrBor/sYenCC3RLXJXWElmoXlGiYyijpHLNKUEo33AUSsVhgLbrxtj/J6ubVFc1SdJ9lmNjlQe80TlXgDRtMZ5H6r5XFDoB4kiNV/vAI7X8/BxsOl/2w==
In-reply-to: <SA0PR15MB3919F0CCF1D878DE8B243B0199C99-QVqTciyWr1pbckbNN7pyz4d3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org" <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "mkoutny-IBi9RG/b67k@public.gmane.org" <mkoutny-IBi9RG/b67k@public.gmane.org>, "daniel-/w4YWyX8dFk@public.gmane.org" <daniel-/w4YWyX8dFk@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org> writes:

>> -----Original Message-----
>> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> Sent: Tuesday, 24 January 2023 15:37
>> To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org; cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
>> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org; tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org;
>> hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org; surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org; mkoutny-IBi9RG/b67k@public.gmane.org; daniel-/w4YWyX8dFk@public.gmane.org;
>> Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>; Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>;
>> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [EXTERNAL] Re: [RFC PATCH 05/19] RMDA/siw: Convert to use
>> vm_account
>> 
>> On Tue, Jan 24, 2023 at 04:42:34PM +1100, Alistair Popple wrote:
>> 
>> > @@ -385,20 +382,16 @@ struct siw_umem *siw_umem_get(u64 start, u64 len,
>> bool writable)
>> >  	if (!umem)
>> >  		return ERR_PTR(-ENOMEM);
>> >
>> > -	mm_s = current->mm;
>> > -	umem->owning_mm = mm_s;
>> >  	umem->writable = writable;
>> >
>> > -	mmgrab(mm_s);
>> > +	vm_account_init_current(&umem->vm_account);
>> >
>> >  	if (writable)
>> >  		foll_flags |= FOLL_WRITE;
>> >
>> > -	mmap_read_lock(mm_s);
>> > +	mmap_read_lock(current->mm);
>> >
>> > -	mlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>> > -
>> > -	if (num_pages + atomic64_read(&mm_s->pinned_vm) > mlock_limit) {
>> > +	if (vm_account_pinned(&umem->vm_account, num_pages)) {
>> >  		rv = -ENOMEM;
>> >  		goto out_sem_up;
>> >  	}
>> > @@ -429,7 +422,6 @@ struct siw_umem *siw_umem_get(u64 start, u64 len,
>> bool writable)
>> >  				goto out_sem_up;
>> >
>> >  			umem->num_pages += rv;
>> > -			atomic64_add(rv, &mm_s->pinned_vm);
>> 
>> Also fixes the race bug
>
> But introduces another one. In that loop, umem->num_pages keeps the
> number of pages currently pinned, not the target number. The current
> patch uses that umem->num_pages to call vm_unaccount_pinned() in
> siw_umem_release(). Bailing out before all pages are pinned would
> mess up that accounting during release. Maybe introduce another
> parameter to siw_umem_release(), or better have another umem member
> 'umem->num_pages_accounted' for correct accounting during release.

Yes, I see the problem thanks for pointing it out. Will fix for the next
version.

> Bernard.
>> 
>> Jason

