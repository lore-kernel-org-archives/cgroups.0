From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] cgroup: add cgroup.stat interface with basic hierarchy
 stats
Date: Fri, 28 Jul 2017 14:01:55 +0100
Message-ID: <20170728130155.GA13728@castle.dhcp.TheFacebook.com>
References: <20170727161420.2552-1-guro@fb.com>
 <20170727162243.GF742618@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=NRZLbhd/WCmpXJh8sKtHMqwwRkKrxlGAW0sVo2CMJqI=;
 b=EDw9uKk/9wkz5p8XWDlnfGR7yF8Rh0ZuiTBqXYyVTODL/HAB1bIrRYX/sBNg3ZVUA546
 H8UMD3Fg5eIlWaFtAfY5zVVvnEgMRc8eEv4jjqZwGvyNdyi3yTg0t+vGly66LWYpSkAu
 NAJAIDq2TmKYYeudD7ac8969ekTgUa3Bphc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=NRZLbhd/WCmpXJh8sKtHMqwwRkKrxlGAW0sVo2CMJqI=;
 b=AFkfJMjwo9ANEVYRKVuruVWzLN6fcSCsKNM1Vo4Ym1wy+k2ZudWJg+YnpyV3w4aW3pjFYckKK18yvlcPC9nvVDH+Ouv+v6KTKBhpgdNNLaIsvKbqA4UsMzEy2nJpz7xLJqd4PgQaIEqMStR0VNQCpfdciKqcbuvhseeFuEPI4WM=
Content-Disposition: inline
In-Reply-To: <20170727162243.GF742618@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jul 27, 2017 at 12:22:43PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jul 27, 2017 at 05:14:20PM +0100, Roman Gushchin wrote:
> > Add a cgroup.stat interface to the base cgroup control files
> > with the following metrics:
> > 
> > nr_descendants		total number of descendant cgroups
> > nr_dying_descendants	total number of dying descendant cgroups
> > max_descendant_depth	maximum descent depth below the current cgroup
> 
> Yeah, this'd be great to have.  Some comments below.
> 
> > +  cgroup.stat
> > +	A read-only flat-keyed file with the following entries:
> > +
> > +	  nr_descendants
> > +		Total number of descendant cgroups.
> > +
> > +	  nr_dying_descendants
> > +		Total number of dying descendant cgroups.
> 
> Can you please go into more detail on what's going on with dying
> descendants here?

Sure.
Don't we plan do describe cgroup/css lifecycle in details
in a separate section?

> > +static int cgroup_stats_show(struct seq_file *seq, void *v)
> > +{
> > +	struct cgroup_subsys_state *css;
> > +	unsigned long total = 0;
> > +	unsigned long offline = 0;
> > +	int max_level = 0;
> > +
> > +	rcu_read_lock();
> > +	css_for_each_descendant_pre(css, seq_css(seq)) {
> > +		if (css == seq_css(seq))
> > +			continue;
> > +		++total;
> 
> Let's do post increment for consistency.

Ok.

> 
> > +		if (!(css->flags & CSS_ONLINE))
> > +			++offline;
> > +		if (css->cgroup->level > max_level)
> > +			max_level = css->cgroup->level;
> > +	}
> > +	rcu_read_unlock();
> 
> I wonder whether we want to keep these counters in sync instead of
> trying to gather the number on read.  Walking all descendants can get
> expensive pretty quickly and things like nr_descendants will be useful
> for other purposes too.

Ok, assuming that I'm working on adding an ability to set limits
on cgroup hierarchy, it seems very reasonable. I'll implement this
and post the updated path as a part of a patchset.

Thanks!
