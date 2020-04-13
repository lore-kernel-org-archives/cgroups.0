From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCHSET v2 block/for-5.8] iocost: improve use_delay and latency
 target handling
Date: Mon, 13 Apr 2020 20:00:29 +0300
Message-ID: <6f69d35c-c593-f140-c351-c7fd2c13069e@gmail.com>
References: <20200413162758.97252-1-tj@kernel.org>
 <dd55f890-740c-16b5-77bd-4c6fdb710b3d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZESNvDEwJ4gUs6e0UsPpowCHJz6ut96Qf"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Y+OjZtirFhjkKohAUaG6BdVWbAOuDBo2mD5OAId8HZs=;
        b=bhljM/45ZDJuZwpwJOb8QMjCZbnOZWPwXXJxlZtz0k8J78lyk63TMhqsI2IwWSibjY
         RID2Cm5+ZEN13Xg4k+c30cv4cJAtDvJacnIbjdsjzoNB0ZZ2O9lrbtipsk2xP7mNwmdr
         CMPnkCStQX4m84ySBmtfT9w2f9sA6d8L8pQFdfZ4CoihS06PKjWsQ4NO30P/boCyZa6T
         jrcw3BJ6mIc9KSEjPrtgpzdk91dpL/AWRXRegYPqD3i7TmEX+W6u8bAHhCRcQ3zgfEwF
         ClsJ9kncLd3QpUgx6qTFNScUmHL4unzU8Q1i/+BMwG1CWVhYoqL0T9Ls7vs1DJnYbJt5
         xqLQ==
In-Reply-To: <dd55f890-740c-16b5-77bd-4c6fdb710b3d@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com, ming.lei@redhat.com, bvanassche@acm.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZESNvDEwJ4gUs6e0UsPpowCHJz6ut96Qf
Content-Type: multipart/mixed; boundary="YJcycZrC01yeR1rFUGN2cbIOj36u3pt4d";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@fb.com, cgroups@vger.kernel.org, newella@fb.com,
 josef@toxicpanda.com, ming.lei@redhat.com, bvanassche@acm.org
Message-ID: <6f69d35c-c593-f140-c351-c7fd2c13069e@gmail.com>
Subject: Re: [PATCHSET v2 block/for-5.8] iocost: improve use_delay and latency
 target handling
References: <20200413162758.97252-1-tj@kernel.org>
 <dd55f890-740c-16b5-77bd-4c6fdb710b3d@gmail.com>
In-Reply-To: <dd55f890-740c-16b5-77bd-4c6fdb710b3d@gmail.com>

--YJcycZrC01yeR1rFUGN2cbIOj36u3pt4d
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 13/04/2020 19:56, Pavel Begunkov wrote:
> On 13/04/2020 19:27, Tejun Heo wrote:
>> Changes from v1[1]
>>
>> * Dropped 0002-block-add-request-io_data_len.patch and updated to use
>>   rq->stats_sectors instead as suggested by Pavel Begunkov.
>=20
> rq->stats_sectors is set only when there is QUEUE_FLAG_STATS, see
> blk_mq_start_request(). I don't see blk-iocost requiring it. Did I miss=
 something?

And there is no reason to not initialise it unconditionally.

--=20
Pavel Begunkov


--YJcycZrC01yeR1rFUGN2cbIOj36u3pt4d--

--ZESNvDEwJ4gUs6e0UsPpowCHJz6ut96Qf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl6Umq0ACgkQWt5b1Glr
+6U03A/+I2I+IhvRJKZaVJ/TYjRLBm1UKE5ljXXgHE/tb96RkjvEh1NlKCGhNKn1
Sd/8fIT0QJW23aZVFUYPwVAYUKkzbmyhUX9bE2nYjq2A7OckDshVBvrKpjzVAH1w
8SBzWFKysTSAPdyGLN2V3/cRn8ioBAGTpZd57WQJs8668WYGKWgxovbrc/s/mkWx
jF9e8PN5ZYg24clRLMK+5T0Z3w5K2VwNitmCiGXzj8K8sxPNz/v6a6p/cpSNKfZ4
6eo+oOhg8o9wGRMiZtA2H9fE2wrY7xcg2sF8vLkvKq6pVz6yI29wk+FbLvQuYJYc
Uhjy0USJV2Mp4ErgLzGD2iZIicPgCQUZoTm5Jgqyp4NWJUoOAquULy1pSm8hYdiX
JOuDcKuo+7S/PMSDUwZiwUYAJfPScy/OxOrYiCiE5letmpty5JV1J79bZ32XGVyA
/dVFVHrTPz1sCAS1F/RMAsERwsa7uXg1DUPelQifAr1wGJ81bQMfrtGbCR4/QU2P
VsyuhDadwS22FmMX4eJKdsCLkAUOX8hhPj2TpDVgYrpB2O4i+hnruPp8oGcHeGsG
2zeMHq5Ld9Ma5rTXlXhUNANsHGRONkg0lWUEF5CJ5/ViwEbfCZ9Tqu3fKBv6sJ7t
NjrTqzZp5B4AdBb0AejSDIkmq4c9Y7tj102TsDs2vVFehf4p99w=
=39Mc
-----END PGP SIGNATURE-----

--ZESNvDEwJ4gUs6e0UsPpowCHJz6ut96Qf--
