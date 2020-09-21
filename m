From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 03/13] bcache: inherit the optimal I/O size
Date: Mon, 21 Sep 2020 23:09:48 +0800
Message-ID: <5bcc52dc-ca8f-bbdd-69ef-4b6312e7994a@suse.de>
References: <20200921080734.452759-1-hch@lst.de>
 <20200921080734.452759-4-hch@lst.de>
 <b547a1b6-ab03-0520-012d-86d112c83d92@suse.de>
 <20200921140010.GA14672@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200921140010.GA14672@lst.de>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On 2020/9/21 22:00, Christoph Hellwig wrote:
> On Mon, Sep 21, 2020 at 05:54:59PM +0800, Coly Li wrote:
>> I am not sure whether virtual bcache device's optimal request size can
>> be simply set like this.
>>
>> Most of time inherit backing device's optimal request size is fine, but
>> there are two exceptions,
>> - Read request hits on cache device
>> - User sets sequential_cuttoff as 0, all writing may go into cache
>> device firstly.
>> For the above two conditions, all I/Os goes into cache device, using
>> optimal request size of backing device might be improper.
>>
>> Just a guess, is it OK to set the optimal request size of the virtual
>> bcache device as the least common multiple of cache device's and backing
>> device's optimal request sizes ?
> 
> Well, if the optimal I/O size is wrong, the read ahead size also is
> wrong.  Can we just drop the setting?
> 

I feel this is something should be fixed. Indeed I overlooked it until
you point out the issue now.

The optimal request size and read ahead pages hint are necessary, but
current initialization is simple. A better way might be dynamically
setting them depends on the cache mode and some special configuration.

By your inspiration, I want to ACK your original patch although it
doesn't work fine for all condition. Then we may know these two settings
(ra_pages and queue_io_opt) should be improved for more situations. At
lease for most part of the situations they provide proper hints.

How do you think of the above idea ?

Coly Li
