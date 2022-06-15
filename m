From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] block: update comment for blkcg_init_queue
Date: Tue, 14 Jun 2022 23:18:42 -0700
Message-ID: <Yql5wrthJvZDwWjq@infradead.org>
References: <20220614100556.20899-1-guoqing.jiang@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rQwWDOk1Ek8zy1OBl1F+0AXgLUzVzQYKZPN8/Z82aqU=; b=F4AyYAO+fhSl4fozyxP+wCmf4A
        +rmuTeJrUzZGAs5q5Tidvwg3Hef342hpE/2CVW2L/1j29EcTiwCXIlDs728azaQN8/wpjbIl0Yzmh
        w1cmDGx0oF9llw/EhoKmiO36sNNXUbpo+MhgQV4nsOxK/s7JzwueFONQbiZVwMYnQY4xp9pAzY+3+
        ocEeifSDHo9wf00a2ZON2dmp7RI7xieBwgzInXNoZeVUg7Si1I5vXS/J7MlqRC2jET/ShAnIdqcdV
        3j1cQm0IlrqNouYrRp747W3jrkoAFm6Ft6720efZ4+aY51HmpG+eEkVbot1pK4pGpbURWd9x3GFi1
        GrTxf3dg==;
Content-Disposition: inline
In-Reply-To: <20220614100556.20899-1-guoqing.jiang-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Guoqing Jiang <guoqing.jiang-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 14, 2022 at 06:05:56PM +0800, Guoqing Jiang wrote:
> It was called from __alloc_disk_node since commit 1059699f87eb ("block:
> move blkcg initialization/destroy into disk allocation/release handler).
> Let's change the comment accordingly.

Well, the right things is to simply drop this comment.  I do have
a large series toucing it and removing it, so maybe we can wait
until that?
