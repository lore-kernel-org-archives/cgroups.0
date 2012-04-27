From: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 3/7 v2] res_counter: add res_counter_uncharge_until()
Date: Sat, 28 Apr 2012 08:51:11 +0900
Message-ID: <CABEgKgrHXeXX1napajY-hRqDPB1snL1xWmrAVxVKkOGEvnJdkQ@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A343F.7020409@jp.fujitsu.com>
	<4F9AD28C.60508@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=2hGpXhJzzZkRqTs5imN84S+QCSKWsvnFmu8ZH/rMGnY=;
        b=PkEwFsZvF/J//6oUcewAV5OjxrBwQp901m0dNrs0bm2o9nk8L4JxOTTOQf9sdNOQfJ
         ML9kUSfKVkoQpLgbIu7kUTMAEvzl/aJO7DigU3H8485O8xkcQ2NMvvUTtitcqVWNZ1pc
         c1qOZyViKIQK7gcy7GQeyJq5L8DaGLDMMwnlrbnuirlIaUiAaiQRzKfceU23GZCb5z3y
         mt0QzS+6m+4ZWAA/90+I2oHXa1wjMSHvAkyFAvWEJP6Rqu5OiM4pSK3o5kSHtFs+flDv
         RHhFKSD9Y0OShDZ16ah/7hEnLlL5Gn0PG8VyD8D/pvGXYIXIFahFszC6gBx/173/4Ne7
         ofrQ==
In-Reply-To: <4F9AD28C.60508-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat, Apr 28, 2012 at 2:08 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> On 04/27/2012 02:53 AM, KAMEZAWA Hiroyuki wrote:
>> =A0From bb0168d5c85f62f36434956e4728a67d0cc41e55 Mon Sep 17 00:00:00=
 2001
>> From: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Date: Thu, 26 Apr 2012 18:48:07 +0900
>> Subject: [PATCH 3/9] memcg: add res_counter_uncharge_until()
>>
>> At killing res_counter which is a child of other counter,
>> we need to do
>> =A0 =A0 =A0 res_counter_uncharge(child, xxx)
>> =A0 =A0 =A0 res_counter_charge(parent, xxx)
>>
>> This is not atomic and wasting cpu. This patch adds
>> res_counter_uncharge_until(). This function's uncharge propagates
>> to ancestors until specified res_counter.
>>
>> =A0 =A0 =A0 res_counter_uncharge_until(child, parent, xxx)
>>
>> This ops is atomic and more efficient.
>>
>> Originaly-written-by: Frederic Weisbecker<fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> I have been carrying Frederic's patch itself in my code for a while n=
ow.
>
> Why not just use it? What are you doing differently to justify writin=
g a
> patch yourself? It's a bit of credit giving as well

I don't need "charge" part for my purpose and have no justification to =
add it.
And task-limit cgroup has no justification, either.

Thanks,
-Kame
