From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [PATCH] selftests: cgroup: Fix exception handling in
 test_memcg_oom_group_score_events()
Date: Sun, 26 Mar 2023 10:15:31 +0200
Message-ID: <5b7921c9-ee5d-c372-b19b-2701bcf33148@web.de>
References: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
 <c383bdca-6f0d-4a75-e788-e1920faa0a62@web.de>
 <fffcd98a-bb73-41cd-8545-0f2c55dd38f9@lucifer.local>
Reply-To: Markus Elfring <Markus.Elfring@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cocci-owner@inria.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject:reply-to:
   sender:list-id:list-help:list-subscribe:list-unsubscribe:
   list-post:list-owner:list-archive;
  bh=0hOXMUsTjQwfIGkRK6IQA5bCvVxoMO8D/eIb/X7Jn6o=;
  b=h27s7AFjPFNk4DISMS/Bsu9JpAwo0hNZ8DDV4lnYal83BHdkeVMmwQeO
   gcZtACutxsvjEfUp2Y+MWd73cv5wNpzCtRglv/xEimbjn39rtUrTXVsFY
   3QdCKoQKwZIjckBIiqkHgGZXHn/yJPLq2yTqdUITq+DbyNoOwGheSLic3
   Q=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1679818543; i=markus.elfring@web.de;
	bh=rBCEKqUiIg95hHqIQA+rJDnVzCS8UUItPB3j6Z3IkBs=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i60JcdfEiXZjhXmlN0wT0hEYONtQ+sM4g9Oc04ByPbsuIwSNCVKKVvSZUmE7VPD/t
	 ypNOoxI2sA+d/y4T+WeAuuicPGKuEfgiK1h1Lm02Ofc0bNBgZvnwzf4xGkwhzR0CO5
	 D2OlYCmR/A0O9pRPh38FVNdjhw6uss8m39rqE+KhIofExgH0pTW3R2IqaNMmjPct8F
	 QBXvq3FK8NKjGuR9tQemjYVP/aAqzLElpD00tI/LGUGhI/bKOkd1cQrQVf5kjZ5Lp6
	 NtcFb2R0zDaob9RnSoJMcNxDqTCqx2GcxnlA+PA9DFq7/zsHxz7Zz5P2gFKshenPnW
	 yiLxGI2/7HzUg==
Content-Language: en-GB
In-Reply-To: <fffcd98a-bb73-41cd-8545-0f2c55dd38f9@lucifer.local>
Errors-To: cocci-owner@inria.fr
Sender: cocci-request@inria.fr
List-Id: <cgroups.vger.kernel.org>
List-Help: <mailto:sympa_inria@inria.fr?subject=help>
List-Subscribe: <mailto:sympa_inria@inria.fr?subject=subscribe%20cocci>
List-Unsubscribe: <mailto:sympa_inria@inria.fr?subject=unsubscribe%20cocci>
List-Post: <mailto:cocci@inria.fr>
List-Owner: <mailto:cocci-request@inria.fr>
List-Archive: <https://sympa.inria.fr/sympa/arc/cocci>
Content-Type: text/plain; charset="utf-8"
To: Lorenzo Stoakes <lstoakes@gmail.com>, kernel-janitors@vger.kernel.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Jay Kamat <jgkamat@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc: cocci@inria.fr, LKML <linux-kernel@vger.kernel.org>

>> The label =E2=80=9Ccleanup=E2=80=9D was used to jump to another pointer=
 check despite of
>> the detail in the implementation of the function
>> =E2=80=9Ctest_memcg_oom_group_score_events=E2=80=9D that it was determi=
ned already
>> that a corresponding variable contained a null pointer.
>
> This is poorly writte and confusing.

A special source code combination was detected.


Reconsidering repeated pointer checks with SmPL
https://lore.kernel.org/cocci/f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de/
https://sympa.inria.fr/sympa/arc/cocci/2023-03/msg00017.html



> Something like 'avoid unnecessary null check/cg_destroy() invocation'
> would be far clearer.

I (or another interested contributor) can integrate such information into
a subsequent patch if the change acceptance will grow accordingly.


>> 1. Thus return directly after a call of the function =E2=80=9Ccg_name=
=E2=80=9D failed.
>
> This feels superfluious.

Under which circumstances would you care more for the advice
=E2=80=9CIf there is no cleanup needed then just return directly.=E2=80=9D
from the section =E2=80=9CCentralized exiting of functions=E2=80=9D?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv6.3-rc3#n532


>> 2. Use an additional label.
>
> This also feels superfluious.

The marking of special source code positions is probably required for
the presented design goal.


>> 3. Delete a questionable check.
>
> This seems superfluois and frankly, rude. It's not questionable,

Can you find the combination of code fragments like =E2=80=9Cif (!memcg)=
=E2=80=9D
and =E2=80=9Cif (memcg)=E2=80=9D suspicious?


> it's readable, you should try to avoid language like 'questionable' when=
 the
> purpose of the check is obvious.

I tend to prefer an other known design variant at this place.


>> This issue was detected by using the Coccinelle software.
>>
>> Fixes: a987785dcd6c8ae2915460582aebd6481c81eb67 ("Add tests for memory.=
oom.group")
>
> Fixes what in the what now?

1. Check repetition (which can be undesirable)

2. Can a cg_destroy() call ever work as expected if a cg_create() call fai=
led?


>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>> @@ -1242,12 +1242,11 @@ static int test_memcg_oom_group_score_events(co=
nst char *root)
>>  	int safe_pid;
>>
>>  	memcg =3D cg_name(root, "memcg_test_0");
>> -
>>  	if (!memcg)
>> -		goto cleanup;
>> +		return ret;
>>
>>  	if (cg_create(memcg))
>> -		goto cleanup;
>> +		goto free_cg;
>>
>>  	if (cg_write(memcg, "memory.max", "50M"))
>>  		goto cleanup;
>> @@ -1275,8 +1274,8 @@ static int test_memcg_oom_group_score_events(cons=
t char *root)
>>  	ret =3D KSFT_PASS;
>>
>>  cleanup:
>> -	if (memcg)
>> -		cg_destroy(memcg);
>> +	cg_destroy(memcg);
>> +free_cg:
>>  	free(memcg);
>>
>>  	return ret;
>> --
=E2=80=A6
> I dislike this patch, it adds complexity for no discernible purpose and
> actively makes the code _less_ readable and in a self-test of all places=
 (!)

It seems that there is a conflict to resolve also according to another
information source.
https://wiki.sei.cmu.edu/confluence/display/c/MEM12-C.+Consider+using+a+go=
to+chain+when+leaving+a+function+on+error+when+using+and+releasing+resourc=
es#MEM12C.Considerusingagotochainwhenleavingafunctiononerrorwhenusingandre=
leasingresources-CompliantSolution%28POSIX,GotoChain%29


Regards,
Markus
