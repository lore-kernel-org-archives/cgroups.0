From: Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-6.0-fixes] cgroup: Fix threadgroup_rwsem <->
 cpus_read_lock() deadlock
Date: Wed, 17 Aug 2022 06:20:08 +1000
Message-ID: <fa9b19c7-65db-9e94-6627-31ae205b76ee@oracle.com>
References: <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
 <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org> <YuGTBLkFerUboctl@slm.duckdns.org>
 <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com>
 <20220815090556.GB27407@blackbody.suse.cz>
 <CAB8ipk90LxNNbq5OKamd-ArkqhEZjxS1fFZJXtnbQwGzyyJ3wQ@mail.gmail.com>
 <20220815093934.GA29323@blackbody.suse.cz>
 <f584fecd-6ca4-4ab0-763d-2ed219009c61@quicinc.com>
 <YvrWaml3F+x9Dk+T@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=+Gnw3FoslHgHWTQOPkfA4s6HrAjZORX0MGRQTTSLwx8=;
 b=U0suUQnmxWJskUAtWRliCSNEXoeo8SIdxHDbT2JaZMVtNe/W7IMYOLo/fTjTJctymDrN
 ZQkxyZ/Wvaea9ANct/Q6G1Xssm/yCLkJCwetT97uBihjgF5+K/LDvHUKRr5HC8UzufFC
 2RT5YVp3fb2rT8BD3klmLOBfXKoR02YLgOiKRr8syKvQxTVYnysPJYVEN8d8odNDJtzC
 uP7iTPxuqicySj22CkbmaM339A9G5ZwoYBLl4BrAc2VOoS62wR9r2RRG8kuo49NpcJRp
 8RJEJBcNWG75ESe1AQmt/ugVdFjqQRB0DtbvakMYUvV433+9gQDHxvE7TrpCF/R7lwad lw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Gnw3FoslHgHWTQOPkfA4s6HrAjZORX0MGRQTTSLwx8=;
 b=prGZ++SOKfkz6mOzQdaXeZUipZsSgM9AjqJAiBSupe2b+z383wWIytvQkepMT+d5vNplUlFtQqlUuvqvcqcWjO/10ExchlhAzxeqfuF8UdrsIypvmo8f16/Z7sLfNCq811sgWmTuy8nreHFw3xmAY34kP7JRKY2wn3QQVPjNQLc=
Content-Language: en-US
In-Reply-To: <YvrWaml3F+x9Dk+T-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Xuewen Yan <xuewen.yan94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello Tejun,

On 16/8/22 9:27 am, Tejun Heo wrote:
> Bringing up a CPU may involve creating new tasks which requires read-locking
> threadgroup_rwsem, so threadgroup_rwsem nests inside cpus_read_lock().
> However, cpuset's ->attach(), which may be called with thredagroup_rwsem
> write-locked, also wants to disable CPU hotplug and acquires
> cpus_read_lock(), leading to a deadlock.
> 
> Fix it by guaranteeing that ->attach() is always called with CPU hotplug
> disabled and removing cpus_read_lock() call from cpuset_attach().
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> Hello, sorry about the delay.
> 
> So, the previous patch + the revert isn't quite correct because we sometimes
> elide both cpus_read_lock() and threadgroup_rwsem together and
> cpuset_attach() woudl end up running without CPU hotplug enabled. Can you
> please test whether this patch fixes the problem?
> 

This fixes the issue seen in my setup. As my setup is 5.4 based I used
cgroup_attach_lock/unlock(true) in the backport version of your patch.

Feel free to add my

Reviewed-and-tested-by: Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks,
-- Imran
