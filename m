From: Hong zhi guo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] blk-throttle: trim tokens generated for an idle tree
Date: Wed, 23 Oct 2013 11:30:29 +0800
Message-ID: <CAA7+ByUn52WqCn=AgSi1QeHLGP=ziQ+vnNug3z3m7W-OXDqr+A@mail.gmail.com>
References: <20131018155532.GD2277@redhat.com>
	<1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
	<1382271072-15664-3-git-send-email-zhiguohong@tencent.com>
	<20131022210232.GB2884@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=iPwnT7BsE7LNu5Q4Fgs2uxx367zrW0V69anD4w0t5rA=;
        b=So4fc1iP/LdVEeuFeGwpLiB0Sg5CCr9dqxjjN3P9GGg35SZsXR1+46p7V7aY4AOopy
         PqoXYXaiH/cBiq6secdmxRUyjH0exxQR6J6xQzXm+BRKkeibYQcQQkE3Hh4WbQuQE86E
         dVUOljFOTSSKmrbx8UbAv02oRxRqAorqnbHrBbwPrVGLtKeHmenXPNTZKbBNUxCJZvaE
         jqWNNigbq646YodWjI3KtzJZYZRyFYepg8xF+HsEpDXIZLr7PBtwXsCV9o5yk83nbC1T
         k6tz7tgJNXJ9Q+rTmwrOjcTE8/KPdahjkRb8Oul7el0pheXlkTjAlBdMQmG/d+VM1gOk
         xfQQ==
In-Reply-To: <20131022210232.GB2884-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Hi, Vivek,

Sorry I don't have time to test them carefully this week. I'll do it
in this weekend.

The updating of nr_queued_tree level by level only happens once for
each bio. We have already the computing(and maybe queue operation)
level by level for every bio, even it's passed through without being
queued on the tree.  And the computing(and queue operation) on each
level is much bigger than updating one counter (nr_queued_tree).

So updating of nr_queued_tree doesn't introduce notable overhead
compared to existing overhead of blk-throttle.

Zhiguo

On Wed, Oct 23, 2013 at 5:02 AM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sun, Oct 20, 2013 at 08:11:12PM +0800, Hong Zhiguo wrote:
>> From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>>
>> Why
>> ====
>> Pointed out by Vivek: Tokens generated during idle period should
>> be trimmed. Otherwise a huge bio may be permited immediately.
>> Overlimit behaviour may be observed during short I/O throughput
>> test.
>>
>> Vivek also pointed out: We should not over-trim for hierarchical
>> groups. Suppose a subtree of groups are idle when a big bio comes.
>> The token of the child group is trimmed and not enough. So the bio is
>> queued on the child group. After some jiffies the child group reserved
>> enough tokens and the bio climbs up. If we trim the parent group at
>> this time again, this bio will wait too much time than expected.
>>
>> Analysis
>> ========
>> When the bio is queued on child group, all it's ancestor groups
>> becomes non-idle. They should start to reserve tokens for that
>> bio from this moment. And their reserved tokens before should be
>> trimmed at this moment.
>>
>> How
>> ====
>> service_queue now has a new member nr_queued_tree[2], to represent
>> the the number of bios waiting on the subtree rooted by this sq.
>>
>> When a bio is queued on the hierarchy first time, nr_queued_tree
>> of all ancestors and the child group itself are increased. When a
>> bio climbs up, nr_queued_tree of the child group is decreased.
>>
>> When nr_queued_tree turns from zero to one, the tokens reserved
>> before are trimmed. And after this switch, this group will never
>> be trimmed to reserve tokens for the bio waiting on it's descendant
>> group.
>>
>
> Hi Hong,
>
> This approach looks good in general. Only downside I can think of
> updation of nr_requests throughout the hierarchy. So deeper the
> hierarchy, higher the overhead.
>
> I am not sure if that's a concern or not. I will have a closer look
> a the patches tomorrow and do some testing too.
>
> Thanks
> Vivek



-- 
best regards
Hong Zhiguo
