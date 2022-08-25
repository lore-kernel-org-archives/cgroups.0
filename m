From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 1/4] blk-throttle: fix that io throttle can only work
 for single bio
Date: Thu, 25 Aug 2022 08:15:47 -1000
Message-ID: <Ywe8Uz4Gy6j/EsUg@slm.duckdns.org>
References: <20220823033130.874230-1-yukuai1@huaweicloud.com>
 <20220823033130.874230-2-yukuai1@huaweicloud.com>
 <YwUXTL+8E/sPcEUB@slm.duckdns.org>
 <73c72914-e27d-b261-e040-2dd31e8a6b9f@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=fcKBwzQ+3FvK05e8vJPVdEnteLULk8JgW8p1pB9U+CI=;
        b=TCOluU41yS0PIH//NJHewas8S7wRDMNMpr/FhfdfFjPVI1OJTelfGc75wL+HbxGtYw
         qytzyT5kAvTVBteRm8wHc5E25sn9+dH9JCzPNsMr73279vyf+7/pTZY6YH276OmkzNjN
         iElud98mzag7VV76DPmVTZET+w6ftAKVSrX9oEOpnnlvY5iTxNyMKI4FqKd6Y9RJYWRl
         yaOfDsKM22jhDLZxX6KOXBjRO/hBeN/WZ2ZMFLsqglTyIm+1nSSkbRYv8c/yun9DAJJh
         WqttI/0IE8EWDAAiiF91zwBeIW4Jhcqjy0lx9ZTekF5fSSuRE8/X8f2u/VN/rGcT4+c2
         PNfA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <73c72914-e27d-b261-e040-2dd31e8a6b9f@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, ming.lei@redhat.com, mkoutny@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On Wed, Aug 24, 2022 at 09:15:32AM +0800, Yu Kuai wrote:
> This patch actually set two flags when bio is throttled and
> dispatched, and only iops flag is cleared after the original bio is
> split. If only one flag can be used, the way that I come up with is
> that let iops limit become default, which means bio is always counted
> for iops limit each time blk_throtl_bio() is called. I'm not quite
> sure yet if iops limit can be counted excessively this way in some
> special scenario...

I don't think we have a path where we clone and re-submit other than
splitting. What do you think about renaming the flag to BIO_BPS_THROTTLED
and just assuming that IOPS is always applied?

Thanks.

-- 
tejun
