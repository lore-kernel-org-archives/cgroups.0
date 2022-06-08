From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v6 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 8 Jun 2022 23:12:53 +0200
Message-ID: <YqEQ1cudjZmUU7rs@blackbook>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-4-longman@redhat.com>
 <20220608165732.GB19399@blackbody.suse.cz>
 <506eaa3d-be84-c51e-3252-2979847054fe@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654722775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cvLTeRgE922dttN+/SnWY6He1Q8u4Sfu7cqwMi2p5dQ=;
        b=aCK4ctriVdhI1i3ubrX52jvQCh+DlkWCXQwz5PScudBWPXCHGxJrvto5HQYoCNJJdY83dW
        DUTyiUUKa36htw8fg4sJdvRBZx9IwaySmfPEWkDsVBxynKg7tKEFOp1PcNVkXw8gLkzhY3
        4QWesCmAvxZAF3XCs+b/cwVycwLiKYA=
Content-Disposition: inline
In-Reply-To: <506eaa3d-be84-c51e-3252-2979847054fe@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Wed, Jun 08, 2022 at 02:16:45PM -0400, Waiman Long <longman@redhat.com> wrote:
> I have thought about that. It can be done as a follow-up patch to add a
> sentinel version into llist and use that instead. Of course, I can also
> update this patchset to include that.

Nothing against the current form, really just an idea for a followup or
prequel.

> Your change may not be enough since there could be update after the flush
> which will pin the blkg and hence blkcg.

Wouldn't that mean submitting a bio from offlined blkcg?
blkg_tryget_closest() should prevent that.

> I guess one possible solution may be to abandon the llist and revert
> back to list iteration when offline. I need to think a bit more about
> that.


> > Maybe bundle the lhead list maintenace with cgroup_rstat_updated() under
> > cgroup_subsys_on_dfl()? The stats can be read on v1 anyway.
> 
> I don't quite understand here. The change is not specific to v1 or v2. What
> do you mean by the stat is readable on v1?

Apologies, the critical "not" fell out. ...can not be read on v1... IOW,
the rstat data are only kept when attached to v2 hierarchy, so the list
of active devices needn't be maintained on v1.


Michal

