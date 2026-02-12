Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334D3279336;
	Thu, 12 Feb 2026 21:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933210; cv=none; b=esWdRkcAxx3FvD4WhjlFEiLGhCmdrptJxpEFs4TRb0Sa512bj2GKJ939dGUoML++P0e/GzVb9HjJZ9zWYezkTNjxA7URcJZskyOdDV95is6Xa03c+PFfL5FaGqDNme+qR0RbEPqBYwBIRlIuKZk3sQfoL835xSOHee5UmjfkA/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933210; c=relaxed/simple;
	bh=p4ZJCecHCHBiHBs51Q4TEO/CKTHw925ogCBsr1+hAhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNwSjCucP+ZMyVuTIYvAl+cL8y4Qrple0ud0qYdd4Vczkkpeeh9W5Wb1OWInQThEzlazFP+GzUwonGOyYnXnDPkkkye00MpdI5GJJssxLyspEwARHDlYlKihAd+z4VT/zhCj5zZO536oOcyOCu9cVThOxSIAF6BY+2SjlUlLrLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VDhdKsNv; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VDhdKsNv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0PQbQqJJLCbQmlIGol0AzmR2YgJKABa97ASi4IkwW84=; b=VDhdKsNv3wZfuk9wH/G9eJDteK
	U97oeP3qtKqEpqurSt5LBiTGaq46ErIGtWzlk0dlbZduXDtQQZoLbayAR+h6Uvql6fsmxcU3nSpon
	cyvkIFtIPD7slmHwuZkAEIjjQybOweqvRsVI+iVoRJ96qgK/0GkkacoOUsRhM8qCV8to1B+86Mld4
	cKDtekIaXwImU/6IsfgxbV/W+3zejStMP3AJaVk60jBoMZR/pMv4cD29ntTSJUWAnK35srnBbipA4
	oN+xVLObBTzU243+Bc1Id4qK7g03whOT+QkxkV8vBiV8heCUGsUiXWm6UBLSHzY51+M4CXPYHdBbi
	tqUv1tOQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqecc-0000000ElyL-0zCy;
	Thu, 12 Feb 2026 21:53:14 +0000
Date: Thu, 12 Feb 2026 21:53:14 +0000
From: Matthew Wilcox <willy@infradead.org>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	mhocko@suse.com, rppt@kernel.org, muchun.song@linux.dev,
	zhengqi.arch@bytedance.com, rakie.kim@sk.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
	virtualization@lists.linux.dev, vbabka@suse.cz, weixugc@google.com,
	xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com,
	yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH 0/2] improve per-node allocation and reclaim visibility
Message-ID: <aY5Lys3bPh0O_pDJ@casper.infradead.org>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <aY1dusLPzP2AHP6f@casper.infradead.org>
 <3bf72620-88ac-4c56-b3ec-0fcfa53c14c8@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bf72620-88ac-4c56-b3ec-0fcfa53c14c8@gmail.com>

On Thu, Feb 12, 2026 at 01:22:09PM -0800, JP Kobryn wrote:
> On 2/11/26 8:57 PM, Matthew Wilcox wrote:
> > On Wed, Feb 11, 2026 at 08:51:07PM -0800, JP Kobryn wrote:
> > > We sometimes find ourselves in situations where reclaim kicks in, yet there
> > 
> > who is we?  you haven't indicated any affiliation in your tags.
> 
> Meta. Is there a preferred way of indicating this?

Documentation/process/submitting-patches.rst:

From Line
^^^^^^^^^

The ``from`` line must be the very first line in the message body,
and has the form:

        From: Patch Author <author@example.com>

The ``from`` line specifies who will be credited as the author of the
patch in the permanent changelog.  If the ``from`` line is missing,
then the ``From:`` line from the email header will be used to determine
the patch author in the changelog.

The author may indicate their affiliation or the sponsor of the work
by adding the name of an organization to the ``from`` and ``SoB`` lines,
e.g.:

        From: Patch Author (Company) <author@example.com>


I do this with ~/.gitconfig

[user]
        name = Matthew Wilcox (Oracle)
        email = willy@infradead.org

and it goes into the From and Signed-off-by lines correctly when
generating patches.
