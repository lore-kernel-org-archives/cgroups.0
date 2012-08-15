From: Ying Han <yinghan@google.com>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
Date: Wed, 15 Aug 2012 11:07:09 -0700
Message-ID: <CALWz4ix7ZfcX+TLob6n8M8gC0TkFRL7djMWT5OigZGTnSd99+Q@mail.gmail.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
	<1344517279-30646-5-git-send-email-glommer@parallels.com>
	<20120814162144.GC6905@dhcp22.suse.cz>
	<502B6D03.1080804@parallels.com>
	<20120815123931.GF23985@dhcp22.suse.cz>
	<000001392ac15404-43a3fd2c-a6d3-4985-b173-74bb586ad47c-000000@email.amazonses.com>
	<502BBC35.809@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=MnGYNhytk0acRcT1l48S9HP1an+y72+ddp5RDiplzr8=;
        b=RyxG9HJkoGknY5Oo10sDPLhPDg21PFg3LO5NGWprjH1f50/c7qlMF+eq3WWXTRWqp3
         etSRUBLDUkpr4zKucjlWpzadLDgZNrNIbsX058QDvwYrGTIXOYcMtbh31TupSEfDT7oq
         hdFiVo26Th2/2O9Ada+fHD9HO0RQvKS+vCYCChjqFrV619GqfEILpW/tCm39ZCxGzwjX
         ljS1+ZHhI9ci3tduWMpuoTaCn0r2BK5v7gv2LctV3oZhh/Yo8rgP98dzJWQaKynfXafZ
         d8Edvj5lOcVZfo477M9lBvPf5GIl2qEc8k6xmBZSrH/lUKUYynDmzOce0ij06M0mmcs8
         cqgg==
In-Reply-To: <502BBC35.809@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>

On Wed, Aug 15, 2012 at 8:11 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 08/15/2012 06:47 PM, Christoph Lameter wrote:
>> On Wed, 15 Aug 2012, Michal Hocko wrote:
>>
>>>> That is not what the kernel does, in general. We assume that if he wants
>>>> that memory and we can serve it, we should. Also, not all kernel memory
>>>> is unreclaimable. We can shrink the slabs, for instance. Ying Han
>>>> claims she has patches for that already...
>>>
>>> Are those patches somewhere around?
>>
>> You can already shrink the reclaimable slabs (dentries / inodes) via
>> calls to the subsystem specific shrinkers. Did Ying Han do anything to
>> go beyond that?
>>
> That is not enough for us.
> We would like to make sure that the objects being discarded belong to
> the memcg which is under pressure. We don't need to be perfect here, and
> an occasional slip is totally fine. But if in general, shrinking from
> memcg A will mostly wipe out objects from memcg B, we harmed the system
> in return for nothing good.

Correct. For example, we have per-superblock shrinker today for vfs
caches. That is not enough since we need to isolate the dentry caches
per-memcg basis.

--Ying
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
