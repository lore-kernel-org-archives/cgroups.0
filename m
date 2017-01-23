From: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: questions about cgroup devices
Date: Mon, 23 Jan 2017 15:16:01 +0800
Message-ID: <d28bc963-4936-6574-c606-d2b0c475f0c9@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi all,

I think I met a problem about cgroup devices.

The following is my detailed operations:

# cd /sys/fs/cgroup/devices/
# mkdir test
# echo "c 1:3 rw" > test/devices.deny
# cat test/devices.list 
a *:* rwm

It seems my setting does not react in devices.list.

But in another terminal, /dev/null is really limited to access.
$ sudo cgexec -g devices:test dd if=/dev/zero of=/dev/null bs=1M count=128
dd: failed to open '/dev/null': Operation not permitted

So, is this a bug of cgroup devices?

Environment:
OS version: Fefora 25
Kernel version: 4.8.15-300.fc25.x86_64


Thanks
-- 
Ma Shimiao
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)

