From: Weiping Zhang <zwp10758@gmail.com>
Subject: Re: [PATCH v5 0/4] Add support Weighted Round Robin for blkcg and nvme
Date: Tue, 31 Mar 2020 14:17:06 +0800
Message-ID: <CAA70yB62_6JD_8dJTGPjnjJfyJSa1xqiCVwwNYtsTCUXQR5uCA@mail.gmail.com>
References: <cover.1580786525.git.zhangweiping@didiglobal.com>
 <20200204154200.GA5831@redsun51.ssa.fujisawa.hgst.com> <CAA70yB5qAj8YnNiPVD5zmPrrTr0A0F3v2cC6t2S1Fb0kiECLfw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WIxxK39yFs5OEp2hoQ/hVPAMvH8Vwu0fOy3U41jNDI4=;
        b=gtnzYGc01I61h4c7FPRTBKTYrGmeLJqPOxWQilD4KbLcH5GwVg/Uuv7hhK9eqxoldh
         gjL/pGOzzxVQMvQ/LcYJhqqsc8wDXhhftxFsch/8i5eoD8Q2dw3TiI5w9VXjtVwEX5uR
         ChUk3p8MIb5NoNxjV0sPR1r0huoWCYmshLRjSHiXCSUV8j9ma4mpP/0xj48nz3tusZ/c
         jz1NULPB1/cd+In7xBAVsHPDhZALLJwJDFNetP9lBc6qt32VxOWsLU+DWt89fx/OElCA
         +ISoWCYB7YSrFXcLmSbmztf9s9ctzTbv2gX4R+UhivVqvU1hgVwu0gV0lmTMYCks40gT
         AFxg==
In-Reply-To: <CAA70yB5qAj8YnNiPVD5zmPrrTr0A0F3v2cC6t2S1Fb0kiECLfw@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>, Minwoo Im <minwoo.im.dev@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ming Lei <ming.lei@redhat.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org

> > On the driver implementation, the number of module parameters being
> > added here is problematic. We already have 2 special classes of queues,
> > and defining this at the module level is considered too coarse when
> > the system has different devices on opposite ends of the capability
> > spectrum. For example, users want polled queues for the fast devices,
> > and none for the slower tier. We just don't have a good mechanism to
> > define per-controller resources, and more queue classes will make this
> > problem worse.
> >
> We can add a new "string" module parameter, which contains a model number,
> in most cases, the save product with a common prefix model number, so
> in this way
> nvme can distinguish the different performance devices(hign or low end).
> Before create io queue, nvme driver can get the device's Model number(40 Bytes),
> then nvme driver can compare device's model number with module parameter, to
> decide how many io queues for each disk;
>
> /* if model_number is MODEL_ANY, these parameters will be applied to
> all nvme devices. */
> char dev_io_queues[1024] = "model_number=MODEL_ANY,
> poll=0,read=0,wrr_low=0,wrr_medium=0,wrr_high=0,wrr_urgent=0";
> /* these paramters only affect nvme disk whose model number is "XXX" */
> char dev_io_queues[1024] = "model_number=XXX,
> poll=1,read=2,wrr_low=3,wrr_medium=4,wrr_high=5,wrr_urgent=0;";
>
> struct dev_io_queues {
>         char model_number[40];
>         unsigned int poll;
>         unsgined int read;
>         unsigned int wrr_low;
>         unsigned int wrr_medium;
>         unsigned int wrr_high;
>         unsigned int wrr_urgent;
> };
>
> We can use these two variable to store io queue configurations:
>
> /* default values for the all disk, except whose model number is not
> in io_queues_cfg */
> struct dev_io_queues io_queues_def = {};
>
> /* user defined values for a specific model number */
> struct dev_io_queues io_queues_cfg = {};
>
> If we need multiple configurations( > 2), we can also extend
> dev_io_queues to support it.
>

Hi Maintainers,

If we add patch to support these queue count at controller level,
instead moudle level,
shall we add WRR ?

Recently I do some cgroup io weight testing,
https://github.com/dublio/iotrack/wiki/cgroup-io-weight-test
I think a proper io weight policy
should consider high weight cgroup's iops, latency and also take whole
disk's throughput
into account, that is to say, the policy should do more carfully trade
off between cgroup's
IO performance and whole disk's throughput. I know one policy cannot
do all things perfectly,
but from the test result nvme-wrr can work well.

From the following test result, nvme-wrr work well for both cgroup's
latency, iops, and whole
disk's throughput.

Notes:
blk-iocost: only set qos.model, not set percentage latency.
nvme-wrr: set weight by:
    h=64;m=32;l=8;ab=0; nvme set-feature /dev/nvme1n1 -f 1 -v $(printf
"0x%x\n" $(($ab<<0|$l<<8|$m<<16|$h<<24)))
    echo "$major:$minor high" > /sys/fs/cgroup/test1/io.wrr
    echo "$major:$minor low" > /sys/fs/cgroup/test2/io.wrr


Randread vs Randread:
cgroup.test1.weight : cgroup.test2.weight = 8 : 1
high weight cgroup test1: randread, fio: numjobs=8, iodepth=32, bs=4K
low  weight cgroup test2: randread, fio: numjobs=8, iodepth=32, bs=4K

test case         bw         iops       rd_avg_lat   wr_avg_lat
rd_p99_lat   wr_p99_lat
=======================================================================================
bfq_test1         767226     191806     1333.30      0.00
536.00       0.00
bfq_test2         94607      23651      10816.06     0.00
610.00       0.00
iocost_test1      1457718    364429     701.76       0.00
1630.00      0.00
iocost_test2      1466337    366584     697.62       0.00
1613.00      0.00
none_test1        1456585    364146     702.22       0.00
1646.00      0.00
none_test2        1463090    365772     699.12       0.00
1613.00      0.00
wrr_test1         2635391    658847     387.94       0.00
1236.00      0.00
wrr_test2         365428     91357      2801.00      0.00
5537.00      0.00

https://github.com/dublio/iotrack/wiki/cgroup-io-weight-test#215-summary-fio-output


Randread vs Seq Write:
cgroup.test1.weight : cgroup.test2.weight = 8 : 1
high weight cgroup test1: randread, fio: numjobs=8, iodepth=32, bs=4K
low  weight cgroup test2: seq write, fio: numjobs=1, iodepth=32, bs=256K

test case      bw         iops       rd_avg_lat   wr_avg_lat
rd_p99_lat   wr_p99_lat
=======================================================================================
bfq_test1      814327     203581     1256.19      0.00         593.00       0.00
bfq_test2      104758     409        0.00         78196.32     0.00
     1052770.00
iocost_test1   270467     67616      3784.02      0.00         9371.00      0.00
iocost_test2   1541575    6021       0.00         5313.02      0.00
     6848.00
none_test1     271708     67927      3767.01      0.00         9502.00      0.00
none_test2     1541951    6023       0.00         5311.50      0.00
     6848.00
wrr_test1      775005     193751     1320.17      0.00         4112.00      0.00
wrr_test2      1198319    4680       0.00         6835.30      0.00
     8847.00


https://github.com/dublio/iotrack/wiki/cgroup-io-weight-test#225-summary-fio-output

Thanks
Weiping
