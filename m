From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 04/13] blkcg: introduce common blkg association logic
Date: Thu, 29 Nov 2018 07:49:17 -0800
Message-ID: <20181129154917.GD2509588@devbig004.ftw2.facebook.com>
References: <20181126211946.77067-1-dennis@kernel.org>
 <20181126211946.77067-5-dennis@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kz3dlz6bQKYwlGklFZS+mfDThvjV457sQrSsgWVJFng=;
        b=vN0j/r2RslOzzzUxYdvwqlYZlvRszVNX/btGSlpATxyvpI2/Y1pAMV2uPkrqvMXoRX
         nHvwy8NXinkgfGCnhQ/YrbWcp6fTQgua/fKOSIOV4Zbfc2ZXokJLb9KVvud3NSHxIQBa
         G0mIw1neHBa0XvVR5ROuv38YIPOMuumXHjVlZOTntH6BsRCtGBY+sm/YNwgMpBlKxKvi
         1ywaWVeJdQjR4soDpb/sifDolAYXlLTKJY6E5ENC+gBsrDp+TMuTAviQiuqO1xd8cYnR
         kvOq7NIdbQwSudVxpf42O1AHmetw5cm07OE9afOESCLEzlpskjuXg+EyVIo+HoGxleZ+
         43Cg==
Content-Disposition: inline
In-Reply-To: <20181126211946.77067-5-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 26, 2018 at 04:19:37PM -0500, Dennis Zhou wrote:
> There are 3 ways blkg association can happen: association with the
> current css, with the page css (swap), or from the wbc css (writeback).
> 
> This patch handles how association is done for the first case where we
> are associating bsaed on the current css. If there is already a blkg
> associated, the css will be reused and association will be redone as the
> request_queue may have changed.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

A minor nit below.

> +/**
> + * bio_associate_blkg - associate a bio with a blkg from q
> + * @bio: target bio
> + *
> + * Associate @bio with the blkg found from the bio's css and request_queue.
> + * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
> + * already associated, the css is reused and association redone as the
> + * request_queue may have changed.
> + */
> +void bio_associate_blkg(struct bio *bio)
> +{
> +	struct request_queue *q;
> +	struct blkcg *blkcg;
> +	struct blkcg_gq *blkg;
> +
> +	if (!bio_has_queue(bio))
> +		return;

So, this isn't actually necessary cuz we don't stack with
request_queues but it might be more consistent to call disassociate
before returning above so that even if sth like that happens the
function always guarantees that the blkg and bio agree.

Thanks.

-- 
tejun
