From: Michal Hocko <mhocko@kernel.org>
Subject: Re: memcg Can't context between v1 and v2 because css->refcnt not
 released
Date: Thu, 10 Aug 2017 09:10:59 +0200
Message-ID: <20170810071059.GC23863@dhcp22.suse.cz>
References: <CADK2BfzM9V=C3Kk6v714K3NVX58Q6pEaAMiHDGSyr6PakC2O=w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CADK2BfzM9V=C3Kk6v714K3NVX58Q6pEaAMiHDGSyr6PakC2O=w@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wang Yu <yuwang668899@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed 09-08-17 15:06:34, wang Yu wrote:
> Hello Johannes ,Michal,and Tejun:
> 
>   i using memcg v1,  but some reason  i want to context to  memcg v2,
> but i can't, here is my step:
> #cat /proc/cgroups
> #subsys_name hierarchy num_cgroups enabled
>  memory 5 1 1
> #cd /sys/fs/cgroup/memory
> #mkdir a
> #echo 0 > a/cgroup.procs
> #sleep 1
> #echo 0 > cgroup.procs

This doesn't do what you think. It will try to add a non-existant pid 0
to the root cgroup. You need to remove cgroup a. Moreover it is possible
that the `sleep' command will fault some page cache and that will stay
in memcg `a' until there is a memory pressure. cgroup v1 had
force_empty knob which you can use to drain the cgroup before removal.
Then you should be able to umount the v1 cgroup and mount v2.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
