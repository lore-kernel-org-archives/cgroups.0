From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cfq-iosched: Fix wrong children_weight calculation
Date: Tue, 26 Aug 2014 11:46:37 -0400
Message-ID: <20140826154637.GE29286@htj.dyndns.org>
References: <1409054196-20945-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LUmfBP7zzD37Ir4aStEyrGczakwj75c8Z0/EIROSsX0=;
        b=i136LW3biRU2cpGlQuGkMEb0XiK5e3szNkb7JbkjjAR8pOKDj937355Brm1H1X4aHn
         jF3YhIPLYf5REMgnKTi5tVWFCkKrzHek43Wl/J6Ti9fRYn4GLIsUGiZKSUOa56KY9EdZ
         c2KSFWZvjTT5dmvSaMW5uLoZifGrB4EfxcyPUO/nJqG5LgKOj2RmOqBUq6B+PCUBlsKv
         VQfm53/gJ4Kzq6bPSQWuxd+uaI/BNHKjb6/6EnH+Qawo5AbFd/yfMPwfuumF3oU6EQjT
         j6n75w3j7yrPaMGOKd1XdDZJiqos9sVj0dKeMnRaE3MoP085Kp3N+poXlh8sxUOG8ORR
         ILFw==
Content-Disposition: inline
In-Reply-To: <1409054196-20945-1-git-send-email-makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 26, 2014 at 08:56:36PM +0900, Toshiaki Makita wrote:
> cfq_group_service_tree_add() is applying new_weight at the beginning of
> the function via cfq_update_group_weight().
> This actually allows weight to change between adding it to and subtracting
> it from children_weight, and triggers WARN_ON_ONCE() in
> cfq_group_service_tree_del(), or even causes oops by divide error during
> vfr calculation in cfq_group_service_tree_add().
> 
> The detailed scenario is as follows:
> 1. Create blkio cgroups X and Y as a child of X.

This is a bit confusing.  Maybe use a different letter for the parent
X?

>    Set X's weight to 500 and perform some I/O to apply new_weight.
>    This X's I/O completes before starting Y's I/O.
> 2. Y starts I/O and cfq_group_service_tree_add() is called with Y.
> 3. cfq_group_service_tree_add() walks up the tree during children_weight
>    calculation and adds parent X's weight (500) to children_weight of root.
>    children_weight becomes 500.
> 4. Set X's weight to 1000.
> 5. X starts I/O and cfq_group_service_tree_add() is called with X.
> 6. cfq_group_service_tree_add() applies its new_weight (1000).
> 7. I/O of Y completes and cfq_group_service_tree_del() is called with Y.
> 8. I/O of X completes and cfq_group_service_tree_del() is called with X.
> 9. cfq_group_service_tree_del() subtracts X's weight (1000) from
>    children_weight of root. children_weight becomes -500.
>    This triggers WARN_ON_ONCE().
> 10. Set X's weight to 500.
> 11. X starts I/O and cfq_group_service_tree_add() is called with X.
> 12. cfq_group_service_tree_add() applies its new_weight (500) and adds it
>     to children_weight of root. children_weight becomes 0. Calcularion of
>     vfr triggers oops by divide error.
> 
> weight should be updated right before adding it to children_weight.
> 
> Reported-by: Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> Signed-off-by: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Comment in the code explaining that new_weight application has to
happen only on activation would be nice tho.

Thanks.

-- 
tejun
