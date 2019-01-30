From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 19:16:30 +0100
Message-ID: <20190130181630.GF18811@dhcp22.suse.cz>
References: <20190128151859.GO18811@dhcp22.suse.cz>
 <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz>
 <20190128174905.GU50184@devbig004.ftw2.facebook.com>
 <20190129144306.GO18811@dhcp22.suse.cz>
 <20190129145240.GX50184@devbig004.ftw2.facebook.com>
 <20190130165058.GA18811@dhcp22.suse.cz>
 <20190130170658.GY50184@devbig004.ftw2.facebook.com>
 <20190130174117.GC18811@dhcp22.suse.cz>
 <20190130175222.GA50184@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190130175222.GA50184@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Wed 30-01-19 09:52:22, Tejun Heo wrote:
> On Wed, Jan 30, 2019 at 06:41:17PM +0100, Michal Hocko wrote:
> > But we are discussing the file name effectively. I do not see a long
> > term maintenance burden. Confusing? Probably yes but that is were the
> 
> Cost on user side.
> 
> > documentation would be helpful.
> 
> which is an a lot worse option with way higher total cost.

And how exactly does the cost get any smaller with a mount option. The
consumer of the API will likely not know there are two modes and check
for it to figure out how to interpret those values. Or maybe I still do
not follow how exactly is the mount option supposed to work.

-- 
Michal Hocko
SUSE Labs
