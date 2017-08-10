From: wang Yu <yuwang668899@gmail.com>
Subject: Re: memcg Can't context between v1 and v2 because css->refcnt not released
Date: Thu, 10 Aug 2017 17:28:57 +0800
Message-ID: <CADK2BfzarAEQz=_Um23mywmdRvhNbe5OL_7k13XD3D5==nn0qg@mail.gmail.com>
References: <CADK2BfzM9V=C3Kk6v714K3NVX58Q6pEaAMiHDGSyr6PakC2O=w@mail.gmail.com>
 <20170810071059.GC23863@dhcp22.suse.cz> <CADK2BfwC3WDGwoDPSjX1UpwP-4fDz5fSBjdENbxn5XQL8y3K3A@mail.gmail.com>
 <20170810081920.GG23863@dhcp22.suse.cz> <CADK2BfxJim8MvLPY497a+JAK2t9OTq+f1BY0o4qK0ihaWsoEMQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=kRf6THtrOPshu9S+Y49vk33+f8FH3iIoRK1z89lhSRg=;
        b=VYW7z3Ngpd6IrKazWi06WnOJdet8heq9jEkbC/H59FkWHpqrpRbybv+kpOAAMsmcxj
         RkKYXOshEzxsuoOnGlPUlYenbes8kc2FPZchDX/Luh9DuS3zw+2MtK90DFZJ44jnMry4
         Tnpl0JnqGLSyfKSLE1UOeYKN7AJciEw75jb1wN9IFPhoQbZysgmdxgih+kIPJsAHGKMi
         RGhQxicSkzj2Co+iBP0WI9DNGyPsxxa7y8/abYSgR1f+cHbAc0m+nx+B7JBmp9EtJi0g
         2w2HtF3GgkA945ThbB6dC7c0he3bJoiNpbXzjfzx4/O1Vxdk2NJhqJVjbpj0hDtrr0Mr
         9CIw==
In-Reply-To: <CADK2BfxJim8MvLPY497a+JAK2t9OTq+f1BY0o4qK0ihaWsoEMQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

2017-08-10 16:26 GMT+08:00 wang Yu <yuwang668899@gmail.com>:
> 2017-08-10 16:19 GMT+08:00 Michal Hocko <mhocko@kernel.org>:
>> [Please do not top-post]
>>
>> On Thu 10-08-17 16:10:45, wang Yu wrote:
>>> at first ,thanks for your reply.
>>> but i also tested what you said, the problem is also.
>>> force_empty only call try_to_free_pages, not all the pages remove
>>> because mem_cgroup_reparent_charges moved
>>
>> Right. An alternative would be dropping the page cache globaly via
>> /proc/sys/vm/drop_caches. Not an ideal solution but it should help.
>> --
>> Michal Hocko
>> SUSE Labs
>
> thanks again, but /proc/sys/vm/drop_caches can't solve it
> you can try as follow
>
> #cat /proc/cgroups
>
> memory 11 2 1
>
> #mkdir a
>
> #echo 0 > a/cgroup.procs
>
> #sleep 1
>
> #echo 0 > cgroup.procs
>
> #echo 1 > a/memory.force_empty
>
> #echo 3 > /proc/sys/vm/drop_caches
>
> #rmdir  a
>
> #cat /proc/cgroups
>
> memory 11 3 1
> the  num_cgroups not decrease
and i found that, after drop cache

after drop caches, memory.stat  shows not pages belong the group, but
memory.usage_in_bytes not zero, so maybe other pages
has wrong to belong this cgroup

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
