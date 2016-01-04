From: David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [RFC PATCH net-next] net: Add l3mdev cgroup
Date: Mon, 4 Jan 2016 11:53:55 -0700
Message-ID: <568ABFC3.3010803@cumulusnetworks.com>
References: <1451925136-13327-1-git-send-email-dsa@cumulusnetworks.com>
 <20160104175836.GA11668@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-type:content-transfer-encoding;
        bh=XGA3gEXH108lqm8AjJFe6OtRP6wAIk99agtQNUnbMoE=;
        b=Chmn931M9mV+x5xZi2LTx9F42b5NgBYWFz+O5PxAL7CeToRNjGz7lR7RyOtwvCZjU6
         Mwnaj3w6CA0HSGvYaPCB4vOTNRK5LKDWuuuwheV6n1xUZn508WGti0DUlnSL8FCaaqHP
         BbTrwUrFHkqitXJPfWDO4e7wvxp2kKqLFo58Y=
In-Reply-To: <20160104175836.GA11668@mtj.duckdns.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: netdev@vger.kernel.org, cgroups@vger.kernel.org, shm@cumulusnetworks.com, roopa@cumulusnetworks.com

Hi Tejun:

On 1/4/16 10:58 AM, Tejun Heo wrote:
> Please don't create any new controller whose sole purpose is
> identifying group membership.  Please take a look at how libxt_cgroup
> handles identification w/o creating a new controller.
>
>   http://lkml.kernel.org/g/1449527935-27056-1-git-send-email-tj@kernel.org
>

This controller applies a cgroup specific setting to tasks associated 
with an instance (similar to cpuset restricting tasks to specifics 
CPUs), so it is more than just identifying membership.

I looked at the commits referenced above and net/netfilter/xt_cgroup.c 
code in particular and I don't see how it applies to this use case. Can 
you elaborate?

Thanks,
David
