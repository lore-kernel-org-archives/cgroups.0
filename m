From: Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: blkio cgroups controller doesn't work with LVM?
Date: Wed, 24 Feb 2016 12:12:19 -0600
Message-ID: <56CDF283.9010802@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi,

Are there known limitations with the blkio cgroup controller when used with LVM?

I'm using Ubuntu 15.10 with the 4.2 kernel.  I got the same results with CentOS 7.

I set up two groups, /sys/fs/cgroup/blkio/test1 and /sys/fs/cgroup/blkio/test2. 
  I set the weight for test1 to 500, and the weight for test2 to 1000.

If I then read/write to a file on /dev/sda1 from a process in each group, then 
everything works as expected and test1 gets half the bandwidth of test2.

If I do the same but accessing an LVM logical volume, where the underlying 
physical volume is /dev/sda4, then both groups get the same bandwidth.

It appears that the group weight doesn't get propagated down through all the 
layers.  Am I missing something?  If not, is this documented anywhere?

Thanks,
Chris
