From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC PATCH 09/19] io_uring: convert to use vm_account
Date: Tue, 24 Jan 2023 10:44:24 -0400
Message-ID: <Y8/uyBKHf5XoXvTW@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRHm2/zQ+7v5wmZb/FJyK3YCzESK/meL/Gv4ezwdRac=;
 b=JWSCAIs2SFD9upzteUIafUKRRpzcn3pDuQSqrGdqbl21L01tY5qvxi1ghbkKU3pbGqwGqr6RSy0SYPk8jS2n4kqpbJqamP8XTjdLNU1h/N2rm8ny39wSkDvEui5zB4U3wOTQZiQyzKhEEntFh8GF1ZFphaGko3ujSdm/i6eVeo3yHSvUSQ6FX++hVYyWXX/Gt49w7m+O4pX5rgT0CLFltvL3iE+klIKU6Ddlh//k5MGzbKh6YRrVNiJ2Yk/vyKjCKJwsHtoST+qbToTM/F2pZs1phUbX1W3q6qmaQ0F6xWbHu+hpgUYlpz8g6mNYmvfbjUz5bnxFGmwOQUm2D++WkA==
Content-Disposition: inline
In-Reply-To: <9f63cf4ab74d6e56e434c1c3d7c98352bb282895.1674538665.git-series.apopple@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org

On Tue, Jan 24, 2023 at 04:42:38PM +1100, Alistair Popple wrote:
> Convert io_uring to use vm_account instead of directly charging pages
> against the user/mm. Rather than charge pages to both user->locked_vm
> and mm->pinned_vm this will only charge pages to user->locked_vm.

I think this is a mistake in the first patch, the pinned_vm should
still increment (but not checked against the rlimit), though its main
purpose in this mode is for debugging in proc.

Jason
