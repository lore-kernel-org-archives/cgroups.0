From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcontrol.c: use list_{first,next}_entry
Date: Sat, 5 Dec 2015 11:22:58 -0500
Message-ID: <20151205162258.GA1792@cmpxchg.org>
References: <9e62e3006561653fcbf0c49cf0b9c2b653a8ed0e.1449152124.git.geliangtang@163.com>
 <20151203162718.GK9264@dhcp22.suse.cz>
 <20151205025542.GB9812@bogon>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20151205025542.GB9812@bogon>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Geliang Tang <geliangtang@163.com>
Cc: Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sat, Dec 05, 2015 at 10:55:42AM +0800, Geliang Tang wrote:
> On Thu, Dec 03, 2015 at 05:27:18PM +0100, Michal Hocko wrote:
> > On Thu 03-12-15 22:16:55, Geliang Tang wrote:
> > > To make the intention clearer, use list_{first,next}_entry instead
> > > of list_entry.
> > 
> > Does this really help readability? This function simply uncharges the
> > given list of pages. Why cannot we simply use list_for_each_entry
> > instead...
> 
> I have tested it, list_for_each_entry can't work. Dose it mean that my
> patch is OK? Or please give me some other advices.

Your patch is okay. Please feel free to add my

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
