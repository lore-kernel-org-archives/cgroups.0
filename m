From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 02/14] block: remove bio_disassociate_blkg
Date: Mon, 29 Jun 2020 09:33:37 +0000
Message-ID: <SN4PR0401MB359848B55D6E3BE7ECE717B99B6E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200627073159.2447325-1-hch@lst.de>
	<20200627073159.2447325-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Johannes, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Li Zefan <lizefan@huawei.com>, Weiner <hannes@cmpxchg.org>, Dennis Zhou <dennis@kernel.org>

On 27/06/2020 09:33, Christoph Hellwig wrote:
> a new value to >bi_blkg.  Just open code the function in the two callers.
Nit: ->bi_blkg

Otherwise,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


