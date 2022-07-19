From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2] block: don't allow the same type rq_qos add more than
 once
Date: Tue, 19 Jul 2022 09:53:55 -0600
Message-ID: <724b2b60-d32c-0785-dfe9-79e208f8f662@kernel.dk>
References: <20220719070258.25721-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v1/mZ9f7cOQb8+ydXwQHj4wRnkN1M8Bc/FKE5w38Qoo=;
        b=TAy5/MJ1dGREUTw++0rn1OsT9njCelvr5d2NkxrRX43BITG0YKrQAyqJizhPcyflpY
         +NkzAKjawOfO12hI2a54ONGCIYwM4mGbTv3H8uADXh8QLGkgB76Hpa8koUrU3/D5yWsh
         Z7nsOAI40BxnHcTuB844wOBee7bp8nEJwl1q61tbUnrjtdP/81PyZXtG8zpVnvZ7X01O
         wqmupWWlWIM8vdG3/9/7Az9v9QdqPk192VEXnvs6RktHQ0fmvjdsca32UyWa/pIQ4qKA
         nyhXXHGUvSedFCDzOpAvxSapKw6BQz3EWLlkvk/6tR1qD8Ug5Y0qgZUxH23b606dOuK8
         mILA==
Content-Language: en-US
In-Reply-To: <20220719070258.25721-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/19/22 1:02 AM, Jinke Han wrote:
> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> In our test of iocost, we encounttered some list add/del corrutions of

encountered and corruptions

> inner_walk list in ioc_timer_fn.
> 
> The reason can be descripted as follow:

described

> cpu 0						cpu 1
> ioc_qos_write					ioc_qos_write
> 
> ioc = q_to_ioc(bdev_get_queue(bdev));
> if (!ioc) {
>         ioc = kzalloc();			ioc = q_to_ioc(bdev_get_queue(bdev));
> 						if (!ioc) {
> 							ioc = kzalloc();
> 							...
> 							rq_qos_add(q, rqos);
> 						}
>         ...
>         rq_qos_add(q, rqos);
>         ...
> }
> 
> When the io.cost.qos file is written by two cpu concurrently, rq_qos may

two cpus

> be added to one disk twice. In that case, there will be two iocs enabled
> and running on one disk. They own different iocgs on their active list.
> In the ioc_timer_fn function, because of the iocgs from two ioc have the
> same root iocg, the root iocg's walk_list may be overwritten by each
> other and this lead to list add/del corrutions in building or destorying

leads to, corruptions, destroying.

Outside of the spelling and grammer which I typically just fix up while
applying, this one doesn't apply to for-5.20/block. Please check and
resend it.

-- 
Jens Axboe

