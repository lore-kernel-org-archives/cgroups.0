From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 4/7] cgroup: cgroup v2 freezer
Date: Tue, 20 Nov 2018 08:36:04 -0800
Message-ID: <20181120163604.GX2509588@devbig004.ftw2.facebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-5-guro@fb.com>
 <20181120162529.GU2509588@devbig004.ftw2.facebook.com>
 <20181120163304.GA21462@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bZPk6X88jmWbA0LBKkgEOfdIJ3iJDdOYKXmDcQOGAJI=;
        b=fTZWYUav0thwvA/I1cJhIfK77MrJ8holI9GwMCzm1NeZaHr9plsTGePvLzgR/UU885
         3Ghmb9qSnPxbGaikmZCdcHIAiqvGkhI4zXAulpAs5Eo55rCJE95w2ejF+bByG+jSVV20
         I2zQdOuRex6IjnwzW2T7szSKia9ESRX49H/xonpWJQ2Q70XVEMTwSGw/PJqO+fBv5iVI
         ctIQTKXD4+eQWSC2N/SKgxZhR4QSkBxYbRB7LYjuQVQZyKW95pcsFU/oVX7j/beZmRs9
         CI0PRcZ8lbycstUbxs+Imef6GoNVcuCHfxx4RU5OfMu01WHo6vet0BIp92mRdaVdrr61
         QStg==
Content-Disposition: inline
In-Reply-To: <20181120163304.GA21462@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Nov 20, 2018 at 04:33:11PM +0000, Roman Gushchin wrote:
> > If a non-frozen task is being moved into a frozen cgroup, shouldn't
> > that also trigger frozen state update?
> 
> It does! Just below these lines:
> 
> 	/*
> 	 * If the task isn't in the desired state, force it to it.
> 	 */
> 	if (task->frozen != test_bit(CGRP_FREEZE, &dst->flags))
> 		cgroup_freeze_task(task, test_bit(CGRP_FREEZE, &dst->flags));

But that wouldn't udpate the cgroup's frozen state and generate
notifications, right?

Thanks.

-- 
tejun
