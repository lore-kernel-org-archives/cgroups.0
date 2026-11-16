Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871036;
	b=q8tLCo5Y+hDK9P11urBy0IWUcs4wOO8dVYERj3nLOUeZt0RAqsxH5LRH2CHkZ5P8b/Br
	 uA0W+iAud/Gz0h3Ot0iaIJnt0p9KaoArGrJj/GYtuImfIRlNzsX0kg4VvGGksZdKT7PZ5
	 DQTc2Z5oXR16+DZT/Exg+tY6Ec4IGd3BGtBIRTOhD6yBS5FCTj5ZsvOQa+I0+J1k8BCQC
	 /RC89nKaGFX7yTkr+ttNmTBv8J8MDf2StSQry/shtMhHteHow9679mepPKTFZ6d27o05b
	 kPI6B44PPYmaFvsDYsTOFI/Ttw0TZF/GcQliyskFyb3+AnkoeOWTyHCzryL6SvKWxGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871036;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lBMZHfw7i4eJx0zD4VQ6/+RNNcDSsfzhNT1NDQ8/k0U=;
	b=XfAlAmJkpbGMqNThMMsUE3r3OWTjhQzdzdkOEV5afSvwoWSi7bqJGmpX6U7OZfKnd8K9
	 Vowr4c9jtgGoxf+I/6dT6SAN1KuuFeScg0+W0tNUSbGNP7QFO1XE7AzLxCh/CxDRmUL24
	 t0FeI/0vUmt/FhIx5jNuDaFtHB5TPdhyGS0uRr8NTtSjRBkN00//6kluw2Vw23YBNLx7E
	 890FbrOxKyxjDk0wcq1A09GfEIXHpg1SKTJUxRiovUHeJRlDDUILn2C1ZC/iF5TwGwwpd
	 +/Q9/M3e/qtBw7W7HtGdo+KYdDyxDYc9WSso3H+TEXWNLZZ8JilVH6PwTP9JtnSW17A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B09606A31C;
	Mon, 16 Nov 2026 23:17:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7B09606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1421760342; Tue, 17 Nov 2026 00:17:13 +0100 (CET)
Date: Tue, 17 Nov 2026 00:17:09 +0100
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
Subject: Re: [PATCH RFC nf-next 7/9] netfilter: nfqueue: reserve capacity
 against the bound owner
Message-ID: <avuO9UUriolRoRg8@strlen.de>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
 <20261115-b4-nfqueue-memory-accounting-v1-7-b9cc30819997@asgari.net>
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
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-7-b9cc30819997@asgari.net>

Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org> wrote:
> +static void nfqnl_mem_refund(struct nfqnl_instance *queue)
> +{
> +	u64 pages;
> +
> +	lockdep_assert_held(&queue->mem_mutex);
> +	spin_lock_bh(&queue->lock);
> +	pages = nfqnl_mem_pages(max(queue->mem_limit, queue->mem_used));
> +	spin_unlock_bh(&queue->lock);
> +
> +	if (pages >= queue->memcg.pages)
> +		return;
> +
> +	/* Shrinking cannot fail. Keep the packet-path copy conservative meanwhile. */
> +	mem_cgroup_reservation_resize(&queue->memcg, pages);
> +	spin_lock_bh(&queue->lock);
> +	queue->mem_reserved = pages;
> +	/* A final drain may have happened while the refund was in progress. */
> +	if (!queue->mem_stopping &&
> +	    pages > nfqnl_mem_pages(max(queue->mem_limit, queue->mem_used)))
> +		queue_work(nfq_cleanup_wq, &queue->mem_work);
> +	spin_unlock_bh(&queue->lock);
> +}
> +
> +static void nfqnl_mem_work(struct work_struct *work)
> +{
> +	struct nfqnl_instance *queue =
> +		container_of(work, struct nfqnl_instance, mem_work);
> +
> +	mutex_lock(&queue->mem_mutex);
> +	nfqnl_mem_refund(queue);
> +	mutex_unlock(&queue->mem_mutex);
> +}

This is rather complex, do we really need all of this extra machinery?

I had hoped we could do the memcg equivalent of

vmalloc(4 * 1024 * 1024, GFP_KERNEL_ACCOUNT);
on queue creation / instantiation, and vfree() on instance destruction.

The only minor inconvenience is queue limit reconfiguration.  But that
also happens from process context, so it should be enough to just
do the equivalent of vrealloc; or, if memcg precharge cannot easily
support that, just vmalloc, then vfree(old).
