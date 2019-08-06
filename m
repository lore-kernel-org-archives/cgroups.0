From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] bdi: Add bdi->id
Date: Tue, 6 Aug 2019 16:01:02 -0700
Message-ID: <20190806160102.11366694af6b56d9c4ca6ea3@linux-foundation.org>
References: <20190803140155.181190-1-tj@kernel.org>
        <20190803140155.181190-3-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565132464;
        bh=vGl/qyUj+m3xdNJaJ9fF/HjSzIEZvTJK5xJjIUiHOxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ram+yxpjoZZlMPdi2p/p8wC9xbLXU244ul4IK2w7JME7Dob0R4Qy/D1hsmAvZ0GDM
         lPuIhCuLFw5/g2cagStWN5Eua65k6HVxgrIAfPon7hrUHTVSJGBaJH22M3WDg17C6L
         TdVf/pEW1LNxxYciU9FWLJmB9xyejRP00N6oKK4k=
In-Reply-To: <20190803140155.181190-3-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, guro@fb.com

On Sat,  3 Aug 2019 07:01:53 -0700 Tejun Heo <tj@kernel.org> wrote:

> There currently is no way to universally identify and lookup a bdi
> without holding a reference and pointer to it.  This patch adds an
> non-recycling bdi->id and implements bdi_get_by_id() which looks up
> bdis by their ids.  This will be used by memcg foreign inode flushing.

Why is the id non-recycling?  Presumably to address some
lifetime/lookup issues, but what are they?

Why was the IDR code not used?

> I left bdi_list alone for simplicity and because while rb_tree does
> support rcu assignment it doesn't seem to guarantee lossless walk when
> walk is racing aginst tree rebalance operations.
> 
> ...
>
> +/**
> + * bdi_get_by_id - lookup and get bdi from its id
> + * @id: bdi id to lookup
> + *
> + * Find bdi matching @id and get it.  Returns NULL if the matching bdi
> + * doesn't exist or is already unregistered.
> + */
> +struct backing_dev_info *bdi_get_by_id(u64 id)
> +{
> +	struct backing_dev_info *bdi = NULL;
> +	struct rb_node **p;
> +
> +	spin_lock_irq(&bdi_lock);

Why irq-safe?  Everywhere else uses spin_lock_bh(&bdi_lock).

> +	p = bdi_lookup_rb_node(id, NULL);
> +	if (*p) {
> +		bdi = rb_entry(*p, struct backing_dev_info, rb_node);
> +		bdi_get(bdi);
> +	}
> +	spin_unlock_irq(&bdi_lock);
> +
> +	return bdi;
> +}
> +
>
> ...
>
