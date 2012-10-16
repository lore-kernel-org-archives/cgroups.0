From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Tue, 16 Oct 2012 14:32:05 +0800
Message-ID: <507CFF65.7050109@gmail.com>
References: <1350367837-27919-1-git-send-email-handai.szj@taobao.com> <alpine.DEB.2.00.1210152311460.9480@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=hw52iVoFTzP/4A5/xAJOJsE362jEqAbfE7tQ5go+Yo8=;
        b=C4ZhqSdTS0cUdRjsE4AhY3rKrhYDjMvKJgxhan3njGVLzbP6dEwPAoF0AFJ8PJH2Kw
         vVDTocsnVL2QxAbL5fPvfCdKqwdF0FONbH6MXDCMaWypqPcfDORHVW1cnD0MbhU8bYc6
         Rd9AE7uzlLQnGxugeYcNqSBFQt7IrOaHWeCVJMMNWamFXy5oPY5kjUofsYnIGzgZQqQs
         ls6VxoN1e8wJzYf3X5hwFDOSQ2oHoblcgreONHM0EZVyE186UJr1NMFZCqxap8YsjGE7
         RpWm+yy2fEyxZRa6ctgsifJAN0WhBMVvAf/UHJWrn9JiYjnzxO1nSs4wM9Lyi3MS19VK
         13BA==
In-Reply-To: <alpine.DEB.2.00.1210152311460.9480@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes@google.com>
Cc: Sha Zhengju <handai.szj@taobao.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, mhocko@suse.cz, linux-kernel@vger.kernel.org

On 10/16/2012 02:12 PM, David Rientjes wrote:
> On Tue, 16 Oct 2012, Sha Zhengju wrote:
>
>> From: Sha Zhengju<handai.szj@taobao.com>
>>
>> Sysctl oom_kill_allocating_task enables or disables killing the OOM-triggering
>> task in out-of-memory situations, but it only works on overall system-wide oom.
>> But it's also a useful indication in memcg so we take it into consideration
>> while oom happening in memcg. Other sysctl such as panic_on_oom has already
>> been memcg-ware.
>>
> You're working on an old kernel, mem_cgroup_out_of_memory() has moved to
> mm/memcontrol.c.  Please rebase on 3.7-rc1 and send an updated patch,
> which otherwise looks good.

Thanks for reminding!  Yes, I cooked it on memcg-devel git repo but a 
out-of-date
since-3.2 branch... But I notice the latest branch is since-3.5(not 
seeing 3.6/3.7), does
it okay to working on this branch?


Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
