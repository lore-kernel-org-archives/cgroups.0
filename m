From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 29.5/32] blk-throttle: add throtl_qnode for dispatch
	fairness
Date: Fri, 3 May 2013 17:53:58 -0700
Message-ID: <20130504005325.GG22860@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
	<20130504005044.GF22860@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=eFlqEL1oQjV17pYdhTAECbtDx9eY3i+d0Y1HGK3E3vc=;
	b=yv+JKGDQxEN8hzlimHjqSEFUKBjKIjgrnG6DYhCogZ8VP6DVFRTPKIlpfhaUlXmVeh
	y9ds4byEZg0k63X4Ci4/CW6f7j8oWt+WNoVJ2SqMqflAqCVQVqCjKKAyr6CiDHWAfhE9
	NHgSBowj3G8wXbaAY6HaGXlVGr3znIXuDWpOER8dpnMnYQwYvyCYpoHTN59e6R3pVrdJ
	wHQWEIy6r15UIgI8kS88mZfC02WYZAhTI7Ve1p+Z+VDi+6QPli7kP2cE3l2iwojT9ICT
	pxHKc62ieghCpOfUUPPuloukEQThrsVoCS2oujxKUB0oVmmBFzuHqNqlTTWJZPM3YpfT
	Qq3A==
Content-Disposition: inline
In-Reply-To: <20130504005044.GF22860-9pTldWuhBndy/B6EtB590w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Fri, May 03, 2013 at 05:50:44PM -0700, Tejun Heo wrote:
....
> +static struct bio *throtl_pop_queued(struct list_head *queued,
> +				     struct throtl_grp **tg_to_put)
> +{
> +	struct throtl_qnode *qn = list_first_entry(queued, struct throtl_qnode, node);
> +	struct bio *bio;
> +
> +	if (list_empty(queued))
> +		return NULL;
> +
> +	bio = bio_list_pop(&qn->bios);
> +	WARN_ON_ONCE(!bio);
> +
> +	if (bio_list_empty(&qn->bios)) {
> +		list_del_init(&qn->node);
> +		if (tg_to_put)
> +			*tg_to_put = qn->tg;
> +		else
> +			blkg_put(tg_to_blkg(tg_to_put));

Oops, this should have been

			blkg_put(tg_to_blkg(qn->tg));

Thanks.

-- 
tejun
