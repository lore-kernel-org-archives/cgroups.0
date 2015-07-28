From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/10] cgroup: introduce cgroup_subsys->legacy_name
Date: Tue, 28 Jul 2015 11:23:10 -0400
Message-ID: <20150728152310.GB454@mtj.duckdns.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
 <1437763434-28699-3-git-send-email-tj@kernel.org>
 <55B723A8.1080201@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tFJ4lgUCxy96en5Uk1RWPiA5X6Fd4uwZCcUNrSBqitw=;
        b=LBdu8c+5jwTiwcC9hHMREp0USrdPz7tg0O8376wCu6YS+oho6GNKrOAJlBbGo3/RZC
         eMK7llfguG31WyLejvUpYkcehjIHCV3Tsc/fVCJ3HeshMiRDfeWQz3wHXHrIqWDzMWQf
         /ie7ZvjH6wSOnTtkMbenQvgoGnX8OCWJcajIEGEaKWL/WttPdKQl6P1CM7y9+upba7ac
         crD7E18M4IK5/2/EuYnZi586RuMAokqrO5DyLWpaT2GV4FNzSaVtxo/nFKNohEBHcyFu
         Vig8eU/4LcSSoc0x4iMneJ5kkccN8iPftMrY7id0PjEOWo4rQLVN6xJ6i3L8o8YzSNNs
         aPaw==
Content-Disposition: inline
In-Reply-To: <55B723A8.1080201@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, cgroups@vger.kernel.org

On Tue, Jul 28, 2015 at 02:39:36PM +0800, Zefan Li wrote:
> > @@ -1448,7 +1451,8 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
> >  		}
> >  
> >  		for_each_subsys(ss, i) {
> > -			if (strcmp(token, ss->name))
> > +			if (strcmp(token, ss->name) &&
> > +			    strcmp(token, ss->legacy_name))
> >  				continue;
> 
> As mounting with specified subsystems is only allowed in legacy hierarchy,
> I think we should allow using leagcy name only?

Yeah, good point.  Will update the patch.

Thanks.

-- 
tejun
