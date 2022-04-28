From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next v4 2/3] block, bfq: refactor the counting of
 'num_groups_with_pending_reqs'
Date: Thu, 28 Apr 2022 13:23:34 +0200
Message-ID: <20220428112334.um5mnmxmm2y2oqqf@quack3.lan>
References: <20220428111907.3635820-1-yukuai3@huawei.com>
 <20220428111907.3635820-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1651145015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ALSlNdnUDfGqnVDNF+XbySa5KKZiHe5nsD1aWA9cJlQ=;
        b=Qqo62OOYsyHjfh46Geys+bzp5ZZw/H7DtsEoukKYDwWaRzoQgHT9LNdSBBtAVJ35q2QG+s
        OgC57syIbets7bbDv9VpnPnulvaIZfuIZyb1SI8/AZcFN+CLkB2RY5Y7/zduhoT5A3HfZg
        drXATWWbO/gIevBcwhXuQJfpu8BlqMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1651145015;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ALSlNdnUDfGqnVDNF+XbySa5KKZiHe5nsD1aWA9cJlQ=;
        b=nozySw/YbNaB4EEXbIQFKP2yluTxF6VXLonrNIQglDs3KxliUb9+ELxwZrRKp8B6L6AI9c
        Mng41wRfV4ecu5CA==
Content-Disposition: inline
In-Reply-To: <20220428111907.3635820-3-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu 28-04-22 19:19:06, Yu Kuai wrote:
> Currently, bfq can't handle sync io concurrently as long as they
> are not issued from root group. This is because
> 'bfqd->num_groups_with_pending_reqs > 0' is always true in
> bfq_asymmetric_scenario().
> 
> The way that bfqg is counted into 'num_groups_with_pending_reqs':
> 
> Before this patch:
>  1) root group will never be counted.
>  2) Count if bfqg or it's child bfqgs have pending requests.
>  3) Don't count if bfqg and it's child bfqgs complete all the requests.
> 
> After this patch:
>  1) root group is counted.
>  2) Count if bfqg have at least one bfqq that is marked busy.
>  3) Don't count if bfqg doesn't have any busy bfqqs.
> 
> The main reason to use busy state of bfqq instead of 'pending requests'
> is that bfqq can stay busy after dispatching the last request if idling
> is needed for service guarantees.
> 
> With this change, the occasion that only one group is activated can be
> detected, and next patch will support concurrent sync io in the
> occasion.
> 
> This patch also rename 'num_groups_with_pending_reqs' to
> 'num_groups_with_busy_queues'.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/bfq-iosched.c | 46 ++-----------------------------------
>  block/bfq-iosched.h | 55 ++++++---------------------------------------
>  block/bfq-wf2q.c    | 19 ++++------------
>  3 files changed, 13 insertions(+), 107 deletions(-)

I love the diffstat :)

> +	 * Number of groups with at leaset one bfqq that is marked busy,
				    ^^^^^ least

Otherwise the patch looks good so feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
