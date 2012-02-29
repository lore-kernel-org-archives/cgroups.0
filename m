From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/10] memcg: Kernel memory accounting infrastructure.
Date: Tue, 28 Feb 2012 16:37:29 -0800
Message-ID: <CABCjUKAmM+DaNFuoUP_BiGdQ=SoWOXHijy8jmSPoEozBD-_JhA@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-2-git-send-email-ssouhlal@FreeBSD.org>
	<4F4CD231.907@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=FzO0MzZS5+jY6HzR2du/UKicRZEe4faJCESNKTLUIgY=;
        b=Fu4ZVQF9rua0Gt78EyADhZe1Go4Y+2CZV+fisPC4jrTlh6w5Rv6hT1AFsnzYfycPRi
         5OkPWA3LSDguC2PAuabJ9lkLZvSxHi559NUlvnN23xvfmr5/aNNSGQ5aLVjGrAo52tN3
         M/qmlAjmBKTDcxEV61yDj1muzwCf+614NLY9tcNJ9aSbsvZD2qBShR6NXIG3lWAGVbUI
         2drTMjjNujyXqlS4mSQ91PYQAlD88/c5UxpPo4UuhnRYBlDAdKKalhf5O9AKrt2Upef/
         +f+83gmNSYacLemIgxU9yqyBFZrNIn6kc5OKWjR7q9E1d5cFQvSXGvK3VDGvTYFjw0MF
         K2rA==
In-Reply-To: <4F4CD231.907-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, Feb 28, 2012 at 5:10 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
> On 02/27/2012 07:58 PM, Suleiman Souhlal wrote:
>>
>> Enabled with CONFIG_CGROUP_MEM_RES_CTLR_KMEM.
>>
>> Adds the following files:
>> =A0 =A0 - memory.kmem.independent_kmem_limit
>> =A0 =A0 - memory.kmem.usage_in_bytes
>> =A0 =A0 - memory.kmem.limit_in_bytes
>>
>> Signed-off-by: Suleiman Souhlal<suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> ---
>> =A0mm/memcontrol.c | =A0121
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>> =A01 files changed, 120 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 228d646..11e31d6 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -235,6 +235,10 @@ struct mem_cgroup {
>> =A0 =A0 =A0 =A0 */
>> =A0 =A0 =A0 =A0struct res_counter memsw;
>> =A0 =A0 =A0 =A0/*
>> + =A0 =A0 =A0 =A0* the counter to account for kernel memory usage.
>> + =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 struct res_counter kmem_bytes;
>> + =A0 =A0 =A0 /*
>
> Not terribly important, but I find this name inconsistent. I like
> just kmem better.

I will change it.

>> =A0 =A0 =A0 =A0 * Per cgroup active and inactive list, similar to th=
e
>> =A0 =A0 =A0 =A0 * per zone LRU lists.
>> =A0 =A0 =A0 =A0 */
>> @@ -293,6 +297,7 @@ struct mem_cgroup {
>> =A0#ifdef CONFIG_INET
>> =A0 =A0 =A0 =A0struct tcp_memcontrol tcp_mem;
>> =A0#endif
>> + =A0 =A0 =A0 int independent_kmem_limit;
>> =A0};
>
> bool ?
>
> But that said, we are now approaching some 4 or 5 selectables in the =
memcg
> structure. How about we turn them into flags?

The only other selectable (that is a boolean) I see is use_hierarchy.
Or do you also mean oom_lock and memsw_is_minimum?

Either way, I'll try to make them into flags.

>> @@ -4587,6 +4647,10 @@ static int register_kmem_files(struct cgroup =
*cont,
>> struct cgroup_subsys *ss)
>> =A0static void kmem_cgroup_destroy(struct cgroup_subsys *ss,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struc=
t cgroup *cont)
>> =A0{
>> + =A0 =A0 =A0 struct mem_cgroup *memcg;
>> +
>> + =A0 =A0 =A0 memcg =3D mem_cgroup_from_cont(cont);
>> + =A0 =A0 =A0 BUG_ON(res_counter_read_u64(&memcg->kmem_bytes, RES_US=
AGE) !=3D 0);
>
> That does not seem to make sense, specially if you are doing lazy cre=
ation.
> What happens if you create a cgroup, don't put any tasks into it (the=
refore,
> usage =3D=3D 0), and then destroy it right away?
>
> Or am I missing something?

The BUG_ON will only trigger if there is any remaining kernel memory,
so the situation you describe should not be a problem.

-- Suleiman
