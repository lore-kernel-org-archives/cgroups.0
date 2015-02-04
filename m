From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 04 Feb 2015 20:58:21 +0300
Message-ID: <54D25DBD.5080009@yandex-team.ru>
References: <20150130044324.GA25699@htj.dyndns.org> <xr93h9v8yfrv.fsf@gthelen.mtv.corp.google.com> <20150130062737.GB25699@htj.dyndns.org> <20150130160722.GA26111@htj.dyndns.org> <54CFCF74.6090400@yandex-team.ru> <20150202194608.GA8169@htj.dyndns.org> <CAHH2K0aSPjNgt30uJQa_6r=AXZso3SitjWOm96dtJF32CumZjQ@mail.gmail.com> <54D1F924.5000001@yandex-team.ru> <20150204171512.GB18858@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
	t=1423072702; bh=+JNUGb/M959cXQ9dk2dSvXV5m2VOX0aXfj/0HAFWryw=;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=LwrHHY6YNQP943sLE6hRbj7vA35HdOQulexeF6jk3PSnyPwnpDzXxSWUrAwZwA1qa
	 8Sb+1LOvJWiVT/mt+4LWWab841gKeclBCmxXGb4+hrYkbZkdlCPgZ6fhr7heF8hnMr
	 OfmnOwZm/5d7q4Z6HnMutANp/FUuHL9OY0TLD5wA=
In-Reply-To: <20150204171512.GB18858@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>

On 04.02.2015 20:15, Tejun Heo wrote:
> Hello,
>
> On Wed, Feb 04, 2015 at 01:49:08PM +0300, Konstantin Khlebnikov wrote:
>> I think important shared data must be handled and protected explicitly.
>> That 'catch-all' shared container could be separated into several
>
> I kinda disagree.  That'd be a major pain in the ass to use and you
> wouldn't know when you got something wrong unless it actually goes
> wrong and you know enough about the innerworkings to look for that.
> Doesn't sound like a sound design to me.
>
>> memory cgroups depending on importance of files: glibc protected
>> with soft guarantee, less important stuff is placed into another
>> cgroup and cannot push top-priority libraries out of ram.
>
> That sounds extremely painful.

I mean this thing _could_ be controlled more precisely. Even if default
policy works for 99% users manual override is still required for 1% or
if something goes wrong.

>
>> If shared files are free for use then that 'shared' container must be
>> ready to keep them in memory. Otherwise this need to be fixed at the
>> container side: we could ignore mlock for shared inodes or amount of
>> such vmas might be limited in per-container basis.
>>
>> But sharing responsibility for shared file is vague concept: memory
>> usage and limit of container must depends only on its own behavior not
>> on neighbors at the same machine.
>>
>>
>> Generally incidental sharing could be handled as temporary sharing:
>> default policy (if inode isn't pinned to memory cgroup) after some
>> time should detect that inode is no longer shared and migrate it into
>> original cgroup. Of course task could provide hit: O_NO_MOVEMEM or
>> even while memory cgroup where it runs could be marked as "scanner"
>> which shouldn't disturb memory classification.
>
> Ditto for annotating each file individually.  Let's please try to stay
> away from things like that.  That's mostly a cop-out which is unlikely
> to actually benefit the majority of users.

Process which scans all files once isn't so rare use case.
Linux still cannot handle this pattern sometimes.

>
>> I've missed obvious solution for controlling memory cgroup for files:
>> project id. This persistent integer id stored in file system. For now
>> it's implemented only for xfs and used for quota which is orthogonal
>> to user/group quotas. We could map some of project id to memory cgroup.
>> That is more flexible than per-superblock mark, has no conflicts like
>> mark on bind-mount.
>
> Again, hell, no.
>
> Thanks.
>

-- 
Konstantin

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
