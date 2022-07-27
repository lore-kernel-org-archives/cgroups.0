From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND v6 5/8] blk-throttle: use 'READ/WRITE' instead of
 '0/1'
Date: Wed, 27 Jul 2022 08:39:38 -1000
Message-ID: <YuGGal0NYDkWJDro@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-6-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=LxG2FPTZCfHZ0sPfmM9/b7EFUr5JHWO+k7kdRXVsfOc=;
        b=PTpX8+xkC2yMfa6i3yo6jvZd+mQNhuldMSAWitMJGvEb5Z52tzlK6rJAHrUBcjNQgO
         i+CEuOqFKUv/qWk0eJXUPvjQ41KFNAPoDPlyEkhQMk4iEQ/JfzCV9ofHqK+RhAE+Rswo
         +ZLzYlYbpZB4yahuogO0iJQ+6tFePo1KsjqdiIalUyaaTa87I8TSXOErnoUYq0iCyE+g
         bR0msdKIRINYTAX2lTvf9LowGmpvpeGEGIi2HNgxcwpxoc7JvFNKV3+igDEMXpE23jjm
         ay+4vQ7fFRyjq5FRca66dFIXTopSqeegODXFvBY3l35s3h1ThJ/3jbiqcQcoZQz/X13d
         zFjw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220701093441.885741-6-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Fri, Jul 01, 2022 at 05:34:38PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Make the code easier to read, like everywhere else.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
