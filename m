Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8A72FDC28;
	Wed, 29 Jul 2026 09:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318376; cv=none; b=KLTvXLMHS03L3msghxshj0KaRgHdClnD05cCPKC+ROxImz5957COE7tYTWg/RKxRSgDU94zL7K2h7Ae5KgV6avg5dy0wRLrS1/YSUONAXuxdtHUgdy1Z8mH77BMfoUlTT0FceEhQJ5uZ08EXe+yM/y+X3Nhfxa268JDuPcP5nug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318376; c=relaxed/simple;
	bh=GMsoI8obxs7Jnu5IR0nC98YgWcF5sPTPGRv0HQMosoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JT3KQAHm5A5YZlxgPLSVMrLWceIItQVQkADRnqLcn0PWhshYDnOyOMkPfjO60rRMdizFj3ZxfeMQA007LXplAAuFwemtT0VbtxIF7l3vTvOw3xNCsUdDGUqNcDoTGeSQXX+ggmsh5jvHD1dP7e0yv+KrpdHfnsI9jxcZcQrScDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V19wazKL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V19wazKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC43A1F000E9;
	Wed, 29 Jul 2026 09:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785318375;
	bh=E7rPxALTKK7Txz1MCTwebeGpX5bzL/i/vLYui1u0ffY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V19wazKLOp6RZkUtSjNDmzHzKEfwQSNjcp6NByfAVngPZ0F6yzYVlqqkdelSC2hhG
	 3QTantQ+D9kN69D1kwsFw1Wv6WID3xWN0+FMRT47gVBUUxqcpjBKhkbDotL7CWGf4z
	 X+hgMNOwVcULaAja0DyLZI2q/w1HT/Ch6ZePWc1QO3SVlCCj1qCJKtXJuAquvmTFjA
	 bD46Ggr+9OlrrRCk9dPF/JGcdBtsK8mvUES3FnHa+6u2Pj/Y2TXtuT9TK2pQAP67Pj
	 bhoQrJAC9ebDHtFNz2dAN3FkGZzbRdAP8YwbLU2Q8mKMvFhcZZVZ2PwgUmpmvvl/nO
	 kkQeyh+iGv7qw==
Message-ID: <aa23851a-5f64-4f01-8804-07b735fc8afe@kernel.org>
Date: Wed, 29 Jul 2026 11:46:11 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
 <amivCT7AaPux-GSK@thinkpad> <365d8e50-5aeb-45e9-97a3-87d0024cdc5f@kernel.org>
 <ammZpX_77SMsxvPz@dev>
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
In-Reply-To: <ammZpX_77SMsxvPz@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/29/26 08:18, Harry Yoo wrote:
>> diff --git a/mm/slab.h b/mm/slab.h
>> index 8f352d9f4d91..fbad99da093c 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -726,6 +726,8 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
>>  static inline union codetag_ref *
>>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
>>  {
>> +       VM_WARN_ON_ONCE(!slab_obj_ext_has_codetag());
>> +
>>         if (IS_ENABLED(CONFIG_MEMCG))
>>                 obj_ext += 1;
>>  
>> ... and for objcg we would need to start passing slab pointer to
>> slab_obj_ext_objcg() and slab_obj_ext_set_objcg(). Hmm...
> 
> But slab_obj_ext_codetag_ref() already takes the parameter to
> calculate offset. I think it's worth as it'll be optimized away on
> non-debug kerenels and there is no way to detect type confusion
> due to subtle errors in the objext layout.

OK, so updated to this. VM_WARN_ON_ONCE() added later.

From db9c3501c0f9747fda8fa92d4f640b6fac8050e0 Mon Sep 17 00:00:00 2001
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:59 +0200
Subject: [PATCH] mm/slab: abstract slabobj_ext.objcg access

In preparation for changes to the structure, abstract getting and
setting the objcg field with slab_obj_ext_objcg() and
slab_obj_ext_set_objcg().
Rename the field to _objcg to make an unexpected direct access a compile
error.

The helpers take a slab pointer, which is currently unused, but will be
used by a debug check later.
Since there is no slab pointer easily available in __kfence_free(), just
drop the debug check there. The whole memcg_kmem accounting in kfence is
to be removed later anyway.

Otherwise, no functional change intended.

Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Link: https://patch.msgid.link/20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c |  3 ---
 mm/memcontrol.c  | 14 ++++++++------
 mm/slab.h        | 17 ++++++++++++++++-
 mm/slub.c        |  2 +-
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 6577bd76954e..5608a37f2b4d 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -1248,9 +1248,6 @@ void __kfence_free(void *addr)
 {
 	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
 
-#ifdef CONFIG_MEMCG
-	KFENCE_WARN_ON(meta->obj_exts.objcg);
-#endif
 	/*
 	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
 	 * the object, as the object page may be recycled for other-typed
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4e427286a88a..68e98fb3350e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2865,6 +2865,7 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	 */
 	unsigned long obj_exts;
 	struct slabobj_ext *obj_ext;
+	struct obj_cgroup *objcg;
 
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
@@ -2872,9 +2873,8 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 
 	get_slab_obj_exts(obj_exts);
 	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
-	if (obj_ext->objcg) {
-		struct obj_cgroup *objcg = obj_ext->objcg;
-
+	objcg = slab_obj_ext_objcg(slab, obj_ext);
+	if (objcg) {
 		put_slab_obj_exts(obj_exts);
 		return obj_cgroup_memcg(objcg);
 	}
@@ -3614,8 +3614,10 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		obj_exts = slab_obj_exts(slab);
 		get_slab_obj_exts(obj_exts);
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
+
 		obj_cgroup_get(objcg);
-		obj_ext->objcg = objcg;
+		slab_obj_ext_set_objcg(slab, obj_ext, objcg);
+
 		put_slab_obj_exts(obj_exts);
 	}
 
@@ -3633,11 +3635,11 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 		struct obj_stock_pcp *stock;
 
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
-		objcg = obj_ext->objcg;
+		objcg = slab_obj_ext_objcg(slab, obj_ext);
 		if (!objcg)
 			continue;
 
-		obj_ext->objcg = NULL;
+		slab_obj_ext_set_objcg(slab, obj_ext, NULL);
 
 		stock = trylock_stock();
 		__refill_obj_stock(objcg, stock, obj_size, true);
diff --git a/mm/slab.h b/mm/slab.h
index 451b50b7f237..ea014311e29f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
  */
 struct slabobj_ext {
 #ifdef CONFIG_MEMCG
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *_objcg;
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 	union codetag_ref ref;
@@ -662,6 +662,21 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 	return kasan_reset_tag(obj_ext);
 }
 
+#ifdef CONFIG_MEMCG
+static inline struct obj_cgroup *
+slab_obj_ext_objcg(struct slab *slab, struct slabobj_ext *obj_ext)
+{
+	return obj_ext->_objcg;
+}
+
+static inline void
+slab_obj_ext_set_objcg(struct slab *slab, struct slabobj_ext *obj_ext,
+		       struct obj_cgroup *objcg)
+{
+	obj_ext->_objcg = objcg;
+}
+#endif
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags);
 
diff --git a/mm/slub.c b/mm/slub.c
index a74f1866c958..ed18860fa0fd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2526,7 +2526,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	if (obj_exts) {
 		get_slab_obj_exts(obj_exts);
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p);
-		if (unlikely(obj_ext->objcg)) {
+		if (unlikely(slab_obj_ext_objcg(slab, obj_ext))) {
 			put_slab_obj_exts(obj_exts);
 			return true;
 		}
-- 
2.55.0


