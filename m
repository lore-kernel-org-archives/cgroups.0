From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Fri, 22 Mar 2019 23:51:20 +0000
Message-ID: <20190322235120.GA31019@chrisdown.name>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
 <20190322222907.GA17496@tower.DHCP.thefacebook.com>
 <20190322224946.GA12527@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uB1/IWOEK+GFSUVXVpArQJE+Iwx/dVBKwpNZw8eSYdI=;
        b=F2HThYNwJG9xqwjVQ01U0dygceVtFhVN0zGiTc2s3fFci+rr5MHvTeD5KDR+N1swhg
         X3d076qrgSksIDL+shRkHOExAf9duEYrkKtDhF+zKxlEIWgd0PSqwXV4x63UJIIQCSve
         jF4basxGu6d75EeaUSo5T89X47nRmV5VwwpNY=
Content-Disposition: inline
In-Reply-To: <20190322224946.GA12527@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

Chris Down writes:
>Are you certain? If so, I don't see what you mean. This is how the 
>code looks in Linus' tree after the fixups:

Hmm, apparently this actually didn't go into Linus' tree yet, so yeah, seems 
worth having as a fixup maybe indeed.
