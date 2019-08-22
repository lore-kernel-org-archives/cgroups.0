From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Thu, 22 Aug 2019 10:58:22 +0200
Message-ID: <9EB760CE-0028-4766-AE9D-6E90028D8579@linaro.org>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614175642.GA657710@devbig004.ftw2.facebook.com>
 <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
 <B5E431F7-549D-4FC4-A098-D074DF9586A1@linaro.org>
 <20190820151903.GH2263813@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HwcMDsi2XQejCpwJcqSON0QYDIy6of9C4lFX3vq5Vd8=;
        b=rws6jNKsi1M8Rkg+o1TcSh47k+MBIMlZ2PG9GVoXpHOHN3MDWajZ42qf2bwZzNxViW
         DAkPKntHOYRZpDPuvQBKP7zUv/xa/jRR6w1y4bYMxRKUh79SEfgnY5pr5iHYPMjsgAXC
         tHtspKL5+LLP11iVlGZn7uqXQIsYg61EWdpwaohwUKU3vfXKzvl5DkkrMzXQtl+wnfPB
         JStOH5mMiyjBhPn0AYgSLb0WOsyjKgkMJnEmj3SR0AeYOSficjQrUV73JMO1ziA+o0Jb
         fVTYxfpb0LpU0FytZ+oQndnyNIff/g8nsrg8CJDfgs0FuxT66v2GorScxqX5dSepeJNF
         /zXQ==
In-Reply-To: <20190820151903.GH2263813@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org



> Il giorno 20 ago 2019, alle ore 17:19, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> Hello, Paolo.
>=20
> On Tue, Aug 20, 2019 at 05:04:25PM +0200, Paolo Valente wrote:
>> and makes one fio instance generate I/O for each group.  The =
bandwidth
>> reported above is that reported by the fio instance emulating the
>> target client.
>>=20
>> Am I missing something?
>=20
> If you didn't configure QoS targets, the controller is using device
> qdepth saturation as the sole guidance in determining whether the
> device needs throttling.  Please try configuring the target latencies.
> The bandwidth you see for single stream of rand ios should have direct
> correlation with how the latency targets are configured.  The head
> letter for the patchset has some examples.
>=20

Ok, I tried with the parameters reported for a SATA SSD:

rpct=3D95.00 rlat=3D10000 wpct=3D95.00 wlat=3D20000 min=3D50.00 =
max=3D400.00

and with a simpler configuration [1]: one target doing random reads
and only four interferers doing sequential reads, with all the
processes (groups) having the same weight.

But there seemed to be little or no control on I/O, because the target
got only 1.84 MB/s, against 1.15 MB/s without any control.

So I tried with rlat=3D1000 and rlat=3D100.

Control did improve, with same results for both values of rlat.  The
problem is that these results still seem rather bad, both in terms of
throughput guaranteed to the target and in terms of total throughput.
Here are results compared with BFQ (throughputs measured in MB/s):

                           io.weight            BFQ
target's throughput        3.415                6.224       =20
total throughput           159.14               321.375

Am I doing something else wrong?

Thanks,
Paolo

[1] sudo ./bandwidth-latency.sh -t randread -s none -b weight -n 4

> Thanks.
>=20
> --=20
> tejun

