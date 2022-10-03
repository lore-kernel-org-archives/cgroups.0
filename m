From: Alexander Fedorov <halcien-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Possible race in obj_stock_flush_required() vs drain_obj_stock()
Date: Mon, 3 Oct 2022 17:09:15 +0300
Message-ID: <821923d8-17c3-f1c2-4d6a-5653c88db3e8@gmail.com>
References: <1664546131660.1777662787.1655319815@gmail.com>
 <Yzc0yZwDB8GG+4t7@P9FQF9L96D.corp.robot.car>
 <b91e75f4-b09c-85aa-c6ad-2364dab9af92@gmail.com>
 <Yzm5cukBe6IfyAs7@P9FQF9L96D.lan>
 <d3cf9c69-19a1-53f9-cf97-5d40ce5cda44@gmail.com>
 <YzrkaKZKYqx+c325@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=OkDSfRBfMfa9dHxVwKJ+wwTsdFDoWYNDFZsgi6+fnhw=;
        b=b44I5aVKf2QZdbcjnF3DCef/sNHnxlRPl59CirotEqe+gPg6iAqRv7GYfqX3AJJDKo
         BnCleimNr9v+1c8ek++HQHptK3w/zGV7ieDXGnG3A0KoTB9p7eXNEMTYhLHrowURQe0X
         4dT/FB2+Dwp4yt0qtzOl4dgxbVxj3EXU5eGnanDSiMJlbSKpKMvn5sizEmsE7kuINxGt
         E/9S4xInFOXsoGOxRZNPImSIY10RERzzV6o4tnvrydS6Bv0vsw5czS6JWonr8KuqnLHs
         j5rKKBotrsFBBp9GTdBJ3WPw2m+lAxC4hA6QwR1aWMTSku8eEf7CWhMhozUaGm71TXX8
         zFaA==
In-Reply-To: <YzrkaKZKYqx+c325-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 03.10.2022 16:32, Michal Hocko wrote:
> On Mon 03-10-22 15:47:10, Alexander Fedorov wrote:
>> @@ -3197,17 +3197,30 @@ static void drain_obj_stock(struct memcg_stock_pcp *stock)
>>  		stock->nr_bytes = 0;
>>  	}
>>  
>> -	obj_cgroup_put(old);
>> +	/*
>> +	 * Clear pointer before freeing memory so that
>> +	 * drain_all_stock() -> obj_stock_flush_required()
>> +	 * does not see a freed pointer.
>> +	 */
>>  	stock->cached_objcg = NULL;
>> +	obj_cgroup_put(old);
> 
> Do we need barrier() or something else to ensure there is no reordering?
> I am not reallyu sure what kind of barriers are implied by the pcp ref
> counting.

obj_cgroup_put() -> kfree_rcu() -> synchronize_rcu() should take care
of this:

3670  * Furthermore, if CPU A invoked synchronize_rcu(), which returned
3671  * to its caller on CPU B, then both CPU A and CPU B are guaranteed
3672  * to have executed a full memory barrier during the execution of
3673  * synchronize_rcu() -- even if CPU A and CPU B are the same CPU (but
3674  * again only if the system has more than one CPU).
3675  */
3676 void synchronize_rcu(void)

If I'm reading this correctly:
 - on SMP A==B and there will be a full memory barrier;
 - on UP we instead rely on the guarantee that schedule() implies a full
   memory barrier (and if there is no schedule() then there is no race).
