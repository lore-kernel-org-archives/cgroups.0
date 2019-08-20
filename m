From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Tue, 20 Aug 2019 17:04:25 +0200
Message-ID: <B5E431F7-549D-4FC4-A098-D074DF9586A1@linaro.org>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614175642.GA657710@devbig004.ftw2.facebook.com>
 <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=b/1w5LvL+fBJM0aA0+n6sQkDfXDbUnJO+MNoklWJK6k=;
        b=s1wwfXpp3IIu5zYLuh/BcfPpG9+/3h93ZL8srfWtCF6/V4AgZTQd88PQVUUcIIceg3
         iSId+Jf/SelQiNRkah6dq2I28zAviqQCMMKXSS+Xiq3oPHj6m6EgZaG51LEYGQoBnQon
         G5r+to80gAgDsdFn3J9Kfbq0B/bgkyctwrG6pxNOikJmnb0tEmRvAZqt7d+KRolHHXm7
         TwWegXMdH5f5PRHcQnm6Izew+8dZ7IHI8eGNOXbrLyLpI01vth6grw8bR/FXPEVPSkrb
         /Ne4lqEnKF4FHaTQ7a8RZpQ+5N9qvYCSvDIJl5JnoEnpsJiBH737i+GLHjhNBHlYpBlF
         jP4A==
In-Reply-To: <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org



> Il giorno 20 ago 2019, alle ore 12:48, Paolo Valente =
<paolo.valente@linaro.org> ha scritto:
>=20
>=20
>=20
>> Il giorno 14 giu 2019, alle ore 19:56, Tejun Heo <tj@kernel.org> ha =
scritto:
>>=20
>> On Thu, Jun 13, 2019 at 06:56:10PM -0700, Tejun Heo wrote:
>> ...
>>> The patchset is also available in the following git branch.
>>>=20
>>> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git =
review-iow
>>=20
>> Updated patchset available in the following branch.  Just build fixes
>> and cosmetic changes for now.
>>=20
>> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git =
review-iow-v2
>>=20
>=20
> Hi Tejun,
> I'm running the kernel in your tree above, in an Ubuntu 18.04.
>=20
> After unmounting the v1 blkio controller that gets mounted at startup
> I have created v2 root as follows
>=20
> $ mount -t cgroup2 none /cgroup
>=20
> Then I have:
> $ ls /cgroup
> cgroup.controllers  cgroup.max.descendants  cgroup.stat             =
cgroup.threads  io.weight.cost_model  system.slice
> cgroup.max.depth    cgroup.procs            cgroup.subtree_control  =
init.scope      io.weight.qos         user.slice
>=20
> But the following command gives no output:
> $ cat /cgroup/io.weight.qos=20
>=20
> And, above all,
> $ echo 1 > /cgroup/io.weight.qos=20
> bash: echo: write error: Invalid argument
>=20
> No complain in the kernel log.
>=20
> What am I doing wrong? How can I make the controller work?
>=20

I made it, sorry for my usual silly questions (for some reason, I
thought the controller could be enabled globally by just passing a 1).

The problem now is that the controller doesn't seem to work.  I've
emulated 16 clients doing I/O on a SATA SSD.  One client, the target,
does random reads, while the remaining 15 clients, the interferers, do
sequential reads.

Each client is encapsulated in a separate group, but whatever weight
is assigned to the target group, the latter gets the same, extremely
low bandwidth.  I have tried with even the maximum weight ratio, i.e.,
1000 for the target and only 1 for each interferer.  Here are the
results, compared with BFQ (bandwidth in MB/s):

io.weight   BFQ
0.2         3.7

I ran this test with the script S/bandwidth-latency/bandwidth-latency.sh
of the S benchmark suite [1], invoked as follows:
sudo ./bandwidth-latency.sh -t randread -s none -b weight -n 15 -w 1000 =
-W 1

The above command simply creates groups, assigns weights as follows

echo 1 > /cgroup/InterfererGroup0/io.weight
echo 1 > /cgroup/InterfererGroup1/io.weight
...
echo 1 > /cgroup/InterfererGroup14/io.weight
echo 1000 > /cgroup/interfered/io.weight

and makes one fio instance generate I/O for each group.  The bandwidth
reported above is that reported by the fio instance emulating the
target client.

Am I missing something?

Thanks,
Paolo

[1] https://github.com/Algodev-github/S


> Thanks,
> Paolo
>=20
>> Thanks.
>>=20
>> --=20
>> tejun
>=20

