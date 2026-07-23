Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB5D33BBC0;
	Thu, 23 Jul 2026 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806388; cv=none; b=oC4j6Rmh64TIdwX7gVGVEUpeH3KTISFTzkFJk1yKSdW37aElkJuk64By6IfJnrim4uE+FrQ9anaa7AL/IPfbRG0bqR6Q+F8mJOsfXq1qnpIq0Sqx9XnL7eST0QOKyvXvnGVafDRZvvgb7Ot+TRCkYDVMwHKOWozZtFqnAz/hXiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806388; c=relaxed/simple;
	bh=O0BUA4KHtTQNqJXuAajP+x9ap7rPj0j6GJnIeOtNNw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A8Bh5kwU2keFx35eARza3BReV6uQjcanLny/y4zmS9ejD1zVOSrXHJdbPau4jlBh7Sqvt6E247Vv7GHG4ynWcr8frUNqzi1CcRnMwLxIhUl74eq5i8zbDalzy/qTSimR3sFOrB2abwVrOiSar7bNocXpUlKBeT8ULN/crVTfs5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UmK2w40M; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UmK2w40M"
Date: Thu, 23 Jul 2026 19:32:56 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4uXExJqvLMtKg00EjemEMSid0MvB4tr4xwG+35o6dDM=;
	b=UmK2w40MFyZ/JojmgRCaLx0E0N2DysqKVJWJd9B3jE/RMQy0AaK4rleRGHpRCwSpLACDZX
	2Sb1AJIWcYppgilQGqaVo6dk4+FQ/IsInEXicA3SpQZOhrN5BV2/JvU5PKopd6qyZbt6nM
	EvQy6fT2YGRXCbcMIY1vQGGZq7+5dmk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 08/13] mm/slab: replace slab.stride with
 obj_exts_in_object
Message-ID: <amH72thTfL0Ur19U@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-8-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-8-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 04:16:22PM +0200, Vlastimil Babka (SUSE) wrote:
> The stride field is used to convert object index to an slabobj_ext so
> both compact arrays (kmalloc() or in-slab-leftover) and spread
> in-object-padding obj_ext layouts are supported.
> 
> In practice thus the stride is always sizeof(slabobj_ext) or s->size.
> 
> This simplifies the calculations, but with the upcoming slabobj_ext
> handling changes, it will be easier to stop storing the stride and
> instead just have a flag whether obj_ext is in the object padding.
> obj_exts_in_object() can then rely on this flag and slab_obj_ext()
> can use that to determine the stride.
> 
> No functional change intended. Performance impact TBD, hopefully
> in the noise.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
