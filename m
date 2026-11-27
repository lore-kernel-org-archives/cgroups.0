Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795813687;
	b=0H2HaF5zOptyEUxl/DTN6ahG2QON13EbCbuz+6wlC4IfGbz6wFRykXdikk1b4XpcfkCu
	 7SAZ37NyqdRkAOOOehAXeVN9CG0H9rQOsfsByxcbtp6/+do90dtCu8of56i3iJ8W5OWu+
	 2bOfKUOjVad+LkM9NnW1xxBdCUZcs5T04gZe2UNfWscFnU8/WbicJ4dY3WAC8A7VPyTzk
	 7ByMmB05z1xmleUWrfsIaI9gGKna7VlkLudZblBzF0d4XgORn4q1vqFIohPmr+wyQRDZx
	 N6DJ7xJveybj7WzV52sQzwTMDZc1Tptdxc9ZfPaWgJ+yOjRYpVeEWpR4lVoreIEoEnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795813687;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=N6vTaXszBb3u+Y5jPFovmYn2ppIGsWmdf1thU21O/tw=;
	b=EI8sMEkI1lc8rAA6VHqWzfobLH4UpQUSXcsl/p1T3Wi5FZgrJ6YTcFHRSKgbyVHiUyFL
	 Qi8HJLW29PlKMsfCUrFVo1RpdRZRdapMSuY2hNzzeH8SHdNNSp733T62kzshklsrj2K9a
	 2cfE/Plc6QUtxW0EoqL0PM8WoaBsAqrsQEaxv5aaUuKur9ieDmBPqTE4b8qVGdeU+NJr4
	 IhJPLsHozGLd91Vph6rv34u8Lkl8Elg2NdfyUMxahKc+81iF2OpWHH+NGWUdXZ9lt8sQt
	 tfJowE5ZQ91YizQBmgWrUc4yaFQxKTxtRATW+spNpovJkeMQFbHlXHVyMmcpW6T/wmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=F8Nvozdz;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6216606A31C
	for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 21:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6216606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=F8Nvozdz
DKIM2-Signature:  i=1; m=1; t=1795813683;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGNncm91cHNAdmdlci5rZXJuZWwub3JnPg==;
 d=gmx.com;
 s=s31663417:rsa-sha256:tV5zptMbdTnOA34YYiPzw62FY9kj
   oXl5evdnZQQEabI4HwsBR3jFJZUL/5ewPypDBxSdUU4EswKsyX0xM5+3ZzkBrVBiqWZF53fNoDg
   MQzxuUAhvNAB7DRyFLxTcKy/HfzLtjq9Lb70qR8l1At/SNKDfH+PFb9SAcQBP5dUbvoX1i9SDaC
   Yeg/qqAMD3Zn31R+sioDheu74UzWJtwRgbeECx33rwODQIUcgqVldzt97v+hOvKsmOhxC/+eS52
   LK9giTp20c1RhPxleLoZtDe2qdvcp2nNeamitg0AnnqIX6yE/CuMaf+sRikVqVPxrAVjolhZoqk
   XMXvOwwQEax75g==;
Message-Instance:  m=1;
 h=sha256:
   qWBKO8gFDdrz/jgv6FFwzlKoLkRVRtqjCfbRSiuz8ko=:
   oxkL/1vT/I62B2ZU/rpKURSLchjNfA4cRrAp86CFG5A=,
  sha512:
   3Np7ctm3thhW5jJzSTxN7bEsDAr2e+OmVFV1XMBwBPC2oNCxohrtVElRGwn2v+9BiNSNbcuqdFIsEkG16mgZgw==:
   yY5OjK2gZv2VsOSTUPawVH0cVMpxK4SN9yvkto6WoDe1LG3m+HgT0l+prsm/UlHPmBDwQ646e40i1RywO3xmzg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795813653; x=1796418453; i=quwenruo.btrfs@gmx.com;
	bh=N6vTaXszBb3u+Y5jPFovmYn2ppIGsWmdf1thU21O/tw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=F8NvozdzigB1izRlI194pDyLLY9OV44vaWD4K6XDwPG2K5UszonQ+iBXY4Xkmydf
	 YLDL5IL1KtWTCFLG8KRbKTaZlKREliLrwQTVZlKaAtiwmfExogeuLA6ayHPBCp1g1
	 zNCYhV0agZKJqI9XJtxMsSIauRG3hfHK1+RZG5zAdk+Zr56rM38BDQ+dSWHUxUgIM
	 4MOVPr/vXGYSyGt/m488SZFpXli+TLZyU5dBXYH3bwRcQh5waRlYyikH8c/sNdLP4
	 epJHMnQVqd8c27RfiC/IYURvqGV9EThQopcU1IUkSr5ujvLzYcbrZ0qSzhqWtay+g
	 uXTKEUNk4XPPvfiFdg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MRCKC-1xu4Dw2qZQ-00Lhm8; Fri, 27
 Nov 2026 22:07:33 +0100
Message-ID: <a0ae6351-2eb1-41b9-b085-db924442c685@gmx.com>
Date: Sat, 28 Nov 2026 07:37:26 +1030
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: btrfs, blk-throttle: cross-subvolume fsync stalls behind
 throttled write_dev_flush()
