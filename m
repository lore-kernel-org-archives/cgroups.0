From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: blkio cgroups controller doesn't work with LVM?
Date: Thu, 25 Feb 2016 09:48:12 +0200
Message-ID: <56CEB1BC.4000005@kyup.com>
References: <56CDF283.9010802@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56CDF283.9010802-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 02/24/2016 08:12 PM, Chris Friesen wrote:
> 
> Hi,
> 
> Are there known limitations with the blkio cgroup controller when used
> with LVM?
> 
> I'm using Ubuntu 15.10 with the 4.2 kernel.  I got the same results with
> CentOS 7.
> 
> I set up two groups, /sys/fs/cgroup/blkio/test1 and
> /sys/fs/cgroup/blkio/test2.  I set the weight for test1 to 500, and the
> weight for test2 to 1000.

The weighed mode of blkio works only with CFQ scheduler. And as far as I
have seen you cannot set CFQ to be the scheduler of DM devices. In this
case you can use the BLK io throttling mechanism. That's what I've
encountered in my practice. Though I'd be happy to be proven wrong by
someone. I believe the following sentence in the blkio controller states
that:
"
First one is proportional weight time based division of disk policy. It
is implemented in CFQ. Hence this policy takes effect only on leaf nodes
when CFQ is being used.
"
> 
> If I then read/write to a file on /dev/sda1 from a process in each
> group, then everything works as expected and test1 gets half the
> bandwidth of test2.
> 
> If I do the same but accessing an LVM logical volume, where the
> underlying physical volume is /dev/sda4, then both groups get the same
> bandwidth.
> 
> It appears that the group weight doesn't get propagated down through all
> the layers.  Am I missing something?  If not, is this documented anywhere?
> 
> Thanks,
> Chris
> -- 
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
