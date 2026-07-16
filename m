Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C4142CB0A
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 15:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784214768; cv=none; b=UsK15OmrP4z7QULkJ3LJyxAmIVyVbhKws1xkBvaW1us/VZ1VEJDEcvUyk2O6JHColTgS77v918CMXKiujZqqlbEBeEkl23AUxxeVbOnbsmT2KrIBWMGRuBYvOI0lQ4lK0HtgyHxWTr8GOHbcUwm6SJ9AuHJX55KWg7RjgEuXmIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784214768; c=relaxed/simple;
	bh=ZPyJI2pYhHQ1MsWDpVe9QVjw0IH7xnyxD9qeAUMH8d4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Uu3JddTUUu5fZ8RFFXdYFJZVeUIENlwO6h2hEFfelsYZqEBqpjVBptuZuWB1LYgkq5fPNfh7CA0nn50/Zv+1W9c9BMjc7jEYD7AU7f+PEpe7UOBuRwj4TRU5c7epcw6mgpwNxBi7tHMnmpasczzEqWIvpjC+sG2e4S/3deVzccM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dOttxxQN; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dOttxxQN"
Date: Thu, 16 Jul 2026 23:12:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784214759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a7siW4BWYbF2bVPq4L28mA1Cng4BLot1w3qQat4kVMw=;
	b=dOttxxQNBwkd8bbJGB7zEsD4LTXG0SFohiwO/ZTtT3iez1RhmLOi/6LknS9S1l8Y1Fslg8
	IfK8T9CEy1fiC9PGfqWjBZ/0y+zmv3xvjbQxwD2EXXnSMTivXsNeCX8Qq7Ry9JgHe5KSrg
	9qseOy2mqJVbCwEObdTUnok5sChgjsQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
To: Haris Iqbal <haris.iqbal@linux.dev>, axboe@kernel.dk, tj@kernel.org,
 josef@toxicpanda.com
CC: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_blk-throttle=3A_fix_divid?=
 =?US-ASCII?Q?e-by-zero_on_legacy_iops_limit_of_0?=
In-Reply-To: <d7d251c8-c0a7-493d-ab7a-386d441b93cb@linux.dev>
References: <20260714103552.1335658-1-cui.tao@linux.dev> <d7d251c8-c0a7-493d-ab7a-386d441b93cb@linux.dev>
Message-ID: <4E3A7403-9006-46D6-826C-B451F2697840@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT



=E4=BA=8E 2026=E5=B9=B47=E6=9C=8816=E6=97=A5 GMT+08:00 00:13:06=EF=BC=8CHa=
ris Iqbal <haris=2Eiqbal@linux=2Edev> =E5=86=99=E9=81=93=EF=BC=9A
>
>
>On 7/14/26 12:35, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos=2Ecn>
>>=20
>> Writing a multiple of 2^32 (e=2Eg=2E 4294967296) to a legacy cgroup v1
>> throttle iops file (blkio=2Ethrottle=2E{read,write}_iops_device) silent=
ly
>> truncates to 0: tg_set_conf() stores the sscanf-parsed u64 value into
>> an unsigned int field with no clamping=2E The cgroup v2 path,
>> tg_set_limit(), already clamps the same kind of value with
>> min_t(u64, val, UINT_MAX), but the legacy path never did=2E Note that
>> the "!v -> U64_MAX" mapping only catches an explicit zero and does not
>> catch a value that truncates to zero=2E
>>=20
>> With iops stored as 0, tg_update_has_rules() sets has_rules_iops[] and
>> the next IO reaches tg_within_iops_limit(), which computes
>>=20
>>      jiffy_wait =3D max(jiffy_wait, HZ / iops_limit + 1);
>>=20
>> triggering a divide-by-zero oops=2E
>>=20
>> Fix it in two places:
>>=20
>>    * tg_set_conf(): clamp the value to UINT_MAX, consistent with
>>      tg_set_limit()=2E This closes the truncation root cause (and the
>>      general silent truncation for any value above UINT_MAX)=2E
>>=20
>>    * tg_dispatch_iops_time(): treat iops_limit =3D=3D 0 as unlimited so=
 the
>>      divide in tg_within_iops_limit() is never reached, defending
>>      against any future path that could produce a zero limit=2E
>>=20
>
>Does this need a "Fixes:" tag=2E
>
Noted, I will address this in the next version=2E

Thanks,
Tao

>> Signed-off-by: Tao Cui <cuitao@kylinos=2Ecn>
>> ---
>>   block/blk-throttle=2Ec | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/block/blk-throttle=2Ec b/block/blk-throttle=2Ec
>> index ffc3b70065d4=2E=2E3f3c1374f4b2 100644
>> --- a/block/blk-throttle=2Ec
>> +++ b/block/blk-throttle=2Ec
>> @@ -883,7 +883,12 @@ static unsigned long tg_dispatch_iops_time(struct =
throtl_grp *tg, struct bio *bi
>>   	u32 iops_limit =3D tg_iops_limit(tg, rw);
>>   	unsigned long iops_wait;
>>   -	if (iops_limit =3D=3D UINT_MAX || tg->flags & THROTL_TG_CANCELING)
>> +	/*
>> +	 * iops_limit =3D=3D 0 is not a valid limit=2E Treat it as unlimited =
so we
>> +	 * never reach the HZ / iops_limit divide in tg_within_iops_limit()=
=2E
>> +	 */
>> +	if (iops_limit =3D=3D UINT_MAX || iops_limit =3D=3D 0 ||
>> +	    tg->flags & THROTL_TG_CANCELING)
>>   		return 0;
>>     	tg_update_slice(tg, rw);
>> @@ -1386,7 +1391,8 @@ static ssize_t tg_set_conf(struct kernfs_open_fil=
e *of,
>>   	if (is_u64)
>>   		*(u64 *)((void *)tg + of_cft(of)->private) =3D v;
>>   	else
>> -		*(unsigned int *)((void *)tg + of_cft(of)->private) =3D v;
>> +		*(unsigned int *)((void *)tg + of_cft(of)->private) =3D
>> +			min_t(u64, v, UINT_MAX);
>>     	tg_conf_updated(tg, false);
>>   	ret =3D 0;
>
