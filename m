From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 09 Jul 2013 17:43:10 +0400
Message-ID: <51DC136E.6020901@openvz.org>
References: <20130708100046.14417.12932.stgit@zurg> <20130708170047.GA18600@mtj.dyndns.org> <20130708175201.GB9094@redhat.com> <20130708175607.GB18600@mtj.dyndns.org> <51DBC99F.4030301@openvz.org> <20130709125734.GA2478@htj.dyndns.org> <51DC0CE2.2050906@openvz.org> <20130709131605.GB2478@htj.dyndns.org> <20130709131646.GC2478@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=C3qKwuPHH8uQymkNJja1BKObikQrOceRjnUUaSmKA/c=;
        b=RLuymLw0ZZE69nFBY1vQkP/8C3Ykv70896SE6kxyJo/4+iv+vdEzYKJjEZCFDuMmj7
         Ndtuv32Npg0qErEcKFJShXfmsW6quwraqVdvuMIh+txPcnnYAWXFq/fm+nJWc6psEkE+
         1NybJwaG/8lawnIwFD6KgmmyUBJYPfAhdLrBDgJY4GQTo28UBpWETdSMScp22FeHrReX
         T6EbuLJAl7PqM9ICge6QPlWJrziMQl1emiIoKNSWEJ48cxhPOeHX5FAUo4adjHOeB9b2
         jKi4kUiR4bWZFB7htXdjtGTdmBHaiWbXroDxvBuXgRaDkCrvqt+/gNl8Cd+oUM3znCW9
         wSfA==
In-Reply-To: <20130709131646.GC2478@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org, Jens Axboe <axboe@kernel.dk>

Tejun Heo wrote:
> On Tue, Jul 09, 2013 at 06:16:05AM -0700, Tejun Heo wrote:
>> On Tue, Jul 09, 2013 at 05:15:14PM +0400, Konstantin Khlebnikov wrote:
>>> blkio controls block devices. not filesystems or superblocks or bdi or pagecache.
>>> It's all about block layer and nothing more. Am I right?
>>>
>>> So, you want to link some completely unrelated subsystems like NFS into the block layer?
>>
>> Heh, yeah, sure, network QoS is completely unrelated to sockets too,
>> right?
>
> And, no, blkio wouldn't have anything to do with NFS.  Where did you
> get that idea?
>

My concept it cgroup which would control io operation on vfs layer for all filesystems.
It will account and manage IO operations. I've found really lightweight technique
for accounting and throttling which don't introduce new locks or priority inversions
(which is major problem in all existing throttlers, including cpu cgroup rate limiter)
So, I've tried to keep code smaller, cleaner and saner as possible while you guys are
trying to push me into the block layer =)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
