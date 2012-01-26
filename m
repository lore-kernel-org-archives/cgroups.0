From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] [PATCH 5/7 v2] memcg: remove PCG_FILE_MAPPED
Date: Thu, 26 Jan 2012 11:10:42 -0800
Message-ID: <CALWz4iyD0THS4X3rcgWMuCcohEDcD75Xe7aGkvMXXa=6tmTgvw@mail.gmail.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174223.aaf5a80c.kamezawa.hiroyu@jp.fujitsu.com>
	<20120119140737.GD13932@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:x-system-of-record:content-type:content-transfer-encoding;
        bh=pCVUbAc2ZOQPqnLL64n8vh5YNPqgiTFCP8jlG5LLaBs=;
        b=HDhSwn0RCgQu2+MtYkDyByJobaM/F0l2zUeTX4tSl8/v9KzS4nVMVPV1fxnUyrJZ1g
         cl6aybtuwNLrZt5VDYFXIMFpPNcq+8L+hKLLAG76Mo7vQJWviLvTUAaY1gjm4aUST7eK
         rrTXk70/dlYlACs69+97RckC7j4C2f4slJElM=
In-Reply-To: <20120119140737.GD13932-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Jan 19, 2012 at 6:07 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Fri 13-01-12 17:42:23, KAMEZAWA Hiroyuki wrote:
>> From a9b51d6204d7f8714173c46a306caf413ad25d4e Mon Sep 17 00:00:00 20=
01
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Date: Thu, 12 Jan 2012 18:40:26 +0900
>> Subject: [PATCH 5/7] memcg: remove PCG_FILE_MAPPED
>>
>> Because we can update page's status and memcg's statistics without
>> race with move_account, this flag is unnecessary.
>
> I would really appreciate a little bit more description ;)
>
> 8725d541 [memcg: fix race in file_mapped accounting] has added the
> flag to resolve a race when a move_account happened between page's
> mapcount has been updated and this has been accounted to memcg.
> This, however, cannot happen anymore because mem_cgroup_update_page_s=
tat
> is always enclosed by mem_cgroup_begin_update_page_stat and
> mem_cgroup_end_update_page_stat along with the mapcount update.

Agree on better documentation.

>
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>
> Other than that looks good and nice to see another one go away.
> I will add my ack along with the patches which this depend on once th=
ey
> settle down if you don't mind
>
> Thanks
>
>> ---
>> =A0include/linux/page_cgroup.h | =A0 =A06 ------
>> =A0mm/memcontrol.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A06 +-----
>> =A02 files changed, 1 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup=
=2Eh
>> index 5dba799..0b9a48a 100644
>> --- a/include/linux/page_cgroup.h
>> +++ b/include/linux/page_cgroup.h
>> @@ -7,8 +7,6 @@ enum {
>> =A0 =A0 =A0 PCG_CACHE, /* charged as cache */
>> =A0 =A0 =A0 PCG_USED, /* this object is in use. */
>> =A0 =A0 =A0 PCG_MIGRATION, /* under page migration */
>> - =A0 =A0 /* flags for mem_cgroup and file and I/O status */
>> - =A0 =A0 PCG_FILE_MAPPED, /* page is accounted as "mapped" */
>> =A0 =A0 =A0 __NR_PCG_FLAGS,
>> =A0};
>>
>> @@ -72,10 +70,6 @@ TESTPCGFLAG(Used, USED)
>> =A0CLEARPCGFLAG(Used, USED)
>> =A0SETPCGFLAG(Used, USED)
>>
>> -SETPCGFLAG(FileMapped, FILE_MAPPED)
>> -CLEARPCGFLAG(FileMapped, FILE_MAPPED)
>> -TESTPCGFLAG(FileMapped, FILE_MAPPED)
>> -
>> =A0SETPCGFLAG(Migration, MIGRATION)
>> =A0CLEARPCGFLAG(Migration, MIGRATION)
>> =A0TESTPCGFLAG(Migration, MIGRATION)
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 30ef810..a96800d 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1952,10 +1952,6 @@ void mem_cgroup_update_page_stat(struct page =
*page,
>>
>> =A0 =A0 =A0 switch (idx) {
>> =A0 =A0 =A0 case MEMCG_NR_FILE_MAPPED:
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (val > 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageCgroupFileMapped(pc=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 else if (!page_mapped(page))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ClearPageCgroupFileMapped(=
pc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 idx =3D MEM_CGROUP_STAT_FILE_MAPPED;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 default:
>> @@ -2606,7 +2602,7 @@ static int mem_cgroup_move_account(struct page=
 *page,
>>
>> =A0 =A0 =A0 mem_cgroup_account_move_wlock(page, &flags);
>>
>> - =A0 =A0 if (PageCgroupFileMapped(pc)) {
>> + =A0 =A0 if (page_mapcount(page)) {

Does it includes anon pages , should it be

if (page_mapped(page) && !PageAnon(page))

--Ying

>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Update mapped_file data for mem_cgrou=
p */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 preempt_disable();
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 __this_cpu_dec(from->stat->count[MEM_CGR=
OUP_STAT_FILE_MAPPED]);
>> --
>> 1.7.4.1
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" i=
n
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9
> Czech Republic
