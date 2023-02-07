From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Date: Tue, 07 Feb 2023 12:03:33 +1100
Message-ID: <87k00unusm.fsf@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
 <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulzZsKnPwt8pnwF8OUVxD4NHDYhB5qj3lLTnLog7IN0=;
 b=H+t/UgZB9U/N+FDkzaaK6EBmuKUq46RJshN9iy21tRecmBY0By929/pnJWlO0PIcmUNvb9G+4NfvWNAlfwsca+IbYFNnR3uBIPs9EEQXykof/lW0CVS9Rb/cmO9VHC4Kos6nZk3SbkqSVb6m5nd3aSysmozvSq3ZWTShHOa0l6zddgtEBqJMzLrfn7jMcsi6h6gI66CPJzw+9KFoyK717FkwcsbBrXe1ZVu7tO1wGbgspYQx96MaaKadkX98cgEDwcmlAvRXqseScroscmRs+Ayr2BbE/cEo7oDqNpMORNWXt84WwYuRqg9vI4JQyrzeNDzgjInn0hVisPxfup9PJg==
In-reply-to: <52d41a7e-1407-e74f-9206-6dd583b7b6b5-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> writes:

> On 2/6/23 12:47=E2=80=AFAM, Alistair Popple wrote:
>> Convert io_uring to use vm_account instead of directly charging pages
>> against the user/mm. Rather than charge pages to both user->locked_vm
>> and mm->pinned_vm this will only charge pages to user->locked_vm.
>
> Not sure how we're supposed to review this, when you just send us 9/19
> and vm_account_release() is supposedly an earlier patch in this series.
>
> Either CC the whole series, or at least the cover letter, core parts,
> and the per-subsystem parts.

Ok, thanks. Will be sure to add everyone to the cover letter and patch
01 when I send the next version.

For reference the cover letter is here:

https://lore.kernel.org/linux-mm/cover.c238416f0e82377b449846dbb2459ae9d703=
0c8e.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org/

And the core patch that introduces vm_account is here:

https://lore.kernel.org/linux-mm/e80b61561f97296a6c08faeebe281cb949333d1d.1=
675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org/

No problem if you want to wait for the resend/next version before
taking another look though.