To: Tianyi Chen <hi@tychen.cc>, David Sterba <dsterba@suse.com>,
 Qu Wenruo <wqu@suse.com>, Tejun Heo <tj@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>
Cc: Chris Mason <mason@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Ming Lei <tom.leiming@gmail.com>, Yu Kuai <yukuai@fygo.io>,
 Mark Korenberg <socketpair@gmail.com>, linux-btrfs@vger.kernel.org,
 linux-block@vger.kernel.org, cgroups@vger.kernel.org
References: <20261127121458.2090454-1-hi@tychen.cc>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <20261127121458.2090454-1-hi@tychen.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Y6cX+J49k1lAWWwZC1+ooBqMxvLo55tn/I1qjzfVkIqhR8SX/Vn
 fnpAAzBf+kIVwAB/naIVRNeefCGg6EUTkzi0jOP30IX2nw8Oq2Ko6IDPfTqQaMp9rhIrROA
 h7G6qd3nnPRaHQ3G64JKZWpNjDeSUKjXotpxAF/Y4wovJBlG3j4gsDDpyiFt/2iXMEOk/5h
 g6ab/qLN+HDAJArO+S6XA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LZKqBDtfWbM=;2HpI8YPQ6lpqpPbFUFL4xVC8E24
 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
 d+MpzvbngUVuPRZ0hsc0s5oEQ+CFQ==



=E5=9C=A8 2026/11/27 22:44, Tianyi Chen =E5=86=99=E9=81=93:
> Hi David, Qu, Tejun, Josef,
>=20
> On f47d223627f8 (post-v7.3; write_dev_flush() and __blk_throtl_bio()
> are unchanged on current mainline), an unthrottled cgroup doing fsync()
> on one Btrfs subvolume can stall for 200-300 ms behind a sibling
> subvolume cgroup capped with io.max wbps. Putting the two workloads on
> separate Btrfs filesystems on the same parent disk avoids the stall.
>=20
> In traced 2-vCPU KVM runs, cgroup A ran 100 Hz SQLite WAL
> (synchronous=3DFULL) or LMDB commits on subvolume lc (io.max=3Dmax) whil=
e
> cgroup B wrote and fsynced 64 KiB files in 1 MiB batches on subvolume
> be (wbps=3D2097152). Every >50 ms foreground commit (18/18 WAL, 18/18
> LMDB) slept in wait_log_commit() on the shared log_root_tree commit
> while B was in:
>=20
>    btrfs_sync_log() -> write_all_supers() -> barrier_all_devices()
>      -> write_dev_flush()
>=20
> When write_dev_flush() submitted its 0-byte REQ_OP_WRITE | REQ_SYNC |
> REQ_PREFLUSH bio, B's blk-throttle queues were empty, but B had just
> dispatched REQ_META tree-log writes (825-45,880 bytes over its slice
> budget), so tg_within_bps_limit() queued the untagged 0-byte preflush
> for 67-112 ms. Right after barrier_all_devices(), write_dev_supers()
> submits the superblock write with REQ_OP_WRITE | REQ_SYNC | REQ_META |
> REQ_PRIO.
>=20
> Commits 29390bb5661d ("blk-throttle: support prioritized processing of
> metadata") and a9fc8868b350 ("blk-throttle: don't take carryover for
> prioritized processing of metadata") dispatch over-limit REQ_META bios
> via bio_issue_as_root_blkg() and charge debt back without trimming the
> slice. On the other hand, Mark Korenberg's recent REQ_META audit [1]
> deliberately left write_dev_flush() untagged because the empty preflush
> covers the whole device cache.
>=20
> In the same thread Qu argued that background work such as scrub
> should not get the priority of metadata I/O [2], and v2 dropped those
> paths [3]. This flush is not background work: write_all_supers()
> issues it on every log or transaction commit, right before the
> superblock write that already carries REQ_META | REQ_PRIO.

What's the point here? The series (older or merged version) has never=20
touched the barrier part, nor my comment.

This looks like some unrelated LLM word salad.

And again, make LLM generated reports shorter for human readers.

>=20
> To measure both sides of that choice, I tested this one-line change to
> the bio_init() flags in write_dev_flush():
>=20
>    -  REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH
>    +  REQ_OP_WRITE | REQ_SYNC | REQ_META | REQ_PRIO | REQ_PREFLUSH

I believe you're using the same flags from the super block writes.

Since btrfs has multi-device support, we can not simply submit super=20
writes with PREFLUSH, or one device may got its super block written,=20
meanwhile the other devices didn't even finish flush.
This is the same as other multi-device storage solution like md/dm.

For other fses like XFS/EXT4 they fold the preflush into the super block=
=20
writes, so the preflush will get the same flags of the super block=20
write, as they do not need to bother multiple devices (except at most=20
one external journal device).


I'd prefer more advice from block layer on such separate flush and sb=20
writes.
Is it recommended to use the same flags for such cases?

IIRC dm/dm may also have the same problem for multi-devices, the=20
per-device flush doesn't care the same META flag of their super block=20
writes.

Thanks,
Qu
