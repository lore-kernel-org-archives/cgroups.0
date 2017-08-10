From: wang Yu <yuwang668899-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: memcg Can't context between v1 and v2 because css->refcnt not released
Date: Thu, 10 Aug 2017 16:10:45 +0800
Message-ID: <CADK2BfwC3WDGwoDPSjX1UpwP-4fDz5fSBjdENbxn5XQL8y3K3A@mail.gmail.com>
References: <CADK2BfzM9V=C3Kk6v714K3NVX58Q6pEaAMiHDGSyr6PakC2O=w@mail.gmail.com>
 <20170810071059.GC23863@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=+2NdSmAvqn/QOlC78ph9dLildBo8cpbkonbvHWgNtVU=;
        b=o5AZXpqHMcsdOCTHNRDiQbyg5OpP8OMODRGcU9gBVpoKCmMU2qyCsb1HJ8LUs54lr+
         ns/4bYr+TtQ1l1bWapO+T6XybpSHE/MatK48sal016R4GFfE6N5jBXBotFGxYydnnkC5
         rRJnvVPScarb+t4IeLFFxlyUftRWg7H7szfHRiEuVBQwx2pjQavKsJnCGN+s+3sY3JFM
         XNBCBeAurNes1+5GN+ZpuTsIbtPTdy2fqL3fDDnu25YLShyiYW9QW9z3IEHcMlw5tQYy
         Iir+Vyopv196ZZOpotWdk4fxi42ROXDAV9c4BJMuY3Jo1kACOrwnOWe6BUfBgGeL6W1k
         VoyA==
In-Reply-To: <20170810071059.GC23863-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

at first ,thanks for your reply.
but i also tested what you said, the problem is also.
force_empty only call try_to_free_pages, not all the pages remove
because mem_cgroup_reparent_charges moved
#cd /sys/fs/cgroup/memory
#mkdir a
#echo 0 > a/cgroup.procs
#sleep 1
#echo 0 > a/cgroup.procs
#echo 1 > a/memory.force_empty
#rmdir a
#cat /proc/cgroups
#subsys_name hierarchy num_cgroups enabled
memory 2 2 1
the num_cgroups also not released





2017-08-10 15:10 GMT+08:00 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> On Wed 09-08-17 15:06:34, wang Yu wrote:
>> Hello Johannes ,Michal,and Tejun:
>>
>>   i using memcg v1,  but some reason  i want to context to  memcg v2,
>> but i can't, here is my step:
>> #cat /proc/cgroups
>> #subsys_name hierarchy num_cgroups enabled
>>  memory 5 1 1
>> #cd /sys/fs/cgroup/memory
>> #mkdir a
>> #echo 0 > a/cgroup.procs
>> #sleep 1
>> #echo 0 > cgroup.procs
>
> This doesn't do what you think. It will try to add a non-existant pid 0
> to the root cgroup. You need to remove cgroup a. Moreover it is possible
> that the `sleep' command will fault some page cache and that will stay
> in memcg `a' until there is a memory pressure. cgroup v1 had
> force_empty knob which you can use to drain the cgroup before removal.
> Then you should be able to umount the v1 cgroup and mount v2.
> --
> Michal Hocko
> SUSE Labs
