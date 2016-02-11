From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: provide cgroup_nov1= to disable controllers in
 v1 mounts
Date: Thu, 11 Feb 2016 10:17:07 -0500
Message-ID: <20160211151707.GY3741@mtj.duckdns.org>
References: <1455145195-7553-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6POmq/kfyPNYGYzZoBzEaE6iez9ttBHnYDSBVojRNBM=;
        b=qc3G6WeGa/29FD9Z6JeqwbMZqI1BkFy/cMJy2euwOZec06fQjWPC0zgrKGuxYcsdDE
         gAGC0glfK9T8RVmyfE8/V6pJ98PtA1//DFuz/8hDdfqX1cngFcCYqWH8/qQ34Bl+yvOH
         ST093hI7QEmAv/BqySDDEo9Hw/SGRbnkOJ2+TPK7XPPeTot7g6cJL69bsVi2+LHmC5/P
         Pay7R5r0+WibchwfUX96p3daJr2zT4bu/A0FFL8Mso6YKNczEIkREs6jvycGZ8Koh2Gv
         SYD04m2CMGvMP4r+dunLbJMpaQRclkp91LxyyzukVhfxVJ0s0ds+tKDPbZDtJEsSNTci
         qX+g==
Content-Disposition: inline
In-Reply-To: <1455145195-7553-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

On Wed, Feb 10, 2016 at 05:59:55PM -0500, Johannes Weiner wrote:
> cgroup_nov1=memory,cpu
> cgroup_nov1=all

It looks kinda confusing.  cgroup_no_v1?

Thanks.

-- 
tejun
