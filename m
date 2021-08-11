From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] mm: hide laptop_mode_wb_timer entirely behind the
 BDI API
Date: Wed, 11 Aug 2021 07:22:29 +0200
Message-ID: <20210811052229.GA1696@lst.de>
References: <20210809141744.1203023-1-hch@lst.de> <20210809141744.1203023-2-hch@lst.de> <20210810215622.GA874076@roeck-us.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210810215622.GA874076@roeck-us.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Guenter Roeck <linux@roeck-us.net>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Tue, Aug 10, 2021 at 02:56:22PM -0700, Guenter Roeck wrote:
> On Mon, Aug 09, 2021 at 04:17:40PM +0200, Christoph Hellwig wrote:
> > Don't leak the deta=D1=96ls of the timer into the block layer, instead
> > initialize the timer in bdi_alloc and delete it in bdi_unregister.
> > Note that this means the timer is initialized (but not armed) for
> > non-block queues as well now.
> >=20
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
>=20
> Just in case this hasn't been reported yet.
> This patch results in a widespread build failure. Example:

Sorry.  This was reported before and a fix is already queued up here:

https://git.kernel.dk/cgit/linux-block/commit/?h=3Dfor-5.15/block&id=3D99d2=
6de2f6d79badc80f55b54bd90d4cb9d1ad90
