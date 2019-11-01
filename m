From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-iocost
Date: Fri, 1 Nov 2019 17:56:48 +0100
Message-ID: <F45F2906-AB10-473D-B515-793E8FB10E6A@linaro.org>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190828220600.2527417-9-tj@kernel.org>
 <20190910125513.GA6399@blackbody.suse.cz>
 <20190910160855.GS2263813@devbig004.ftw2.facebook.com>
 <20191003145106.GC6678@blackbody.suse.cz>
 <20191003164552.GA3247445@devbig004.ftw2.facebook.com>
 <20191009153629.GA5400@blackbody.suse.cz>
 <20191014153643.GD18794@devbig004.ftw2.facebook.com>
 <20191101161506.GA28212@blackbody.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nS/+TuNpW6A1PUyhzxZcAt0Rui/rYCvfdsnTwLIkmXw=;
        b=sk3+H7dO516bj4wsmf/aijFVggFKvvcBuKWoWWmP306tit1N5cx4Qtom236Y07f0ea
         gbRPnVHnWEUHHv4lcm6mJQ0DEJDe09DQAQiaQxkRxtI5n1CPRYhk1NitTna5L6gekVBG
         iRUT+gTn2tXf/bzdLAgVKL1tXWjgPVgYNjTs07ltD51Vs2HqC17+KocxxKXq/ZrWQshU
         kgMl5lViIosBn8ACvqZX5dZ4dtZPR0KdCR6h7sRA77FmOptA1TkPIQIkWf8hQvb5RPPk
         jF/qKqrmwU+l8KR7PXfwXujK6BJO/lo5Dkev274P+I+FtMyEDYwFYAMqhbV4Lh86hXXL
         0ppw==
In-Reply-To: <20191101161506.GA28212@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, clm@fb.com, dennisz@fb.com, Josef Bacik <jbacik@fb.com>, kernel-team@fb.com, newella@fb.com, lizefan@huawei.com, axboe@kernel.dk, Rik van Riel <riel@surriel.com>, josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



> Il giorno 1 nov 2019, alle ore 17:15, Michal Koutn=C3=BD =
<mkoutny@suse.com> ha scritto:
>=20
> Hello
>=20

Hi Michal,

> (I realize it's likely late for the remark but I'd like to bring it up
> anyway.)
>=20
> On Mon, Oct 14, 2019 at 08:36:43AM -0700, Tejun Heo <tj@kernel.org> =
wrote:
>> We likely can talk on the subject
>> for a really long time probalby because there's no clearly =
technically
>> better choice here, so...
> I agree with you that functionally the two options are equal and also
> from configuration POV they seem both sensible.
>=20
> I checked where BFQ stores its per-device parameters and its under the
> sysfs directory of given device's iosched directory. So from the user
> perspective it'd be more consistent if all similar tunables resided
> under that location.
>=20
> (OTOH, I admit I'm not that familiar with block layer internals to
> identify the overlap between IO scheduler and IO controller.)
>=20

If useful for you to know, BFQ parameters are not meant to changed
(apart from the low_latency tunable, if one wants full control on
weights).  Parameters are a testing aid, to use in case of an anomaly.
After solving the anomaly, default values should be used again.

Thanks,
Paolo

>> Yeah, it's kinda unfortunate that it requires this many parameters =
but
>> at least my opinion is that that's reflecting the inherent
>> complexities of the underlying devices and how workloads interact =
with
>> them.
> After I learnt about the existence of BFQ tunables, I'm no longer
> concerned by the complexity of the parameter space.
>=20
> Thanks for the explanations of QoS purpose.
>=20
>> For QoS parameters, Andy is currently working on a method to =
determine
>> the set of parametesr which are at the edge of total work cliff -
>> ie. the point where tighetning QoS params further starts reducing the
>> total amount of work the device can do significantly.
> The QoS description in the Documentation/ describes the interpretation
> of the individual parameters, however, this purpose and how it works =
was
> not clear to be from that. I think the QoS policy would deserve =
similar
> description in the Documentation/.
>=20
>> Nothing can issue IOs indefinitely without some of them completing =
and
>> the total amount of work a workload can do is conjoined with the
>> completion latencies. [...]
> I may reply to this point later. However, if that provably works, I'm
> likely missing something in my understanding, so that'd be irrelevant.
>=20
> Cheers,
> Michal

