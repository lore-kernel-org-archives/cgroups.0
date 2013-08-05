From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Date: Mon, 5 Aug 2013 12:29:58 -0400
Message-ID: <20130805162958.GF19631@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <20130805160107.GM10146@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vj3Z9DjB7A9eLw+EgcEzHGVD2Fq6gKlUHJU0tjDEHYE=;
        b=JtsZEgSALQrwIu6+Pt/pNE/kG9jg6nZbAouF/gnUEgTTy0KJGyxh4Zjx9XxaN1ec8W
         4YFtQRyWshMfbd3xWbaIBr8xVwF92vrX3BnBeKgKRMFa9/vzuvJSGiXm63xPbUvV1LaY
         vDE70urBaBI4lhCafEpmVgGSfvLW7YeP6pnjQAQEOL5tPDm9+v9Ln1ljbLr8dqoH3aK0
         FWYs6yCmkpLln3s3Nj2meGh3Etk8S0J/ITsbV+SLFrB9Xmj0HZ3nzAefnQNWWlQnSgjQ
         SzGrNN1S4Na21rLAc7ZkD+0FiV4S3Jd4YRegH91qPKPTJrbiKL9c+nKdp0llIe27YPB6
         7tSA==
Content-Disposition: inline
In-Reply-To: <20130805160107.GM10146@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hello, Michal.

On Mon, Aug 05, 2013 at 06:01:07PM +0200, Michal Hocko wrote:
> Could you be more specific about what is so "overboard" about this
> interface? I am not familiar with internals much, so I cannot judge the
> complexity part, but I thought that eventfd was intended for this kind
> of kernel->userspace notifications.

It's just way over-engineered like many other things in cgroup, most
likely misguided by the appearance that cgroup could be delegated and
accessed by multiple actors concurrently.

The most clear example would be the vmpressure event.  When it could
have just called fsnotify_modify() unconditionally when the state
changes, now it involves parsing, dynamic list of events and so on
without actually adding any benefits.  For the usage ones,
configurability makes some sense but even then just giving it a single
array of event points of limited size would be sufficient.

It's just way over-done.

> So you think that vmpressure, oom notification or thresholds are
> an abuse of this interface? What would you consider a reasonable
> replacement for those notifications?  Or do you think that controller
> shouldn't be signaling any conditions to the userspace at all?

I don't think the ability to generate events are an abuse, just that
the facility itself is way over-engineered.  Just generate a file
changed event unconditionally for vmpressure and oom and maybe
implement configureable cadence or single set of threshold array for
threshold events.  These are things which can and should be done in a
a few tens of lines of code with far simpler interface.  There's no
need for this obsecenely flexible event infrastructure, which of
course leads to things like shared contiguous threshold table without
any size limit and allocated with kmalloc().

So, let's please move towards something simple.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
