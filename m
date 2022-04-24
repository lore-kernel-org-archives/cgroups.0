From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup/cpuset: fix a memory binding failure for
 cgroup v2
Date: Sun, 24 Apr 2022 12:04:40 -0400
Message-ID: <e278054c-098a-4859-4cef-2509f77ef0ca@redhat.com>
References: <20220419020958.40419-1-feng.tang@intel.com>
 <YmHZK+M470GjeJCV@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650816295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2vstIxikfDjecSs+FgBZkRhZG01eDmdBK5EXWWYfDA=;
        b=Dn8Lx2ayKej9mEKJapOQMAXtLovSnDMYeafEIKWSitdhwXaVsHzh7fnvAnrzsyYy3a98Ao
        zjEudmMD+oOeNKmn5Fejr+hvP1+YbuSpnZjv6N7Hvc0iDC6Yb5Ix9idU5vcPOTRf9r9y3D
        tTJloB5qkYr133T/1mrI8F+3ljaPZoA=
Content-Language: en-US
In-Reply-To: <YmHZK+M470GjeJCV-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On 4/21/22 18:22, Tejun Heo wrote:
> cc'ing Waiman and copying the whole body.
>
> Waiman, can you please take a look?
>
> Thanks.
>
> On Tue, Apr 19, 2022 at 10:09:58AM +0800, Feng Tang wrote:
>> We got report that setting cpuset.mems failed when the nodemask
>> contains a newly onlined memory node (not enumerated during boot)
>> for cgroup v2, while the binding succeeded for cgroup v1.
>>
>> The root cause is, for cgroup v2, when a new memory node is onlined,
>> top_cpuset's 'mem_allowed' is not updated with the new nodemask of
>> memory nodes, and the following setting memory nodemask will fail,
>> if the nodemask contains a new node.
>>
>> Fix it by updating top_cpuset.mems_allowed right after the
>> new memory node is onlined, just like v1.
>>
>> Signed-off-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>> Very likely I missed some details here, but it looks strange that
>> the top_cpuset.mem_allowed is not updatd even after we onlined
>> several memory nodes after boot.
>>
>>   kernel/cgroup/cpuset.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 9390bfd9f1cd..b97caaf16374 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -3314,8 +3314,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>>   	/* synchronize mems_allowed to N_MEMORY */
>>   	if (mems_updated) {
>>   		spin_lock_irq(&callback_lock);
>> -		if (!on_dfl)
>> -			top_cpuset.mems_allowed = new_mems;
>> +		top_cpuset.mems_allowed = new_mems;
>>   		top_cpuset.effective_mems = new_mems;
>>   		spin_unlock_irq(&callback_lock);
>>   		update_tasks_nodemask(&top_cpuset);
The on_dfl check was added by commit 7e88291beefb ("cpuset: make 
cs->{cpus, mems}_allowed as user-configured masks"). This is the 
expected behavior for cgroup v2 as we don't want to remove a node 
because it is hot-removed. However, I do see a problem in case we are 
adding a node that is not originally in top_cpuset.mems_allowed. We 
should be allowed to add the extra memory node. So something like

         if (!on_dfl)
                 top_cpuset.mems_allowed = new_mems;
         else if (!nodes_subset(new_mems, top_cpuset.mems_allowed))
                 nodes_or(top_cpuset.mems_allowed, 
top_cpuset.mems_allowed, new_mems);

For v2, top_cpuset.mems_allowed is set to node_possible_map in 
cpuset_bind(). Perhaps node_possible_map may not include all the nodes 
that are hot-pluggable.

I don't know if that is similar problem with cpu_possible_mask or not.

Cheers,
Longman

