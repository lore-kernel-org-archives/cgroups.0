From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/3] mm, memcg: Don't put offlined memcg into local stock
Date: Mon, 31 Jan 2022 09:01:14 -0800
Message-ID: <YfgV2iiaVlR0hozD@carbon.dhcp.thefacebook.com>
References: <20211001190938.14050-1-longman@redhat.com>
 <20211001190938.14050-2-longman@redhat.com>
 <YVefHLo1+6lgw3aB@carbon.dhcp.thefacebook.com>
 <f7026256-4086-6632-569e-5b13594cb3fc@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Y4HUQwPeuAbzYap8tBpYSb9KNcPloBhp0o+4zwLzb7s=;
 b=WmqesgWQT0e/urveuv4u/sp5o892fmT0SwOSn6lorEPgiZI5adxBdwbUz1b0Qbx5rXQh
 hUGV+Uef9jgjjZSJZGU/0V3aRCt7QRHn7JoVpR7pYuegCeLrPVs7900chOs580donmrC
 5/ahSCWZWfsALgNRwUyITfUKQGiEPhLwTsY= 
Content-Disposition: inline
In-Reply-To: <f7026256-4086-6632-569e-5b13594cb3fc@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>

On Sun, Jan 30, 2022 at 10:55:56PM -0500, Waiman Long wrote:
> On 10/1/21 19:51, Roman Gushchin wrote:
> > On Fri, Oct 01, 2021 at 03:09:36PM -0400, Waiman Long wrote:
> > > When freeing a page associated with an offlined memcg, refill_stock()
> > > will put it into local stock delaying its demise until another memcg
> > > comes in to take its place in the stock. To avoid that, we now check
> > > for offlined memcg and go directly in this case to the slowpath for
> > > the uncharge via the repurposed cancel_charge() function.
> > Hi Waiman!
> > 
> > I'm afraid it can make a cleanup of a dying cgroup slower: for every
> > released page we'll potentially traverse the whole cgroup tree and
> > decrease atomic page counters.
> > 
> > I'm not sure I understand the benefits we get from this change which
> > do justify the slowdown on the cleanup path.
> > 
> > Thanks!
> 
> I was notified of a lockdep splat that this patch may help to prevent.

Would you mind to test this patch:
https://www.spinics.net/lists/cgroups/msg31244.html ?

It should address this dependency.

Thanks!
