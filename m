From: "Wangshen (Peter)" <peter.w-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: A problem of blkio in throttlling I/O weight across multiple hosts.
Date: Tue, 15 Oct 2013 07:20:14 +0000
Message-ID: <FD44589ECFC0AF44ABFD421806CAB1F081ECC567@SZXEMA502-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: zh-CN
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Jinbo (Justin)" <jinbo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi All,
To set blkio.weight_device will throttle I/O weight among tasks running on a single host.
But it won't take effect among tasks running on different hosts.

Is it necessary to add some distributed functions to cgroup?
Let cgroup can throttle block I/O weight across multiple nodes.

Because in modern IT industry, instead of running on one single host, more and more applications
are running in clustering environment. Storage devices like SAN are also shared across multiple nodes.
So I think cgroup needs urgently to support block I/O weight throttle on multiple hosts.

I apologize if this question was covered and I missed it.
