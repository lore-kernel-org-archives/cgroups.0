Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869195;
	b=jQja6/sFmfijt/H+0TDEl01Uij0NdaDdVhMpLYc0/gYFy6QjQfSUBmLfo/A8wpoXk+1d
	 0IxfYKdcyVf1NLAMplGtxe1bp4c3cOaJmuu01gApN8kiH7Xn8V0lMlq8GuJvhoBi5CtJr
	 Qcb++tFmN+eIo/mdHZD45xtlTxb+BF9VkFM/1JI/aIQs9OM00pSCzKPJiG+ZS5mqPNfLK
	 RCgEpK6jWuZ0q+5zZpcdF5aoWgkxPOYy7PKcAQZE0GkhuLm9H1/lkGbo0a5MN4VJJ2pZ6
	 +OMkHvf1PX5Zhjru/lFX0n1lEYrWFrC4rUo7zfmU4CUJ3Jy0oSA+oQZRu3VbSNyUGsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869195;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jqSwoAjsDQRdlLqv7HFSYNZ2dAycXMwZNoLGHbmfdsw=;
	b=J+q6xif0AUu8Hdp8v/aeeVOUlX0gpa/Uf4R+bYKkrToZsWVPZ42kDogxcq3Al1AbkmQd
	 ot1xfd1uErOOpEEKNxOijFATw016MKYogTTAaFReGXM4yhntgEn80Ijo42pmIUDxnQ7D2
	 vjUoaFZGn9QPyGCOeLdK/guvaJ+T0q75peY6nY+8hmMTeVTQ0f02UdSiWM8v2rp0Ocf4n
	 qT+vplNQitk5saVuRMIzriqBnSkbzL9CBOmWqoH49G0REdn2sHnwFQRtR3s1aGXVEp0RW
	 ZITjNsFGMp/jxnct4bNojQsYi1O0wddRh9+gXuQbr1LT2Ca1dOBaSbxdRtRnnAHZ8rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B8A606A323;
	Mon, 16 Nov 2026 22:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82B8A606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6663260D56; Mon, 16 Nov 2026 23:46:32 +0100 (CET)
Date: Mon, 16 Nov 2026 23:46:29 +0100
From: Florian Westphal <fw@strlen.de>
To: alireza@asgari.net
Cc: netfilter-devel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Zhang Jiao <zhangjiao2@cmss.chinamobile.com>,
	Song Hu <husong@kylinos.cn>, cgroups@vger.kernel.org,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC nf-next 6/9] netfilter: nfqueue: account saved skb
 bytes per queue
Message-ID: <avuHxb9In-dIYj_G@strlen.de>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
 <20261115-b4-nfqueue-memory-accounting-v1-6-b9cc30819997@asgari.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-6-b9cc30819997@asgari.net>

Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org> wrote:
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -92,6 +92,8 @@ struct nfqnl_instance {
>  	unsigned int	queue_total;
>  	unsigned int	id_sequence;		/* 'sequence' of pkt ids */
>  	struct list_head queue_list;		/* packets in queue */
> +	u64 mem_limit;
> +	u64 mem_used;

I think u32 is fine for those.  Or do you see a use case for 2**32 mbyte
worth of queued packets?

> +/* All release paths use the saved admission cost, including notification undo. */
> +static void nfqnl_mem_uncharge(struct nfqnl_instance *queue,
> +			       struct nf_queue_entry *entry)
> +{
> +	lockdep_assert_held(&queue->lock);
> +	queue->mem_used -= entry->truesize;
> +	entry->truesize = 0;
> +}
> +
>  static struct nfqnl_instance *
>  instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  {
> @@ -152,6 +176,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
>  	inst->queue_num = queue_num;
>  	inst->peer_portid = portid;
>  	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
> +	inst->mem_limit = nfqnl_mem_limit(NFQNL_QMAX_DEFAULT);
>  	inst->copy_range = NFQNL_MAX_COPY_RANGE;
>  	inst->copy_mode = NFQNL_COPY_NONE;
>  	spin_lock_init(&inst->lock);
> @@ -199,6 +224,7 @@ static void instance_destroy_work(struct work_struct *work)
>  	rcu_read_lock();
>  	nfqnl_flush(inst, NULL, 0);
>  	rcu_read_unlock();
> +	WARN_ON_ONCE(inst->mem_used);

I'd suggest DEBUG_NET_WARN_ONCE() here, unless you have a strong
preference/reason for a full splat here.
