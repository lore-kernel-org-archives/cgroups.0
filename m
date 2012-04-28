From: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 7/9 v2] cgroup: avoid attaching task to a cgroup
 under rmdir()
Date: Sat, 28 Apr 2012 09:06:20 +0900
Message-ID: <CABEgKgqVJZic-6U0YTv7u7GHe4bNOvChSUqzpb93OXU-ZPPWAQ@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A366E.9020307@jp.fujitsu.com>
	<20120427103927.GA3514@somewhere.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=3EVM5xqkUIxuGMLQsGbAykKc8GR1lpI55Vc5GRQpCRs=;
        b=AaoYmf1kU3lAzXJwq0Np1yWz/jRePb12+zgicVtGYw/zmstm540+0oj5TZn+/CEQJI
         HvglzCXsb/xoAajUUI9WmZ0+5ms7TmV5TSGeHRfD14Tal88Qlg0K+AGALrHW+uxMNsk7
         IvynN728+fnMNnZZ4wsn0GLKU05QfElzqeFjD0QeM4nMXenFLoVOxcJzdAkRbJ9PjbwB
         DJQcKMpGW+HNKM25YrkUpgqhSkjg8n3LWEw9rppd5ZO80VFKSWPp81DuprHgK6prB47s
         DPB9yXh3xf4mTwZvWaBr98EQd2kIMg8krCbK0jxWXlj1VKBQ988kEtB/bpBNJCuecTwE
         5hVA==
In-Reply-To: <20120427103927.GA3514-oHC15RC7JGTpAmv0O++HtFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Fri, Apr 27, 2012 at 7:39 PM, Frederic Weisbecker <fweisbec-Re5JQEeQqe8@public.gmane.org=
m> wrote:
> On Fri, Apr 27, 2012 at 03:02:22PM +0900, KAMEZAWA Hiroyuki wrote:
>> attach_task() is done under cgroup_mutex() but ->pre_destroy() callb=
ack
>> in rmdir() isn't called under cgroup_mutex().
>>
>> It's better to avoid attaching a task to a cgroup which
>> is under pre_destroy(). Considering memcg, the attached task may
>> increase resource usage after memcg's pre_destroy() confirms that
>> memcg is empty. This is not good.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> ---
>> =A0kernel/cgroup.c | =A0 =A05 ++++-
>> =A01 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index ad8eae5..7a3076b 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1953,6 +1953,9 @@ int cgroup_attach_task(struct cgroup *cgrp, st=
ruct task_struct *tsk)
>> =A0 =A0 =A0 if (cgrp =3D=3D oldcgrp)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> + =A0 =A0 if (test_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EBUSY;
>> +
>
> You probably need to update cgroup_attach_proc() as well?
>
Ahh...I missed that. Thank you for pointing out !

Thanks,
-Kame
