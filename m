From: Jens Axboe <axboe@kernel.dk>
Subject: Re: drive-by blk-cgroup cleanups
Date: Mon, 29 Jun 2020 09:09:45 -0600
Message-ID: <90c404ed-58b0-274e-516f-b7c63ce34fcc@kernel.dk>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1593443411;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OkuzWxq5MPKibfDkbF8UgIAp5Drw48bilMejAITGG8s=;
	b=DnFiFM4n0vYqVjxCPMg0oIdjp94GtIi01CfrfHh0sVzPVGbA/ZAFJVOi5BuZQgq/DyLV3V
	EYxNI+OaoL3CSfvrTiIK7ozHhC9Sui6wMoq9aNpmQBa3ZWh0pJgE3/QbwfcbY+gHOFB1/7
	B0NjyNz630o1qNAEQhPQjmjhW8/FjxY=
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Dennis Zhou <dennis@kernel.org>

On 6/27/20 1:31 AM, Christoph Hellwig wrote:
> Hi all,
> 
> while looking into another "project" I ended up wading through the
> blkcq code for research and found a bunch of lose ends.  So here is
> a bunch of drive-by cleanups for the code.

Applied, thanks.

-- 
Jens Axboe
