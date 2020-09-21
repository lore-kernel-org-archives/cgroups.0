From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 03/13] bcache: inherit the optimal I/O size
Date: Mon, 21 Sep 2020 17:54:59 +0800
Message-ID: <b547a1b6-ab03-0520-012d-86d112c83d92@suse.de>
References: <20200921080734.452759-1-hch@lst.de>
 <20200921080734.452759-4-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200921080734.452759-4-hch@lst.de>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On 2020/9/21 16:07, Christoph Hellwig wrote:
> Inherit the optimal I/O size setting just like the readahead window,
> as any reason to do larger I/O does not apply to just readahead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/bcache/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1bbdc410ee3c51..48113005ed86ad 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1430,6 +1430,8 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  	dc->disk.disk->queue->backing_dev_info->ra_pages =
>  		max(dc->disk.disk->queue->backing_dev_info->ra_pages,
>  		    q->backing_dev_info->ra_pages);
> +	blk_queue_io_opt(dc->disk.disk->queue,
> +		max(queue_io_opt(dc->disk.disk->queue), queue_io_opt(q)));
>  

Hi Christoph,

I am not sure whether virtual bcache device's optimal request size can
be simply set like this.

Most of time inherit backing device's optimal request size is fine, but
there are two exceptions,
- Read request hits on cache device
- User sets sequential_cuttoff as 0, all writing may go into cache
device firstly.
For the above two conditions, all I/Os goes into cache device, using
optimal request size of backing device might be improper.

Just a guess, is it OK to set the optimal request size of the virtual
bcache device as the least common multiple of cache device's and backing
device's optimal request sizes ?


[snipped]

Thanks.

Coly Li

