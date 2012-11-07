From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 9/9] cgroup_freezer: implement proper hierarchy support
Date: Wed, 7 Nov 2012 08:31:44 -0800
Message-ID: <20121107163144.GB2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-10-git-send-email-tj@kernel.org>
 <20121107110024.GA4143@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-pm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+CgOIPrCgccK5/N0WuxDFYakmBKUTsWH4eMvUszXy5w=;
        b=RvHBYeQ/zXqp9MWAYj3tS6t/auvLejqsya3jDTGnzxLmQDm03LmFlaBJjHAiESrzTB
         N4Bpji1MmZX8bO/MWMLbH4DUCVrVMLwi3Pf4G0Yn3XOkOEppSwtOh3a5ZmVobaOkf/Xl
         8RsRU0NKGrcfloDCHxW75mWXk/UGguezag/m2crwb/ZiOJ4LXlUAE/X2WdcgC0ctHMIM
         aTpGgvzBUA3unGAtVCxliak1Hn8kVBoSAiOzicTAeFMiRwlnJoWao3oG4zjZzmT0cWW9
         JVLseBP6/Qrb3qUtOtF7KZO5UDSAfhoujc1WtSTP4/Nn5q69B0ZEsofQB7dLMRJlmPiw
         Q62g==
Content-Disposition: inline
In-Reply-To: <20121107110024.GA4143@dhcp22.suse.cz>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, rjw@sisk.pl, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, fweisbec@gmail.com

Hello, Michal.

On Wed, Nov 07, 2012 at 12:00:57PM +0100, Michal Hocko wrote:
> > +	 * Update all its descendants in pre-order traversal.  Each
> > +	 * descendant will try to inherit its parent's FREEZING state as
> > +	 * CGROUP_FREEZING_PARENT.
> > +	 */
> > +	rcu_read_lock();
> > +	cgroup_for_each_descendant_pre(pos, freezer->css.cgroup) {
> > +		struct freezer *pos_f = cgroup_freezer(pos);
> > +		struct freezer *parent = parent_freezer(freezer);
> 
> This doesn't seem right. Why are we interested in freezer->parent here
> at all? We should either care about freezer->state & CGROUP_FREEZING or
> parent = parent_freezer(pos_f), right?

Yeap, that should have been parent_freezer(pos_f).  Argh...

Thanks.

-- 
tejun
