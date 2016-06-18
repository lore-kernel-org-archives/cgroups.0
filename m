From: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: question about cgroupv2
Date: Sat, 18 Jun 2016 10:11:17 +0800
Message-ID: <5764ADC5.20205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Sorry for disturbing.

I want to test how to use cgroup v2 on kernel 4.6.2.
And I have read https://www.kernel.org/doc/Documentation/cgroup-v2.txt
According to the above document, I added kernel parameter cgroup_no_v1=1.
But, system still automount the v1 cgroup.
Then, I executed:
# mount -t cgroup2 none /mnt

But, cgroup.controllers in /mnt is empty.

I'm not sure if I made something wrong or cgroup v2 is not supported on kernel 4.6.2?


Thanks
-- 
Ma Shimiao
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)

