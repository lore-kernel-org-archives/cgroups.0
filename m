From: "Li,Rongqing" <lirongqing@baidu.com>
Subject: mount cgroup with "already mounted or cgroup busy"
Date: Wed, 30 Oct 2019 09:32:41 +0000
Message-ID: <11be9352e1e54ebebad078b1dac7b670@baidu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

Hi:

I meet a issue, and not sure if it is normal
Using the below script, the last line mount will fail after unmount
And it will fail until reboot system

mount -t cgroup -o cpu,cpuset xx cgroup
mkdir cgroup/x
rmdir cgroup/x
umount cgroup
mount -t cgroup -o cpu xx cgroup
mount: xx already mounted or cgroup busy

but if I add sleep, it will success

mount -t cgroup -o cpu,cpuset xx cgroup
mkdir cgroup/x
rmdir cgroup/x
sleep 10  <<<<==========
umount cgroup
mount -t cgroup -o cpu xx cgroup

- Li RongQing


