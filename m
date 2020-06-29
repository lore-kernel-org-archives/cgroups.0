From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: drive-by blk-cgroup cleanups
Date: Mon, 29 Jun 2020 08:05:07 +0000
Message-ID: <SN4PR0401MB3598A198ACA6126D96E949B59B6E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200627073159.2447325-1-hch@lst.de>
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
> Hi all,
> 
> while looking into another "project" I ended up wading through the
> blkcq code for research and found a bunch of lose ends.  So here is
> a bunch of drive-by cleanups for the code.
> 
> Diffstat:
>  block/bio.c                |  143 +----------------------------------
>  block/blk-cgroup.c         |  182 +++++++++++++++++++++++++++++++++++++--------
>  block/blk-core.c           |    7 +
>  block/blk-throttle.c       |   10 +-
>  block/blk.h                |    2 
>  drivers/md/dm.c            |    5 -
>  include/linux/bio.h        |    9 --
>  include/linux/blk-cgroup.h |  101 ------------------------
>  kernel/cgroup/rstat.c      |    1 
>  mm/page_io.c               |   17 ++++
>  10 files changed, 192 insertions(+), 285 deletions(-)
> 

Btw what ever happened to https://lore.kernel.org/r/20200430150356.35691-1-johannes.thumshirn@wdc.com?


