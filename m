From: Tao Ma <tm-d1IQDZat3X0@public.gmane.org>
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Date: Tue, 03 Apr 2012 06:41:37 +0800
Message-ID: <4F7A2B21.5000907@tao.ma>
References: <1332975091-10950-1-git-send-email-tj@kernel.org> <1332975091-10950-19-git-send-email-tj@kernel.org> <4F7A1C8B.3010402@tao.ma> <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com> <4F7A2217.2030201@tao.ma> <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com> <4F7A261A.9000200@tao.ma> <20120402222504.GA2672@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tao.ma; s=default;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Subject:CC:To:MIME-Version:From:Date:Message-ID; bh=LNN7vlD+/hmFk/j1ai8gHORotJ4lQzsYJyCf+LTAMxs=;
	b=TJt4N1D3zIpRNiV4VGdIc8U3Boc1o5Y9Uk1QyAtO+O4wRyctD1zs8skKMW8WpR6HL6nkymuEkSnGT6EBW3GEdaG8T6yWfTytbegwDKtPGTBQeD0AhTESwGoUJMH2btER;
In-Reply-To: <20120402222504.GA2672-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On 04/03/2012 06:25 AM, Vivek Goyal wrote:
> On Tue, Apr 03, 2012 at 06:20:10AM +0800, Tao Ma wrote:
> 
> [..]
>>> Yeah, just add config and stat files prefixed with the name of the new
>>> blkcg policy.
>> OK, I will add a new config file for it.
> 
> Only if CFQ could be modified to add one iops mode, flippable through a
> sysfs tunable, things will be much simpler. You will not have to add a
> new IO scheduler, no new configuration/stat files in blkcg (which is
> already crowded now).
> 
> I don't think anybody has shown the code that why CFQ can't be modified
> to support iops mode.
Yes, I have thought of it, but it seems to me that time slice is deeply
involved within the cfq(even current cfq's iops mode has used time slice
to calculate). So I don't think it is feasible for me to change it. And
cfq works perfectly well for sas/sata environment and the code is quite
stable, more codes and more complicate algorithm does mean more bugs. So
I guess a new iops based scheduler is easy and not intrusive for the
user(since he can choose whether to use it or not).

Thanks
Tao
