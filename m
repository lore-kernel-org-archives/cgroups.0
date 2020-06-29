From: Tejun Heo <tj@kernel.org>
Subject: Re: drive-by blk-cgroup cleanups
Date: Mon, 29 Jun 2020 09:56:43 -0400
Message-ID: <20200629135643.GA233973@mtj.thefacebook.com>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1593439026;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yHtZ5HCo/mQeTLdBrmJF6lD45z2CTbPjJndpVN3vQJE=;
	b=XJ20KEqXSVzeaX8samGwslSnFluW7ZXu8auWjaTJJo8yExFI1DhjP+xcN3UiWF5aa2rdcl
	K4f3pBgTCATfASyZMqIcZyO8IvKGwRbtGm3289WvbKDjT+n01vvUwctZIJwUFOF9oI/FhY
	MbwdoEedOzQMNhUodZTzFgysVMOT6zQ=
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Dennis Zhou <dennis@kernel.org>

On Sat, Jun 27, 2020 at 09:31:45AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> while looking into another "project" I ended up wading through the
> blkcq code for research and found a bunch of lose ends.  So here is
> a bunch of drive-by cleanups for the code.

The whole series looks great to me.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
