From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC PATCH 09/19] io_uring: convert to use vm_account
Date: Mon, 30 Jan 2023 09:21:36 -0400
Message-ID: <Y9fEYNQOV0+iDvWJ@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
 <Y8/uyBKHf5XoXvTW@nvidia.com>
 <87tu08z2zv.fsf@nvidia.com>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g47Ib/RumelIOz6micA8aQgCRRk/pRAB+0AK/E6UWPc=;
 b=KtZSDy1cP3jyUWeP7cVvaaiJZI+LrpOVBljPMUCErnA5pZiutoniN/OxF1wuYrBJpQ0/s+qtQtZR9724CwuXEj0PHXIeZB6+n21RDtwrtCRPhr6V4Ez2hFy3t0w9uk24GROPhLAoQavu/d39C7VSvt19L0KLobZ6r//StX5gCo4dJdyVrqsTq15GmeT0NaMEQGHscfNRrSO/aD9Kq2BJ1aUGYsiSkH2L7vz/8Mk0wC0TV22+QwGCL5D2vd1zhM1Qo5EArNwQpYwo/7ETws1ZbdtoXehiqb94r7n+OOkR5x4HeBZusoWeK7w3a/iBjgYMpXtDshZYD3/V9UrA8e3EVA==
Content-Disposition: inline
In-Reply-To: <87tu08z2zv.fsf@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org

On Mon, Jan 30, 2023 at 10:12:43PM +1100, Alistair Popple wrote:
> 
> Jason Gunthorpe <jgg@nvidia.com> writes:
> 
> > On Tue, Jan 24, 2023 at 04:42:38PM +1100, Alistair Popple wrote:
> >> Convert io_uring to use vm_account instead of directly charging pages
> >> against the user/mm. Rather than charge pages to both user->locked_vm
> >> and mm->pinned_vm this will only charge pages to user->locked_vm.
> >
> > I think this is a mistake in the first patch, the pinned_vm should
> > still increment (but not checked against the rlimit), though its main
> > purpose in this mode is for debugging in proc.
> 
> Sorry, didn't quite follow - are you saying we should always increment
> mm->pinned_vm and only use VM_ACCOUNT_USER vs. TASK to select which one
> the rlimit is enforced against?

yes pinned_vm was created primarily a debugging counter in proc

Jason
