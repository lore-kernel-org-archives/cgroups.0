From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2 RESEND] cfq-iosched: Fix wrong children_weight calculation
Date: Wed, 27 Aug 2014 08:10:31 -0600
Message-ID: <53FDE6D7.205@kernel.dk>
References: <1409128352.11712.2.camel@ubuntu-vm-makita>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409128352.11712.2.camel@ubuntu-vm-makita>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

On 08/27/2014 02:32 AM, Toshiaki Makita wrote:
> cfq_group_service_tree_add() is applying new_weight at the beginning of
> the function via cfq_update_group_weight().
> This actually allows weight to change between adding it to and subtracting
> it from children_weight, and triggers WARN_ON_ONCE() in
> cfq_group_service_tree_del(), or even causes oops by divide error during
> vfr calculation in cfq_group_service_tree_add().
> 
> The detailed scenario is as follows:
> 1. Create blkio cgroups P and P's child C.
>    Set P's weight to 500 and perform some I/O to apply new_weight.
>    This P's I/O completes before starting C's I/O.
> 2. C starts I/O and cfq_group_service_tree_add() is called with C.
> 3. cfq_group_service_tree_add() walks up the tree during children_weight
>    calculation and adds parent P's weight (500) to children_weight of root.
>    children_weight becomes 500.
> 4. Set P's weight to 1000.
> 5. P starts I/O and cfq_group_service_tree_add() is called with P.
> 6. cfq_group_service_tree_add() applies its new_weight (1000).
> 7. I/O of C completes and cfq_group_service_tree_del() is called with C.
> 8. I/O of P completes and cfq_group_service_tree_del() is called with P.
> 9. cfq_group_service_tree_del() subtracts P's weight (1000) from
>    children_weight of root. children_weight becomes -500.
>    This triggers WARN_ON_ONCE().
> 10. Set P's weight to 500.
> 11. P starts I/O and cfq_group_service_tree_add() is called with P.
> 12. cfq_group_service_tree_add() applies its new_weight (500) and adds it
>     to children_weight of root. children_weight becomes 0. Calculation of
>     vfr triggers oops by divide error.
> 
> weight should be updated right before adding it to children_weight.

I already queued up the previous one yesterday. I'd welcome the
comments, but could you send them against the previous one?

-- 
Jens Axboe
