From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 09/19] io_uring: convert to use vm_account
Date: Mon, 30 Jan 2023 22:12:43 +1100
Message-ID: <87tu08z2zv.fsf@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
 <Y8/uyBKHf5XoXvTW@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mL3G2lIOGx8nGb74swMZ/4CJHpsCfm93T1KicB/1V4o=;
 b=MjHFPcOldZLkPFvGY7UQm5m9qLg/x5tohNAZ9ISF+QOzd5Me3f0DmSPYFGzXRIMokeOjvwwwFQ14niAkAqa0A5QeYEeYFMECIr0gQPlKTD+zVpO8vOUGrzW8Uy0AAgsqmPlaCY6giDLRdLKMtttIOI5wfs1rqZ5R7Ffy4y/2FCMhEI/fbwMzkPTPku2B6BHpMy0fRt5zRcOfWuEuI1hnDs/vZKfQOxuu+AZLfTPk55813ufjlsNAqElNpUCfcq2LKMmhse4mHb2ddPNBkv3JL7NqY3OzSzZYA0DO54sDvtg9r3HjrKNtWe2MkoM56pHAQYUNUmwkfXIa1sCYZDa4MQ==
In-reply-to: <Y8/uyBKHf5XoXvTW-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> writes:

> On Tue, Jan 24, 2023 at 04:42:38PM +1100, Alistair Popple wrote:
>> Convert io_uring to use vm_account instead of directly charging pages
>> against the user/mm. Rather than charge pages to both user->locked_vm
>> and mm->pinned_vm this will only charge pages to user->locked_vm.
>
> I think this is a mistake in the first patch, the pinned_vm should
> still increment (but not checked against the rlimit), though its main
> purpose in this mode is for debugging in proc.

Sorry, didn't quite follow - are you saying we should always increment
mm->pinned_vm and only use VM_ACCOUNT_USER vs. TASK to select which one
the rlimit is enforced against?

> Jason

