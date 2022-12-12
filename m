From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2 block/for-6.2] blk-iolatency: Fix memory leak on
 add_disk() failures
Date: Mon, 12 Dec 2022 00:47:57 -0800
Message-ID: <Y5bqvWdDa5MW7w3v@infradead.org>
References: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pUS0fRVuVl28efMmBL1cfrJsUvoRpvkefUc506NhvMs=; b=C3JZ2MLMHV9lxb2dpe3XDzlN9m
        UtvdwvY9w6C7R1gTQTR87vhICvE8PlmEhX889b/IHQN4NVCbIFZgdov+9GfE2XOslvUcpBrusCrpQ
        M3mQdPNaiKDPoYeUD2Ye4ClUOPiNsemr6TmMNZeLq92zFE2zNulIjC49Wdnb25YQtKEjVraqfVnzz
        5mErGIlhBGmw6zoPts2sPGEAUGp4ynvM7h5MorgNEOILbbvcjuxVBd3/biQY6CnhkAPxewO6ohptw
        p0nnRdi6aegVspDWUwK67iBdYVm+D4SbSimbEDZ/wPoz6vEXiPFI/8hyMMDkCLOe6IasufH4uDb6j
        s6RWk0oQ==;
Content-Disposition: inline
In-Reply-To: <Y5TQ5gm3O4HXrXR3-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darklight2357-mVuRI66OGLPQT0dZR+AlfA@public.gmane.org, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 10, 2022 at 08:33:10AM -1000, Tejun Heo wrote:
> When a gendisk is successfully initialized but add_disk() fails such as when
> a loop device has invalid number of minor device numbers specified,
> blkcg_init_disk() is called during init and then blkcg_exit_disk() during
> error handling. Unfortunately, iolatency gets initialized in the former but
> doesn't get cleaned up in the latter.
> 
> This is because, in non-error cases, the cleanup is performed by
> del_gendisk() calling rq_qos_exit(), the assumption being that rq_qos
> policies, iolatency being one of them, can only be activated once the disk
> is fully registered and visible. That assumption is true for wbt and iocost,
> but not so for iolatency as it gets initialized before add_disk() is called.
> 
> It is desirable to lazy-init rq_qos policies because they are optional
> features and add to hot path overhead once initialized - each IO has to walk
> all the registered rq_qos policies. So, we want to switch iolatency to lazy
> init too. However, that's a bigger change. As a fix for the immediate
> problem, let's just add an extra call to rq_qos_exit() in blkcg_exit_disk().
> This is safe because duplicate calls to rq_qos_exit() become noop's.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: darklight2357-mVuRI66OGLPQT0dZR+AlfA@public.gmane.org

Looks good:

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
