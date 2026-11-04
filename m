Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793790181;
	b=lszE6PbnCzn8eNf7htB1+FG2YG2UqR8qQ4/ezl+VMeHxrxvgzeRK7QgRdn7f6W8lRhP2
	 q/2gLf9gPjwqTCs6wTSfMI6C2bUzbP1AY9a9plvYPqVrxZ2za+rpV2iro43ctLEPLPVKA
	 GxvtShULdlkgp6veF7QOJKf/UKn/ox4FlrIxlnu3o1mGjXPIEATBWczOGoJjBWyjnqMF7
	 LC60z8NqDG6tyLLhazNKt2KHad0d25Li2oXTZ0TjdGjlxXudskzdrnr6pTAGsM/VnLlEi
	 57LtyAEEk0PmQrtQJGUJN0yesBOjbmTVZ6nA5kqbess8FvBAc2RbtFwJnNMR9jUurig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793790181;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=MmAAu5i6ADNm9DWcT6htUpjVYsuBgc5FPA1Ofa2D4uU=;
	b=BE1ah5/b9qzi95J4YsS3I1/KXVNoIfNGmas8vMS5UV2js9mF1lVfda8oEqIZ73CkbJ0P
	 rhSMc/UrUVaaGOOS0BrXoxWjpNDpGwkfbcnU7VWQg31Xj2mNd2Ig8REOBMIewVNPSDnTa
	 YtBbcRSl/Rj8XkwGz1OiHaY24+flz9oJ0LpCnaYN3PGQd04GHt20Pn+5e+SCxgdv0sYpW
	 hhOczsgRXt9xhl5HuOVebqMHRczUYw5WzpDd3ljapyTZjbLATQ/JB6r63zu3amOBCeloi
	 Z9nNxXY7q2EwTPoeJi+nSstpwtDfBmWrmk1ojk0npLF/V8DjSrIqjcoVwZ/hlRGL75g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUzV4Hv2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D34606A31B;
	Wed,  4 Nov 2026 11:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SUzV4Hv2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98D11F000C1;
	Wed,  4 Nov 2026 11:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793790180;
	bh=MmAAu5i6ADNm9DWcT6htUpjVYsuBgc5FPA1Ofa2D4uU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SUzV4Hv2uoryb9Q24Qln7PLzOfILm3kcqdwfobU3M4CtRlVN+xvpdBz65WTxlF/gG
	 8zP5EQSJRfHEWirYplJxgwJ29EazRs1Mtzvxmn9j/5BRuUCriKNjEQ6vWa85IZ7zvE
	 WuILPXj4mRjIbJhGR3aqB1qDZw9j/RFjbb8AafNxTetksy2ejxRbqHLTQ4RvqYD9jb
	 O6hf0LTX03ok0deyQOvKIkyVnEJ0dhPdL49nmq+b6ZSKK7ln/bUJ6qWmoIrk5VacIF
	 naGDLX+xTp/LHq6a1qbMWKniZntZ//3XK//oLTIAOMcf6eoMlnZhva7GG2ft0UJFOs
	 uJq1G/yQE/gmg==
Message-ID: <b181dade-ffa1-4b58-9927-8a2429a59ac1@kernel.org>
Date: Wed, 4 Nov 2026 12:02:55 +0100
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next-fixes v2 1/5] mm/memcontrol: defer
 obj_cgroup_release() to irq_work
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-1-19167cfe4779@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-1-19167cfe4779@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/26 15:47, Harry Yoo (Meta) wrote:
> obj_cgroup_put() can be called from any context.
> __memcg_slab_free_hook() puts a per-object reference on
> every accounted free, and draining a per-cpu objcg stock slot puts
> the cached reference. When it drops the last reference,
> obj_cgroup_release() takes objcg_lock, frees percpu memory
> (pcpu_lock, via percpu_ref_exit()) and calls kfree_rcu(). Each of
> these can deadlock when the current context interrupted a holder of
> the respective lock.
> 
> Defer the release to irq_work. llist_add() and irq_work_queue() are
> NMI-safe, and the irq_work runs in a context where acquiring a
> spinlock is allowed.
> 
> Add a separate llist_node instead of reusing the list/rcu union
> because the list stays linked until the deferred release. struct
> obj_cgroup grows from 56 to 64 bytes, but both are served from
> kmalloc-64, so no memory is additionally consumed.
> 
> Closes: https://lore.kernel.org/20261001044056.75079-3-kmehltretter@gmail.com
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

I guess releasing objcg isn't too frequent, so it won't matter that we make
all cases use the defered work instead of somehow trying to do that only in
contexts that would really need it.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

since memcg tree will be used from the next cycle, we can just keep this as
part of the series in the slab tree?

> ---
>  include/linux/memcontrol.h |  2 ++
>  mm/memcontrol.c            | 27 ++++++++++++++++++++++++---
>  2 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69e1bcc67c58..4d5c634daef8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -185,6 +185,8 @@ struct obj_cgroup {
>  		struct list_head list; /* protected by objcg_lock */
>  		struct rcu_head rcu;
>  	};
> +	/* Used to defer obj_cgroup_release() to irq_work */
> +	struct llist_node release_node;
>  	bool is_root;
>  };
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b..c53147a88580 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -147,9 +147,8 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
>  		memcg_uncharge(memcg, nr_pages);
>  }
>  
> -static void obj_cgroup_release(struct percpu_ref *ref)
> +static void __obj_cgroup_release(struct obj_cgroup *objcg)
>  {
> -	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
>  	unsigned int nr_bytes;
>  	unsigned int nr_pages;
>  	unsigned long flags;
> @@ -190,10 +189,32 @@ static void obj_cgroup_release(struct percpu_ref *ref)
>  	list_del(&objcg->list);
>  	spin_unlock_irqrestore(&objcg_lock, flags);
>  
> -	percpu_ref_exit(ref);
> +	percpu_ref_exit(&objcg->refcnt);
>  	kfree_rcu(objcg, rcu);
>  }
>  
> +static LLIST_HEAD(objcg_release_llist);
> +
> +static void objcg_release_workfn(struct irq_work *work)
> +{
> +	struct llist_node *head = llist_del_all(&objcg_release_llist);
> +	struct obj_cgroup *objcg, *tmp;
> +
> +	llist_for_each_entry_safe(objcg, tmp, head, release_node)
> +		__obj_cgroup_release(objcg);
> +}
> +
> +static DEFINE_IRQ_WORK(objcg_release_work, objcg_release_workfn);
> +
> +static void obj_cgroup_release(struct percpu_ref *ref)
> +{
> +	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
> +
> +	/* The last put may come from a context that cannot take spinlocks */
> +	if (llist_add(&objcg->release_node, &objcg_release_llist))
> +		irq_work_queue(&objcg_release_work);
> +}
> +
>  static struct obj_cgroup *obj_cgroup_alloc(void)
>  {
>  	struct obj_cgroup *objcg;
> 

