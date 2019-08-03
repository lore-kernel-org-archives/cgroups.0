From: Masoud Sharbiani <msharbiani@apple.com>
Subject: Re: Possible mem cgroup bug in kernels between 4.18.0 and 5.3-rc1.
Date: Sat, 03 Aug 2019 11:24:37 -0700
Message-ID: <9B718E2A-FE3B-453E-9426-1E1880351765@apple.com>
References: <5659221C-3E9B-44AD-9BBF-F74DE09535CD@apple.com>
 <20190802074047.GQ11627@dhcp22.suse.cz>
 <7E44073F-9390-414A-B636-B1AE916CC21E@apple.com>
 <20190802144110.GL6461@dhcp22.suse.cz>
 <5DE6F4AE-F3F9-4C52-9DFC-E066D9DD5EDC@apple.com>
 <20190802191430.GO6461@dhcp22.suse.cz>
 <A06C5313-B021-4ADA-9897-CE260A9011CC@apple.com>
 <f7733773-35bc-a1f6-652f-bca01ea90078@I-love.SAKURA.ne.jp>
 <d7efccf4-7f07-10da-077d-a58dafbf627e@I-love.SAKURA.ne.jp>
 <77568CFC-280C-4C0F-85FC-92F1212BC6FC@apple.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : content-type
 : mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=20180706;
 bh=TsJz3OUo2WROq2nv/KDSlpoFx4edCT2XPw2Br1eBQ6Q=;
 b=f4Qnm3ODL1wAWmRXb6oQDjtVtLketIu79BacRVZ073C/QBz0u0+yFkjxkLQPfwN2B7cI
 glQ6sdc6r/rXbX+d/HS/8p79FYdQwiedwSE06/76VVqvAHHMD1RW0PFKhBVQaqTudXwZ
 1haM67pSkIDoYgzKGDdMzvJE6ltHsGMQmtLdolSuXZru862QBb0ygHAjQnvDmGPnJqlE
 T5HPQfNredWYW+ftIBSBlAPg7x+hSh8po4YtUc63xENMDOMjG+v4XttMJkQhCAnvRtH/
 VwHZDPCmnyorabSVSWKgvB8lsXWoKY3BW6XMyBENROIG+AXXBuA+90QEJzEAXQCClzK/ MA== 
In-reply-to: <77568CFC-280C-4C0F-85FC-92F1212BC6FC@apple.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michal Hocko <mhocko@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



> On Aug 3, 2019, at 10:41 AM, Masoud Sharbiani <msharbiani@apple.com> =
wrote:
>=20
>=20
>=20
>> On Aug 3, 2019, at 8:51 AM, Tetsuo Handa =
<penguin-kernel@I-love.SAKURA.ne.jp> wrote:
>>=20
>> Masoud, will you try this patch?
>=20
> Gladly.
> It looks like it is working (and OOMing properly).
>=20
>=20
>>=20
>> By the way, is /sys/fs/cgroup/memory/leaker/memory.usage_in_bytes =
remains non-zero
>> despite /sys/fs/cgroup/memory/leaker/tasks became empty due to memcg =
OOM killer expected?
>> Deleting big-data-file.bin after memcg OOM killer reduces some, but =
still remains
>> non-zero.
>=20
> Yes. I had not noticed that:
>=20
> [ 1114.190477] oom_reaper: reaped process 1942 (leaker), now =
anon-rss:0kB, file-
> rss:0kB, shmem-rss:0kB
> ./test-script.sh: line 16:  1942 Killed                  ./leaker -p =
10240 -c 100000
>=20
> [root@localhost laleaker]# cat  =
/sys/fs/cgroup/memory/leaker/memory.usage_in_bytes
> 3194880
> [root@localhost laleaker]# cat  =
/sys/fs/cgroup/memory/leaker/memory.limit_in_bytes
> 536870912
> [root@localhost laleaker]# rm -f big-data-file.bin
> [root@localhost laleaker]# cat  =
/sys/fs/cgroup/memory/leaker/memory.usage_in_bytes
> 2838528
>=20
> Thanks!
> Masoud
>=20
> PS: Tried hand-back-porting it to 4.19-y and it didn=E2=80=99t work. I =
think there are other patches between 4.19.0 and 5.3 that could be =
necessary=E2=80=A6
>=20

Please ignore this last part. It works on 4.19-y branch as well.=20

Masoud

>=20
>>=20
>> ----------------------------------------
>> =46rom 2f92c70f390f42185c6e2abb8dda98b1b7d02fa9 Mon Sep 17 00:00:00 =
2001
>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Date: Sun, 4 Aug 2019 00:41:30 +0900
>> Subject: [PATCH] memcg, oom: don't require __GFP_FS when invoking =
memcg OOM killer
>>=20
>> Masoud Sharbiani noticed that commit 29ef680ae7c21110 ("memcg, oom: =
move
>> out_of_memory back to the charge path") broke memcg OOM called from
>> __xfs_filemap_fault() path. It turned out that try_chage() is =
retrying
>> forever without making forward progress because =
mem_cgroup_oom(GFP_NOFS)
>> cannot invoke the OOM killer due to commit 3da88fb3bacfaa33 ("mm, =
oom:
>> move GFP_NOFS check to out_of_memory"). Regarding memcg OOM, we need =
to
>> bypass GFP_NOFS check in order to guarantee forward progress.
>>=20
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Reported-by: Masoud Sharbiani <msharbiani@apple.com>
>> Bisected-by: Masoud Sharbiani <msharbiani@apple.com>
>> Fixes: 29ef680ae7c21110 ("memcg, oom: move out_of_memory back to the =
charge path")
>> ---
>> mm/oom_kill.c | 5 +++--
>> 1 file changed, 3 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index eda2e2a..26804ab 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -1068,9 +1068,10 @@ bool out_of_memory(struct oom_control *oc)
>> 	 * The OOM killer does not compensate for IO-less reclaim.
>> 	 * pagefault_out_of_memory lost its gfp context so we have to
>> 	 * make sure exclude 0 mask - all other users should have at =
least
>> -	 * ___GFP_DIRECT_RECLAIM to get here.
>> +	 * ___GFP_DIRECT_RECLAIM to get here. But mem_cgroup_oom() has =
to
>> +	 * invoke the OOM killer even if it is a GFP_NOFS allocation.
>> 	 */
>> -	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS))
>> +	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS) && =
!is_memcg_oom(oc))
>> 		return true;
>>=20
>> 	/*
>> --=20
>> 1.8.3.1
>>=20
>>=20
>=20

