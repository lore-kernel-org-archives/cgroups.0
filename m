From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: Make rebind_subsystems() disable v2
 controllers all at once
Date: Mon, 20 Sep 2021 08:00:28 -1000
Message-ID: <YUjMPK5IzG7V2MnB@slm.duckdns.org>
References: <20210918225308.23822-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GW86IGUcMDKzVGAN04j3id2pxwxU5rmCGoMKv3mUqk0=;
        b=e0saxRzRZlC8Lgq4gXik9RYBQBAyVRuu5ycCyW2wxsag+Xtqrc7kSn8fOHDDs6coKG
         pmVPv73Cfn9xw3yjS3jgFJ+xXMyJQLn4oAuOPMNCQ+2qVFqKWb0IJOlote/fUwuCsWCy
         QBdlFRYoTauNy/EpY54H5vfAuCqm8Qp21ZCTNueWiURoMBtOWm+QADbCxaBJ4gIRq/2B
         CU076jVa59LvxhtmIvLRiv1wyVUW6ahXMAQUP6WYMcpwJaFyqzn6qjwLkn1FcWErFyT7
         wt3SkTgBCL7GgOo9g6Qd4N1qhbh2fmt26TISkzrX4U3dNEE4BBvP8TBm26Wu+nwywsS1
         Bj3w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210918225308.23822-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Sep 18, 2021 at 06:53:08PM -0400, Waiman Long wrote:
...
> It was caused by the fact that rebind_subsystem() disables
> controllers to be rebound one by one. If more than one disabled
> controllers are originally from the default hierarchy, it means that
> cgroup_apply_control_disable() will be called multiple times for the
> same default hierarchy. A controller may be killed by css_kill() in
> the first round. In the second round, the killed controller may not be
> completely dead yet leading to the warning.
> 
> To avoid this problem, we collect all the ssid's of controllers that
> needed to be disabled from the default hierarchy and then disable them
> in one go instead of one by one.
> 
> Fixes: 334c3679ec4b ("cgroup: reimplement rebind_subsystems() using cgroup_apply_control() and friends")
> Signed-off-by: Waiman Long <longman@redhat.com>

Applied to cgroup/for-5.16.

Thanks.

-- 
tejun
