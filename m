From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm/memcg: set pos to prev unconditionally
Date: Wed, 30 Mar 2022 00:47:50 +0000
Message-ID: <20220330004750.fx4jr4bnehz4ynpf@master>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
 <20220225003437.12620-3-richard.weiyang@gmail.com>
 <YkNUZYrSHPjJ1XOb@cmpxchg.org>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aUg+nsxlXPscnfiMYKd+M7CmvIDxhBFg2TxnVLMBR5s=;
        b=kX4HPddeobRAwdKEOnLTw4DYufDEk5c8qxuMObUBbwxa3aPvdY7LNLDGNalvMKvNKt
         F6jP6FhmeL+vsQ3CGykJmjwsST/Wba5VeZJ/Ou7Bg88KA3ZYI8jZCBK2zTUUGLcPECTp
         hwi30uLJsriwV0WJU/eHst1MWIbyhtSIA1SHOv5fwNP0C9Txq5brTn04fkHUtq9L8Fgd
         7KtMs8b4AWITjk1htYA6IbtbpDBOTkPMPVM43gsJpLbApkLr9FQzBIYN3rD58r9GqzEI
         bEbbb46WFRzhbK9EoZsgb4v8ClkPsVfVyUzHMqBYoUUb6zzqW3WdSw6odrdPaMeqn7Vj
         fUGA==
Content-Disposition: inline
In-Reply-To: <YkNUZYrSHPjJ1XOb-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Mar 29, 2022 at 02:48:05PM -0400, Johannes Weiner wrote:
>On Fri, Feb 25, 2022 at 12:34:36AM +0000, Wei Yang wrote:
>> Current code set pos to prev based on condition (prev && !reclaim),
>> while we can do this unconditionally.
>> 
>> Since:
>> 
>>   * If !reclaim, pos is the same as prev no matter it is NULL or not.
>>   * If reclaim, pos would be set properly from iter->position.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  mm/memcontrol.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 9464fe2aa329..03399146168f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -980,7 +980,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>>  	struct mem_cgroup_reclaim_iter *iter;
>>  	struct cgroup_subsys_state *css = NULL;
>>  	struct mem_cgroup *memcg = NULL;
>> -	struct mem_cgroup *pos = NULL;
>> +	struct mem_cgroup *pos = prev;
>
>I don't like this so much. It suggests pos always starts with prev, no
>matter what. But this isn't true for reclaim mode, which overrides the
>initialized value again.
>
>>  	if (mem_cgroup_disabled())
>>  		return NULL;
>> @@ -988,9 +988,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>>  	if (!root)
>>  		root = root_mem_cgroup;
>>  
>> -	if (prev && !reclaim)
>> -		pos = prev;
>
>How about making the reclaim vs non-reclaim mode explicit and do:
>
>	if (reclaim) {
>		...
>		pos = iter->position;
>		...
>	} else {
>		pos = prev;
>	}

Something like this?

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eed9916cdce5..5d433b79ba47 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1005,9 +1005,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	if (!root)
 		root = root_mem_cgroup;
 
-	if (prev && !reclaim)
-		pos = prev;
-
 	rcu_read_lock();
 
 	if (reclaim) {
@@ -1033,6 +1030,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			 */
 			(void)cmpxchg(&iter->position, pos, NULL);
 		}
+	} else if (prev) {
+		pos = prev;
 	}
 
 	if (pos)
-- 
Wei Yang
Help you, Help me
