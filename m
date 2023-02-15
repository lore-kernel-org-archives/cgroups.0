From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: revert blk-cgroup changs
Date: Wed, 15 Feb 2023 09:30:16 +0800
Message-ID: <Y+w1qFgMNh6mz/GH@T590>
References: <20230214183308.1658775-1-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676424636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bKU0neX7HspOKwgho4RN5DZrsBuffeJ73oSMJgy2eMo=;
        b=GCkNdpXMvi1S332h7Iw/1eguYe53xY0CU8ggS+5/uWRhpaVO/K+j3TMTXc0HuKxaikOTbO
        PsRAjIKoaoqRswvoZOTDxJcsRwiYqK/EObsyTTlhTUZFL4ADlqhixfXPzCg7sYdcXdqu5z
        W9pd3Uq7hDwF8RBSSmzRIy3wwwXvOLY=
Content-Disposition: inline
In-Reply-To: <20230214183308.1658775-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 14, 2023 at 07:33:03PM +0100, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series reverts a bunch of blk-cgroup patches as one of them
> caused a problem for which the time is running out to fix for this
> merge window

Thanks for fixing these issues!

Tested-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Ming

