From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] memcg: use global stat directly for root memcg usage
Date: Wed, 13 Mar 2013 16:50:17 +0800
Message-ID: <CAFj3OHUMyJDmDd4TYCXw4JO+cgH4AAFy3uSV93T3FfcF42eKew@mail.gmail.com>
References: <1363082773-3598-1-git-send-email-handai.szj@taobao.com>
	<1363082920-3711-1-git-send-email-handai.szj@taobao.com>
	<513FD0CB.4000407@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        bh=ySUu++iUZ7S1P0lUtkiwcbDry8mvhEJH893rjR0AiJ0=;
        b=WjxMkP47wE/Wm8mzA5EHJ6dIzfzS0agHQQrBDp7ZKWSZUFMBCJ2G0qDassnf0hHmaA
         wQw7p6Ps41XQCLdyLITqNfNJPBd64yKf5tOqZwLLO1avkw84c1nY/UDCGmI0FRl2rsye
         f0DAu2KRSuJoE50GhNjM8uq0OjhJYV1XloaQ0kgGqtZ/b+ie7RcCXrH/dwdPbukabk0r
         k2gq8f937yHTO3C+nUgsLYJ52Ob0AwUXj/TeL8ZDyebrZTOZviVn6m/CAjzVWgPkzCc4
         1K5LB+EQQKx957V57u4o+oRwnjeksGJNMVG4xoyHsffD/Osslc+xz7upCU9Um7DgoypS
         8DCw==
In-Reply-To: <513FD0CB.4000407-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Wed, Mar 13, 2013 at 9:05 AM, Kamezawa Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> (2013/03/12 19:08), Sha Zhengju wrote:
>> Since mem_cgroup_recursive_stat(root_mem_cgroup, INDEX) will sum up
>> all memcg stats without regard to root's use_hierarchy, we may use
>> global stats instead for simplicity.
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>> ---
>>   mm/memcontrol.c |    6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 669d16a..735cd41 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4987,11 +4987,11 @@ static inline u64 mem_cgroup_usage(struct me=
m_cgroup *memcg, bool swap)
>>                       return res_counter_read_u64(&memcg->memsw, RES=
_USAGE);
>>       }
>>
>> -     val =3D mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE=
);
>> -     val +=3D mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS)=
;
>> +     val =3D global_page_state(NR_FILE_PAGES);
>> +     val +=3D global_page_state(NR_ANON_PAGES);
>>
> you missed NR_ANON_TRANSPARENT_HUGEPAGES
right..

>
>>       if (swap)
>> -             val +=3D mem_cgroup_recursive_stat(memcg, MEM_CGROUP_S=
TAT_SWAP);
>> +             val +=3D total_swap_pages - atomic_long_read(&nr_swap_=
pages);
>>
> Double count mapped SwapCache ? Did you saw Costa's trial in a week a=
go ?

yeah, I=92m hesitating how to handle swapcache. I've replied in that th=
read.  : )


Thanks,
Sha
