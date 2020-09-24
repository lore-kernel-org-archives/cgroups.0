From: Jens Axboe <axboe@kernel.dk>
Subject: Re: bdi cleanups v7
Date: Thu, 24 Sep 2020 13:44:54 -0600
Message-ID: <a9235ba9-95a0-4251-ee7d-e4012775346e@kernel.dk>
References: <20200924065140.726436-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ADwlTn9rnJzlHv/xfLefERCgTh/zOY3+dj+IP5LMhIo=;
        b=L2Wx7FlLw8QHVp62Ne3mt4GV7+MUCO/WLUazgDqXAmYbUX1Et5GwKUZRbOhKWcg1pJ
         h3F8YG2QH8T53HlhbxkOnKDq7rYr7VYQSpBZ/SrGKbAAN0q9gjlZztvIvkLYWYD2H5p5
         D5jWhUDJxNaNV9x10hDsgdYsv3+GqUJuih92RXGRYnyEyog4jlWpFA8o+B+sqtqEeysu
         zXsVFR5QGsEI7lJZ39JHqx1JjZyubGP7QEwNsybW+JHQWulohPcvjDgNlPxNi7sQOhp+
         YLXR3ph4QhgGStegDp9ue2849D7tWES5wOYPeY73GujeWcYMaP3DsMTgcgakPfQ8C4Iw
         pmzA==
In-Reply-To: <20200924065140.726436-1-hch@lst.de>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On 9/24/20 12:51 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series contains a bunch of different BDI cleanups.  The biggest item
> is to isolate block drivers from the BDI in preparation of changing the
> lifetime of the block device BDI in a follow up series.

Applied, thanks.

-- 
Jens Axboe

