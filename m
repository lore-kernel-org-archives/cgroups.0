From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 2/2] mm: move the high field from struct mem_cgroup to
 page_counter
Date: Mon, 23 Apr 2018 13:41:51 +0100
Message-ID: <20180423124145.GA29016@castle.DHCP.thefacebook.com>
References: <20180420163632.3978-1-guro@fb.com>
 <20180420163632.3978-2-guro@fb.com>
 <20180420205450.GB24563@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=Bn76lBWjgooTTnZQABXxM17ZzsKKMrjCDCKgteCak0c=;
 b=OluHcSb2q9WQYbRZ+r1fFt9ETPbzxpJnnIN3Px+vpEjGVYeS4tOo2WJA2OwgSfz81f7+
 Vt8B2pFcTr2LeRialFrBmPIq4E1XzVr5fAPYhBSZQmz8hDNgXfquKWKDj7OC2oty9i3+
 ZnCdj2bMBAj3jeVP8rIm753PUygL3CVp9ss= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Bn76lBWjgooTTnZQABXxM17ZzsKKMrjCDCKgteCak0c=;
 b=i8Ijhyt7rc14KOc/5WBZxDLZ87aLcBk3BaPmKEU1SH3eYSFd+GpLaldifTxhpISXPlB7NHYIEgF/HuWEMBxKIHP7Fi6sBLn21C8vzacd+FNoNvHd3L0gNiftoJ5pvsRgT5qSDxIWAlqm7d/E6JKrmsXjLX8kbvJ2sMdbgfVkqQg=
Content-Disposition: inline
In-Reply-To: <20180420205450.GB24563@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>

On Fri, Apr 20, 2018 at 04:54:50PM -0400, Johannes Weiner wrote:
> On Fri, Apr 20, 2018 at 05:36:32PM +0100, Roman Gushchin wrote:
> > We do store memory.min, memory.low and memory.max actual values
> > in struct page_counter fields, while memory.high value is located
> > in the struct mem_cgroup directly, which is not very consistent.
> > 
> > This patch moves the high field from struct mem_cgroup to
> > struct page_counter to simplify the code and make handling
> > of all limits/boundaries clearer.
> 
> I would prefer not doing this.
> 
> Yes, it looks a bit neater if all these things are next to each other
> in the struct, but on the other hand it separates the high variable
> from high_work, and it adds an unnecessary setter function as well.
> 
> Plus, nothing in the page_counter code actually uses the value, it
> really isn't part of that abstraction layer.
> 

Ok, not a problem.
It's nice to have all 4 limits in one place, but separating
high and high_work isn't good, I agree. Let's leave it as it is.

Thanks!
