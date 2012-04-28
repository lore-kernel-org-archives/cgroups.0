From: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 5/9 v2] move charges to root at rmdir if
 use_hierarchy is unset
Date: Sat, 28 Apr 2012 09:01:23 +0900
Message-ID: <CABEgKgpCyWhe1KMgcF7ob0myzcCypNbw5SebhVpSX_Xaz7yOBw@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A359C.10107@jp.fujitsu.com>
	<CALWz4ixHGCqfWh1U+JyiJWTkGmCDtXQy1vbHRjrHaU_pOgGuBw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=FxJ7UVyVTlmZbon+hlcVxwUAtjrzmgsSlFjMrFu5U0c=;
        b=Yrj0n5OOeiqUtDNEUoSP8X5kYH/+FvZTUA5JV5mH5zjKgp7HtnOvmd5mtK2h2vcpL9
         SkXqjTUy9Ws5mqz0gNfK+k/LU/YvmmYOEJBj4+xD/ylSQXvO0bZwXNfLn4XtXc/OHd39
         Sxlj5spMQLUXoPsOPXZPgIc7ZQ2mPxxdwx3NrTmB502+8h+HRQBoxfbcwNnopD1quKKA
         aRPImMZNs/Z/ptSUtqlRT+nTbNQr3yidvowMPtpHPqvrg5exZY1lSrStVFzvAzxx2MkI
         2T8eWijaetn3X3U+H8gCqF3/Kgcg1LxWoCtV6khUh4fbzH/c9oeBE8UP1ATNWarlLLK7
         tihg==
In-Reply-To: <CALWz4ixHGCqfWh1U+JyiJWTkGmCDtXQy1vbHRjrHaU_pOgGuBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat, Apr 28, 2012 at 4:12 AM, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Apr 26, 2012 at 10:58 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>> Now, at removal of cgroup, ->pre_destroy() is called and move charge=
s
>> to the parent cgroup. A major reason of -EBUSY returned by ->pre_des=
troy()
>> is that the 'moving' hits parent's resource limitation. It happens o=
nly
>> when use_hierarchy=3D0. This was a mistake of original design.(it's =
me...)
>
> Nice patch, i can see how broken it is now with use_hierarchy=3D0...
>
> nitpick on the documentation below:
>
>>
>> Considering use_hierarchy=3D0, all cgroups are treated as flat. So, =
no one
>> cannot justify moving charges to parent...parent and children are in
>> flat configuration, not hierarchical.
>>
>> This patch modifes to move charges to root cgroup at rmdir/force_emp=
ty
>> if use_hierarchy=3D=3D0. This will much simplify rmdir() and reduce =
error
>> in ->pre_destroy.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> ---
>> =A0Documentation/cgroups/memory.txt | =A0 12 ++++++----
>> =A0mm/memcontrol.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 39 +++++=
++++++++------------------------
>> =A02 files changed, 21 insertions(+), 30 deletions(-)
>>
>> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroup=
s/memory.txt
>> index 54c338d..82ce1ef 100644
>> --- a/Documentation/cgroups/memory.txt
>> +++ b/Documentation/cgroups/memory.txt
>> @@ -393,14 +393,14 @@ cgroup might have some charge associated with =
it, even though all
>> =A0tasks have migrated away from it. (because we charge against page=
s, not
>> =A0against tasks.)
>>
>> -Such charges are freed or moved to their parent. At moving, both of=
 RSS
>> -and CACHES are moved to parent.
>> -rmdir() may return -EBUSY if freeing/moving fails. See 5.1 also.
>> +Such charges are freed or moved to their parent if use_hierarchy=3D=
1.
>> +if use_hierarchy=3D0, the charges will be moved to root cgroup.
>
> It is more clear that we move the stats to root (if use_hierarchy=3D=3D=
0)
> or parent (if use_hierarchy=3D=3D1), and no change on the charge exce=
pt
> uncharging from the child.
>

Seems nicer. I'll use your text in next ver.

Thanks,
-Kame
