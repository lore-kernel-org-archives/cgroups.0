From: Christoph Hellwig <hch@lst.de>
Subject: Re: drive-by blk-cgroup cleanups
Date: Mon, 29 Jun 2020 10:08:31 +0200
Message-ID: <20200629080831.GA32117@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
	<SN4PR0401MB3598A198ACA6126D96E949B59B6E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1593418128;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dL9lBWKMAxVrEbJnug2asAm3UkHU/K29t/Cc+kgDcHk=;
	b=UE+M9IXagMdXCuvfiGgLxA2+1IY+BfgxxjF4ZYbN/NboQJrks7tfGnBNNDZ6ljdh9LxH5d
	Uqsk4xj73En6W/BEtJtNjuHUUYpz/YeBexCagR0eOUD97EHntWWR9Dt1RE6t8aN6IVOafp
	7Wo02+FXF4Tc0cpWkklgE9W+zPfTxU4=
In-Reply-To: <SN4PR0401MB3598A198ACA6126D96E949B59B6E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
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
Content-Disposition: inline
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, Christoph Hellwig <hch@lst.de>

On Mon, Jun 29, 2020 at 08:05:07AM +0000, Johannes Thumshirn wrote:
> Btw what ever happened to https://lore.kernel.org/r/20200430150356.35691-1-johannes.thumshirn@wdc.com?

You'll have to ask Jens :)  Note that your patch 2 overlaps with this
series.  I thik my version is a little nicer, given that
blkcg_bio_issue_check is a very strange function doing multiple things
as-is.
