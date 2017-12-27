From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [RFC] distinguish foreground and background IOs in block throttle
Date: Wed, 27 Dec 2017 13:36:14 +0100
Message-ID: <A491ADB3-5487-4161-A526-E0C3AF416437@linaro.org>
References: <1fa623a6-e374-de5e-477e-e604cb760f82@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_AACAA3E2-F234-41B8-BEC9-D703D74EC9BC"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=Lnhjbup2faMH7pvIfRF4yJsiPnSYFfRli9JYc9qtQhI=;
        b=Qb23TNpl3wp9dUk5mvqhsj/paTMD7UkuRuVZOsGmG7KZQHCEgac8I6Fl2mmmtGtCgJ
         DgrtiXeuZmploYIq54ELXwyX8ueVCdb3fS60vRQiBUw/85HHFCbS+UMesfNWCDxS2y8K
         ydWr4YYPDpRR1rNeIsV2/qDbvOQw046fEN6Zs=
In-Reply-To: <1fa623a6-e374-de5e-477e-e604cb760f82@gmail.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: xuejiufei <xuejiufei@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@fb.com>, Shaohua Li <shli@kernel.org>, linux-block <linux-block@vger.kernel.org>, cgroups@vger.kernel.org, Mark Brown <broonie@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>


--Apple-Mail=_AACAA3E2-F234-41B8-BEC9-D703D74EC9BC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> Il giorno 25 dic 2017, alle ore 03:44, xuejiufei <xuejiufei@gmail.com> =
ha scritto:
>=20
> Hi all,
>=20
> Cgroup writeback is supported since v4.2. I found there exists a
> problem in the following case.
>=20
> A cgroup may send both buffer and direct/sync IOs. The foreground
> thread will be stalled when periodic writeback IOs is flushed because
> the service queue already has a plenty of writeback IOs, then
> foreground IOs should be enqueued with its FIFO policy.
>=20
> I wonder if we can distinguish foreground and background IOs in block
> throttle to fix the above problem.
>=20
> Any suggestion are always appreciated.
>=20

Hi,
to address similar issues, I have just sent a patch [1] for the BFQ
I/O scheduler.  If you want to give it a try, it might solve, or at
least mitigate, your problem (the patch does not involve groups,
though, at least for the moment).

There are still pending patches related to the low_latency mode of
BFQ, so I suggest you to try with low_latency disabled, i.e., as root:
echo bfq > /sys/block/<your-device>/queue/scheduler
echo 0 > /sys/block/<your-device>/queue/iosched/low_latency=20

For your possible convenience, I have attached the patch, gzipped, to
this email too.

Thanks,
Paolo

[1] https://www.spinics.net/lists/kernel/msg2684463.html


--Apple-Mail=_AACAA3E2-F234-41B8-BEC9-D703D74EC9BC
Content-Disposition: attachment;
	filename=0001-block-bfq-limit-tags-for-writes-and-async-I-O.patch.gz
Content-Type: application/x-gzip;
	x-unix-mode=0644;
	name="0001-block-bfq-limit-tags-for-writes-and-async-I-O.patch.gz"
Content-Transfer-Encoding: base64

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
Y8LBGbjeyPUc53+2m3pzbBUAAA==
--Apple-Mail=_AACAA3E2-F234-41B8-BEC9-D703D74EC9BC
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



> 
> Thanks,
> Jiufei


--Apple-Mail=_AACAA3E2-F234-41B8-BEC9-D703D74EC9BC--
