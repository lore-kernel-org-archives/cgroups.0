From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Wed, 5 Jun 2013 02:03:26 -0700
Message-ID: <20130605090326.GC7990@mtj.dyndns.org>
References: <1370306679-13129-4-git-send-email-tj@kernel.org>
 <20130604131843.GF31242@dhcp22.suse.cz>
 <20130604205025.GG14916@htj.dyndns.org>
 <20130604212808.GB13231@dhcp22.suse.cz>
 <20130604215535.GM14916@htj.dyndns.org>
 <20130605073023.GB15997@dhcp22.suse.cz>
 <20130605082023.GG7303@mtj.dyndns.org>
 <20130605083628.GE15997@dhcp22.suse.cz>
 <20130605084456.GA7990@mtj.dyndns.org>
 <20130605085531.GG15997@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UyFuaSwRj32asqCwGCJUfaYYn8HHk0pg22d7dzdLSCc=;
        b=gT9tBleCAjyL8PEUBBDwndje/AMrtii+jW5B2TUTwFgExU3bUXHcQKOS1UOOy9pisR
         ElXPqiCThO98AQkKZIzJ+n8JyuYziqQve+ADurIE9NNyZ570tC8nCssouRRl6oG8UHpj
         84/310ObUB7vS2ZmG7MizFnRbhf+yK8OOiIyM9mRdFr55Vr1rd69k0vNCTgm0An2VZPg
         r9KvNWy0Fx+RuDyKFtEHxtCna/sOdFp5lU/BLaXYPViZor7kVcsY/TOpS59QbuCxFNSm
         vRCBlNpzcROEcaLYo9esxAMdNtMfxjyV21R8WEBbpIMyQSevEwxHG7u/sUxUjE6o+cMH
         LjZw==
Content-Disposition: inline
In-Reply-To: <20130605085531.GG15997@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

Hey,

On Wed, Jun 05, 2013 at 10:55:31AM +0200, Michal Hocko wrote:
> > Yeah, that's true.  I just wanna avoid the barrier dancing.  Only one
> > of the ancestors can cache a memcg, right?
> 
> No. All of them on the way up hierarchy. Basically each parent which
> ever triggered the reclaim caches reclaimers.

Oh, I meant only the ancestors can cache a memcg, so yeap.

> > Walking up the tree scanning for cached ones and putting them should
> > work?  Is that what you were suggesting?
> 
> That was my first version of the patch I linked in the previous email.

Yeah, indeed.  Johannes, what do you think?  Between the recent cgroup
iterator update and xchg(), we don't need the weak referencing and
it's just wrong to have that level of complexity in memcg proper.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
