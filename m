From: Florian Schmidt <flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] memcg v1: provide read access to memory.pressure_level
Date: Wed, 22 Mar 2023 16:00:52 +0000
Message-ID: <916c1255-26b0-05e8-96af-e5062512cb97@nutanix.com>
References: <20230322142525.162469-1-flosch@nutanix.com>
 <ZBslZrtFISfYqV5l@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=B0cqh26iRx1ke3EBKYJdQfPpB7QOf1cZVgdjogUnTZo=;
 b=BO1oEEm8qDRmjKTcQRhHUeNV94+Pw0tbPmt3FF7jRMH+cc+4oLJ+IxkPvAgLP5a0bT6w
 7+kDZ5KMiHclznjJ59LE8DJmdjK1dcuOQY5dytqnZdA0G07DXPCrwJRTlgvZ6tT8IJTH
 pTESR2031Jg3JKSlftH5WvVPiPjkURmoaZtKsAaJPosRbqk0cCh4H/3Rwf5/TzVMAZDO
 TNB6bEgbkKInGZYfLicwOM5KvvHH86dNmj2v9U9CYsiBuW5SGMyUrW+pk/gRkTT+p1qA
 LXivOlWwumklEIBAYLE0OSZbj8K7JYGnYLuMrwnSegt5RzjPx9N13eY+fDu2vtVseSBR CQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0cqh26iRx1ke3EBKYJdQfPpB7QOf1cZVgdjogUnTZo=;
 b=rPvP+pAJL5mqzVTZk6eC0unUV2hKvxOoarKcIjG/h6XCc6vKK6N5ow92xDcnpB9kzbpsM+TnutHSqKABXiaz/tfjcYzvVl89Slv9BmWxL/wFFHB/WH9cyAwMBujRfvJh/CfEK+FMkbMcIFD0T9OFd12ZHN5/3d/nJqXEbWFPIeH65dLSwdXVyN7zT4kGomJqp2CxjSKLp8DGZL3iytTt3qikY395lms/T6dc/uKp8qoxrpy3UrS0FF2ua7QVVShdZXT8+UIGqF9+FCLZUQPghht6t66lTYgaAHo09DrFWz4i1GQzUUYsNMtnxlM5IqIgU+PP4D62xLrpMJ6GWat7qA==
Content-Language: en-US
In-Reply-To: <ZBslZrtFISfYqV5l-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 22/03/2023 15:57, Michal Hocko wrote:
> On Wed 22-03-23 14:25:25, Florian Schmidt wrote:
>> cgroups v1 has a unique way of setting up memory pressure notifications:
>> the user opens "memory.pressure_level" of the cgroup they want to
>> monitor for pressure, then open "cgroup.event_control" and write the fd
>> (among other things) to that file. memory.pressure_level has no other
>> use, specifically it does not support any read or write operations.
>> Consequently, no handlers are provided, and the file ends up with
>> permissions 000. However, to actually use the mechanism, the subscribing
>> user must have read access to the file and open the fd for reading, see
>> memcg_write_event_control().
>>
>> This is all fine as long as the subscribing process runs as root and is
>> otherwise unconfined by further restrictions. However, if you add strict
>> access controls such as selinux, the permission bits will be enforced,
>> and opening memory.pressure_level for reading will fail, preventing the
>> process from subscribing, even as root.
>>
>>
>> There are several ways around this issue, but adding a dummy read
>> handler seems like the least invasive to me.
> 
> I was struggling to see how that addresses the problem because all you
> need is a read permission. But then I've looked into cgroup code and
> learned that permissions are constructed based on available callbacks
> (cgroup_file_mode). This would have made the review easier ;)

Oh, sorry, I forgot to mention that salient detail!
I didn't check whether that was a common pattern or not...


> 
> I have no issue with the patch. It would be great to hear from cgroup
> maintainers whether a concept of default permissions is something that
> would be useful also for other files.
> 
>> I'd be interested to hear:
>> (a) do you think there is a less invasive way? Alternatively, we could
>>      add a flag in cftype in include/linux/cgroup-defs.h, but that seems
>>      more invasive for what is a legacy interface.
>> (b) would you be interested to take this patch, or is it too niche a fix
>>      for a legacy subsystem?
> 
> After you add your s-o-b, feel free to add
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> If cgroup people find a concept of default permissions for a cgroup file
> sound then this could be replaced by that approach but this is really an
> easy workaround.

Will do, once I know the path forward and construct a proper commit 
message, I'll add the s-o-b and ack.

>> ---
>>   mm/memcontrol.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 5abffe6f8389..e48c749d9724 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3734,6 +3734,16 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
>>   	}
>>   }
>>   
>> +/*
>> + * This function doesn't do anything useful. Its only job is to provide a read
>> + * handler so that the file gets read permissions when it's created.
> 
> I would just reference cgroup_file_mode() in the comment to make our
> lifes easier and comment more helpful.

Ack.


> 
>> + */
>> +static int mem_cgroup_dummy_seq_show(__always_unused struct seq_file *m,
>> +				     __always_unused void *v)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>>   #ifdef CONFIG_MEMCG_KMEM
>>   static int memcg_online_kmem(struct mem_cgroup *memcg)
>>   {
>> @@ -5064,6 +5074,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
>>   	},
>>   	{
>>   		.name = "pressure_level",
>> +		.seq_show = mem_cgroup_dummy_seq_show,
>>   	},
>>   #ifdef CONFIG_NUMA
>>   	{
>> -- 
>> 2.32.0
> 
