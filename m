Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E83C22F74A;
	Fri, 22 May 2026 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779466578; cv=none; b=Wm6Ek4cUaPnXaj6+U1lh2bWIbs4fa93ZLpln+swoX9f5dmaLWN/CjztwtZSqHA91WNlyQCPQSnFbqMRHVR6Gzq5AbgsqIkc9Y3KBg1SaJ6KHHJnqq8R+ICPjj4GLipFa6COdvMKuN7UX2QVKQZqn3HC31+dgJUY3QkBf7P3RQ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779466578; c=relaxed/simple;
	bh=l/P/kac3ae7xnzMpNxb7xo3RtnBkFvgoNaBV6B9/WB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MjQNZKKRC43yEbQ0coV4b+VNjMtLIbd/8mQ5e4G128qGyWCI6GXW6Yo4XAG8f+acNHKYjtuUH5+khrhRXWmWHr6MnDi2Ev5xmY5ywgBmLlup6DvBFSssmZ7IAJjqun6BJ+7UMsLT64MTo93DoiLBt7ANKCCaafwskXDJTFmBL0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q0r7+mfJ; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q0r7+mfJ"
Date: Fri, 22 May 2026 09:16:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779466574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Z1BzU0TCCSZhOvR13JsXIxVpOY0gN7R0aERAlJ0Ans=;
	b=Q0r7+mfJigdGlW8RWCJe1aremsWrxqE6KL7UKXX4fkS+fXcRHFRRk2UtaJ5w02O2diHDkV
	yRLTtjoJxg0QbEYbrhpexs4sOFebYZuk2wyEMlAL9Ust7lt1jsmA08/fLTOJRfKEKZXOF4
	xA63/cU2zqsFx0P9+xcXZgYsgfXml60=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
Message-ID: <ahB_kaWXowIIQ6dQ@linux.dev>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
 <4e296262-fbbf-4ac7-aecc-3ef831583704@kernel.org>
 <agxszIIN6FtK0fEb@linux.dev>
 <ca8e655d-5fe7-4957-8a36-6667616be8b6@kernel.org>
 <agynzVVBb4CYJTYG@linux.dev>
 <20260519134927.ee04379d07b0674872422c06@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519134927.ee04379d07b0674872422c06@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Tue, May 19, 2026 at 01:49:27PM -0700, Andrew Morton wrote:
> On Tue, 19 May 2026 13:11:13 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Andrew, please don't send this patch to Linus until we decide on the option.
> 
> No probs, I added a note-to-self.

Here is my suggestion on how to proceed.

1. Let's drop this patch (memcg: cache obj_stock by memcg, not by objcg pointer)
   from mm-tree.

2. Let's not add anything to 7.1.

3. 7.2+ will have the multi-objcg series [1] and the patches will have fixes
   tag. If someone uses non-LTS 7.1, they can easily find those patches and can
   backport them.

Please let me know if there are any concerns.


[1] https://lore.kernel.org/20260522011908.1669332-1-shakeel.butt@linux.dev/
