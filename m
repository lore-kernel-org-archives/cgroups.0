Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCF8190462
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302276; cv=none; b=TY7KMepaj+J0EzqHlL/6sdzbST2fw9vdeKeXDTPUVTCIr9hUCDRcBy3CySVqG90CFgx3H6Jom5T5Ba7eV0nQeBjgqktL8omYQF6fojMEfcKNpgrklhgkotG/1m9MzbuccLhWjXauATmKnhKakBzfF+FSVNoEJJaxiXB8A59UcRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302276; c=relaxed/simple;
	bh=aGFBJJz1yqFYpScKeGR/8AsuUXJdbFeYZZ53zq3dtAI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=qVNlQCmYGYCJv38oA5DjlH7tcWPsdUnQlls6AMnC7wj0fpUn+TwytG4QuEPN0GByWCD+a8YkJSe7nextUgFdotRgkahQ5Y9b2pw8Y7x4JpS6y5OqN5j+smTfyklIk7aAl4+21rY9o4Ha4uT79tkg4+CmAXtxhgzg+Ij3+XrGTOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sJ0eT7ts; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sJ0eT7ts"
Date: Fri, 17 Jul 2026 23:30:01 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784302262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NlouOKa/8PPMBwt5vs9hE9n+1BxmphX8h70rR3/rDEs=;
	b=sJ0eT7tst1v/bT+eH3+C3malLU4xwrFGVNXygbxIO7x8ikKECupdeDuauHCcsJxjrFM/qI
	RNYnPrizgTYnkvpJXdK1Vvt7ks4w6f+I9hxacz7NqoZobnft6QFL/SHPlofjiQsxGTycfG
	5kdiLIgYJGAY25GSC/W+MhOU50+zdao=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
To: guojian <guojian@kylinos.cn>, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, shuah@kernel.org
CC: cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_selftests/cgroup=3A_Remove_redu?=
 =?US-ASCII?Q?ndant_cg=5Fenter=5Fcurrent=28=29_call_in_test=5Fcore?=
In-Reply-To: <274129a4-88cd-49d4-9148-5112a8ac59e3@linux.dev>
References: <20260717110606.298368-1-guojian@kylinos.cn> <274129a4-88cd-49d4-9148-5112a8ac59e3@linux.dev>
Message-ID: <25054CA3-5D62-4254-85A2-F9CE876FB15D@linux.dev>
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



=E4=BA=8E 2026=E5=B9=B47=E6=9C=8817=E6=97=A5 GMT+08:00 20:51:58=EF=BC=8CTa=
o Cui <cui=2Etao@linux=2Edev> =E5=86=99=E9=81=93=EF=BC=9A
>
>
>=E5=9C=A8 2026/7/17 19:06, guojian =E5=86=99=E9=81=93:
>> From: Jian Guo <guojian@kylinos=2Ecn>
>>=20
>> The test_cgcore_no_internal_process_constraint_on_threads test has two
>> back-to-back cg_enter_current(root) calls in its cleanup path=2E
>>=20
>> A single cg_enter_current() call atomically migrates the entire thread
>> group to the target cgroup even for multi-threaded processes, and this
>> test creates no extra threads or child processes that would require a
>> second migration attempt=2E The second call is a harmless no-op once th=
e
>> process is already in the root cgroup, but it is redundant and
>> inconsistent with the cleanup logic used in all other cgroup core
>> selftest cases=2E
>>=20
>> Remove the duplicate call to clean up the code=2E No functional change =
is
>> intended=2E
>>=20
>> Signed-off-by: Jian Guo <guojian@kylinos=2Ecn>
>> ---
>>  tools/testing/selftests/cgroup/test_core=2Ec | 1 -
>>  1 file changed, 1 deletion(-)
>>=20
>> diff --git a/tools/testing/selftests/cgroup/test_core=2Ec b/tools/testi=
ng/selftests/cgroup/test_core=2Ec
>> index 88ca832d4fc1=2E=2E8e3f9b391e44 100644
>> --- a/tools/testing/selftests/cgroup/test_core=2Ec
>> +++ b/tools/testing/selftests/cgroup/test_core=2Ec
>> @@ -426,7 +426,6 @@ static int test_cgcore_no_internal_process_constrai=
nt_on_threads(const char *roo
>>  	ret =3D KSFT_PASS;
>> =20
>>  cleanup:
>> -	cg_enter_current(root);
>>  	cg_enter_current(root);
>>  	if (child)
>>  		cg_destroy(child);
>
>Ran test_core on x86_64 (cgroup v2, all controllers available),
>12/12 pass, 0 fail, 0 skip =E2=80=94 output byte-identical before and
>after the patch=2E Confirms the removed call is a no-op=2E
>
>Acked-by: Tao Cui <cuitao@kylinos=2Ecn>
>

Hi,

Correction to my previous reply:

Ran test_core on x86_64 (cgroup v2, all controllers available),
12/12 pass, 0 fail, 0 skip =E2=80=94 output byte-identical before and afte=
r the patch=2E Confirms the removed call is a no-op=2E

Tested-by: Tao Cui <cuitao@kylinos=2Ecn>

Please ignore the earlier Acked-by tag=2E

Thanks,
Tao

>Thanks,
>Tao
