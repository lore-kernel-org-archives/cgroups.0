From: Wenwei Tao <ww.tao0320@gmail.com>
Subject: Re: [PATCH] mm/memcontrol.c: add memory allocation result check
Date: Mon, 30 May 2016 17:28:40 +0800
Message-ID: <CACygaLCupPNRMWUpRe3WSCHWtAFH3MYKzppbjaX3As6EKKnVQQ@mail.gmail.com>
References: <1464597951-2976-1-git-send-email-wwtao0320@163.com>
	<20160530085311.GM22928@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=N53RboOQjfnVfVBtJaqdcQUEQphzWoCy3JSTDg/ChA0=;
        b=lwVipeBp/Z71vazIqrkfJyX8QasqMJaGO2Bvk1AB8quMz1vM6UiMFI4Pn/1Rg/jwl6
         bFu7Etx9TNrsko2vLiMmgI58Ae6ZyqXtsIL0Yr9B/mRS8/CpWupQ8NDB5KjfTys3KmbH
         A8DFAGXoNXiH8tfDpy7HbQetD3q42z6lfGa0QjTM9aUs2nbFCzuFTX2wvVY+4Kdom3HB
         MUd/Xelvq9bt031vCyromE5fS9YRDVt44hQ5PyU70J5SOdIS1LZNN5GamQsPz8ti6QaS
         qjeVTVTBMDzeCWAESXH8K8DJyUaLe+6iVySO9VKrqgI9UU5ktMwajxr8U3asgskAhqis
         TOEA==
In-Reply-To: <20160530085311.GM22928@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Wenwei Tao <wwtao0320@163.com>, hannes@cmpxchg.org, vdavydov@virtuozzo.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

I think explicit BUG_ON may make the debug easier, since it can point
out the wrong line.

2016-05-30 16:53 GMT+08:00 Michal Hocko <mhocko@kernel.org>:
> On Mon 30-05-16 16:45:51, Wenwei Tao wrote:
>> From: Wenwei Tao <ww.tao0320@gmail.com>
>>
>> The mem_cgroup_tree_per_node allocation might fail,
>> check that before continue the memcg init. Since it
>> is in the init phase, trigger the panic if that failure
>> happens.
>
> We would blow up in the very same function so what is the point of the
> explicit BUG_ON?
>
>> Signed-off-by: Wenwei Tao <ww.tao0320@gmail.com>
>> ---
>>  mm/memcontrol.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 925b431..6385c62 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5712,6 +5712,7 @@ static int __init mem_cgroup_init(void)
>>
>>               rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
>>                                   node_online(node) ? node : NUMA_NO_NODE);
>> +             BUG_ON(!rtpn);
>>
>>               for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>>                       struct mem_cgroup_tree_per_zone *rtpz;
>> --
>> 1.8.3.1
>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
> --
> Michal Hocko
> SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
