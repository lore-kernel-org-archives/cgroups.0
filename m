From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Thu, 14 Apr 2016 13:50:55 -0400
Message-ID: <20160414175055.GA6794@cmpxchg.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413192313.GA30260@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Petr Mladek <pmladek@suse.com>, cgroups@vger.kernel.org, Cyril Hrubis <chrubis@suse.cz>, linux-kernel@vger.kernel.org

On Wed, Apr 13, 2016 at 09:23:14PM +0200, Michal Hocko wrote:
> I think we can live without lru_add_drain_all() in the migration path.

Agreed. Michal, would you care to send a patch to remove it?
