From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v10 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Wed, 22 Apr 2015 17:42:12 +0200
Message-ID: <20150422154212.GE3007@worktop.Skamania.guest>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-2-git-send-email-cyphar@cyphar.com>
 <20150422152551.GA10738@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150422152551.GA10738@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, lizefan@huawei.com, mingo@redhat.com, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Apr 22, 2015 at 11:25:51AM -0400, Tejun Heo wrote:
> Hello, Aleksa.
> 
> On Sun, Apr 19, 2015 at 10:22:31PM +1000, Aleksa Sarai wrote:
> > -static int need_forkexit_callback __read_mostly;
> > +static int need_fork_callback __read_mostly;
> > +static int need_exit_callback __read_mostly;
> 
> These are bitmasks now, right?  Let's make them unsigned int.

If, as per the below you want to use the bitmap ops; it needs be
unsigned long.

> >  static struct cftype cgroup_dfl_base_files[];
> > +#define for_each_subsys_which(ss_mask, ss, ssid) \
> > +	for_each_subsys((ss), (ssid)) \
> > +		if ((ss_mask) & (1 << (ssid)))
> 
> Maybe using for_each_set_bit() is better?
> 
> #define for_each_subsys_which(ss_mask, ss, ssid)		\
> 	for_each_set_bit(ssid, &(ss_mask), CGROUP_SUBSYS_COUNT)	\
> 		if ((ss) = group_subsys[ssid] && false)		\
> 			;					\
> 		else

Clever that ;-)
