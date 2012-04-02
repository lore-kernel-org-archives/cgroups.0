From: Tao Ma <tm-d1IQDZat3X0@public.gmane.org>
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Date: Tue, 03 Apr 2012 06:03:03 +0800
Message-ID: <4F7A2217.2030201@tao.ma>
References: <1332975091-10950-1-git-send-email-tj@kernel.org> <1332975091-10950-19-git-send-email-tj@kernel.org> <4F7A1C8B.3010402@tao.ma> <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tao.ma; s=default;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Subject:CC:To:MIME-Version:From:Date:Message-ID; bh=ZN3R3IUjEMDsSSbxZpZnonyX/u5mXJh1n9a9EAnL3h0=;
	b=E23jOCmo8HtHyS6q3gts09rip5s06mUqzBLz0vz3HTTeeNZeo89gi+X3PyREwWbkCHND30RtQX9qRgtETO+Vvm0iRb/5uQEFMVM2dGSp82Kkm4A3PhDwb3NrTKrpQuCn;
In-Reply-To: <20120402214938.GA19634-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On 04/03/2012 05:49 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 03, 2012 at 05:39:23AM +0800, Tao Ma wrote:
>> I guess blkio->weight is a generic way of abstracting the weight between
>> different block cgroups.
> 
> It isn't and can't be.  There's nothing generic about it across
> different policies and it's not even clear what that means.  If the
> user chooses combine, iops limit with cfq weights, what the hell is
> "generic" about that weight?
> 
>> Yes, currently, only cfq uses it, but I am
>> trying to improve Shaohua's original fiops scheduler and add cgroup
>> support to it. So please leave it there so that future scheduler(if
>> other than the fiops scheduler) can use the framework.
> 
> So, if you want to implement a new blkcg policy, add the config
> parameters and export the stats the policy wants *yourself*.  Not
> having clear separation between policies and generic stuff was what
> led us to this yucky mess and there's no way we're going back there.
> So, NO.
Currently weight is just used to calculate the time slice of different
cfq group, right? So why can't it be used to indicate other weight? So
say, if we are just want to use iops to indicate the difference between
different cgroups(100 weight vs 200 weight), so one process will send
100 ios while the other will send 200 ios just for example. We will need
a new iops_weight in your option to be exported?

Thanks
Tao
