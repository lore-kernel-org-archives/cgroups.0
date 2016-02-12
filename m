From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: provide cgroup_nov1= to disable controllers in
 v1 mounts
Date: Fri, 12 Feb 2016 15:03:34 -0500
Message-ID: <20160212200334.GA3965@htj.duckdns.org>
References: <1455145195-7553-1-git-send-email-hannes@cmpxchg.org>
 <20160211151707.GY3741@mtj.duckdns.org>
 <20160211183449.GA399@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=kv3yqj5rI8lg61KKJynuMG96D6Zr5Nm+VVUo3M0cKTM=;
        b=lprD/A8gW2JWtmSo3eYqdm4SpEQTX6NDi65RBFnCZ02vFPhQgE/Fuqo7pnEmmKwc01
         j8KDLmYF9dMLmaa/hVzVMmiIB/6nMuhVS0xZjC7JHjXbPceNIJ0gO08EVcAaFEuyxXl2
         GUcgTAjoDNW46bTUGi7aoKz1RjD7eaYHyMhPLYwx2jma0XxIUeXrVwdmEQJLLL+5UouO
         LgmkovjRnmnr3M8Gwk8iG1CPYeS6q6AL8eIsZD5sn+nvYFsp9JI+Sxm9DV6l4XrCdEQS
         x+/rlppTyrUVjQ1XoeuCwx36IJBuqGts1iRSw2ooLR8cJmZr1HE3JTa+wIqLHG9pfVmY
         DXhw==
Content-Disposition: inline
In-Reply-To: <20160211183449.GA399@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Feb 11, 2016 at 01:34:49PM -0500, Johannes Weiner wrote:
> From 89e581ca54bdca37d6c464334d2217d14a229540 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Wed, 10 Feb 2016 17:29:31 -0500
> Subject: [PATCH] cgroup: provide cgroup_no_v1= to disable controllers in v1
>  mounts

Applied to cgroup/for-4.6.  Can you please send another patch to
update Documentation/kernel-parameters.txt and cgroup.txt for the new
knob?

Thanks.

-- 
tejun
