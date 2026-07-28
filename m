Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F24C3ACA65;
	Tue, 28 Jul 2026 17:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785260481; cv=none; b=FR5GHiASv2g6mc0kB5L7rYbsRUyni1ff1oYuaXN9zjE9+KRaqb4SaLXsUrWYRnBmVyWlchJx0MMxtJ/c45P0+NInPK8BAP340QSNSDBGEENBAeg4oUUpLPFGAM2C2BoMQuPgAdHYdz9jIKcSbRWfxRxgqN5Cim5ttMqEwmPAnyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785260481; c=relaxed/simple;
	bh=BVTnpdIgE+twlr46r77gbUzYM6j1lVYDV2wgr+02qoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dPGRzsoDgEWqriZqBS3Sn7rQo1zkXOhR8k1cpx8XUt4bAImhgkzMzDwSvk0Nhg+fbvYEGbpErzROcncg41GfxW6sexDBAImqNTzEUHR3e5fpScVaKVm6M5HlU2o7eNbv8qvWNRLc7Vd+Kn3VV8poL8ZBBzJ4memLvZIQTyEHqXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQuCOS3d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQuCOS3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FDC1F000E9;
	Tue, 28 Jul 2026 17:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785260480;
	bh=BQDHHrPTm8wUA00SAU3tWeSEWOP+J5kB/jxB8HLfcPA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lQuCOS3d1ws7UGlowjuxi/xIeEVlvuM4bUkrEBOZ6HkXbSiLWY26/U34wGWnYFniJ
	 axYfRytTmC1LQ+BYWNolzK2224KO0LrAZ2rKKXxlY5FbBOsqYN7VsljtLj0FvniKxr
	 LS/rMna4q5if94a2rREaCbeBLCVSl5PX+YLn7+YrtyqHzBi6Kuagxsjh8w7/OvitQD
	 BIZkFRoUeUT9rwEWSTqu54KZUlz8lXSTrSUKXu59nSImUPgXD5pr56/hxYYaM92ynZ
	 lMXpVgbnLfaCJ/pGaL10KWxrIT4yRU/QZixdsZMjzkeNiJnmGkzn4BDUC8TtlIb5nS
	 2VkepP6EHTkaQ==
Message-ID: <365d8e50-5aeb-45e9-97a3-87d0024cdc5f@kernel.org>
Date: Tue, 28 Jul 2026 19:41:15 +0200
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
 <amivCT7AaPux-GSK@thinkpad>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <amivCT7AaPux-GSK@thinkpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/28/26 15:41, Harry Yoo wrote:
> On Mon, Jul 27, 2026 at 02:54:00PM +0200, Vlastimil Babka (SUSE) wrote:
>> In preparation for changes to the structure, abstract access to the ref
>> field with a slab_obj_ext_codetag_ref() function. Rename the field to
>> _ctref to make an unexpected direct access a compile error.
>> 
>> No functional change intended.
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Hao Li <hao.li@linux.dev>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> With a suggestion: it would be nice to have debug warnings
> that trigger when slab_obj_ext_codetag_ref() is compiled but
> not supposed to be called.
> 
> e.g.) for kfence objects, or later in the series when we
> reduce slabobj_ext memory (!slab_obj_ext_has_codetag()) 
> 
> Similarly, it would be nice (later in the series) to have a warning
> in slab_obj_ext_objcg() when slab_needs_objcg() returns false.

OK good idea but we can't do it right now as the helpers are introduced
later.

So for 9/13 mm/slab: introduce slab_obj_ext_has_codetag():

diff --git a/mm/slab.h b/mm/slab.h
index 8f352d9f4d91..fbad99da093c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -726,6 +726,8 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 static inline union codetag_ref *
 slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
 {
+       VM_WARN_ON_ONCE(!slab_obj_ext_has_codetag());
+
        if (IS_ENABLED(CONFIG_MEMCG))
                obj_ext += 1;
 
... and for objcg we would need to start passing slab pointer to
slab_obj_ext_objcg() and slab_obj_ext_set_objcg(). Hmm...


>>  mm/slab.h | 10 +++++++++-
>>  mm/slub.c | 42 ++++++++++++++++++++++++++++--------------
>>  2 files changed, 37 insertions(+), 15 deletions(-)

